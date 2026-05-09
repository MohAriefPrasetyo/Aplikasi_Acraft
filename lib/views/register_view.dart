import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/register_viewmodel.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    final regVM = Provider.of<RegisterViewModel>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF7B3F00)),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            children: [
              // Logo
              ClipOval(
                child: Image.asset(
                  'lib/assets/kerajinan.png',
                  width: 120,
                  height: 120,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    width: 120,
                    height: 120,
                    color: const Color(0xFFD2B48C),
                    child: const Icon(Icons.auto_awesome,
                        size: 60, color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "Daftar Akun",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF7B3F00),
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                "Buat akun untuk mulai menjelajah",
                style: TextStyle(fontSize: 13, color: Colors.grey),
              ),
              const SizedBox(height: 32),

              // Username field
              TextField(
                controller: _emailController,
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
                controller: _passController,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  hintText: "Password (min. 6 karakter)",
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
                    onPressed: () => setState(
                        () => _obscurePassword = !_obscurePassword),
                  ),
                ),
              ),

              // Error message
              if (regVM.errorMessage != null) ...
                [
                  const SizedBox(height: 10),
                  Text(
                    regVM.errorMessage!,
                    style: const TextStyle(color: Colors.red, fontSize: 13),
                  ),
                ],

              const SizedBox(height: 24),

              // Tombol daftar
              regVM.isLoading
                  ? const CircularProgressIndicator(
                      color: Color(0xFF7B3F00))
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
                          final email = _emailController.text.trim();
                          final pass = _passController.text.trim();
                          if (email.isEmpty || pass.isEmpty) return;
                          bool success =
                              await regVM.register(email, pass);
                          if (success && context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                    "Registrasi Berhasil! Silakan Login."),
                                backgroundColor: Color(0xFF7B3F00),
                              ),
                            );
                            Navigator.pop(context);
                          }
                        },
                        child: const Text(
                          "Daftar Sekarang",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  "Sudah punya akun? Login di sini",
                  style: TextStyle(
                      color: Color(0xFFB8860B),
                      fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
