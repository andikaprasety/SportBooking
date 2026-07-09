import 'package:flutter/material.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  ForgotPasswordScreenState createState() => ForgotPasswordScreenState();
}

class ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  bool isLinkSent = false;
  final emailCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
            onPressed: () => Navigator.pop(context)),
        title: const Text("Lupa Password",
            style:
            TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(children: [
          const SizedBox(height: 20),
          Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                  color: const Color(0xFFF1F8F4),
                  borderRadius: BorderRadius.circular(20)),
              child: const Icon(Icons.lock_outline_rounded,
                  size: 80, color: Color(0xFF1E6F3D))),
          const SizedBox(height: 24),
          const Text("Reset Password",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const Text("Masukkan email terdaftar,\nkami kirimkan link reset.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey)),
          const SizedBox(height: 32),
          TextField(
            controller: emailCtrl,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
                hintText: "nama@email.com",
                filled: true,
                fillColor: const Color(0xFFF1F8F4),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none)),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => setState(() => isLinkSent = true),
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1E6F3D),
                minimumSize: const Size(double.infinity, 55),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12))),
            child: const Text("Kirim Link Reset",
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(height: 30),
          if (isLinkSent)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                  color: const Color(0xFFE8F5E9),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFC8E6C9))),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Cek email kamu",
                        style: TextStyle(
                            color: Color(0xFF2E7D32),
                            fontWeight: FontWeight.bold)),
                    Text(
                        "Link dikirim ke ${emailCtrl.text}.\nCek folder spam jika tidak muncul.",
                        style: const TextStyle(
                            color: Color(0xFF2E7D32), fontSize: 13)),
                  ]),
            ),
        ]),
      ),
    );
  }
}