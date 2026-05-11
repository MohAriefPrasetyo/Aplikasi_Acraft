import '../services/auth_service.dart';

class RegisterViewModel {
  final _authService = AuthService();

  Future<String?> register(String username, String password) async {
    if (username.isEmpty || password.isEmpty) {
      return 'Username dan password tidak boleh kosong.';
    }
    if (password.length < 6) {
      return 'Password minimal 6 karakter.';
    }
    final success = await _authService.register(username, password);
    if (!success) return 'Username sudah digunakan.';
    return null; // null = sukses
  }
}
