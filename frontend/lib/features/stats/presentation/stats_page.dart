import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:m2m/core/config/app_config.dart';
import 'package:permission_handler/permission_handler.dart';

class StatsPage extends StatefulWidget {
  const StatsPage({super.key});

  @override
  State<StatsPage> createState() => _StatsPageState();
}

class _StatsPageState extends State<StatsPage> {
  late final Guid _serviceUuid = Guid(AppConfig.bleServiceUuid);
  late final Guid _characteristicUuid = Guid(AppConfig.bleCharacteristicUuid);
  static const double _smoothingAlpha = 0.85;

  BluetoothDevice? _device;
  BluetoothCharacteristic? _characteristic;

  StreamSubscription<List<ScanResult>>? _scanSub;
  StreamSubscription<BluetoothConnectionState>? _connectionSub;
  StreamSubscription<List<int>>? _notifySub;
  StreamSubscription<BluetoothAdapterState>? _adapterSub;

  Timer? _notifyWatchdog;

  bool _isScanning = false;
  bool _isConnecting = false;
  bool _isConnected = false;
  bool _statusIsError = false;

  String _status = 'Idle';
  int _rawValue = 0;
  int _smoothedValue = 0;
  int _maxValue = 0;
  DateTime? _lastNotifyAt;
  bool _hasSmoothedValue = false;

  @override
  void initState() {
    super.initState();
    _adapterSub = FlutterBluePlus.adapterState.listen(_handleAdapterState);
    _bootstrap();
  }

  void _handleAdapterState(BluetoothAdapterState state) {
    if (state != BluetoothAdapterState.on) {
      _setStatus('Bluetooth is off', isError: true);
      unawaited(_safeDisconnect());
    }
  }

  Future<void> _bootstrap() async {
    final supported = await FlutterBluePlus.isSupported;
    if (!supported) {
      _setStatus('Bluetooth not supported on this device', isError: true);
      return;
    }

    final permissionsOk = await _ensurePermissions();
    if (!permissionsOk) return;

    final adapterOk = await _waitForAdapterOn();
    if (!adapterOk) return;

    await _startScanWithFallback();
  }

  Future<bool> _ensurePermissions() async {
    final permissions = <Permission>[];

    if (Platform.isAndroid) {
      permissions.add(Permission.bluetoothScan);
      permissions.add(Permission.bluetoothConnect);
      permissions.add(Permission.locationWhenInUse);
    } else if (Platform.isIOS) {
      permissions.add(Permission.bluetooth);
    }

    final results = await permissions.request();
    final denied = results.values.any((status) => !status.isGranted);

    if (denied) {
      _setStatus('Permission denied', isError: true);
      return false;
    }

    if (Platform.isAndroid) {
      final serviceStatus = await Permission.locationWhenInUse.serviceStatus;
      if (serviceStatus.isDisabled) {
        _setStatus('Location services off (scans may be empty)');
      }
    }

    return true;
  }

  Future<bool> _waitForAdapterOn() async {
    final state = await FlutterBluePlus.adapterState.first;
    if (state == BluetoothAdapterState.on) return true;

    _setStatus('Bluetooth is off', isError: true);
    try {
      await FlutterBluePlus.adapterState
          .where((s) => s == BluetoothAdapterState.on)
          .first
          .timeout(const Duration(seconds: 10));
      return true;
    } on TimeoutException {
      return false;
    }
  }

  Future<void> _startScanWithFallback() async {
    if (_isScanning || _isConnecting) return;

    await _stopScan();
    await _safeDisconnect(resetStatus: false);
    _resetValues();

    _setStatus('Scanning (filtered)');
    final filteredResult = await _scanForDevice(
      useFilter: true,
      timeout: const Duration(seconds: 6),
    );

    if (filteredResult != null) {
      await _connectTo(filteredResult.device);
      return;
    }

    _setStatus('Scanning (fallback)');
    final fallbackResult = await _scanForDevice(
      useFilter: false,
      timeout: const Duration(seconds: 8),
    );

    if (fallbackResult == null) {
      _setStatus('Device not found', isError: true);
      return;
    }

    await _connectTo(fallbackResult.device);
  }

