import 'package:flutter/material.dart';

class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({Key? key}) : super(key: key);
  @override
  NotificationSettingsScreenState createState() =>
      NotificationSettingsScreenState();
}

class NotificationSettingsScreenState
    extends State<NotificationSettingsScreen> {
  bool bookingConfirm = true;
  bool bookingReminder = true;
  bool promoNotif = true;
  bool systemNotif = false;
  bool emailNotif = true;

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
        title: const Text('Pengaturan Notifikasi',
            style: TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text('Notifikasi Push',
              style:
              TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 12),
          _switchTile('Konfirmasi Booking',
              'Notifikasi saat booking dikonfirmasi', bookingConfirm,
                  (v) => setState(() => bookingConfirm = v)),
          _switchTile(
              'Pengingat Booking',
              'Ingatkan 1 jam sebelum waktu main',
              bookingReminder,
                  (v) => setState(() => bookingReminder = v)),
          _switchTile('Promo & Diskon', 'Info promo dan penawaran terbaru',
              promoNotif, (v) => setState(() => promoNotif = v)),
          _switchTile('Info Sistem', 'Maintenance dan pembaruan aplikasi',
              systemNotif, (v) => setState(() => systemNotif = v)),
          const SizedBox(height: 24),
          const Text('Notifikasi Email',
              style:
              TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 12),
          _switchTile('Email Konfirmasi', 'Terima tiket booking via email',
              emailNotif, (v) => setState(() => emailNotif = v)),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text('Pengaturan notifikasi disimpan!'),
                backgroundColor: Color(0xFF1E6F3D),
              ));
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1E6F3D),
              minimumSize: const Size(double.infinity, 52),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Simpan',
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _switchTile(String title, String subtitle, bool value,
      ValueChanged<bool> onChanged) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding:
      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFEEEEEE)),
      ),
      child: Row(children: [
        Expanded(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 14)),
                Text(subtitle,
                    style:
                    const TextStyle(color: Colors.grey, fontSize: 12)),
              ]),
        ),
        Switch(
          value: value,
          onChanged: onChanged,
          activeColor: const Color(0xFF1E6F3D),
        ),
      ]),
    );
  }
}