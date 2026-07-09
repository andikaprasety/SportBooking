import 'package:flutter/material.dart';
import '../../models/user_model.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  EditProfileScreenState createState() => EditProfileScreenState();
}

class EditProfileScreenState extends State<EditProfileScreen> {
  late final TextEditingController nameCtrl;
  late final TextEditingController emailCtrl;
  late final TextEditingController phoneCtrl;
  late final TextEditingController birthDateCtrl;
  late final TextEditingController addressCtrl;
  String selectedGender = '';
  String errorMsg = '';

  @override
  void initState() {
    super.initState();
    nameCtrl = TextEditingController(text: CurrentUser.name);
    emailCtrl = TextEditingController(text: CurrentUser.email);
    phoneCtrl = TextEditingController(text: CurrentUser.phone);
    birthDateCtrl = TextEditingController(text: CurrentUser.birthDate);
    addressCtrl = TextEditingController(text: CurrentUser.address);
    selectedGender = CurrentUser.gender;
  }

  @override
  void dispose() {
    nameCtrl.dispose();
    emailCtrl.dispose();
    phoneCtrl.dispose();
    birthDateCtrl.dispose();
    addressCtrl.dispose();
    super.dispose();
  }

  void _saveProfile() {
    final name = nameCtrl.text.trim();
    final email = emailCtrl.text.trim();
    if (name.isEmpty) {
      setState(() => errorMsg = 'Nama tidak boleh kosong.');
      return;
    }
    if (email.isNotEmpty && !email.contains('@')) {
      setState(() => errorMsg = 'Format email tidak valid.');
      return;
    }
    CurrentUser.name = name;
    CurrentUser.email = email;
    CurrentUser.phone = phoneCtrl.text.trim();
    CurrentUser.birthDate = birthDateCtrl.text.trim();
    CurrentUser.address = addressCtrl.text.trim();
    CurrentUser.gender = selectedGender;

    final idx =
    globalUsers.indexWhere((u) => u.email == CurrentUser.email);
    if (idx >= 0) {
      globalUsers[idx].name = name;
      globalUsers[idx].phone = phoneCtrl.text.trim();
    }

    setState(() => errorMsg = '');
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Profil berhasil disimpan!'),
        backgroundColor: Color(0xFF1E6F3D)));
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
            onPressed: () => Navigator.pop(context)),
        title: const Text("Edit Profil",
            style: TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold)),
        actions: [
          TextButton(
            onPressed: _saveProfile,
            child: const Text('Simpan',
                style: TextStyle(
                    color: Color(0xFF1E6F3D),
                    fontWeight: FontWeight.bold)),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Stack(children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: const Color(0xFF1E6F3D),
                  child: Text(
                      CurrentUser.name.isNotEmpty
                          ? CurrentUser.initials
                          : '?',
                      style: const TextStyle(
                          fontSize: 36,
                          color: Colors.white,
                          fontWeight: FontWeight.bold)),
                ),
                Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(
                          color: Color(0xFF1E6F3D),
                          shape: BoxShape.circle),
                      child: const Icon(Icons.camera_alt,
                          color: Colors.white, size: 16),
                    )),
              ]),
            ),
            const SizedBox(height: 28),
            if (errorMsg.isNotEmpty)
              Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                    color: const Color(0xFFFFEBEE),
                    borderRadius: BorderRadius.circular(10)),
                child: Row(children: [
                  const Icon(Icons.error_outline,
                      color: Colors.red, size: 18),
                  const SizedBox(width: 8),
                  Expanded(
                      child: Text(errorMsg,
                          style: const TextStyle(
                              color: Colors.red, fontSize: 13))),
                ]),
              ),
            _label('Nama Lengkap *'),
            TextField(
                controller: nameCtrl,
                decoration: _dec('Nama lengkap kamu')),
            const SizedBox(height: 16),
            _label('Email'),
            TextField(
                controller: emailCtrl,
                keyboardType: TextInputType.emailAddress,
                decoration: _dec('nama@email.com')),
            const SizedBox(height: 16),
            _label('No. HP / WhatsApp'),
            TextField(
                controller: phoneCtrl,
                keyboardType: TextInputType.phone,
                decoration: _dec('08xx-xxxx-xxxx')),
            const SizedBox(height: 16),
            _label('Jenis Kelamin'),
            Row(children: [
              Expanded(
                  child: _genderBtn(
                      'Laki-laki', selectedGender == 'Laki-laki')),
              const SizedBox(width: 12),
              Expanded(
                  child: _genderBtn(
                      'Perempuan', selectedGender == 'Perempuan')),
            ]),
            const SizedBox(height: 16),
            _label('Tanggal Lahir'),
            TextField(
                controller: birthDateCtrl,
                keyboardType: TextInputType.datetime,
                decoration: _dec('DD/MM/YYYY')),
            const SizedBox(height: 16),
            _label('Alamat'),
            TextField(
                controller: addressCtrl,
                maxLines: 3,
                decoration: _dec('Alamat lengkap kamu')),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _saveProfile,
              style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1E6F3D),
                  minimumSize: const Size(double.infinity, 55),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14))),
              child: const Text('Simpan Perubahan',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16)),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _label(String t) => Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(t,
          style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black54,
              fontSize: 14)));

  InputDecoration _dec(String hint) => InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: const Color(0xFFF3F4F6),
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none));

  Widget _genderBtn(String label, bool selected) => GestureDetector(
    onTap: () => setState(() => selectedGender = label),
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
          color: selected
              ? const Color(0xFFE8F5E9)
              : const Color(0xFFF3F4F6),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
              color: selected
                  ? const Color(0xFF1E6F3D)
                  : Colors.transparent)),
      child: Center(
          child: Text(label,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: selected
                      ? const Color(0xFF1E6F3D)
                      : Colors.black54))),
    ),
  );
}