import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Provides strongly typed access to environment-backed configuration.
class AppConfig {
  AppConfig._();

  static const _baseUrlKey = 'FLUTTER_APP_BASE_URL';
  static const _ipKey = 'FLUTTER_APP_EXP_IP';
  static const _portKey = 'FLUTTER_APP_EXP_PORT';

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

  static String? _read(String key) => dotenv.env[key]?.trim();
}
