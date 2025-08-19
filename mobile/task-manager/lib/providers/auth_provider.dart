import 'package:flutter/material.dart';
import 'package:task_manager/models/user.dart';
import 'package:task_manager/services/api_service.dart';
import '../services/auth_service.dart';
import '../exceptions/auth_exception.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService;

  AuthProvider({AuthService? authService})
      : _authService = authService ?? AuthService(ApiService());

  bool _authenticated = false;
  bool get isAuthenticated => _authenticated;

  User? _user;
  User? get user => _user;

  Future<bool> login(String email, String password) async {
    try {
      await _authService.login(email, password);
      _authenticated = true;
      notifyListeners();
      return true;
    } on AuthException catch (e) {
      print("Auth error: ${e.message}");
      throw e; // Mantiene el mensaje real del backend
    } catch (e) {
      print("Unexpected error: $e");
      throw AuthException("No se pudo conectar con el servidor.");
    }
  }

  Future<bool> register(String email, String password, String name) async {
    final res = await _authService.register(email, password, name);
    return res['status'] == 201 || res['status'] == 200;
  }

  Future<void> logout() async {
    await _authService.logout();
    _authenticated = false;
    notifyListeners();
  }

  Future<void> loadUser() async {
    _user = await _authService.getProfile();
    notifyListeners();
  }
}

