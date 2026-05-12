import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class WelcomeViewModel {
  String username = '';

  Future<void> initWelcome() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user != null && user.email != null) {
      username = user.email!;
    } else {
      final prefs = await SharedPreferences.getInstance();
      username = prefs.getString('username') ?? 'Pengguna';
    }
  }

  Future<void> delayBeforeHome() async {
    await Future.delayed(const Duration(seconds: 2));
  }
}
