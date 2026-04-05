import 'package:flutter/material.dart';

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
  final Map<UnityGame, GameCalibrationPreset> _presets =
      <UnityGame, GameCalibrationPreset>{};

  bool _loading = true;
  UnityGame _selectedGame = UnityGame.pizza;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    await _bridge.ensureInitialized();
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

  @override
  Widget build(BuildContext context) {
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
        ],
      ),
    );
  }

  void _updatePreset(GameCalibrationPreset preset) {
    setState(() {
      _presets[_selectedGame] = preset;
    });
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
