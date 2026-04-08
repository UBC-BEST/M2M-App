import 'package:flutter/material.dart';

import '../../../../core/services/bluetooth_sensor_service.dart';
import '../../../unity/domain/button_calibration_profile.dart';
import '../../../unity/application/sensor_game_bridge.dart';
import '../../../unity/domain/game_calibration_preset.dart';
import '../../../unity/domain/unity_game.dart';

class GameSensorCalibrationPage extends StatefulWidget {
  const GameSensorCalibrationPage({super.key});

  @override
  State<GameSensorCalibrationPage> createState() =>
      _GameSensorCalibrationPageState();
}

class _GameSensorCalibrationPageState extends State<GameSensorCalibrationPage> {
  final SensorGameBridge _bridge = SensorGameBridge.instance;
  final BluetoothSensorService _sensorService = BluetoothSensorService.instance;
  final Map<UnityGame, GameCalibrationPreset> _presets =
      <UnityGame, GameCalibrationPreset>{};

  bool _loading = true;
  bool _isCalibratingButtons = false;
  UnityGame _selectedGame = UnityGame.pizza;

  @override
  void initState() {
    super.initState();
    _sensorService.addListener(_onSensorUpdate);
    _load();
  }

  @override
  void dispose() {
    _sensorService.removeListener(_onSensorUpdate);
    super.dispose();
  }

  Future<void> _load() async {
    await _bridge.ensureInitialized();
    await _sensorService.ensureInitialized(autoConnect: true);
    for (final game in UnityGame.values) {
      _presets[game] = await _bridge.readPreset(game);
    }
    if (!mounted) return;
    setState(() => _loading = false);
  }

