import 'package:flutter/material.dart';
import '../../models/user_model.dart';
import '../../models/booking_model.dart';
import '../auth/onboarding_screen.dart';
import 'edit_profile_screen.dart';
import '../promo/promo_screen.dart';
import '../booking/booking_history_screen.dart';
import '../notification/notification_settings_screen.dart';
import '../help/help_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text(
          "Profil",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            CircleAvatar(
              radius: 45,
              backgroundColor: const Color(0xFF1E6F3D),
              child: Text(
                CurrentUser.initials,
                style: const TextStyle(
                  fontSize: 32,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              CurrentUser.name.isEmpty ? 'Pengguna' : CurrentUser.name,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(
              CurrentUser.email.isEmpty ? '-' : CurrentUser.email,
              style: const TextStyle(color: Colors.grey),
            ),
            if (CurrentUser.phone.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  CurrentUser.phone,
                  style: const TextStyle(color: Colors.grey, fontSize: 13),
                ),
              ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF1F8F4),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _stat("${globalBookingHistory.length}", "Total Booking"),
                  _divider(),
                  _stat(
                    "${globalBookingHistory.where((b) => b.status == 'Aktif').length}",
                    "Aktif",
                  ),
                  _divider(),
                  _stat(
                    "${globalBookingHistory.where((b) => b.status == 'Selesai').length}",
                    "Selesai",
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            _menu(context, Icons.person_outline, "Edit Profil", () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const EditProfileScreen()),
              );
            }),
            _menu(context, Icons.local_offer_outlined, "Promo & Diskon", () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const PromoScreen()),
              );
            }),
            _menu(context, Icons.history, "Riwayat Booking", () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const BookingHistoryScreen()),
              );
            }),
            _menu(
              context,
              Icons.notifications_outlined,
              "Pengaturan Notifikasi",
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const NotificationSettingsScreen(),
                  ),
                );
              },
            ),
            _menu(context, Icons.help_outline, "Bantuan", () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const HelpScreen()),
              );
            }),
            _menu(context, Icons.logout, "Keluar", () {
              _showLogoutDialog(context);
            }, isRed: true),
          ],
        ),
      ),
    );
  }

  Widget _stat(String val, String label) {
    return Column(
      children: [
        Text(
          val,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1E6F3D),
          ),
        ),
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
      ],
    );
  }

  Widget _divider() {
    return Container(height: 36, width: 1, color: const Color(0xFFD1E7D8));
  }

  Widget _menu(
    BuildContext ctx,
    IconData icon,
    String label,
    VoidCallback onTap, {
    bool isRed = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFF9FAFB),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFEEEEEE)),
        ),
        child: Row(
          children: [
            Icon(icon, color: isRed ? Colors.red : const Color(0xFF1E6F3D)),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: isRed ? Colors.red : Colors.black87,
                ),
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 14,
              color: Colors.grey.shade400,
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Konfirmasi Logout',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        content: const Text(
          'Apakah Anda yakin ingin keluar dari akun?',
          style: TextStyle(fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              CurrentUser.clear();
              // ⚠️ HAPUS const di sini - pakai OnboardingScreen() tanpa const
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => OnboardingScreen()),
                (route) => false,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text(
              'Logout',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
