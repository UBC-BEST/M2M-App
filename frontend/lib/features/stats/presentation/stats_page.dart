import 'package:flutter/material.dart';
import 'package:m2m/core/services/bluetooth_sensor_service.dart';
import 'package:m2m/l10n/app_localizations.dart';

import 'bar_chart.dart';
import 'line_chart.dart';

class StatsPage extends StatefulWidget {
  const StatsPage({super.key});

  @override
  State<StatsPage> createState() => _StatsPageState();
}

class _StatsPageState extends State<StatsPage> {
  final BluetoothSensorService _sensorService = BluetoothSensorService.instance;

  @override
  void initState() {
    super.initState();
    _sensorService.addListener(_handleSensorChange);
    _sensorService.ensureInitialized(autoConnect: true);
  }

  void _handleSensorChange() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _sensorService.removeListener(_handleSensorChange);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final currentPercent = _sensorService.currentPercent.clamp(0, 100).toDouble();
    final maxPercent = _sensorService.maxPercent.clamp(0, 100).toDouble();
    final sampleBarData = [2, 5, 15, 7, 10, 30, 11];
    final sampleLineData = [20.0, 35.0, 50.0, 40.0, 60.0, 80.0, 70.0];
    final sourceText = _sensorService.selectedDevice == null
        ? 'Select and connect your FSR sensor in Settings to stream live data.'
        : _sensorService.isConnected
            ? 'Live source: ${_sensorService.selectedDevice!.displayName}'
            : _sensorService.isConnecting
                ? 'Connecting to ${_sensorService.selectedDevice!.displayName}...'
                : _sensorService.statusIsError
                    ? _sensorService.status
                    : 'Using saved sensor: ${_sensorService.selectedDevice!.displayName}';
    final sourceColor = (_sensorService.statusIsError &&
            !_sensorService.isConnected &&
            !_sensorService.isConnecting)
        ? const Color(0xFFB00020)
        : Colors.black54;

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
          children: [
            Text(
              localizations.statsPageTitle,
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 24),
            RepsCompletedBarChart(reps: sampleBarData),
            const SizedBox(height: 32),
            ForceOutputLineChart(lineData: sampleLineData),
            const SizedBox(height: 16),
            Text(
              sourceText,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: sourceColor,
                fontWeight: (_sensorService.statusIsError &&
                        !_sensorService.isConnected &&
                        !_sensorService.isConnecting)
                    ? FontWeight.w600
                    : FontWeight.w500,
              ),
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
              percent: currentPercent,
              color: const Color(0xFF719E66),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _ValueCard(
                    title: 'Current',
                    value: '${currentPercent.toStringAsFixed(1)}%',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _ValueCard(
                    title: 'Max',
                    value: '${maxPercent.toStringAsFixed(1)}%',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerLeft,
              child: OutlinedButton(
                onPressed: _sensorService.resetMax,
                child: const Text('Reset Max'),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Percent is normalized to the 0-4095 ADC range.',
              style: theme.textTheme.bodySmall?.copyWith(color: Colors.black54),
            ),
          ],
        ),
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
