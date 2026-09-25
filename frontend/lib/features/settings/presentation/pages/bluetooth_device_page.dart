import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:m2m/core/services/bluetooth_sensor_service.dart';

class BluetoothDevicePage extends StatefulWidget {
  const BluetoothDevicePage({super.key});

  @override
  State<BluetoothDevicePage> createState() => _BluetoothDevicePageState();
}

class _BluetoothDevicePageState extends State<BluetoothDevicePage> {
  final BluetoothSensorService _sensorService = BluetoothSensorService.instance;

  @override
  void initState() {
    super.initState();
    _sensorService.addListener(_handleServiceChanged);
    _initialize();
  }

  Future<void> _initialize() async {
    await _sensorService.ensureInitialized();
    await _sensorService.refreshScan();
  }

  void _handleServiceChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _sensorService.removeListener(_handleServiceChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final selectedDevice = _sensorService.selectedDevice;
    final scanResults = _sensorService.scanResults;
    final activeStatus = _sensorService.isConnected
        ? 'Connected'
        : _sensorService.isConnecting
            ? 'Connecting'
            : selectedDevice == null
                ? 'No device selected'
                : 'Saved device';
    final activeStatusColor = _sensorService.isConnected
        ? const Color(0xFF1B5E20)
        : _sensorService.statusIsError
            ? const Color(0xFFB00020)
            : Colors.black54;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bluetooth Devices'),
        backgroundColor: Colors.white,
        centerTitle: true,
        actions: [
          IconButton(
            onPressed:
                _sensorService.isScanning ? null : _sensorService.refreshScan,
            icon: const Icon(Icons.refresh),
            tooltip: 'Scan again',
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        children: [
          _StatusCard(
            status: _sensorService.status,
            isError: _sensorService.statusIsError,
            isBusy: _sensorService.isScanning || _sensorService.isConnecting,
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Active device',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  selectedDevice?.displayName ?? 'No device selected',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: Colors.black,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  activeStatus,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: activeStatusColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (selectedDevice != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    selectedDevice.id,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      if (_sensorService.isConnected)
                        OutlinedButton(
                          onPressed: _sensorService.disconnect,
                          child: const Text('Disconnect'),
                        )
                      else
                        FilledButton(
                          onPressed: _sensorService.isConnecting
                              ? null
                              : _sensorService.connectToSavedDevice,
                          child: Text(
                            _sensorService.isConnecting
                                ? 'Connecting...'
                                : 'Connect',
                          ),
                        ),
                      OutlinedButton(
                        onPressed: _sensorService.clearSelection,
                        child: const Text('Clear Selection'),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Nearby compatible devices',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 12),
          if (scanResults.isEmpty && !_sensorService.isScanning)
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                'No compatible Bluetooth devices are visible right now.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: Colors.black54,
                ),
              ),
            ),
          for (final result in scanResults) ...[
            _DeviceTile(
              result: result,
              label: _sensorService.labelForResult(result),
              isSaved: _sensorService.selectedDevice?.id ==
                  result.device.remoteId.str,
              isConnected: _sensorService.connectedDeviceId ==
                  result.device.remoteId.str,
              isConnecting: _sensorService.connectingDeviceId ==
                  result.device.remoteId.str,
              onConnect: () => _sensorService.connectToScanResult(result),
            ),
            const SizedBox(height: 12),
          ],
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
  });

  final String status;
  final bool isError;
  final bool isBusy;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final statusColor = isError ? const Color(0xFFB00020) : Colors.black87;
    final badgeColor =
        isBusy ? const Color(0xFFFFD54F) : const Color(0xFFE0E0E0);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
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
              isBusy ? 'Working' : 'Ready',
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

class _DeviceTile extends StatelessWidget {
  const _DeviceTile({
    required this.result,
    required this.label,
    required this.isSaved,
    required this.isConnected,
    required this.isConnecting,
    required this.onConnect,
  });

  final ScanResult result;
  final String label;
  final bool isSaved;
  final bool isConnected;
  final bool isConnecting;
  final VoidCallback onConnect;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final subtitle = isConnected
        ? 'Connected'
        : isConnecting
            ? 'Connecting...'
            : isSaved
                ? 'Saved device'
                : result.device.remoteId.str;

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: const Color(0xFFE8F1FF),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.bluetooth, color: Color(0xFF1967D2)),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: isConnected
                          ? const Color(0xFF1B5E20)
                          : Colors.black54,
                      fontWeight:
                          isConnected ? FontWeight.w600 : FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    result.device.remoteId.str,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            FilledButton(
              onPressed: isConnected || isConnecting ? null : onConnect,
              style: FilledButton.styleFrom(
                backgroundColor: isConnected
                    ? const Color(0xFF1B5E20)
                    : const Color(0xFF1967D2),
              ),
              child: Text(
                isConnected
                    ? 'Connected'
                    : isConnecting
                        ? 'Connecting...'
                        : 'Connect',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
