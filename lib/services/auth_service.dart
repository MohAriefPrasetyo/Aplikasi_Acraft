import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final _supabase = Supabase.instance.client;

  // --------------------------------------------------------
  // 1. KODE LAMA: LOGIN & REGISTER MANUAL (TIDAK DIUBAH)
  // --------------------------------------------------------
  Future<bool> login(String username, String password) async {
    final res = await _supabase
        .from('users')
        .select()
        .eq('username', username)
        .eq('password', password)
        .maybeSingle();
    if (res != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('username', username);
      return true;
    }
    return false;
  }

  Future<bool> register(String username, String password) async {
    final existing = await _supabase
        .from('users')
        .select()
        .eq('username', username)
        .maybeSingle();
    if (existing != null) return false;

    await _supabase.from('users').insert({
      'username': username,
      'password': password,
    });
    return true;
  }

  // --------------------------------------------------------
  // 2. KODE BARU: LOGIN GOOGLE (CARA MUDAH SUPABASE)
  // --------------------------------------------------------
  Future<void> signInWithGoogle() async {
    // Ini adalah keajaiban Supabase. 
    // Otomatis membuka halaman login Google di Edge tanpa package tambahan!
    await _supabase.auth.signInWithOAuth(
      OAuthProvider.google,
      redirectTo: 'http://localhost:*/',
      queryParams: {
        'prompt': 'select_account', // Memaksa Google untuk selalu menampilkan pop-up pilihan akun
      },
    );
  }

  // --------------------------------------------------------
  // 3. LOGOUT & GET USERNAME
  // --------------------------------------------------------
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('username');
    await _supabase.auth.signOut();
  }

  Future<String> getCurrentUsername() async {
    final user = _supabase.auth.currentUser;
    // Jika login menggunakan akun Google, ambil emailnya
    if (user != null && user.email != null) {
      return user.email!;
    }
    // Jika login manual, ambil dari penyimpanan lokal
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('username') ?? '';
  }

  bool isLoggedIn() {
    return Supabase.instance.client.auth.currentUser != null;
  }
}