  Future<void> _save(UnityGame game, GameCalibrationPreset preset) async {
    await _bridge.savePreset(game, preset);
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text('${game.displayName} preset saved')),
      );
  }

  void _onSensorUpdate() {
    if (!mounted || _loading) return;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final buttonProfile = _sensorService.buttonProfile;
    final isConnected = _sensorService.isConnected;
    final currentPercent =
        _sensorService.currentPercent.clamp(0, 100).toDouble();
    final normalized = (currentPercent / 100).clamp(0.0, 1.0);
    if (_loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final preset = _presets[_selectedGame] ?? const GameCalibrationPreset();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Game Sensor Calibration'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: <Widget>[
          _BleStatusCard(
            isConnected: isConnected,
            status: _sensorService.status,
            currentRaw: _sensorService.currentRawValue,
            currentPercent: currentPercent,
            activeButton: _sensorService.activeButton,
            onConnect: () => _sensorService.connectToSavedDevice(),
          ),
          const SizedBox(height: 16),
          SegmentedButton<UnityGame>(
            segments: UnityGame.values
                .map(
                  (game) => ButtonSegment<UnityGame>(
                    value: game,
                    label: Text(game.displayName.replaceAll(' Game', '')),
                  ),
                )
                .toList(),
            selected: <UnityGame>{_selectedGame},
            onSelectionChanged: (selection) {
              setState(() {
                _selectedGame = selection.first;
              });
            },
          ),
          const SizedBox(height: 20),
          _QuickCaptureRow(
            normalized: normalized,
            onCaptureMin: () => _captureAndApplyPreset(
              preset.copyWith(min: normalized),
            ),
            onCaptureCenter: () => _captureAndApplyPreset(
              preset.copyWith(center: normalized),
            ),
            onCaptureMax: () => _captureAndApplyPreset(
              preset.copyWith(max: normalized),
            ),
            onCaptureThreshold: () => _captureAndApplyPreset(
              preset.copyWith(triggerThreshold: normalized),
            ),
          ),
          const SizedBox(height: 8),
          _SliderTile(
            label: 'Center',
            value: preset.center,
            min: 0,
            max: 1,
            onChanged: (value) => _updatePreset(preset.copyWith(center: value)),
          ),
          _SliderTile(
            label: 'Min',
            value: preset.min,
            min: 0,
            max: 1,
            onChanged: (value) {
              final nextMin = value;
              final nextMax = preset.max < nextMin ? nextMin : preset.max;
              _updatePreset(
                preset.copyWith(min: nextMin, max: nextMax),
              );
            },
          ),
          _SliderTile(
            label: 'Max',
            value: preset.max,
            min: 0,
            max: 1,
            onChanged: (value) {
              final nextMax = value;
              final nextMin = preset.min > nextMax ? nextMax : preset.min;
              _updatePreset(
                preset.copyWith(min: nextMin, max: nextMax),
              );
            },
          ),
          _SliderTile(
            label: 'Dead Zone',
            value: preset.deadZone,
            min: 0,
            max: 0.5,
            onChanged: (value) =>
                _updatePreset(preset.copyWith(deadZone: value)),
          ),
          _SliderTile(
            label: 'Sensitivity',
            value: preset.sensitivity,
            min: 0.2,
            max: 2.0,
            onChanged: (value) =>
                _updatePreset(preset.copyWith(sensitivity: value)),
          ),
          _SliderTile(
            label: 'Trigger Threshold',
            value: preset.triggerThreshold,
            min: 0,
            max: 1,
            onChanged: (value) =>
                _updatePreset(preset.copyWith(triggerThreshold: value)),
          ),
          _SliderTile(
            label: 'Trigger Cooldown (ms)',
            value: preset.triggerCooldownMs.toDouble(),
            min: 50,
            max: 600,
            divisions: 11,
            onChanged: (value) => _updatePreset(
              preset.copyWith(triggerCooldownMs: value.round()),
            ),
          ),
          const SizedBox(height: 20),
          FilledButton.icon(
            onPressed: () => _save(_selectedGame, _presets[_selectedGame]!),
            icon: const Icon(Icons.save_outlined),
            label: const Text('Save Preset'),
          ),
          const SizedBox(height: 28),
          _ButtonCalibrationCard(
            profile: buttonProfile,
            isConnected: _sensorService.isConnected,
            activeButton: _sensorService.activeButton,
            currentRaw: _sensorService.currentRawValue,
            isCalibrating: _isCalibratingButtons,
            onStartCalibration:
                _isCalibratingButtons ? null : _runGuidedButtonCalibration,
            onClearCalibration:
                _isCalibratingButtons ? null : _clearButtonCalibration,
          ),
        ],
      ),
    );
  }

  void _updatePreset(GameCalibrationPreset preset) {
    setState(() {
      _presets[_selectedGame] = preset;
    });
  }

  void _captureAndApplyPreset(GameCalibrationPreset nextPreset) {
    if (!_sensorService.isConnected) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Connect your ESP sensor first.')),
      );
      return;
    }
    _updatePreset(nextPreset);
  }

  Future<void> _runGuidedButtonCalibration() async {
    if (!_sensorService.isConnected) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Connect your BLE sensor first in Bluetooth Devices.'),
        ),
      );
      return;
    }

    setState(() => _isCalibratingButtons = true);
    final samples = <int, int>{};

    try {
      final idleAccepted = await _showStepDialog(
        title: 'Idle sample',
        body:
            'Release all buttons and keep your hand still. Tap Capture to record the idle reading.',
        actionLabel: 'Capture',
      );
      if (!idleAccepted) return;
      final idleRaw = await _captureAverageRaw();

      for (var button = 1; button <= 12; button++) {
        if (!mounted) return;
        final accepted = await _showStepDialog(
          title: 'Button $button',
          body: 'Press and hold button $button, then tap Capture.',
          actionLabel: 'Capture',
        );
        if (!accepted) return;
        samples[button] = await _captureAverageRaw();
      }

      final validationError = _validateSamples(idleRaw, samples);
      if (validationError != null) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(validationError)),
        );
        return;
      }

      final tolerance = _estimateMatchTolerance(idleRaw, samples);
      final releaseTolerance = _estimateReleaseTolerance(idleRaw, samples);
      final profile = ButtonCalibrationProfile(
        idleRaw: idleRaw,
        releaseTolerance: releaseTolerance,
        matchTolerance: tolerance,
        buttonRawValues: samples,
      );

      await _sensorService.saveButtonCalibrationProfile(profile);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Button calibration saved')),
      );
      setState(() {});
    } finally {
      if (mounted) {
        setState(() => _isCalibratingButtons = false);
      }
    }
  }

  Future<void> _clearButtonCalibration() async {
    await _sensorService.clearButtonCalibrationProfile();
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Button calibration cleared')),
    );
    setState(() {});
  }

  Future<bool> _showStepDialog({
    required String title,
    required String body,
    required String actionLabel,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(body),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(actionLabel),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  Future<int> _captureAverageRaw() async {
    const samples = 12;
    var sum = 0;
    for (var i = 0; i < samples; i++) {
      await Future<void>.delayed(const Duration(milliseconds: 45));
      sum += _sensorService.currentRawValue;
    }
    return (sum / samples).round();
  }

  int _estimateMatchTolerance(int idleRaw, Map<int, int> samples) {
    if (samples.length < 2) return 140;
    final sorted = samples.values.toList()..sort();
    var minGap = 1 << 30;
    for (var i = 1; i < sorted.length; i++) {
      final gap = (sorted[i] - sorted[i - 1]).abs();
      if (gap < minGap) minGap = gap;
    }
    final byGap = (minGap * 0.35).round();
    final maxIdleDistance = samples.values
        .map((v) => (v - idleRaw).abs())
        .fold<int>(0, (prev, next) => next > prev ? next : prev);
    final byIdle = (maxIdleDistance * 0.2).round();
    return _clampInt(byGap < byIdle ? byGap : byIdle, 35, 220);
  }

  int _estimateReleaseTolerance(int idleRaw, Map<int, int> samples) {
    if (samples.isEmpty) return 80;
    final closestButtonDistance = samples.values
        .map((v) => (v - idleRaw).abs())
        .fold<int>(1 << 30, (prev, next) => next < prev ? next : prev);
    final estimate = (closestButtonDistance * 0.35).round();
    return _clampInt(estimate, 20, 180);
  }

  String? _validateSamples(int idleRaw, Map<int, int> samples) {
    if (samples.length < 12) {
      return 'Calibration incomplete. Please capture all 12 buttons.';
    }

    final distancesToIdle =
        samples.values.map((value) => (value - idleRaw).abs()).toList();
    final minIdleDistance = distancesToIdle.reduce(
      (a, b) => a < b ? a : b,
    );
    if (minIdleDistance < 25) {
      return 'Some button readings are too close to idle. Press each button firmly and recalibrate.';
    }

    final sorted = samples.entries.toList()
      ..sort((a, b) => a.value.compareTo(b.value));
    var minGap = 1 << 30;
    for (var i = 1; i < sorted.length; i++) {
      final gap = (sorted[i].value - sorted[i - 1].value).abs();
      if (gap < minGap) minGap = gap;
    }
    if (minGap < 20) {
      return 'Multiple buttons measured almost the same value. Recalibrate and hold each button steady while capturing.';
    }

    return null;
  }

  int _clampInt(int value, int min, int max) {
    if (value < min) return min;
    if (value > max) return max;
    return value;
  }
}

class _ButtonCalibrationCard extends StatelessWidget {
  const _ButtonCalibrationCard({
    required this.profile,
    required this.isConnected,
    required this.activeButton,
    required this.currentRaw,
    required this.isCalibrating,
    required this.onStartCalibration,
    required this.onClearCalibration,
  });

  final ButtonCalibrationProfile? profile;
  final bool isConnected;
  final int? activeButton;
  final int currentRaw;
  final bool isCalibrating;
  final VoidCallback? onStartCalibration;
  final VoidCallback? onClearCalibration;

  @override
  Widget build(BuildContext context) {
    final profileReady = profile?.isComplete ?? false;
    final statusColor = profileReady ? const Color(0xFF1B5E20) : Colors.black54;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
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
          const Text(
            'Button Mapping (1-12)',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 6),
          Text(
            profileReady
                ? 'Calibrated: ready for button-to-game mapping'
                : 'Not calibrated yet',
            style: TextStyle(color: statusColor, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Text('Connection: ${isConnected ? 'Connected' : 'Disconnected'}'),
          Text('Live raw: $currentRaw'),
          Text('Detected button: ${activeButton?.toString() ?? '-'}'),
          const SizedBox(height: 14),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              FilledButton.icon(
                onPressed: onStartCalibration,
                icon: const Icon(Icons.auto_fix_high),
                label: Text(
                  isCalibrating
                      ? 'Calibrating...'
                      : profileReady
                          ? 'Recalibrate'
                          : 'Run Guided Calibration',
                ),
              ),
              OutlinedButton(
                onPressed: onClearCalibration,
                child: const Text('Clear'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _BleStatusCard extends StatelessWidget {
  const _BleStatusCard({
    required this.isConnected,
    required this.status,
    required this.currentRaw,
    required this.currentPercent,
    required this.activeButton,
    required this.onConnect,
  });

  final bool isConnected;
  final String status;
  final int currentRaw;
  final double currentPercent;
  final int? activeButton;
  final Future<void> Function() onConnect;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color:
              isConnected ? const Color(0xFF22C55E) : const Color(0xFFE5E7EB),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                isConnected
                    ? Icons.bluetooth_connected
                    : Icons.bluetooth_disabled,
                color: isConnected ? const Color(0xFF16A34A) : Colors.black45,
              ),
              const SizedBox(width: 8),
              Text(
                isConnected
                    ? 'ESP sensor connected'
                    : 'ESP sensor disconnected',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: isConnected ? const Color(0xFF166534) : Colors.black87,
                ),
              ),
              const Spacer(),
              if (!isConnected)
                FilledButton.tonal(
                  onPressed: onConnect,
                  child: const Text('Connect'),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Text('Status: $status'),
          const SizedBox(height: 2),
          Text(
              'Live raw: $currentRaw  •  ${currentPercent.toStringAsFixed(1)}%'),
          if (activeButton != null) ...[
            const SizedBox(height: 2),
            Text('Detected button: $activeButton'),
          ],
        ],
      ),
    );
  }
}

class _QuickCaptureRow extends StatelessWidget {
  const _QuickCaptureRow({
    required this.normalized,
    required this.onCaptureMin,
    required this.onCaptureCenter,
    required this.onCaptureMax,
    required this.onCaptureThreshold,
  });

  final double normalized;
  final VoidCallback onCaptureMin;
  final VoidCallback onCaptureCenter;
  final VoidCallback onCaptureMax;
  final VoidCallback onCaptureThreshold;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Live normalized: ${normalized.toStringAsFixed(3)}',
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            OutlinedButton(
              onPressed: onCaptureMin,
              child: const Text('Capture Min'),
            ),
            OutlinedButton(
              onPressed: onCaptureCenter,
              child: const Text('Capture Center'),
            ),
            OutlinedButton(
              onPressed: onCaptureMax,
              child: const Text('Capture Max'),
            ),
            OutlinedButton(
              onPressed: onCaptureThreshold,
              child: const Text('Capture Threshold'),
            ),
          ],
        ),
      ],
    );
  }
}

class _SliderTile extends StatelessWidget {
  const _SliderTile({
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    required this.onChanged,
    this.divisions,
  });

  final String label;
  final double value;
  final double min;
  final double max;
  final int? divisions;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          '$label: ${value.toStringAsFixed(2)}',
          style: const TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
        Slider(
          value: value.clamp(min, max),
          min: min,
          max: max,
          divisions: divisions,
          onChanged: onChanged,
        ),
      ],
    );
  }
}
