import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'register_screen.dart';
import '../../admin/admin_login_screen.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E6F3D),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 60),
            Container(
              width: 190,
              height: 190,
              child: Image.asset('assets/logo.png', width: 100, height: 90),
            ),
            const SizedBox(height: 20),
            const Text(
              "SportBook",
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 1,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "Booking lapangan olahraga,\nkapan saja & di mana saja",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white70, fontSize: 15),
            ),
            const SizedBox(height: 40),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _Stat(value: "200+", label: "Lapangan"),
                _Stat(value: "15rb+", label: "Pengguna"),
                _Stat(value: "4.9 ★", label: "Rating"),
              ],
            ),
            const Spacer(),
            const _PrimaryButton(
              text: "Mulai Sekarang",
              backgroundColor: Color(0xFF145A32),
              textColor: Colors.white,
            ),
            const SizedBox(height: 12),
            const _OutlineButton(text: "Sudah punya akun? Masuk"),
            const SizedBox(height: 12),
            const _AdminLink(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  final String value;
  final String label;
  const _Stat({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(label, style: const TextStyle(color: Colors.white70)),
      ],
    );
  }
}

class _PrimaryButton extends StatelessWidget {
  final String text;
  final Color backgroundColor;
  final Color textColor;
  const _PrimaryButton({
    required this.text,
    required this.backgroundColor,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const RegisterScreen()),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          minimumSize: const Size(double.infinity, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(text, style: TextStyle(color: textColor, fontSize: 16)),
      ),
    );
  }
}

class _OutlineButton extends StatelessWidget {
  final String text;
  const _OutlineButton({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: OutlinedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const LoginScreen()),
          );
        },
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: Colors.white),
          minimumSize: const Size(double.infinity, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(text, style: const TextStyle(color: Colors.white)),
      ),
    );
  }
}

class _AdminLink extends StatelessWidget {
  const _AdminLink();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const AdminLoginScreen()),
        );
      },
      child: const Text(
        "Masuk sebagai Admin →",
        style: TextStyle(color: Colors.white38),
      ),
    );
  }
}
