import 'dart:convert';
import 'package:flutter/material.dart';
import '../services/api_service.dart';
class AuthProvider extends ChangeNotifier{
  final ApiService _api = ApiService();
  bool _authenticated = false;
  bool get isAuthenticated => _authenticated;
  Future<bool> login(String email, String password) async{
    final res = await _api.login(email,password);
    if(res['status']==200){
      _authenticated = true;
      notifyListeners();
      return true;
    }
    return false;
  }
  Future<bool> register(String email, String password) async{
    final res = await _api.register(email,password);
    return res['status']==201 || res['status']==200;
  }
  Future<void> logout() async{
    await _api.logout();
    _authenticated = false;
    notifyListeners();
  }
}
