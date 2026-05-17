import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider with ChangeNotifier {
  bool _isLoggedIn = false;
  String? _userName;
  String? _userEmail;

  bool get isLoggedIn => _isLoggedIn;
  String? get userName => _userName;
  String? get userEmail => _userEmail;

  AuthProvider() {
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    _isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    _userName = prefs.getString('userName');
    _userEmail = prefs.getString('userEmail');
    notifyListeners();
  }

  Future<bool> register(String name, String email, String password) async {
    final prefs = await SharedPreferences.getInstance();
    // In a real app, we would send this to a server.
    // Locally, we'll just save this one user for simplicity.
    await prefs.setString('reg_name', name);
    await prefs.setString('reg_email', email);
    await prefs.setString('reg_password', password);
    return true;
  }

  Future<bool> login(String email, String password) async {
    final prefs = await SharedPreferences.getInstance();
    final regEmail = prefs.getString('reg_email');
    final regName = prefs.getString('reg_name');

    // Jika email yang dimasukkan sama dengan email terdaftar, gunakan nama yang didaftarkan
    String name = 'Mahasiswa';
    if (regEmail != null && email.trim().toLowerCase() == regEmail.trim().toLowerCase()) {
      name = regName ?? 'Mahasiswa';
    } else {
      // Jika tidak terdaftar, gunakan nama dari prefix email (bagian sebelum '@')
      if (email.contains('@')) {
        final prefix = email.split('@')[0];
        if (prefix.isNotEmpty) {
          name = prefix[0].toUpperCase() + prefix.substring(1);
        }
      }
    }

    _isLoggedIn = true;
    _userName = name;
    _userEmail = email;
    
    await prefs.setBool('isLoggedIn', true);
    await prefs.setString('userName', name);
    await prefs.setString('userEmail', email);
    
    notifyListeners();
    return true;
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);
    _isLoggedIn = false;
    _userName = null;
    _userEmail = null;
    notifyListeners();
  }
}
