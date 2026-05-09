import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart'; // TAMBAHAN: Import Supabase

class WelcomeViewModel extends ChangeNotifier {
  String _username = "";
  String get username => _username;

  Future<void> initWelcome() async {
    // 1. Cek dulu apakah user login menggunakan Google/Supabase
    final user = Supabase.instance.client.auth.currentUser;
    
    if (user != null && user.email != null) {
      // Jika ada, gunakan email dari Google
      _username = user.email!;
    } else {
      // 2. Jika tidak ada, ambil dari SharedPreferences (untuk user login manual)
      final prefs = await SharedPreferences.getInstance();
      _username = prefs.getString('username') ?? "Pengguna";
    }
    
    notifyListeners();

    // Delay 2 detik sebelum pindah ke halaman Home
    await Future.delayed(const Duration(seconds: 2));
  }
}