  Future<ScanResult?> _scanForDevice({
    required bool useFilter,
    required Duration timeout,
  }) async {
    final completer = Completer<ScanResult?>();
    await _scanSub?.cancel();

    _scanSub = FlutterBluePlus.onScanResults.listen(
      (results) {
        for (final result in results) {
          if (_advertisesService(result.advertisementData)) {
            if (!completer.isCompleted) {
              completer.complete(result);
            }
            break;
          }
        }
      },
      onError: (e) {
        if (!completer.isCompleted) {
          completer.completeError(e);
        }
      },
    );

    _isScanning = true;
    if (mounted) setState(() {});

    if (useFilter) {
      await FlutterBluePlus.startScan(
        withServices: [_serviceUuid],
        timeout: timeout,
      );
    } else {
      await FlutterBluePlus.startScan(timeout: timeout);
    }

    ScanResult? result;
    try {
      result = await completer.future.timeout(timeout);
    } on TimeoutException {
      result = null;
    } catch (_) {
      result = null;
    }

    await FlutterBluePlus.stopScan();
    _isScanning = false;
    await _scanSub?.cancel();
    _scanSub = null;
    if (mounted) setState(() {});

    return result;
  }

  bool _advertisesService(AdvertisementData data) {
    final target = _serviceUuid.toString().toLowerCase();
    return data.serviceUuids
        .any((uuid) => uuid.toString().toLowerCase() == target);
  }

  Future<void> _connectTo(BluetoothDevice device) async {
    _device = device;
    _isConnecting = true;
    _isConnected = false;
    _setStatus('Connecting');

    try {
      await device.connect(
        license: License.free,
        timeout: const Duration(seconds: 15),
      );

      _connectionSub?.cancel();
      _connectionSub = device.connectionState.listen((state) {
        if (state == BluetoothConnectionState.disconnected) {
          _isConnected = false;
          _setStatus('Disconnected');
        }
      });

      final services = await device.discoverServices();
      final service = services.firstWhere(
        (s) => s.uuid == _serviceUuid,
        orElse: () => throw Exception('Service not found'),
      );

      final characteristic = service.characteristics.firstWhere(
        (c) => c.uuid == _characteristicUuid,
        orElse: () => throw Exception('Characteristic not found'),
      );

      _characteristic = characteristic;
      final notifyOk = await characteristic.setNotifyValue(true);
      if (!notifyOk) {
        _setStatus('Error: failed to enable notifications', isError: true);
        return;
      }

      _listenForNotifications(characteristic);

      _isConnecting = false;
      _isConnected = true;
      _setStatus('Connected');
    } catch (e) {
      _isConnecting = false;
      _isConnected = false;
      _setStatus('Error: $e', isError: true);
    }
  }

  void _listenForNotifications(BluetoothCharacteristic characteristic) {
    _notifySub?.cancel();
    _lastNotifyAt = null;

    _notifySub = characteristic.onValueReceived.listen((value) {
      if (value.length < 2) return;
      final raw = value[0] | (value[1] << 8);
      final clamped = raw.clamp(0, 4095);

      _rawValue = clamped;
      if (!_hasSmoothedValue) {
        _smoothedValue = clamped;
        _hasSmoothedValue = true;
      } else {
        final next = (_smoothingAlpha * clamped) +
            ((1 - _smoothingAlpha) * _smoothedValue);
        _smoothedValue = next.round().clamp(0, 4095);
      }
      if (clamped > _maxValue) {
        _maxValue = clamped;
      }

      _lastNotifyAt = DateTime.now();
      if (mounted) setState(() {});
    });

    _notifyWatchdog?.cancel();
    _notifyWatchdog = Timer(const Duration(seconds: 6), () {
      if (_isConnected && _lastNotifyAt == null) {
        _setStatus('Error: notifications not firing', isError: true);
      }
    });
  }

  Future<void> _stopScan() async {
    try {
      await FlutterBluePlus.stopScan();
    } catch (_) {}
    await _scanSub?.cancel();
    _scanSub = null;
    _isScanning = false;
  }

