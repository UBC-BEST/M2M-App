import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:m2m/core/config/app_config.dart';
import 'package:m2m/features/unity/data/button_calibration_store.dart';
import 'package:m2m/features/unity/domain/button_calibration_profile.dart';
import 'package:permission_handler/permission_handler.dart';

import 'bluetooth_device_manager.dart';

class BluetoothSensorService extends ChangeNotifier {
  BluetoothSensorService._();

  static final BluetoothSensorService instance = BluetoothSensorService._();

  static const double _smoothingAlpha = 0.85;
  static const Duration _scanDuration = Duration(seconds: 8);
  static const int _pinIndex = 36;
  static const int _pinMiddle = 39;
  static const int _pinThumb = 35;
  static const int _legacyPinIndex = 27;
  static const int _legacyPinMiddle = 14;
  static const int _legacyPinThumb = 26;
  static const int _legacyPinRing = 12;
  static const int _legacyPinPinky = 13;

  final BluetoothDeviceManager _deviceManager = BluetoothDeviceManager();
  final ButtonCalibrationStore _buttonStore = ButtonCalibrationStore();
  final Guid _serviceUuid = Guid(AppConfig.bleServiceUuid);
  final Guid _characteristicUuid = Guid(AppConfig.bleCharacteristicUuid);
  final Map<String, ScanResult> _scanResults = <String, ScanResult>{};

  StreamSubscription<List<ScanResult>>? _scanSub;
  StreamSubscription<BluetoothConnectionState>? _connectionSub;
  StreamSubscription<List<int>>? _notifySub;
  StreamSubscription<BluetoothAdapterState>? _adapterSub;
  Timer? _notifyWatchdog;

  BluetoothDevice? _device;
  BluetoothCharacteristic? _characteristic;
  SavedBluetoothDevice? _selectedDevice;
  ButtonCalibrationProfile? _buttonProfile;
  String? _connectingDeviceId;
  DateTime? _lastNotifyAt;

  bool _initialized = false;
  bool _isScanning = false;
  bool _isConnecting = false;
  bool _isConnected = false;
  bool _statusIsError = false;
  bool _hasSmoothedValue = false;

  String _status = 'Idle';
  int _smoothedValue = 0;
  int _maxValue = 0;
  int _latestRawValue = 0;
  int? _activeButton;
  final Map<int, int> _pinReadings = <int, int>{};

  List<ScanResult> get scanResults {
    final values = _scanResults.values.toList();
    values.sort((a, b) {
      final nameA = labelForResult(a);
      final nameB = labelForResult(b);

      if (nameA.isEmpty && nameB.isNotEmpty) return 1;
      if (nameA.isNotEmpty && nameB.isEmpty) return -1;

      final byName = nameA.toLowerCase().compareTo(nameB.toLowerCase());
      if (byName != 0) return byName;

      return a.device.remoteId.str.compareTo(b.device.remoteId.str);
    });
    return values;
  }

  SavedBluetoothDevice? get selectedDevice => _selectedDevice;
  String? get connectedDeviceId => _isConnected ? _device?.remoteId.str : null;
  String? get connectingDeviceId => _connectingDeviceId;
  bool get isScanning => _isScanning;
  bool get isConnecting => _isConnecting;
  bool get isConnected => _isConnected;
  bool get statusIsError => _statusIsError;
  String get status => _status;
  int get currentRawValue => _latestRawValue;
  double get currentPercent => (_smoothedValue / 4095) * 100;
  double get maxPercent => (_maxValue / 4095) * 100;
  int? get activeButton => _activeButton;
  Map<int, int> get pinReadings => Map<int, int>.unmodifiable(_pinReadings);
  ButtonCalibrationProfile? get buttonProfile => _buttonProfile;
  bool get hasButtonCalibration => _buttonProfile != null;

