import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/constants/storage_keys.dart';
import '../domain/game_calibration_preset.dart';
import '../domain/unity_game.dart';

class GameCalibrationStore {
  Future<GameCalibrationPreset> readPreset(UnityGame game) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_keyFor(game));
    if (raw == null || raw.isEmpty) {
      return const GameCalibrationPreset();
    }

    try {
      final json = jsonDecode(raw);
      if (json is Map<String, dynamic>) {
        return GameCalibrationPreset.fromJson(json);
      }
      if (json is Map) {
        return GameCalibrationPreset.fromJson(
          json.map(
            (key, value) => MapEntry(key.toString(), value),
          ),
        );
      }
    } catch (_) {}
    return const GameCalibrationPreset();
  }

  Future<void> writePreset(UnityGame game, GameCalibrationPreset preset) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyFor(game), jsonEncode(preset.toJson()));
  }

  Future<bool> hasPreset(UnityGame game) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(_keyFor(game));
  }

  String _keyFor(UnityGame game) =>
      '${StorageKeys.gameCalibrationPrefix}${game.id}';
}
