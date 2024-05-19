// lib/src/providers/auth_provider.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_service.dart';

class AuthProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  bool _isLoading = false;

  bool _isLoggedIn = false;
  bool get isLoading => _isLoading;

  Future<bool> login(String email, String password, bool rememberMe) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await _apiService.login(email, password);
      // Handle the response, save tokens, etc.
      final token = response['token'];

      if (rememberMe) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('email', email);
        await prefs.setString('password', password);
      }

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', token);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Register a new user
  Future<bool> register(String email, String username, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await _apiService.register(email, username, password);
      // Handle the response, save tokens, etc.

      // if successful, login the user
      if (!response['error']) {
        final loginRes = await login(email, password, false);
        if (loginRes) {
          _isLoading = false;
          notifyListeners();
          return true;
        } else {
          _isLoading = false;
          notifyListeners();
          return false;
        }
      } else {
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    _isLoggedIn = token != null;
    notifyListeners();
  }

  Future<void> checkRememberMe() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('email');
    final password = prefs.getString('password');

    if (email != null && password != null) {
      // Automatically login if credentials exist
      _isLoggedIn = true;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('email');
    await prefs.remove('password');
    _isLoggedIn = false;
    notifyListeners();
  }
}
