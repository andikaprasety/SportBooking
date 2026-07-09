import 'dart:async';
import 'package:flutter/material.dart';
import '../../models/venue_model.dart';
import '../../models/booking_model.dart';
import '../../models/promo_model.dart';
import '../../models/notification_model.dart';
import '../../models/user_model.dart';
import '../../utils/helpers.dart';
import '../booking/booking_success_screen.dart';

class PaymentSelectionScreen extends StatefulWidget {
  final VenueModel venue;
  final int totalPrice;
  final PromoModel? appliedPromo;
  const PaymentSelectionScreen({
    Key? key,
    required this.venue,
    required this.totalPrice,
    this.appliedPromo,
  }) : super(key: key);

  @override
  PaymentSelectionScreenState createState() =>
      PaymentSelectionScreenState();
}

class PaymentSelectionScreenState extends State<PaymentSelectionScreen> {
  String selectedBank = '';
  int startSeconds = 892;
  late Timer timer;

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (startSeconds > 0) setState(() => startSeconds--);
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  String formatTime(int sec) =>
      "${(sec ~/ 60).toString().padLeft(2, '0')}:${(sec % 60).toString().padLeft(2, '0')}";

  String formatDate(DateTime date) {
    final days = ['Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab', 'Min'];
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun', 'Jul', 'Ags', 'Sep', 'Okt', 'Nov', 'Des'];
    return '${days[date.weekday - 1]}, ${date.day} ${months[date.month - 1]} ${date.year}';
  }

  void confirmTransfer() {
    if (widget.appliedPromo != null) widget.appliedPromo!.isUsed = true;

    final dateStr = formatDate(DateTime.now());
    final timeStr = '08.00 – 09.00 WIB';

    final newBooking = BookingModel(
      venueName: widget.venue.name,
      type: "$dateStr · $timeStr",
      date: dateStr,
      time: timeStr,
      price: "Rp ${formatPrice(widget.totalPrice)}",
      code: "SB-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}",
      status: "Aktif",
      icon: widget.venue.icon,
      userName: CurrentUser.name,
      userEmail: CurrentUser.email,
    );
    globalBookingHistory.insert(0, newBooking);

    final userIdx =
        globalUsers.indexWhere((u) => u.email == CurrentUser.email);
    if (userIdx >= 0) {
      globalUsers[userIdx].totalBooking++;
      globalUsers[userIdx].totalSpend += widget.totalPrice;
    }

    globalNotifications.insertAll(0, [
      NotificationModel(
        title: "Booking Berhasil!",
        message: "${widget.venue.name} · $dateStr $timeStr",
        time: "Baru saja",
        icon: Icons.check,
        iconBgColor: const Color(0xFFE8F5E9),
        iconColor: const Color(0xFF1E6F3D),
        isRead: false,
      ),
      NotificationModel(
        title: "Pengingat Booking",
        message: "Besok ada booking di ${widget.venue.name} jam $timeStr",
        time: "Baru saja",
        icon: Icons.alarm,
        iconBgColor: const Color(0xFFFFF3E0),
        iconColor: Colors.orange,
        isRead: false,
      ),
    ]);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BookingSuccessScreen(
          venueName: widget.venue.name,
          totalPrice: "Rp ${formatPrice(widget.totalPrice)}",
          date: dateStr,
          time: timeStr,
          lapangan: 'Lapangan A',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          "Transfer",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFFF1F8F4),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Total yang harus dibayar",
                    style: TextStyle(color: Color(0xFF1E6F3D)),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Rp ${formatPrice(widget.totalPrice)}",
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E6F3D),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            _bankItem("Dana", Colors.blue),
            _bankItem("Mandiri", Colors.blue),
            _bankItem("BNI", Colors.orange),
            _bankItem("BRI", Colors.blue),
            const Spacer(),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF7ED),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.access_time, color: Colors.orange),
                  const SizedBox(width: 8),
                  Text(
                    "Batas waktu: ${formatTime(startSeconds)} tersisa",
                    style: const TextStyle(
                      color: Colors.orange,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: selectedBank == '' ? null : confirmTransfer,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1E6F3D),
                  disabledBackgroundColor: Colors.grey[300],
                  minimumSize: const Size(double.infinity, 55),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text(
                  "Saya Sudah Transfer",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _bankItem(String name, Color color) {
    return ListTile(
      onTap: () => setState(() => selectedBank = name),
      leading: Icon(Icons.account_balance, color: color),
      title: Text(
        name,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      trailing: Radio<String>(
        value: name,
        groupValue: selectedBank,
        onChanged: (v) => setState(() => selectedBank = v ?? ''),
      ),
      selected: selectedBank == name,
    );
  }
}