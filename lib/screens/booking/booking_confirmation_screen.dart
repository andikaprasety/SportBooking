import 'dart:async';
import 'package:flutter/material.dart';
import '../../models/venue_model.dart';
import '../../models/booking_model.dart';
import '../../models/promo_model.dart';
import '../../models/notification_model.dart';
import '../../models/user_model.dart';
import '../../utils/helpers.dart';
import 'booking_success_screen.dart';
import '../payment/payment_selection_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../services/firestore_service.dart';

class BookingConfirmationScreen extends StatefulWidget {
  final VenueModel venue;
  const BookingConfirmationScreen({Key? key, required this.venue})
    : super(key: key);

  @override
  BookingConfirmationScreenState createState() =>
      BookingConfirmationScreenState();
}

class BookingConfirmationScreenState extends State<BookingConfirmationScreen> {
  // ============================================
  // Variabel untuk Form Booking
  // ============================================
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  int selectedDuration = 1;
  String selectedLapangan = 'Lapangan A';
  List<String> daftarLapangan = ['Lapangan A', 'Lapangan B', 'Lapangan C'];

  // ============================================
  // Variabel untuk Pembayaran & Promo
  // ============================================
  String selectedMethod = 'QRIS';
  final promoCtrl = TextEditingController();
  String promoMessage = '';
  bool promoApplied = false;
  PromoModel? appliedPromo;

  // ============================================
  // Getter untuk Perhitungan Harga
  // ============================================
  int get basePrice => widget.venue.pricePerHour * selectedDuration;
  int get serviceFee => 2000 * selectedDuration;

  int get discountAmount {
    if (!promoApplied || appliedPromo == null) return 0;
    final disc = (basePrice * appliedPromo!.discountPercent / 100).round();
    return disc > appliedPromo!.maxDiscount ? appliedPromo!.maxDiscount : disc;
  }

  int get totalPrice => basePrice - discountAmount + serviceFee;

