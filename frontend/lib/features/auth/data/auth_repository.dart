import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:m2m/core/config/app_config.dart';

class AuthRepository {
  AuthRepository({http.Client? httpClient})
      : _httpClient = httpClient ?? http.Client();

  final http.Client _httpClient;

  Future<AuthResponse> login({
    required String email,
    required String password,
  }) async {
    final uri = Uri.parse('${AppConfig.serverBaseUrl}/auth/login');
    final response = await _httpClient.post(
      uri,
      headers: _jsonHeaders,
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode != 200) {
      throw AuthException(_resolveErrorMessage(response.body, 'Login failed'));
    }

    final decoded = _decode(response.body);
    final token = decoded['accessToken'] as String?;

    if (token == null || token.isEmpty) {
      throw const AuthException(
          'Missing access token in the response payload.');
    }

    return AuthResponse(accessToken: token);
  }

  Future<void> register({
    required String email,
    required String displayName,
    required String password,
  }) async {
    final uri = Uri.parse('${AppConfig.serverBaseUrl}/auth/register');
    final response = await _httpClient.post(
      uri,
      headers: _jsonHeaders,
      body: jsonEncode({
        'email': email,
        'displayName': displayName,
        'password': password,
      }),
    );

    if (response.statusCode != 201) {
      throw AuthException(
        _resolveErrorMessage(response.body, 'Registration failed'),
      );
    }
  }

  Map<String, dynamic> _decode(String source) {
    try {
      final decoded = jsonDecode(source);
      if (decoded is Map<String, dynamic>) {
        return decoded;
      }
      throw const AuthException('Unexpected response format.');
    } on FormatException {
      throw const AuthException('Failed to decode server response.');
    }
  }

  static Map<String, String> get _jsonHeaders => const {
        'Content-Type': 'application/json',
      };

  String _resolveErrorMessage(String body, String fallback) {
    try {
      final decoded = jsonDecode(body);
      if (decoded is Map<String, dynamic>) {
        final message = decoded['message'] ?? decoded['error'];
        if (message is String && message.isNotEmpty) {
          return message;
        }
      }
    } catch (_) {}
    return fallback;
  }
}

class AuthResponse {
  const AuthResponse({required this.accessToken});

  final String accessToken;
}

class AuthException implements Exception {
  const AuthException(this.message);

  final String message;

  @override
  String toString() => message;
}
