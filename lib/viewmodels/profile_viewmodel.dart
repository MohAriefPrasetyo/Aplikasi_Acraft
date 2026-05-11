import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileViewModel {
  String username = '';

  Future<void> loadProfile() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user != null && user.email != null) {
      username = user.email!;
    } else {
      final prefs = await SharedPreferences.getInstance();
      username = prefs.getString('username') ?? 'Pengguna ACraft';
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    await Supabase.instance.client.auth.signOut();
  }
}
