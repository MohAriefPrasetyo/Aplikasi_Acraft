import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:device_preview/device_preview.dart';

import 'views/login_view.dart';
import 'views/register_view.dart';
import 'views/welcome_view.dart';
import 'views/home_view.dart';
import 'views/profile_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://fydyehygazkaxabxblih.supabase.co',
    anonKey: 'sb_publishable_yk4DXbP8vvhkGMTBurxbwg_7KjoezZh',
  );

  runApp(
    DevicePreview(
      enabled: true,
      builder: (context) => const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      useInheritedMediaQuery: true,
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
      theme: ThemeData(primarySwatch: Colors.brown),
      home: const LoginView(),
      routes: {
        '/login': (context) => const LoginView(),
        '/register': (context) => const RegisterView(),
        '/welcome': (context) => const WelcomeView(),
        '/home': (context) => const HomeView(),
        '/profile': (context) => const ProfileView(),
      },
    );
  }
}
