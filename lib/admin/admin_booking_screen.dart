import 'package:flutter/material.dart';
import '../../models/booking_model.dart';
import '../../models/notification_model.dart';

class AdminBookingScreen extends StatefulWidget {
  const AdminBookingScreen({Key? key}) : super(key: key);

  @override
  AdminBookingScreenState createState() => AdminBookingScreenState();
}

class AdminBookingScreenState extends State<AdminBookingScreen> {
  String activeTab = 'Semua';
  final searchCtrl = TextEditingController();
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    searchCtrl.addListener(
      () => setState(() => searchQuery = searchCtrl.text.toLowerCase()),
    );
  }

  @override
  void dispose() {
    searchCtrl.dispose();
    super.dispose();
  }

  List<BookingModel> get filtered {
    List<BookingModel> list = List.from(globalBookingHistory);
    if (activeTab != 'Semua') {
      final tabMap = {
        'Menunggu': 'Aktif',
        'Lunas': 'Selesai',
        'Batal': 'Batal',
      };
      list = list
          .where((b) => b.status == (tabMap[activeTab] ?? activeTab))
          .toList();
    }
    if (searchQuery.isNotEmpty) {
      list = list
          .where(
            (b) =>
                b.venueName.toLowerCase().contains(searchQuery) ||
                b.code.toLowerCase().contains(searchQuery) ||
                b.userName.toLowerCase().contains(searchQuery),
          )
          .toList();
    }
    return list;
  }

  void _confirmBooking(BookingModel b) {
    setState(() => b.status = 'Selesai');
    globalNotifications.insert(
      0,
      NotificationModel(
        title: 'Booking Dikonfirmasi',
        message: '${b.venueName} · ${b.code} telah dikonfirmasi.',
        time: 'Baru saja',
        icon: Icons.check_circle,
        iconBgColor: const Color(0xFFE8F5E9),
        iconColor: const Color(0xFF1E6F3D),
        isRead: false,
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Booking berhasil dikonfirmasi'),
        backgroundColor: Color(0xFF1E6F3D),
      ),
    );
  }

  void _rejectBooking(BookingModel b) {
    setState(() => b.status = 'Batal');
    globalNotifications.insert(
      0,
      NotificationModel(
        title: 'Booking Ditolak',
        message: '${b.venueName} · ${b.code} telah ditolak.',
        time: 'Baru saja',
        icon: Icons.cancel,
        iconBgColor: const Color(0xFFFFEBEE),
        iconColor: Colors.red,
        isRead: false,
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Booking ditolak'),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final items = filtered;
    final pendingCount = globalBookingHistory
        .where((b) => b.status == 'Aktif')
        .length;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            const Text(
              'Kelola Booking',
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            if (pendingCount > 0) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: Colors.orange,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '$pendingCount',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: TextField(
              controller: searchCtrl,
              decoration: InputDecoration(
                hintText: 'Cari nama user, venue atau kode...',
                hintStyle: const TextStyle(color: Colors.grey, fontSize: 13),
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 0,
                  horizontal: 16,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFFEEEEEE)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFFEEEEEE)),
                ),
              ),
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Row(
              children: [
                for (final t in ['Semua', 'Menunggu', 'Lunas', 'Batal']) ...[
                  _tab(t),
                  const SizedBox(width: 8),
                ],
              ],
            ),
          ),
          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '${items.length} data ditemukan',
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: items.isEmpty
                ? _emptyState('Belum ada booking')
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: items.length,
                    itemBuilder: (ctx, i) => _bookingCard(items[i]),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _tab(String name) {
    bool sel = activeTab == name;
    final countMap = {
      'Semua': globalBookingHistory.length,
      'Menunggu': globalBookingHistory.where((b) => b.status == 'Aktif').length,
      'Lunas': globalBookingHistory.where((b) => b.status == 'Selesai').length,
      'Batal': globalBookingHistory.where((b) => b.status == 'Batal').length,
    };
    return GestureDetector(
      onTap: () => setState(() => activeTab = name),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: sel ? const Color(0xFF1E6F3D) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: sel ? const Color(0xFF1E6F3D) : const Color(0xFFEEEEEE),
          ),
        ),
        child: Row(
          children: [
            Text(
              name,
              style: TextStyle(
                color: sel ? Colors.white : Colors.black87,
                fontSize: 13,
                fontWeight: sel ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            if ((countMap[name] ?? 0) > 0) ...[
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                decoration: BoxDecoration(
                  color: sel
                      ? Colors.white.withOpacity(0.3)
                      : const Color(0xFFF3F4F6),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${countMap[name]}',
                  style: TextStyle(
                    color: sel ? Colors.white : Colors.grey,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _bookingCard(BookingModel b) {
    final isActive = b.status == 'Aktif';
    Color sc = b.status == 'Aktif'
        ? Colors.orange
        : b.status == 'Selesai'
        ? const Color(0xFF1E6F3D)
        : Colors.red;

    final userName = b.userName.isNotEmpty ? b.userName : 'Pengguna';
    final userPhone = '0812-3456-789';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isActive
              ? Colors.orange.withOpacity(0.3)
              : const Color(0xFFEEEEEE),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: const Color(0xFF1E6F3D),
                  child: Text(
                    userName.isNotEmpty ? userName[0].toUpperCase() : 'U',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        userName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        b.code,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: sc.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    b.status == 'Aktif' ? 'Menunggu' : b.status,
                    style: TextStyle(
                      color: sc,
                      fontWeight: FontWeight.bold,
                      fontSize: 11,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 14),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF7F8FA),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Icon(b.icon, size: 14, color: Colors.black54),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        b.venueName,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.calendar_today,
                          size: 12,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          b.date,
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Icon(
                          Icons.access_time,
                          size: 12,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          b.time,
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.phone, size: 12, color: Colors.grey),
                        const SizedBox(width: 4),
                        Text(
                          userPhone,
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      b.price,
                      style: const TextStyle(
                        color: Color(0xFF1E6F3D),
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (isActive) ...[
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => _confirmBooking(b),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1E6F3D),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                      ),
                      child: const Text(
                        'Konfirmasi',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => _rejectBooking(b),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFFEBEE),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                      ),
                      child: const Text(
                        'Tolak',
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ] else
            const SizedBox(height: 14),
        ],
      ),
    );
  }

  Widget _emptyState(String msg) => Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.calendar_today_outlined, size: 60, color: Colors.grey),
        const SizedBox(height: 16),
        Text(msg, style: const TextStyle(color: Colors.grey, fontSize: 16)),
      ],
    ),
  );
}
