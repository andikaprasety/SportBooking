import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final emailCtrl = TextEditingController();
  bool loading = false;

  Future<void> resetPassword() async {
    final email = emailCtrl.text.trim();

    if (email.isEmpty) {
      showMessage("Email tidak boleh kosong");
      return;
    }

    try {
      setState(() {
        loading = true;
      });

      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);

      showMessage("Link reset password telah dikirim ke email kamu");
    } on FirebaseAuthException catch (e) {
      String message = "Terjadi kesalahan";

      if (e.code == "user-not-found") {
        message = "Email tidak terdaftar";
      }

      if (e.code == "invalid-email") {
        message = "Format email tidak valid";
      }

      showMessage(message);
    } finally {
      setState(() {
        loading = false;
      });
    }
  }

  void showMessage(String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Lupa Password"),
        backgroundColor: const Color(0xFF1E6F3D),
      ),

      body: Padding(
        padding: const EdgeInsets.all(24),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            const Text(
              "Masukkan email akun kamu untuk menerima link reset password",
              style: TextStyle(fontSize: 16),
            ),

            const SizedBox(height: 20),

            TextField(
              controller: emailCtrl,

              decoration: InputDecoration(
                hintText: "contoh@gmail.com",

                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 25),

            ElevatedButton(
              onPressed: loading ? null : resetPassword,

              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1E6F3D),

                minimumSize: const Size(double.infinity, 50),
              ),

              child: loading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text(
                      "Kirim Link Reset",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
