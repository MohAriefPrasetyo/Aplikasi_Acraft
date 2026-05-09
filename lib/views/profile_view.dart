import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/profile_viewmodel.dart';
import '../viewmodels/auth_viewmodel.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProfileViewModel>().loadProfile();
    });
  }

  @override
  Widget build(BuildContext context) {
    final profileVM = Provider.of<ProfileViewModel>(context);
    final authVM = Provider.of<AuthViewModel>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      body: Column(
        children: [
          // Header coklat dengan tombol kembali dan avatar
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(
                top: 50, bottom: 30, left: 20, right: 20),
            decoration: const BoxDecoration(
              color: Color(0xFF7B3F00),
              borderRadius:
                  BorderRadius.vertical(bottom: Radius.circular(32)),
            ),
            child: Column(
              children: [
                // --- TOMBOL KEMBALI ---
                Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 22),
                    onPressed: () {
                      // Mengembalikan ke halaman sebelumnya
                      Navigator.pop(context);
                    },
                  ),
                ),
                
                // Avatar
                Container(
                  width: 90,
                  height: 90,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    border: Border.all(
                        color: const Color(0xFFB8860B), width: 3),
                  ),
                  child: const Icon(Icons.person,
                      size: 50, color: Color(0xFF7B3F00)),
                ),
                const SizedBox(height: 14),
                
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    profileVM.username.isEmpty
                        ? 'Pengguna ACraft'
                        : profileVM.username,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                
                const SizedBox(height: 4),
                const Text(
                  'Member ACraft',
                  style: TextStyle(
                      fontSize: 13, color: Color(0xFFD2B48C)),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Menu items
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                _menuItem(
                  icon: Icons.person_outline,
                  label: 'Akun Saya',
                  onTap: () {},
                ),
                const SizedBox(height: 12),
                _menuItem(
                  icon: Icons.favorite_border,
                  label: 'Favorit',
                  onTap: () {},
                ),
                const SizedBox(height: 12),
                _menuItem(
                  icon: Icons.history,
                  label: 'Riwayat',
                  onTap: () {},
                ),
                const SizedBox(height: 12),
                _menuItem(
                  icon: Icons.info_outline,
                  label: 'Tentang Aplikasi',
                  onTap: () {},
                ),
                const SizedBox(height: 32),

                // Tombol Logout
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    icon: const Icon(Icons.logout, color: Colors.white),
                    label: const Text(
                      'Keluar Akun',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w600),
                    ),
                    onPressed: () async {
                      await profileVM.logout();
                      await authVM.logout();
                      if (context.mounted) {
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          '/login',
                          (route) => false,
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _menuItem(
      {required IconData icon,
      required String label,
      required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 6,
              offset: const Offset(0, 2),
            )
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: const Color(0xFFF5EFE6),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: const Color(0xFF7B3F00), size: 20),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                    fontSize: 14, fontWeight: FontWeight.w500),
              ),
            ),
            const Icon(Icons.arrow_forward_ios,
                size: 14, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}