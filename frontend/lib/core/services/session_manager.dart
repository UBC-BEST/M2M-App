import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/storage_keys.dart';

class SessionManager {
  SessionManager({
    SharedPreferences? preferences,
    FlutterSecureStorage? secureStorage,
  })  : _preferences = preferences,
        _secureStorage = secureStorage ?? const FlutterSecureStorage();

  final SharedPreferences? _preferences;
  final FlutterSecureStorage _secureStorage;

  Future<SharedPreferences> get _prefs async =>
      _preferences ?? await SharedPreferences.getInstance();

  Future<void> saveAccessToken(String token) async {
    final prefs = await _prefs;
    await prefs.setString(StorageKeys.accessToken, token);
  }

  Future<String?> readAccessToken() async {
    final prefs = await _prefs;
    return prefs.getString(StorageKeys.accessToken);
  }

  Future<void> clearSession() async {
    final prefs = await _prefs;
    await prefs.remove(StorageKeys.accessToken);
    await prefs.remove(StorageKeys.useFaceId);
    await _secureStorage.delete(key: StorageKeys.faceIdEmail);
    await _secureStorage.delete(key: StorageKeys.faceIdPassword);
  }

  Future<bool> isFaceIdEnabled() async {
    final prefs = await _prefs;
    return prefs.getBool(StorageKeys.useFaceId) ?? false;
  }

  Future<void> updateFaceIdPreference({
    required bool enabled,
    String? email,
    String? password,
  }) async {
    final prefs = await _prefs;
    await prefs.setBool(StorageKeys.useFaceId, enabled);

    if (!enabled) {
      await _secureStorage.delete(key: StorageKeys.faceIdEmail);
      await _secureStorage.delete(key: StorageKeys.faceIdPassword);
      return;
    }

    if (email != null) {
      await _secureStorage.write(key: StorageKeys.faceIdEmail, value: email);
    }

    if (password != null) {
      await _secureStorage.write(
        key: StorageKeys.faceIdPassword,
        value: password,
      );
    }
  }
}
