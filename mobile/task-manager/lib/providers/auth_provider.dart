import 'dart:convert';
import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../exceptions/auth_exception.dart';

class AuthProvider extends ChangeNotifier {
  final ApiService _api = ApiService();
  bool _authenticated = false;
  bool get isAuthenticated => _authenticated;

  Future<bool> login(String email, String password) async {
    try {
      await _api.login(email, password);
      _authenticated = true;
      notifyListeners();
      return true;
    } on AuthException catch (e) {
      print("Auth error: $e");
      throw e; // Rethrow the exception
    } catch (e) {
      print("Unexpected error: $e");
      throw AuthException("Error inesperado.");
    }
  }

  Future<bool> register(String email, String password, String name) async {
    final res = await _api.register(email, password, name);
    return res['status'] == 201 || res['status'] == 200;
  }

  Future<void> logout() async {
    await _api.logout();
    _authenticated = false;
    notifyListeners();
  }
}
