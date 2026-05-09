import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart'; // TAMBAHAN: Import Supabase

class ProfileViewModel extends ChangeNotifier {
  String _username = "";
  String get username => _username;

  // Panggil otomatis saat ViewModel pertama kali dibuat
  ProfileViewModel() {
    loadProfile();
  }

  Future<void> loadProfile() async {
    // 1. Cek dulu apakah user login menggunakan Google/Supabase
    final user = Supabase.instance.client.auth.currentUser;
    
    if (user != null && user.email != null) {
      // Jika ada, gunakan email dari Google
      _username = user.email!;
    } else {
      // 2. Jika tidak ada, ambil dari SharedPreferences (untuk user login manual)
      final prefs = await SharedPreferences.getInstance();
      _username = prefs.getString('username') ?? "Pengguna ACraft";
    }
    
    notifyListeners();
  }

  Future<void> logout() async {
    // Hapus sesi manual
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear(); 
    
    // Hapus sesi Google/Supabase
    await Supabase.instance.client.auth.signOut();
  }
}