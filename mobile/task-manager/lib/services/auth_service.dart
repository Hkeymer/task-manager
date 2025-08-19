import 'dart:convert';
import 'package:task_manager/models/user.dart';
import '../exceptions/auth_exception.dart';
import 'api_service.dart';

class AuthService {
  final ApiService _api;

  AuthService(this._api);

  Future<Map<String, dynamic>> register(
      String email, String password, String name) async {
    try {
      final res = await _api.request(
        'POST',
        '/api/v1/auth/register',
        body: {'email': email, 'password': password, 'name': name},
        retry: false,
      );

      if (res.statusCode >= 200 && res.statusCode < 300) {
        // Registro exitoso
        return {
          'status': res.statusCode,
          'body': res.body,
        };
      } else {
        final j = json.decode(res.body);
        final msg = j['message'] ?? "Credenciales inválidas.";
        throw AuthException(msg);
      }
    } catch (e) {
      if (e is AuthException) rethrow;
      throw AuthException("No se pudo conectar con el servidor.");
    }
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final res = await _api.request(
        'POST',
        '/api/v1/auth/login',
        body: {'email': email, 'password': password},
        retry: false,
      );

      if (res.statusCode == 200 || res.statusCode == 201) {
        final j = json.decode(res.body);

        if (j['tokens'] != null) {
          await _api.saveTokens(
            j['tokens']['accessToken'],
            j['tokens']['refreshToken'],
          );
          return {'status': res.statusCode, 'body': res.body};
        }
        throw AuthException("El servidor no envió tokens válidos.");
      } else if (res.statusCode == 400 || res.statusCode == 401) {
        // Aquí tomamos el mensaje real que manda el backend
        final j = json.decode(res.body);
        final msg = j['message'] ?? "Error en el egistro.";
        throw AuthException(msg);
      } else {
        throw AuthException("Error inesperado (${res.statusCode}).");
      }
    } catch (e) {
      if (e is AuthException) rethrow;
      throw AuthException("No se pudo conectar con el servidor.");
    }
  }

  Future<User> getProfile() async {
    final res = await _api.request('GET', '/api/v1/auth/profile', retry: false);

    if (res.statusCode == 200 || res.statusCode == 201) {
      return User.fromJson(json.decode(res.body));
    }
    throw AuthException("Error al obtener los datos del usuario.");
  }

  Future<Map<String, dynamic>> logout() async {
    final res = await _api.request('POST', '/api/v1/auth/logout', retry: false);
    await _api.clearTokens();
    return {'status': res.statusCode, 'body': res.body};
  }
}
