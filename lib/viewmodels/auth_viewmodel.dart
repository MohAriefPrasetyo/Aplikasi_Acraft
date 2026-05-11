import '../services/auth_service.dart';

class AuthViewModel {
  final _authService = AuthService();

  Future<bool> login(String username, String password) async {
    return await _authService.login(username, password);
  }

  Future<void> loginWithGoogle() async {
    await _authService.signInWithGoogle();
  }

  Future<void> logout() async {
    await _authService.logout();
  }
}
