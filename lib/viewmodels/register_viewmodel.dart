import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class RegisterViewModel extends ChangeNotifier {
  final _authService = AuthService();
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  String? errorMessage;

  Future<bool> register(String username, String password) async {
    _isLoading = true;
    errorMessage = null;
    notifyListeners();
    try {
      if (username.isEmpty || password.isEmpty) {
        errorMessage = 'Username dan password tidak boleh kosong.';
        _isLoading = false;
        notifyListeners();
        return false;
      }
      if (password.length < 6) {
        errorMessage = 'Password minimal 6 karakter.';
        _isLoading = false;
        notifyListeners();
        return false;
      }
      final success = await _authService.register(username, password);
      if (!success) errorMessage = 'Username sudah digunakan.';
      _isLoading = false;
      notifyListeners();
      return success;
    } catch (e) {
      errorMessage = 'Registrasi gagal. Coba lagi.';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
}
