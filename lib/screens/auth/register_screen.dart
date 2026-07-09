import 'package:flutter/material.dart';
import '../../services/auth_service.dart';
import '../main/main_navigation.dart'; // ⚠️ Tambahkan ini
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  RegisterScreenState createState() => RegisterScreenState();
}

class RegisterScreenState extends State<RegisterScreen> {
  final nameCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  final confirmPassCtrl = TextEditingController();
  bool obscure1 = true, obscure2 = true;
  String errorMsg = '';

  Future<void> doRegister() async {
    final name = nameCtrl.text.trim();
    final phone = phoneCtrl.text.trim();
    final email = emailCtrl.text.trim();
    final pass = passCtrl.text.trim();
    final confirm = confirmPassCtrl.text.trim();

    if (name.isEmpty ||
        phone.isEmpty ||
        email.isEmpty ||
        pass.isEmpty ||
        confirm.isEmpty) {
      setState(() => errorMsg = 'Semua kolom harus diisi.');
      return;
    }

    if (!email.contains('@')) {
      setState(() => errorMsg = 'Format email tidak valid.');
      return;
    }

    if (pass.length < 8) {
      setState(() => errorMsg = 'Password minimal 8 karakter.');
      return;
    }

    if (pass != confirm) {
      setState(() => errorMsg = 'Password tidak cocok.');
      return;
    }

    final user = await AuthService().registerWithEmail(
      name: name,
      email: email,
      password: pass,
      phone: phone,
    );

    if (user != null) {
      if (context.mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => MainNavigation(initialIndex: 0)),
        );
      }
    } else {
      setState(() {
        errorMsg = 'Register gagal. Email mungkin sudah digunakan.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Buat Akun Baru",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _label("Nama lengkap"),
            _field("Nama kamu", ctrl: nameCtrl),
            const SizedBox(height: 16),
            _label("No. HP / WhatsApp"),
            _field(
              "08xx-xxxx-xxxx",
              ctrl: phoneCtrl,
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 16),
            _label("Email"),
            _field(
              "nama@email.com",
              ctrl: emailCtrl,
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            _label("Password"),
            TextField(
              controller: passCtrl,
              obscureText: obscure1,
              decoration: InputDecoration(
                hintText: "Min. 8 karakter",
                filled: true,
                fillColor: const Color(0xFFF3F4F6),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    obscure1
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: Colors.grey,
                  ),
                  onPressed: () => setState(() => obscure1 = !obscure1),
                ),
              ),
            ),
            const SizedBox(height: 16),
            _label("Konfirmasi password"),
            TextField(
              controller: confirmPassCtrl,
              obscureText: obscure2,
              decoration: InputDecoration(
                hintText: "••••••••",
                filled: true,
                fillColor: const Color(0xFFF3F4F6),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    obscure2
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: Colors.grey,
                  ),
                  onPressed: () => setState(() => obscure2 = !obscure2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            if (errorMsg.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFEBEE),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.error_outline,
                      color: Colors.red,
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        errorMsg,
                        style: const TextStyle(color: Colors.red, fontSize: 13),
                      ),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                await doRegister();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1E6F3D),
                minimumSize: const Size(double.infinity, 55),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                "Daftar Sekarang",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Sudah punya akun? "),
                GestureDetector(
                  onTap: () => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => LoginScreen()),
                  ),
                  child: const Text(
                    "Masuk",
                    style: TextStyle(
                      color: Color(0xFF1E6F3D),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _label(String t) => Padding(
    // ⚠️ Perbaiki: EdgeInsets.only (huruf kecil)
    padding: const EdgeInsets.only(bottom: 8),
    child: Text(
      t,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        color: Colors.black54,
      ),
    ),
  );

  Widget _field(
    String hint, {
    required TextEditingController ctrl,
    TextInputType keyboardType = TextInputType.text,
  }) => Padding(
    padding: const EdgeInsets.only(bottom: 0),
    child: TextField(
      controller: ctrl,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: const Color(0xFFF3F4F6),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    ),
  );
}
