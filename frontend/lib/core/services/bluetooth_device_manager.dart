import 'package:shared_preferences/shared_preferences.dart';

import '../constants/storage_keys.dart';

class SavedBluetoothDevice {
  const SavedBluetoothDevice({
    required this.id,
    required this.name,
  });

  final String id;
  final String name;

  String get displayName => name.isNotEmpty ? name : id;
}

class BluetoothDeviceManager {
  BluetoothDeviceManager({
    SharedPreferences? preferences,
  }) : _preferences = preferences;

  final SharedPreferences? _preferences;

  Future<SharedPreferences> get _prefs async =>
      _preferences ?? await SharedPreferences.getInstance();

  Future<SavedBluetoothDevice?> readSelectedDevice() async {
    final prefs = await _prefs;
    final id = prefs.getString(StorageKeys.bluetoothDeviceId);

    if (id == null || id.isEmpty) {
      return null;
    }

    final name = prefs.getString(StorageKeys.bluetoothDeviceName) ?? '';
    return SavedBluetoothDevice(id: id, name: name);
  }

  Future<void> saveSelectedDevice({
    required String id,
    required String name,
  }) async {
    final prefs = await _prefs;
    await prefs.setString(StorageKeys.bluetoothDeviceId, id);
    await prefs.setString(StorageKeys.bluetoothDeviceName, name);
  }

  Future<void> clearSelectedDevice() async {
    final prefs = await _prefs;
    await prefs.remove(StorageKeys.bluetoothDeviceId);
    await prefs.remove(StorageKeys.bluetoothDeviceName);
  }
}