  Future<void> ensureInitialized({bool autoConnect = false}) async {
    if (!_initialized) {
      _initialized = true;
      _selectedDevice = await _deviceManager.readSelectedDevice();
      final savedProfile = await _buttonStore.readProfile();
      _buttonProfile = (savedProfile != null && savedProfile.hasDistinctButtons)
          ? savedProfile
          : ButtonCalibrationProfile.m2mDefault;
      _adapterSub = FlutterBluePlus.adapterState.listen(_handleAdapterState);
      notifyListeners();
    }

    if (autoConnect &&
        _selectedDevice != null &&
        !_isConnected &&
        !_isConnecting) {
      unawaited(connectToSavedDevice());
    }
  }

  void _handleAdapterState(BluetoothAdapterState state) {
    if (state != BluetoothAdapterState.on) {
      _setStatus('Bluetooth is off', isError: true);
      unawaited(disconnect(resetStatus: false));
    }
  }

  Future<void> refreshScan() async {
    await ensureInitialized();
    if (_isScanning || _isConnecting) return;

    final supported = await FlutterBluePlus.isSupported;
    if (!supported) {
      _setStatus('Bluetooth is not supported on this device', isError: true);
      return;
    }

    final permissionsOk = await _ensurePermissions();
    if (!permissionsOk) return;

    final adapterOk = await _waitForAdapterOn();
    if (!adapterOk) return;

    await _stopScan();
    _scanResults.clear();
    _isScanning = true;
    _setStatus('Scanning for compatible devices');
    notifyListeners();

    _scanSub = FlutterBluePlus.onScanResults.listen(
      (results) {
        var changed = false;

        for (final result in results) {
          if (!_advertisesService(result.advertisementData)) {
            continue;
          }

          final deviceId = result.device.remoteId.str;
          if (_scanResults[deviceId] == result) {
            continue;
          }

          _scanResults[deviceId] = result;
          changed = true;
        }

        if (changed) {
          notifyListeners();
        }
      },
      onError: (Object error) {
        _setStatus('Scan failed: $error', isError: true);
      },
    );

    try {
      await FlutterBluePlus.startScan(
        withServices: [_serviceUuid],
        timeout: _scanDuration,
      );
      await Future<void>.delayed(_scanDuration);
    } catch (error) {
      _setStatus('Scan failed: $error', isError: true);
    }

    await _stopScan();
    if (_isConnected && _selectedDevice != null) {
      _setStatus('Connected to ${_selectedDevice!.displayName}');
    } else if (_scanResults.isEmpty) {
      _setStatus('No compatible devices found', isError: true);
    } else {
      _setStatus('Compatible devices found');
    }
  }

  Future<void> connectToScanResult(ScanResult result) async {
    await ensureInitialized();
    final selected = SavedBluetoothDevice(
      id: result.device.remoteId.str,
      name: labelForResult(result),
    );

    _selectedDevice = selected;
    await _deviceManager.saveSelectedDevice(
      id: selected.id,
      name: selected.name,
    );
    notifyListeners();

    await _connectTo(result.device, displayName: selected.displayName);
  }

  Future<void> connectToSavedDevice() async {
    await ensureInitialized();
    final saved = _selectedDevice;
    if (saved == null) {
      _setStatus('Select an FSR sensor in Settings first', isError: true);
      return;
    }

    if (_isConnected && _device?.remoteId.str == saved.id) {
      return;
    }

    final supported = await FlutterBluePlus.isSupported;
    if (!supported) {
      _setStatus('Bluetooth is not supported on this device', isError: true);
      return;
    }

    final permissionsOk = await _ensurePermissions();
    if (!permissionsOk) return;

    final adapterOk = await _waitForAdapterOn();
    if (!adapterOk) return;

    _setStatus('Looking for ${saved.displayName}');
    final result = await _scanForDevice(
      preferredId: saved.id,
      timeout: _scanDuration,
    );

    if (result == null) {
      _setStatus('${saved.displayName} not found', isError: true);
      return;
    }

    await _connectTo(result.device, displayName: saved.displayName);
  }

  Future<void> clearSelection() async {
    await ensureInitialized();
    await disconnect();
    _selectedDevice = null;
    await _deviceManager.clearSelectedDevice();
    notifyListeners();
  }

  Future<void> disconnect({bool resetStatus = true}) async {
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
    _connectingDeviceId = null;

    if (resetStatus) {
      _setStatus('Disconnected');
    } else {
      notifyListeners();
    }
  }

