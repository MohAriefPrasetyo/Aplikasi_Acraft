import 'package:flutter/material.dart';
import '../viewmodels/welcome_viewmodel.dart';

class WelcomeView extends StatefulWidget {
  const WelcomeView({super.key});

  @override
  State<WelcomeView> createState() => _WelcomeViewState();
}

class _WelcomeViewState extends State<WelcomeView> {
  final WelcomeViewModel _welcomeVM = WelcomeViewModel();
  String _username = '';

  @override
  void initState() {
    super.initState();
    _welcomeVM.initWelcome().then((_) {
      setState(() {
        _username = _welcomeVM.username;
      });
      _welcomeVM.delayBeforeHome().then((_) {
        if (mounted) Navigator.pushReplacementNamed(context, '/home');
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Login Berhasil!",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF8B4513),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                "Selamat Datang,\n$_username",
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 22,
                  color: Color(0xFFD2B48C),
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