  Future<void> _safeDisconnect({bool resetStatus = true}) async {
    _notifyWatchdog?.cancel();
    _notifyWatchdog = null;

    try {
      if (_characteristic?.isNotifying == true) {
        await _characteristic?.setNotifyValue(false);
      }
    } catch (_) {}

    await _notifySub?.cancel();
    _notifySub = null;

    try {
      await _device?.disconnect();
    } catch (_) {}

    await _connectionSub?.cancel();
    _connectionSub = null;

    _device = null;
    _characteristic = null;
    _isConnected = false;
    _isConnecting = false;

    if (resetStatus) {
      _setStatus('Disconnected');
    }
  }

  void _resetValues() {
    _rawValue = 0;
    _smoothedValue = 0;
    _maxValue = 0;
    _lastNotifyAt = null;
    _hasSmoothedValue = false;
  }

  void _setStatus(String message, {bool isError = false}) {
    if (!mounted) return;
    setState(() {
      _status = message;
      _statusIsError = isError;
    });
  }

  @override
  void dispose() {
    _adapterSub?.cancel();
    unawaited(_stopScan());
    unawaited(_safeDisconnect());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final percent = (_smoothedValue / 4095) * 100;
    final maxPercent = (_maxValue / 4095) * 100;

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
        children: [
          Text(
            'Data',
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 16),
          _StatusCard(
            status: _status,
            isError: _statusIsError,
            isBusy: _isScanning || _isConnecting,
            isConnected: _isConnected,
          ),
          const SizedBox(height: 18),
          Text(
            'FSR Pressure',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 12),
          _PercentBar(
            percent: percent.clamp(0, 100),
            color: const Color(0xFF719E66),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _ValueCard(
                  title: 'Raw',
                  value: _rawValue.toString(),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _ValueCard(
                  title: 'Max %',
                  value: '${maxPercent.clamp(0, 100).toStringAsFixed(1)}%',
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerLeft,
            child: OutlinedButton(
              onPressed: () => setState(() => _maxValue = 0),
              child: const Text('Reset Max'),
            ),
          ),
          const SizedBox(height: 20),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              ElevatedButton(
                onPressed: _isScanning || _isConnecting
                    ? null
                    : _startScanWithFallback,
                child: const Text('Rescan'),
              ),
              OutlinedButton(
                onPressed: _isConnected ? _safeDisconnect : null,
                child: const Text('Disconnect'),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Percent is normalized to the 0–4095 ADC range.',
            style: theme.textTheme.bodySmall?.copyWith(color: Colors.black54),
          ),
        ],
      ),
    );
  }
}

class _PercentBar extends StatelessWidget {
  const _PercentBar({
    required this.percent,
    required this.color,
  });

  final double percent;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final clamped = (percent.isNaN ? 0 : percent).clamp(0, 100);
    final textColor = clamped > 55 ? Colors.white : Colors.black87;

    return Stack(
      alignment: Alignment.center,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: LinearProgressIndicator(
            value: clamped / 100,
            minHeight: 26,
            backgroundColor: const Color(0xFFE7EEE9),
            color: color,
          ),
        ),
        Text(
          '${clamped.toStringAsFixed(1)}%',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: textColor,
                fontWeight: FontWeight.w700,
              ),
        ),
      ],
    );
  }
}

class _ValueCard extends StatelessWidget {
  const _ValueCard({
    required this.title,
    required this.value,
  });

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.labelLarge?.copyWith(
              color: Colors.black54,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusCard extends StatelessWidget {
  const _StatusCard({
    required this.status,
    required this.isError,
    required this.isBusy,
    required this.isConnected,
  });

  final String status;
  final bool isError;
  final bool isBusy;
  final bool isConnected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final statusColor = isError
        ? const Color(0xFFB00020)
        : isConnected
            ? const Color(0xFF1B5E20)
            : Colors.black87;
    final badgeText = isBusy
        ? 'Working'
        : isConnected
            ? 'Connected'
            : 'Idle';
    final badgeColor = isBusy
        ? const Color(0xFFFFD54F)
        : isConnected
            ? const Color(0xFFB9F6CA)
            : const Color(0xFFE0E0E0);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              status,
              style: theme.textTheme.titleSmall?.copyWith(
                color: statusColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: badgeColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              badgeText,
              style: theme.textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
