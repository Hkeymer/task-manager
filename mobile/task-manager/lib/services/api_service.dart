import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiService {
  final _storage = FlutterSecureStorage();
  String get baseUrl => dotenv.env['BASE_URL'] ?? 'http://192.168.1.3:3000/';
  Map<String, String> defaultHeaders(String? token) {
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

  Future<http.Response> _request(String method, String path,
      {Map<String, dynamic>? body, bool retry = true}) async {
    String? token = await getAccessToken();
    final uri = Uri.parse('$baseUrl$path');
    final headers = defaultHeaders(token);
    http.Response res;
    if (method == 'GET')
      res = await http.get(uri, headers: headers);
    else if (method == 'POST')
      res = await http.post(uri, headers: headers, body: json.encode(body));
    else if (method == 'PATCH')
      res = await http.patch(uri, headers: headers, body: json.encode(body));
    else if (method == 'DELETE')
      res = await http.delete(uri, headers: headers);
    else
      throw Exception('Unsupported method');
    if (res.statusCode == 401 && retry) {
      final ok = await _tryRefresh();
      if (ok) return _request(method, path, body: body, retry: false);
    }
    return res;
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
      await saveTokens(j['accessToken'], j['refreshToken']);
      return true;
    } else {
      await clearTokens();
      return false;
    }
  }

  Future<Map<String, dynamic>> register(
      String email, String password, String name) async {
    final res = await _request('POST', '/api/v1/auth/register',
        body: {'email': email, 'password': password, 'name': name},
        retry: false);
    return {'status': res.statusCode, 'body': res.body};
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    final res = await _request('POST', '/api/v1/auth/login',
        body: {'email': email, 'password': password}, retry: false);
    if (res.statusCode == 200 || res.statusCode == 201) {
      final j = json.decode(res.body);
      await saveTokens(j['accessToken'], j['refreshToken']);
    }
    return {'status': res.statusCode, 'body': res.body};
  }

  Future<Map<String, dynamic>> logout() async {
    final res = await _request('POST', '/api/v1/auth/logout', retry: false);
    await clearTokens();
    return {'status': res.statusCode, 'body': res.body};
  }

  Future<List<dynamic>> getTasksUser() async {
    final res = await _request('GET', '/api/v1/tasks/my-tasks');
    if (res.statusCode == 200 || res.statusCode == 201)
      return json.decode(res.body);
    throw Exception('Error');
  }

  Future<Map<String, dynamic>> createTask(Map<String, dynamic> data) async {
    final res = await _request('POST', '/api/v1/tasks', body: data);
    return {'status': res.statusCode, 'body': res.body};
  }

  Future<Map<String, dynamic>> patchTask(
      String id, Map<String, dynamic> data) async {
    final res = await _request('PATCH', '/api/v1/tasks/$id', body: data);
    return {'status': res.statusCode, 'body': res.body};
  }

  Future<Map<String, dynamic>> deleteTask(String id) async {
    final res = await _request('DELETE', '/api/v1/tasks/$id');
    return {'status': res.statusCode, 'body': res.body};
  }

  Future<List<dynamic>> getMyTasks() async {
    final res = await _request('GET', '/api/v1/tasks/my-tasks');
    if (res.statusCode == 200 || res.statusCode == 201)
      return json.decode(res.body);
    throw Exception('Error');
  }

  Future<List<dynamic>> getFavorites() async {
    final res = await _request('GET', '/api/v1/tasks/favorites');
    if (res.statusCode == 200 || res.statusCode == 201)
      return json.decode(res.body);
    throw Exception('Error');
  }

  Future<Map<String, dynamic>> toggleComplete(String id) async {
    final res = await _request('PATCH', '/api/v1/tasks/$id/completed');
    return {'status': res.statusCode, 'body': res.body};
  }

  Future<Map<String, dynamic>> toggleFavorite(String id) async {
    final res = await _request('PATCH', '/api/v1/tasks/$id/favorite');
    return {'status': res.statusCode, 'body': res.body};
  }

  Future<Map<String, dynamic>> toggleAllCompleted() async {
    final res = await _request('PATCH', '/api/v1/tasks/completed/toggle-all');
    return {'status': res.statusCode, 'body': res.body};
  }

  Future<List<dynamic>> getCategories() async {
    final res = await _request('GET', '/api/v1/categories');
    if (res.statusCode == 200 || res.statusCode == 201)
      return json.decode(res.body);
    throw Exception('Error');
  }

  Future<Map<String, dynamic>> createCategory(Map<String, dynamic> data) async {
    final res = await _request('POST', '/api/v1/categories', body: data);
    return {'status': res.statusCode, 'body': res.body};
  }

  Future<Map<String, dynamic>> patchCategory(
      String id, Map<String, dynamic> data) async {
    final res = await _request('PATCH', '/api/v1/categories/$id', body: data);
    return {'status': res.statusCode, 'body': res.body};
  }

  Future<Map<String, dynamic>> deleteCategory(String id) async {
    final res = await _request('DELETE', '/api/v1/categories/$id');
    return {'status': res.statusCode, 'body': res.body};
  }
}
