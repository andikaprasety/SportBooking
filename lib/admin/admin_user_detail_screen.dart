import 'package:flutter/material.dart';
import 'package:sport_booking/screens/auth/onboarding_screen.dart';
import '../../models/user_model.dart';
import '../../models/booking_model.dart';
import '../../screens/auth/onboarding_screen.dart';

class AdminUserDetailScreen extends StatefulWidget {
  final AppUser user;
  const AdminUserDetailScreen({Key? key, required this.user})
      : super(key: key);

  @override
  AdminUserDetailScreenState createState() =>
      AdminUserDetailScreenState();
}

class AdminUserDetailScreenState
    extends State<AdminUserDetailScreen> {
  late AppUser u;

  @override
  void initState() {
    super.initState();
    u = widget.user;
  }

  List<BookingModel> get userBookings {
    return globalBookingHistory
        .where((b) =>
    b.userName == u.name ||
        b.userEmail == u.email ||
        (u.email == CurrentUser.email && b.userName.isEmpty))
        .toList();
  }

  String _fmtPrice(int p) {
    if (p >= 1000000)
      return 'Rp ${(p / 1000000).toStringAsFixed(1)}jt';
    if (p >= 1000) return 'Rp ${(p / 1000).round()}rb';
    return 'Rp $p';
  }

  void _toggleActive() {
    setState(() => u.isActive = !u.isActive);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(u.isActive
            ? '${u.name} diaktifkan kembali'
            : '${u.name} telah disuspend'),
        backgroundColor:
        u.isActive ? const Color(0xFF1E6F3D) : Colors.orange));
  }

  void _deleteUser() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16)),
        title: const Text('Hapus pengguna?',
            style:
            TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
        content: RichText(
          text: TextSpan(
            style: const TextStyle(
                color: Colors.black87, fontSize: 14, height: 1.5),
            children: [
              const TextSpan(text: 'Akun '),
              TextSpan(
                  text: u.name,
                  style:
                  const TextStyle(fontWeight: FontWeight.bold)),
              const TextSpan(
                  text:
                  ' akan dihapus permanen.\nData riwayat booking tetap tersimpan.'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal',
                style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              final isCurrentUser = u.email == CurrentUser.email;
              globalUsers.remove(u);

              if (isCurrentUser) {
                CurrentUser.clear();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const OnboardingScreen()),
                      (route) => false,
                );
                return;
              }

              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('${u.name} berhasil dihapus'),
                backgroundColor: Colors.red,
              ));
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text('Ya, Hapus',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  void _sendMessage() {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Pesan dikirim ke ${u.name}'),
        backgroundColor: const Color(0xFF1E6F3D)));
  }

  @override
  Widget build(BuildContext context) {
    final bookings = userBookings;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new,
                color: Colors.black),
            onPressed: () => Navigator.pop(context)),
        title: const Text('Detail User',
            style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(24),
              child: Column(children: [
                CircleAvatar(
                  radius: 36,
                  backgroundColor:
                  u.isActive ? const Color(0xFF1E6F3D) : Colors.grey,
                  child: Text(
                      u.name.isNotEmpty
                          ? u.name[0].toUpperCase()
                          : 'U',
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 28)),
                ),
                const SizedBox(height: 12),
                Text(u.name,
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(u.email,
                    style: const TextStyle(
                        color: Colors.grey, fontSize: 13)),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                      color: u.isActive
                          ? const Color(0xFFE8F5E9)
                          : Colors.red.shade50,
                      borderRadius: BorderRadius.circular(8)),
                  child: Text(
                      u.isActive ? 'Aktif' : 'Suspended',
                      style: TextStyle(
                          color: u.isActive
                              ? const Color(0xFF1E6F3D)
                              : Colors.red,
                          fontWeight: FontWeight.bold,
                          fontSize: 12)),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment:
                  MainAxisAlignment.spaceAround,
                  children: [
                    _miniStat('${bookings.length}', 'Booking',
                        Colors.black),
                    _miniStat(
                        u.rating > 0
                            ? u.rating.toStringAsFixed(1)
                            : 'N/A',
                        'Rating',
                        Colors.orange),
                    _miniStat(_fmtPrice(u.totalSpend),
                        'Total Spend', Colors.blue),
                  ],
                ),
              ]),
            ),
            const SizedBox(height: 8),
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Informasi Akun',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15)),
                  const SizedBox(height: 12),
                  _infoRow(Icons.phone, 'No. HP', u.phone),
                  _infoRow(Icons.location_on, 'Kota', u.city),
                  _infoRow(Icons.calendar_month, 'Bergabung',
                      u.joinDate),
                  _infoRow(Icons.access_time, 'Login terakhir',
                      u.lastLogin),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Booking terakhir',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15)),
                      Text('${bookings.length} total',
                          style: const TextStyle(
                              color: Color(0xFF1E6F3D),
                              fontSize: 12,
                              fontWeight: FontWeight.w600)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  if (bookings.isEmpty)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.all(20),
                        child: Text('Belum ada booking',
                            style:
                            TextStyle(color: Colors.grey)),
                      ),
                    )
                  else
                    ...bookings.take(3).map((b) => _bookingRow(b)),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(children: [
                ElevatedButton.icon(
                  onPressed: _sendMessage,
                  icon: const Icon(Icons.send, size: 18),
                  label: const Text('Kirim Pesan',
                      style:
                      TextStyle(fontWeight: FontWeight.bold)),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1E6F3D),
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12))),
                ),
                const SizedBox(height: 12),
                ElevatedButton.icon(
                  onPressed: _toggleActive,
                  icon: Icon(
                      u.isActive ? Icons.block : Icons.check_circle,
                      size: 18),
                  label: Text(
                      u.isActive ? 'Suspend User' : 'Aktifkan User',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold)),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: u.isActive
                          ? const Color(0xFFFFF3E0)
                          : const Color(0xFFE8F5E9),
                      foregroundColor: u.isActive
                          ? Colors.orange
                          : const Color(0xFF1E6F3D),
                      elevation: 0,
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12))),
                ),
                const SizedBox(height: 12),
                ElevatedButton.icon(
                  onPressed: _deleteUser,
                  icon: const Icon(Icons.delete_forever, size: 18),
                  label: const Text('Hapus User Permanen',
                      style:
                      TextStyle(fontWeight: FontWeight.bold)),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFFEBEE),
                      foregroundColor: Colors.red,
                      elevation: 0,
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12))),
                ),
              ]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _miniStat(String val, String label, Color color) =>
      Column(children: [
        Text(val,
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: color)),
        Text(label,
            style:
            const TextStyle(color: Colors.grey, fontSize: 11)),
      ]);

  Widget _infoRow(IconData icon, String label, String value) =>
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(children: [
          Icon(icon, size: 16, color: Colors.grey),
          const SizedBox(width: 10),
          Text('$label: ',
              style: const TextStyle(
                  color: Colors.grey, fontSize: 13)),
          Expanded(
              child: Text(value,
                  style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 13))),
        ]),
      );

  Widget _bookingRow(BookingModel b) {
    Color sc = b.status == 'Aktif'
        ? Colors.orange
        : b.status == 'Selesai'
        ? const Color(0xFF1E6F3D)
        : Colors.red;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
          color: const Color(0xFFF7F8FA),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFEEEEEE))),
      child: Row(children: [
        Icon(b.icon, size: 20, color: Colors.black54),
        const SizedBox(width: 10),
        Expanded(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(b.venueName,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 12)),
                  Text('${b.date} · ${b.time}',
                      style: const TextStyle(
                          color: Colors.grey, fontSize: 11)),
                ])),
        Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                    color: sc.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6)),
                child: Text(b.status,
                    style: TextStyle(
                        color: sc,
                        fontSize: 10,
                        fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 2),
              Text(b.price,
                  style: const TextStyle(
                      color: Color(0xFF1E6F3D),
                      fontWeight: FontWeight.bold,
                      fontSize: 11)),
            ]),
      ]),
    );
  }
}