  void resetMax() {
    _maxValue = 0;
    notifyListeners();
  }

  Future<void> saveButtonCalibrationProfile(
    ButtonCalibrationProfile profile,
  ) async {
    _buttonProfile = profile;
    await _buttonStore.writeProfile(profile);
    _activeButton = profile.decodeButton(_latestRawValue);
    notifyListeners();
  }

  Future<void> clearButtonCalibrationProfile() async {
    _buttonProfile = null;
    _activeButton = null;
    await _buttonStore.clearProfile();
    notifyListeners();
  }

  String labelForResult(ScanResult result) {
    final advertised = result.advertisementData.advName.trim();
    if (advertised.isNotEmpty) {
      return advertised;
    }

    final platformName = result.device.platformName.trim();
    if (platformName.isNotEmpty) {
      return platformName;
    }

    return result.device.remoteId.str;
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
    final bluetoothStatus =
        Platform.isIOS ? results[Permission.bluetooth] : null;
    final denied = results.values.any((status) => !status.isGranted);

    if (bluetoothStatus != null &&
        (bluetoothStatus.isPermanentlyDenied || bluetoothStatus.isRestricted)) {
      _setStatus(
        'Bluetooth access is blocked. Enable it in iPhone Settings for M2M App.',
        isError: true,
      );
      return false;
    }

    if (denied) {
      _setStatus(
        'Bluetooth permission was not granted. Accept the iPhone prompt to scan.',
        isError: true,
      );
      return false;
    }

    if (Platform.isAndroid) {
      final serviceStatus = await Permission.locationWhenInUse.serviceStatus;
      if (serviceStatus.isDisabled) {
        _setStatus('Location services are off, scan results may be limited');
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

  Future<ScanResult?> _scanForDevice({
    required String preferredId,
    required Duration timeout,
  }) async {
    final completer = Completer<ScanResult?>();
    await _scanSub?.cancel();

    _scanSub = FlutterBluePlus.onScanResults.listen(
      (results) {
        for (final result in results) {
          if (result.device.remoteId.str != preferredId) {
            continue;
          }

          if (!_advertisesService(result.advertisementData)) {
            continue;
          }

          if (!completer.isCompleted) {
            completer.complete(result);
          }
          break;
        }
      },
      onError: (Object error) {
        if (!completer.isCompleted) {
          completer.completeError(error);
        }
      },
    );

    _isScanning = true;
    notifyListeners();

    try {
      await FlutterBluePlus.startScan(
        withServices: [_serviceUuid],
        timeout: timeout,
      );
      return await completer.future.timeout(timeout);
    } on TimeoutException {
      return null;
    } catch (_) {
      return null;
    } finally {
      await _stopScan();
    }
  }

  bool _advertisesService(AdvertisementData data) {
    final target = _serviceUuid.toString().toLowerCase();
    return data.serviceUuids
        .any((uuid) => uuid.toString().toLowerCase() == target);
  }

  Future<void> _connectTo(
    BluetoothDevice device, {
    required String displayName,
  }) async {
    if (_isConnecting) return;

    await _stopScan();
    await disconnect(resetStatus: false);

    _device = device;
    _isConnecting = true;
    _isConnected = false;
    _connectingDeviceId = device.remoteId.str;
    _setStatus('Connecting to $displayName');
    notifyListeners();

    try {
      await device.connect(
        license: License.free,
        timeout: const Duration(seconds: 15),
      );

      await _connectionSub?.cancel();
      _connectionSub = device.connectionState.listen((state) {
        if (state == BluetoothConnectionState.disconnected) {
          _isConnected = false;
          _isConnecting = false;
          _connectingDeviceId = null;
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
        throw Exception('Failed to enable notifications');
      }

      _listenForNotifications(characteristic);

      _isConnecting = false;
      _isConnected = true;
      _connectingDeviceId = null;
      _setStatus('Connected to $displayName');
    } catch (error) {
      _isConnecting = false;
      _isConnected = false;
      _connectingDeviceId = null;
      _setStatus('Error: $error', isError: true);
    }
  }

  void _listenForNotifications(BluetoothCharacteristic characteristic) {
    _notifySub?.cancel();
    _lastNotifyAt = null;

    _notifySub = characteristic.onValueReceived.listen((value) {
      _parsePinReadings(value);
      final decoded = _decodeButtonAndRaw(value);
      if (decoded == null) return;

      final btn = decoded.$1;
      final raw = decoded.$2;
      final clamped = raw.clamp(0, 4095);

      _latestRawValue = clamped;
      // Firmware may emit a non-zero button even when ladder raw is 0
      // (joystick diagnostics). Gate by raw>0 to keep app buttons stable.
      final firmwareButton = (btn >= 1 && btn <= 12 && clamped > 0) ? btn : null;
      final profileButton = _buttonProfile?.decodeButton(clamped);
      final rangeButton = ButtonCalibrationProfile.decodeM2MRangeButton(clamped);
      // Prefer explicit firmware button when provided, then calibration/profile mapping.
      _activeButton =
          firmwareButton ?? profileButton ?? rangeButton;

      // If per-pin telemetry is missing from BLE text payload, mirror the decoded
      // button/raw frame into finger pin diagnostics so Index/Middle/Thumb still
      // show live values in the monitor.
      _applyFingerFallbackTelemetry(
        button: _activeButton,
        raw: clamped,
      );

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
      notifyListeners();
    });

    _notifyWatchdog?.cancel();
    _notifyWatchdog = Timer(const Duration(seconds: 6), () {
      if (_isConnected && _lastNotifyAt == null) {
        _setStatus('Error: notifications not firing', isError: true);
      }
    });
  }

  void _parsePinReadings(List<int> value) {
    final text = utf8.decode(value, allowMalformed: true);
    if (text.trim().isEmpty) return;

    // Supports payload fragments like:
    // "13:120,12:0,14:55,27:0,26:9,25:2140,33:1870"
    final matches = RegExp(r'(\d+)\s*[:=]\s*(-?\d+)').allMatches(text);
    if (matches.isEmpty) return;

    var changed = false;
    for (final match in matches) {
      final pinStr = match.group(1);
      final valueStr = match.group(2);
      if (pinStr == null || valueStr == null) continue;
      final pin = int.tryParse(pinStr);
      final reading = int.tryParse(valueStr);
      if (pin == null || reading == null) continue;
      if (_pinReadings[pin] == reading) continue;
      _pinReadings[pin] = reading;
      changed = true;
    }

    if (changed) {
      notifyListeners();
    }
  }

  (int button, int raw)? _decodeButtonAndRaw(List<int> value) {
    // Text packets from firmware are common while debugging. If packet looks like
    // ASCII, try extracting explicit fields first.
    if (_looksLikeAsciiPayload(value)) {
      final text = utf8.decode(value, allowMalformed: true);
      final textButton = _extractFirstIntField(
        text,
        const <String>['button', 'btn', 'activeButton', 'active'],
      );
      final textRaw = _extractFirstIntField(
        text,
        const <String>['raw', 'adc', 'value', 'sensor'],
      );
      final indexPin = _extractPinReadingFromPayload(text, _pinIndex);
      final middlePin = _extractPinReadingFromPayload(text, _pinMiddle);
      final thumbPin = _extractPinReadingFromPayload(text, _pinThumb);
      final legacyIndexPin = _extractPinReadingFromPayload(text, _legacyPinIndex);
      final legacyMiddlePin =
          _extractPinReadingFromPayload(text, _legacyPinMiddle);
      final legacyThumbPin = _extractPinReadingFromPayload(text, _legacyPinThumb);
      final legacyRingPin = _extractPinReadingFromPayload(text, _legacyPinRing);
      final legacyPinkyPin =
          _extractPinReadingFromPayload(text, _legacyPinPinky);

      // Three-finger build: use explicit raw first, then strongest finger pin.
      final resolvedRaw = textRaw ??
          _maxNonNull(
            indexPin,
            middlePin,
            thumbPin,
            legacyIndexPin,
            legacyMiddlePin,
            legacyThumbPin,
            legacyRingPin,
            legacyPinkyPin,
          ) ??
          _maxNonNull(
            _pinReadings[_pinIndex],
            _pinReadings[_pinMiddle],
            _pinReadings[_pinThumb],
            _pinReadings[_legacyPinIndex],
            _pinReadings[_legacyPinMiddle],
            _pinReadings[_legacyPinThumb],
            _pinReadings[_legacyPinRing],
            _pinReadings[_legacyPinPinky],
          );
      if (resolvedRaw != null) {
        return (textButton ?? 0, resolvedRaw);
      }
    }

    // Binary packet fallback: [button (1-12, 0=none), raw_low, raw_high]
    if (value.length >= 3) {
      final btn = value[0];
      final raw = value[1] | (value[2] << 8);
      return (btn, raw);
    }

    return null;
  }

  bool _looksLikeAsciiPayload(List<int> bytes) {
    if (bytes.isEmpty) return false;
    var printable = 0;
    for (final b in bytes) {
      final isPrintable = (b >= 32 && b <= 126) || b == 9 || b == 10 || b == 13;
      if (isPrintable) {
        printable++;
      }
    }
    return printable / bytes.length >= 0.85;
  }

  int? _extractFirstIntField(String text, List<String> keys) {
    for (final key in keys) {
      final match = RegExp('$key\\s*[:=]\\s*(-?\\d+)', caseSensitive: false)
          .firstMatch(text);
      final value = match?.group(1);
      if (value == null) continue;
      final parsed = int.tryParse(value);
      if (parsed != null) return parsed;
    }
    return null;
  }

  int? _extractPinReadingFromPayload(String text, int pin) {
    final match = RegExp('(?:^|[\\s,|])$pin\\s*[:=]\\s*(-?\\d+)')
        .firstMatch(text);
    final value = match?.group(1);
    if (value == null) {
      return null;
    }
    return int.tryParse(value);
  }

  void _applyFingerFallbackTelemetry({
    required int? button,
    required int raw,
  }) {
    final hadAnyFingerTelemetry =
        _pinReadings[_pinIndex] != null ||
        _pinReadings[_pinMiddle] != null ||
        _pinReadings[_pinThumb] != null ||
        _pinReadings[_legacyPinIndex] != null ||
        _pinReadings[_legacyPinMiddle] != null ||
        _pinReadings[_legacyPinThumb] != null;
    if (hadAnyFingerTelemetry) {
      return;
    }

    // Keep both "new" and legacy monitor mappings in sync.
    _pinReadings[_pinIndex] = 0;
    _pinReadings[_pinMiddle] = 0;
    _pinReadings[_pinThumb] = 0;
    _pinReadings[_legacyPinIndex] = 0;
    _pinReadings[_legacyPinMiddle] = 0;
    _pinReadings[_legacyPinThumb] = 0;

    if (button == null || raw <= 0) {
      return;
    }

    if (button == 2) {
      _pinReadings[_pinIndex] = raw;
      _pinReadings[_legacyPinIndex] = raw;
    } else if (button == 3) {
      _pinReadings[_pinMiddle] = raw;
      _pinReadings[_legacyPinMiddle] = raw;
    } else if (button == 5) {
      _pinReadings[_pinThumb] = raw;
      _pinReadings[_legacyPinThumb] = raw;
    }
  }

  int? _maxNonNull(
    int? a,
    int? b,
    int? c, [
    int? d,
    int? e,
    int? f,
    int? g,
    int? h,
  ]) {
    int? best;
    for (final v in <int?>[a, b, c, d, e, f, g, h]) {
      if (v == null || v < 0) continue;
      if (best == null || v > best) {
        best = v;
      }
    }
    return best;
  }

  // REMOVED: _decodeRawValue — replaced by direct binary parsing in _listenForNotifications

  Future<void> _stopScan() async {
    try {
      await FlutterBluePlus.stopScan();
    } catch (_) {}

    await _scanSub?.cancel();
    _scanSub = null;
    _isScanning = false;
    notifyListeners();
  }

  void _setStatus(String message, {bool isError = false}) {
    _status = message;
    _statusIsError = isError;
    notifyListeners();
  }

  Future<void> close() async {
    await _adapterSub?.cancel();
    _adapterSub = null;
    await _stopScan();
    await disconnect(resetStatus: false);
  }
}