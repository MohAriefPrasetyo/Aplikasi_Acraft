import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../viewmodels/auth_viewmodel.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final TextEditingController _uController = TextEditingController();
  final TextEditingController _pController = TextEditingController();
  bool _obscurePassword = true;
  
  // --- TAMBAHAN: Variabel untuk menahan tampilan form awal ---
  bool _isCheckingAuth = true; 

  @override
  void initState() {
    super.initState();
    
    // Memberikan waktu 1.5 detik untuk Supabase membaca data dari web Google.
    // Jika lewat dari 1.5 detik tidak ada proses login, maka tampilkan form login biasa.
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) {
        setState(() {
          _isCheckingAuth = false;
        });
      }
    });

    Supabase.instance.client.auth.onAuthStateChange.listen((data) {
      final AuthChangeEvent event = data.event;
      if (event == AuthChangeEvent.signedIn) {
        if (mounted) {
          Navigator.pushReplacementNamed(context, '/welcome');
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // --- TAMBAHAN: Layar Loading Penuh saat baru buka aplikasi ---
    // Agar form login tidak "numpang lewat" saat kembali dari Google
    if (_isCheckingAuth) {
      return const Scaffold(
        backgroundColor: Color(0xFFF2F2F2),
        body: Center(
          child: CircularProgressIndicator(color: Color(0xFF7B3F00)),
        ),
      );
    }

    final authVM = Provider.of<AuthViewModel>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo
              ClipOval(
                child: Image.asset(
                  'lib/assets/kerajinan.png',
                  width: 140,
                  height: 140,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 28),

              const Text(
                "Welcome to ACraft",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF7B3F00),
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                "Silakan login untuk melihat kerajinan",
                style: TextStyle(fontSize: 13, color: Colors.grey),
              ),
              const SizedBox(height: 32),

              // Username field
              TextField(
                controller: _uController,
                decoration: InputDecoration(
                  hintText: "Username",
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 14),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Color(0xFFCCCCCC)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Color(0xFFCCCCCC)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Color(0xFF7B3F00)),
                  ),
                ),
              ),
              const SizedBox(height: 14),

              // Password field
              TextField(
                controller: _pController,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  hintText: "Password",
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 14),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Color(0xFFCCCCCC)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Color(0xFFCCCCCC)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Color(0xFF7B3F00)),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      color: Colors.grey,
                    ),
                    onPressed: () =>
                        setState(() => _obscurePassword = !_obscurePassword),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Tombol Masuk Biasa
              authVM.isLoading
                  ? const CircularProgressIndicator(color: Color(0xFF7B3F00))
                  : SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF7B3F00),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () async {
                          bool success = await authVM.login(
                            _uController.text,
                            _pController.text,
                          );
                          if (success && context.mounted) {
                            Navigator.pushReplacementNamed(context, '/welcome');
                          } else if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Login Gagal!")),
                            );
                          }
                        },
                        child: const Text(
                          "Masuk",
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
              
              const SizedBox(height: 20),

              Row(
                children: const [
                  Expanded(child: Divider(thickness: 1, color: Color(0xFFCCCCCC))),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      "ATAU",
                      style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 12),
                    ),
                  ),
                  Expanded(child: Divider(thickness: 1, color: Color(0xFFCCCCCC))),
                ],
              ),
              
              const SizedBox(height: 20),

              // Tombol Masuk dengan Google
              authVM.isLoading 
                ? const SizedBox.shrink() 
                : SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: OutlinedButton.icon(
                      onPressed: () async {
                        await authVM.loginWithGoogle();
                      },
                      icon: const FaIcon(
                        FontAwesomeIcons.google, 
                        color: Color(0xFF7B3F00),
                        size: 24,
                      ),
                      label: const Text(
                        "Masuk dengan Google",
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        backgroundColor: Colors.white,
                        side: const BorderSide(color: Color(0xFFCCCCCC)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),

              const SizedBox(height: 16),

              TextButton(
                onPressed: () => Navigator.pushNamed(context, '/register'),
                child: const Text(
                  "Belum punya akun? Daftar di sini",
                  style: TextStyle(
                      color: Color(0xFFB8860B), fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}