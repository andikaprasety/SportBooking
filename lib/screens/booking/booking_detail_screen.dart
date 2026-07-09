import 'package:flutter/material.dart';
import '../../models/booking_model.dart';

class BookingDetailScreen extends StatelessWidget {
  final BookingModel bookingItem;
  final VoidCallback onCancel;
  const BookingDetailScreen(
      {Key? key, required this.bookingItem, required this.onCancel})
      : super(key: key);

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
        title: const Text("Detail Booking",
            style: TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold)),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                    color: const Color(0xFFE8F5E9),
                    borderRadius: BorderRadius.circular(14)),
                child: Row(children: [
                  Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                          color: Color(0xFF1E6F3D), shape: BoxShape.circle),
                      child: const Icon(Icons.check,
                          color: Colors.white, size: 20)),
                  const SizedBox(width: 14),
                  Expanded(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Booking ${bookingItem.status}",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                    color: Color(0xFF1E6F3D))),
                            const Text("Menunggu waktu bermain",
                                style: TextStyle(
                                    color: Colors.black54, fontSize: 13)),
                          ])),
                  Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                          color: const Color(0xFFC8E6C9),
                          borderRadius: BorderRadius.circular(8)),
                      child: const Text("Lunas",
                          style: TextStyle(
                              color: Color(0xFF1E6F3D),
                              fontWeight: FontWeight.bold,
                              fontSize: 12))),
                ]),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                    color: const Color(0xFFF9FAFB),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFFE5E7EB))),
                child: Column(children: [
                  Row(children: [
                    CircleAvatar(
                        backgroundColor: Colors.white,
                        child: Icon(bookingItem.icon,
                            color: Colors.black54)),
                    const SizedBox(width: 12),
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(bookingItem.venueName,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16)),
                          const Text("Lapangan A – Indoor",
                              style: TextStyle(
                                  color: Colors.grey, fontSize: 13)),
                        ]),
                  ]),
                  const Divider(height: 30),
                  _row("Kode booking", bookingItem.code, isBold: true),
                  _row("Tanggal", bookingItem.date),
                  _row("Jam", bookingItem.time),
                  _row("Durasi", "1 jam"),
                  _row("Total bayar", bookingItem.price, isGreen: true),
                  _row("Metode bayar", "QRIS"),
                ]),
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () => ScaffoldMessenger.of(context)
                    .showSnackBar(const SnackBar(
                    content: Text("Tiket berhasil dibagikan!"))),
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1E6F3D),
                    minimumSize: const Size(double.infinity, 55),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14))),
                child: const Text("Bagikan Tiket",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 14),
              ElevatedButton(
                onPressed: () {
                  onCancel();
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content:
                          Text("Booking berhasil dibatalkan")));
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFFEBEE),
                    elevation: 0,
                    minimumSize: const Size(double.infinity, 55),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14))),
                child: const Text("Batalkan Booking",
                    style: TextStyle(
                        color: Colors.red, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _row(String label, String value,
      {bool isBold = false, bool isGreen = false}) =>
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label,
                  style: const TextStyle(
                      color: Colors.grey, fontSize: 14)),
              Text(value,
                  style: TextStyle(
                      fontWeight: isBold || isGreen
                          ? FontWeight.bold
                          : FontWeight.normal,
                      fontSize: 14,
                      color: isGreen
                          ? const Color(0xFF1E6F3D)
                          : Colors.black)),
            ]),
      );
}