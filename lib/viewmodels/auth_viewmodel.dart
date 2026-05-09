import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class AuthViewModel extends ChangeNotifier {
  final _authService = AuthService();
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  String? errorMessage;

  // 1. KODE LAMA: LOGIN MANUAL
  Future<bool> login(String username, String password) async {
    _isLoading = true;
    errorMessage = null;
    notifyListeners();
    try {
      final success = await _authService.login(username, password);
      if (!success) errorMessage = 'Username atau password salah';
      _isLoading = false;
      notifyListeners();
      return success;
    } catch (e) {
      errorMessage = 'Terjadi kesalahan. Coba lagi.';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // 2. KODE BARU: LOGIN DENGAN GOOGLE
  Future<bool> loginWithGoogle() async {
    _isLoading = true;
    errorMessage = null;
    notifyListeners();
    
    try {
      await _authService.signInWithGoogle();
      _isLoading = false;
      notifyListeners();
      return true; // Mengembalikan true jika login sukses
    } catch (e) {
      // Mengambil pesan error (misal: "Login dibatalkan oleh pengguna")
      errorMessage = e.toString(); 
      _isLoading = false;
      notifyListeners();
      return false; // Mengembalikan false jika gagal/batal
    }
  }

  // 3. KODE LAMA: LOGOUT
  Future<void> logout() async {
    await _authService.logout();
    notifyListeners();
  }
}