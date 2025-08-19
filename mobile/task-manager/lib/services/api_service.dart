import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiService {
  final _storage = const FlutterSecureStorage();

  String get baseUrl => dotenv.env['BASE_URL'] ?? 'http://192.168.1.3:3000/';

  Map<String, String> _defaultHeaders(String? token) {
    final headers = {'Content-Type': 'application/json'};
    if (token != null) headers['Authorization'] = 'Bearer $token';
    return headers;
  }

  Future<String?> getAccessToken() => _storage.read(key: 'access_token');
  Future<String?> getRefreshToken() => _storage.read(key: 'refresh_token');

  Future<void> saveTokens(String access, String refresh) async {
    await _storage.write(key: 'access_token', value: access);
    await _storage.write(key: 'refresh_token', value: refresh);
  }

  Future<void> clearTokens() async {
    await _storage.delete(key: 'access_token');
    await _storage.delete(key: 'refresh_token');
  }

  Future<http.Response> request(
    String method,
    String path, {
    Map<String, dynamic>? body,
    bool retry = true,
  }) async {
    try {
      final token = await getAccessToken();
      final uri = Uri.parse('$baseUrl$path');
      final headers = _defaultHeaders(token);

      http.Response res;
      switch (method) {
        case 'GET':
          res = await http.get(uri, headers: headers);
          break;
        case 'POST':
          res = await http.post(uri, headers: headers, body: json.encode(body));
          break;
        case 'PATCH':
          res =
              await http.patch(uri, headers: headers, body: json.encode(body));
          break;
        case 'DELETE':
          res = await http.delete(uri, headers: headers);
          break;
        default:
          throw Exception('Unsupported method');
      }

      // 🔄 Si expira el token intenta refrescar
      if (res.statusCode == 401 && retry) {
        final ok = await _tryRefresh();
        if (ok) return request(method, path, body: body, retry: false);
      }

      return res;
    } catch (e) {
      return http.Response(
        json.encode({'error': 'Error de conexión: $e'}),
        500,
      );
    }
  }

  Future<bool> _tryRefresh() async {
    final refresh = await getRefreshToken();
    if (refresh == null) return false;

    final uri = Uri.parse('$baseUrl/api/v1/auth/refresh');
    final res = await http.post(uri,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'refresh': refresh}));

    if (res.statusCode == 200 || res.statusCode == 201) {
      final j = json.decode(res.body);
      await saveTokens(j['tokens']['accessToken'], j['tokens']['refreshToken']);
      return true;
    } else {
      await clearTokens();
      return false;
    }
  }
}
