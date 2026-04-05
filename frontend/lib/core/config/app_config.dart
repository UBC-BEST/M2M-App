import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Provides strongly typed access to environment-backed configuration.
class AppConfig {
  AppConfig._();

  static const _baseUrlKey = 'FLUTTER_APP_BASE_URL';
  static const _ipKey = 'FLUTTER_APP_EXP_IP';
  static const _portKey = 'FLUTTER_APP_EXP_PORT';
  static const _bleServiceUuidKey = 'FLUTTER_APP_BLE_SERVICE_UUID';
  static const _bleCharacteristicUuidKey =
      'FLUTTER_APP_BLE_CHARACTERISTIC_UUID';
  static const _bypassAuthKey = 'FLUTTER_APP_BYPASS_AUTH';
  static const _allowGameLaunchWithoutSensorKey =
      'FLUTTER_APP_ALLOW_GAME_LAUNCH_WITHOUT_SENSOR';

  static const _defaultBleServiceUuid = '6e400001-b5a3-f393-e0a9-e50e24dcca9e';
  static const _defaultBleCharacteristicUuid =
      '6e400002-b5a3-f393-e0a9-e50e24dcca9e';

  /// Returns the server base URL defined in the `.env` file.
  ///
  /// By default the config prefers the [`FLUTTER_APP_BASE_URL`] variable, but
  /// will fall back to building a URL from [`FLUTTER_APP_EXP_IP`] and
  /// [`FLUTTER_APP_EXP_PORT`]. This method throws when the configuration is
  /// missing or malformed so the app fails fast during startup.
  static String get serverBaseUrl {
    final explicitUrl = _read(_baseUrlKey);
    if (explicitUrl != null && explicitUrl.isNotEmpty) {
      return explicitUrl;
    }

    final ip = _read(_ipKey);
    if (ip == null || ip.isEmpty) {
      throw StateError(
        'Missing API configuration. Define $_baseUrlKey or at least $_ipKey '
        'in your .env file.',
      );
    }

    final port = _read(_portKey);

    final sanitizedIp = ip.startsWith('http') ? ip : 'http://$ip';
    return port != null && port.isNotEmpty ? '$sanitizedIp:$port' : sanitizedIp;
  }

  /// Returns the BLE service UUID.
  ///
  /// Defaults to the ESP32 service UUID if not provided in the `.env` file.
  static String get bleServiceUuid {
    final value = _read(_bleServiceUuidKey);
    return value != null && value.isNotEmpty ? value : _defaultBleServiceUuid;
  }

  /// Returns the BLE characteristic UUID.
  ///
  /// Defaults to the ESP32 characteristic UUID if not provided in the `.env` file.
  static String get bleCharacteristicUuid {
    final value = _read(_bleCharacteristicUuidKey);
    return value != null && value.isNotEmpty
        ? value
        : _defaultBleCharacteristicUuid;
  }

  /// When `true` (set `FLUTTER_APP_BYPASS_AUTH=true` in `.env`), the app stores a
  /// local placeholder token so you can open the UI without a running backend.
  static bool get bypassAuth {
    return _readBool(_bypassAuthKey);
  }

  /// When `true`, allows launching Unity games without sensor connection/preset
  /// checks. Intended only for local development and testing.
  static bool get allowGameLaunchWithoutSensor {
    return _readBool(_allowGameLaunchWithoutSensorKey);
  }

  static String? _read(String key) => dotenv.env[key]?.trim();

  static bool _readBool(String key) {
    final v = _read(key)?.toLowerCase();
    return v == 'true' || v == '1' || v == 'yes';
  }
}
