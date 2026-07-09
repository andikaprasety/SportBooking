import 'package:flutter/material.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final faqs = [
      {
        'q': 'Bagaimana cara membatalkan booking?',
        'a':
        'Buka Riwayat Booking → pilih booking Aktif → klik "Batalkan". Refund diproses 1-3 hari kerja.',
      },
      {
        'q': 'Apakah bisa booking untuk hari yang sama?',
        'a':
        'Ya, kamu bisa booking untuk hari ini selama slot masih tersedia dan minimal 2 jam sebelum waktu main.',
      },
      {
        'q': 'Bagaimana cara menggunakan kode promo?',
        'a':
        'Pertama klaim promo di halaman Promo & Diskon. Lalu masukkan kode saat konfirmasi booking.',
      },
      {
        'q': 'Metode pembayaran apa yang tersedia?',
        'a': 'QRIS dan Transfer Bank (Dana, Mandiri, BNI, BRI).',
      },
      {
        'q': 'Berapa lama refund setelah pembatalan?',
        'a':
        'Refund diproses dalam 1-3 hari kerja ke metode pembayaran asal.',
      },
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Bantuan',
            style: TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F8F4),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(children: [
                  const Icon(Icons.support_agent,
                      color: Color(0xFF1E6F3D), size: 32),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Butuh bantuan lebih lanjut?',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 15)),
                          Text('Hubungi CS kami via WhatsApp',
                              style:
                              TextStyle(color: Colors.grey, fontSize: 12)),
                        ]),
                  ),
                  ElevatedButton(
                    onPressed: () => ScaffoldMessenger.of(context)
                        .showSnackBar(const SnackBar(
                        content: Text('Membuka WhatsApp CS...'))),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1E6F3D),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    child: const Text('Chat',
                        style: TextStyle(color: Colors.white)),
                  ),
                ]),
              ),
              const SizedBox(height: 24),
              const Text('FAQ — Pertanyaan Umum',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 12),
              ...faqs.map((faq) => _faqItem(faq['q']!, faq['a']!)),
            ]),
      ),
    );
  }

  Widget _faqItem(String q, String a) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFEEEEEE)),
      ),
      child: ExpansionTile(
        title: Text(q,
            style: const TextStyle(
                fontWeight: FontWeight.w600, fontSize: 14)),
        iconColor: const Color(0xFF1E6F3D),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
            child: Text(a,
                style: const TextStyle(
                    color: Colors.black54,
                    fontSize: 13,
                    height: 1.5)),
          ),
        ],
      ),
    );
  }
}