import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/constants/storage_keys.dart';
import '../domain/button_calibration_profile.dart';

class ButtonCalibrationStore {
  Future<ButtonCalibrationProfile?> readProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(StorageKeys.buttonCalibrationProfile);
    if (raw == null || raw.isEmpty) return null;

    try {
      final json = jsonDecode(raw);
      if (json is Map<String, dynamic>) {
        return ButtonCalibrationProfile.fromJson(json);
      }
      if (json is Map) {
        return ButtonCalibrationProfile.fromJson(
          json.map((key, value) => MapEntry(key.toString(), value)),
        );
      }
    } catch (_) {}
    return null;
  }

  Future<void> writeProfile(ButtonCalibrationProfile profile) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      StorageKeys.buttonCalibrationProfile,
      jsonEncode(profile.toJson()),
    );
  }

  Future<void> clearProfile() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(StorageKeys.buttonCalibrationProfile);
  }
}
