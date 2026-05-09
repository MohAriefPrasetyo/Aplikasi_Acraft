import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/welcome_viewmodel.dart';

class WelcomeView extends StatefulWidget {
  const WelcomeView({super.key});

  @override
  State<WelcomeView> createState() => _WelcomeViewState();
}

class _WelcomeViewState extends State<WelcomeView> {
  @override
  void initState() {
    super.initState();
    // Jalankan logika welcome saat halaman muncul
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<WelcomeViewModel>().initWelcome().then((_) {
        if (mounted) Navigator.pushReplacementNamed(context, '/home');
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final welcomeVM = Provider.of<WelcomeViewModel>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24), // Memberikan jarak kiri-kanan
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
              const SizedBox(height: 12), // Sedikit dilonggarkan
              
              // --- PERBAIKAN TEKS WELCOME ---
              Text(
                // Menggunakan \n agar Username ada di baris bawahnya
                "Selamat Datang,\n${welcomeVM.username}", 
                textAlign: TextAlign.center, // Memaksa rata tengah
                style: const TextStyle(
                  fontSize: 22, // Ukuran disesuaikan agar email yang panjang tidak terlalu sesak
                  color: Color(0xFFD2B48C),
                  height: 1.4, // Memberi jarak renggang antar baris atas dan bawah
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}