  // ============================================
  // Fungsi Format Tanggal & Jam
  // ============================================
  String formatDate(DateTime date) {
    final days = ['Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab', 'Min'];
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'Mei',
      'Jun',
      'Jul',
      'Ags',
      'Sep',
      'Okt',
      'Nov',
      'Des',
    ];
    return '${days[date.weekday - 1]}, ${date.day} ${months[date.month - 1]} ${date.year}';
  }

  String formatTime(TimeOfDay time) {
    return '${time.hour.toString().padLeft(2, '0')}.${time.minute.toString().padLeft(2, '0')}';
  }

  String formatTimeRange(TimeOfDay start, int duration) {
    final endHour = start.hour + duration;
    final endMinute = start.minute;
    String endHourStr = endHour.toString().padLeft(2, '0');
    String endMinuteStr = endMinute.toString().padLeft(2, '0');
    return '${formatTime(start)} – ${endHourStr}.${endMinuteStr} WIB';
  }

  // ============================================
  // Fungsi Pilih Tanggal
  // ============================================
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF1E6F3D),
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  // ============================================
  // Fungsi Pilih Jam
  // ============================================
  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF1E6F3D),
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != selectedTime) {
      setState(() {
        selectedTime = picked;
      });
    }
  }

  // ============================================
  // Fungsi Pilih Durasi
  // ============================================
  void _showDurationPicker() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Pilih Durasi',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ...List.generate(4, (index) {
              final duration = index + 1;
              return ListTile(
                title: Text('$duration Jam'),
                trailing: selectedDuration == duration
                    ? const Icon(Icons.check_circle, color: Color(0xFF1E6F3D))
                    : null,
                onTap: () {
                  setState(() {
                    selectedDuration = duration;
                  });
                  Navigator.pop(ctx);
                },
              );
            }),
          ],
        ),
      ),
    );
  }

  // ============================================
  // Fungsi Pilih Lapangan
  // ============================================
  void _showLapanganPicker() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Pilih Lapangan',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ...daftarLapangan.map((lapangan) {
              return ListTile(
                title: Text(lapangan),
                trailing: selectedLapangan == lapangan
                    ? const Icon(Icons.check_circle, color: Color(0xFF1E6F3D))
                    : null,
                onTap: () {
                  setState(() {
                    selectedLapangan = lapangan;
                  });
                  Navigator.pop(ctx);
                },
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  // ============================================
  // Fungsi Promo
  // ============================================
  void _applyPromo() {
    final code = promoCtrl.text.trim().toUpperCase();
    final found = globalPromos.where((p) => p.code == code).toList();
    if (found.isEmpty) {
      setState(() {
        promoMessage = 'Kode promo tidak ditemukan.';
        promoApplied = false;
        appliedPromo = null;
      });
      return;
    }
    final promo = found.first;
    if (!promo.isClaimed) {
      setState(() {
        promoMessage = 'Klaim promo terlebih dahulu.';
        promoApplied = false;
        appliedPromo = null;
      });
      return;
    }
    if (promo.isUsed) {
      setState(() {
        promoMessage = 'Promo sudah digunakan.';
        promoApplied = false;
        appliedPromo = null;
      });
      return;
    }
    setState(() {
      promoApplied = true;
      appliedPromo = promo;
      promoMessage =
          'Promo ${promo.code} berhasil diterapkan! Hemat Rp ${formatPrice(discountAmount)}';
    });
  }

  // ============================================
  // Fungsi Booking - SUDAH DIPERBAIKI
  // ============================================
  Future<void> doBooking() async {
    if (promoApplied && appliedPromo != null) appliedPromo!.isUsed = true;

    final dateStr = formatDate(selectedDate);
    final timeStr = formatTimeRange(selectedTime, selectedDuration);
    await FirestoreService().addBooking(
      userId: FirebaseAuth.instance.currentUser!.uid,
      venueId: widget.venue.name,
      venueName: widget.venue.name,
      date: dateStr,
      time: timeStr,
      duration: selectedDuration,
      totalPrice: totalPrice,
    );

    final newBooking = BookingModel(
      venueName: widget.venue.name,
      type: "$dateStr · $timeStr",
      date: dateStr,
      time: timeStr,
      price: "Rp ${formatPrice(totalPrice)}",
      code:
          "SB-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}",
      status: "Aktif",
      icon: widget.venue.icon,
      userName: CurrentUser.name,
      userEmail: CurrentUser.email,
    );
    globalBookingHistory.insert(0, newBooking);

    final userIdx = globalUsers.indexWhere((u) => u.email == CurrentUser.email);
    if (userIdx >= 0) {
      globalUsers[userIdx].totalBooking++;
      globalUsers[userIdx].totalSpend += totalPrice;
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

    // ✅ NAVIGASI KE BOOKING SUCCESS DENGAN PARAMETER YANG BENAR
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BookingSuccessScreen(
          venueName: widget.venue.name,
          totalPrice: "Rp ${formatPrice(totalPrice)}",
          date: dateStr,
          time: timeStr,
          lapangan: selectedLapangan,
        ),
      ),
    );
  }

  // ============================================
  // BUILD WIDGET
  // ============================================
  @override
  Widget build(BuildContext context) {
    final claimedPromos = globalPromos
        .where((p) => p.isClaimed && !p.isUsed)
        .toList();

    final dateStr = formatDate(selectedDate);
    final timeStr = formatTimeRange(selectedTime, selectedDuration);
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
          "Konfirmasi Booking",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ============================================
            // Informasi Venue
            // ============================================
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF9FAFB),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFF3F4F6)),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: const Color(0xFFE8F5E9),
                        child: Icon(
                          widget.venue.icon,
                          color: const Color(0xFF1E6F3D),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.venue.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const Text(
                              "Lapangan A – Indoor",
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // ============================================
            // Form Pilihan Tanggal, Jam, Durasi, Lapangan
            // ============================================
            const Text(
              "Pilih Detail Booking",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              "Klik pada field untuk mengubah",
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
            const SizedBox(height: 12),

            // Tanggal
            _inputRow(
              icon: Icons.calendar_today,
              label: "Tanggal",
              value: dateStr,
              onTap: () => _selectDate(context),
            ),

            // Jam
            _inputRow(
              icon: Icons.access_time,
              label: "Jam",
              value: timeStr,
              onTap: () => _selectTime(context),
            ),

            // Durasi
            _inputRow(
              icon: Icons.timer,
              label: "Durasi",
              value: "$selectedDuration Jam",
              onTap: _showDurationPicker,
            ),

            // Lapangan
            _inputRow(
              icon: Icons.sports_soccer,
              label: "Lapangan",
              value: selectedLapangan,
              onTap: _showLapanganPicker,
            ),

            const SizedBox(height: 20),

            // ============================================
            // Kode Promo
            // ============================================
            const Text(
              "Kode Promo",
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: promoCtrl,
                    textCapitalization: TextCapitalization.characters,
                    decoration: InputDecoration(
                      hintText: "Masukkan kode promo",
                      filled: true,
                      fillColor: const Color(0xFFF3F4F6),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _applyPromo,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1E6F3D),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 17,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Gunakan',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            if (promoMessage.isNotEmpty) ...[
              const SizedBox(height: 6),
              Text(
                promoMessage,
                style: TextStyle(
                  color: promoApplied ? Colors.green : Colors.red,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
            if (claimedPromos.isNotEmpty && !promoApplied) ...[
              const SizedBox(height: 10),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: claimedPromos.map((p) {
                    return GestureDetector(
                      onTap: () {
                        promoCtrl.text = p.code;
                        _applyPromo();
                      },
                      child: Container(
                        margin: const EdgeInsets.only(right: 8),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE8F5E9),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: const Color(0xFF1E6F3D).withOpacity(0.3),
                          ),
                        ),
                        child: Row(
                          children: [
                            Text(
                              p.code,
                              style: const TextStyle(
                                color: Color(0xFF1E6F3D),
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(width: 6),
                            const Text(
                              'Gunakan',
                              style: TextStyle(
                                color: Color(0xFF1E6F3D),
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],

            const SizedBox(height: 20),

            // ============================================
            // Rincian Pembayaran
            // ============================================
            const Text(
              "Rincian pembayaran",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _priceRow(
              "Sewa lapangan ($selectedDuration jam)",
              "Rp ${formatPrice(basePrice)}",
            ),
            if (promoApplied)
              _priceRow(
                "Diskon (${appliedPromo!.discountPercent}%)",
                "– Rp ${formatPrice(discountAmount)}",
                isGreen: true,
              ),
            _priceRow("Biaya layanan", "Rp ${formatPrice(serviceFee)}"),
            const Divider(),
            _priceRow("Total", "Rp ${formatPrice(totalPrice)}", isTotal: true),

            const SizedBox(height: 20),

            // ============================================
            // Metode Pembayaran
            // ============================================
            Row(
              children: [
                Expanded(child: _methodBtn("QRIS", selectedMethod == 'QRIS')),
                const SizedBox(width: 12),
                Expanded(
                  child: _methodBtn("Transfer", selectedMethod == 'Transfer'),
                ),
              ],
            ),
            const SizedBox(height: 16),

            if (selectedMethod == 'QRIS')
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F8F4),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFA3D1B4)),
                ),
                child: Column(
                  children: [
                    const Text(
                      "Scan QR Code untuk membayar",
                      style: TextStyle(
                        color: Color(0xFF1E6F3D),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Icon(Icons.qr_code_2, size: 80),
                    const SizedBox(height: 12),
                    Text(
                      "Berlaku 15 menit · Rp ${formatPrice(totalPrice)}",
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                ),
              )
            else
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF9FAFB),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Text(
                  "Pilih opsi Transfer Mandiri/E-Wallet pada langkah berikutnya.",
                ),
              ),

            const SizedBox(height: 28),

            // ============================================
            // Tombol Bayar
            // ============================================
            ElevatedButton(
              onPressed: () async {
                if (selectedMethod == 'Transfer') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => PaymentSelectionScreen(
                        venue: widget.venue,
                        totalPrice: totalPrice,
                        appliedPromo: appliedPromo,
                      ),
                    ),
                  );
                } else {
                  await doBooking();
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1E6F3D),
                minimumSize: const Size(double.infinity, 55),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: Text(
                selectedMethod == 'Transfer'
                    ? "Pilih Bank Transfer"
                    : "Bayar Sekarang — Rp ${formatPrice(totalPrice)}",
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================
  // Widget Input Row
  // ============================================
  Widget _inputRow({
    required IconData icon,
    required String label,
    required String value,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: const Color(0xFFF9FAFB),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFEEEEEE)),
        ),
        child: Row(
          children: [
            Icon(icon, size: 20, color: const Color(0xFF1E6F3D)),
            const SizedBox(width: 14),
            Text(
              "$label:",
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                value,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: Colors.black87,
                ),
              ),
            ),
            const Icon(Icons.arrow_drop_down, color: Colors.grey, size: 24),
          ],
        ),
      ),
    );
  }

  // ============================================
  // Widget Price Row
  // ============================================
  Widget _priceRow(
    String label,
    String price, {
    bool isTotal = false,
    bool isGreen = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            price,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isGreen
                  ? Colors.green
                  : (isTotal ? const Color(0xFF1E6F3D) : Colors.black),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================
  // Widget Method Button
  // ============================================
  Widget _methodBtn(String label, bool selected) {
    return OutlinedButton(
      onPressed: () => setState(() => selectedMethod = label),
      style: OutlinedButton.styleFrom(
        backgroundColor: selected ? const Color(0xFFF1F8F4) : Colors.white,
        side: BorderSide(
          color: selected ? const Color(0xFF1E6F3D) : Colors.grey,
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: selected ? const Color(0xFF1E6F3D) : Colors.black,
        ),
      ),
    );
  }
}
