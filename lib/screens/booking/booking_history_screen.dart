import 'package:flutter/material.dart';
import '../../models/booking_model.dart';
import '../../models/notification_model.dart';
import '../../models/venue_model.dart';
import '../../utils/helpers.dart';
import 'booking_detail_screen.dart';
import '../venue/venue_detail_screen.dart';

class BookingHistoryScreen extends StatefulWidget {
  const BookingHistoryScreen({Key? key}) : super(key: key);

  @override
  BookingHistoryScreenState createState() => BookingHistoryScreenState();
}

class BookingHistoryScreenState extends State<BookingHistoryScreen> {
  String activeTab = 'Semua';

  @override
  Widget build(BuildContext context) {
    List<BookingModel> filtered = globalBookingHistory
        .where((e) => activeTab == 'Semua' || e.status == activeTab)
        .toList();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text("Riwayat Booking",
            style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 22)),
      ),
      body: Column(children: [
        Padding(
          padding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(children: [
              _tab("Semua"),
              const SizedBox(width: 8),
              _tab("Aktif"),
              const SizedBox(width: 8),
              _tab("Selesai"),
              const SizedBox(width: 8),
              _tab("Batal"),
            ]),
          ),
        ),
        const SizedBox(height: 6),
        Expanded(
          child: filtered.isEmpty
              ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.calendar_today_outlined,
                      size: 60, color: Colors.grey.shade300),
                  const SizedBox(height: 16),
                  Text(
                      "Belum ada booking ${activeTab == 'Semua' ? '' : activeTab}",
                      style: const TextStyle(
                          color: Colors.grey, fontSize: 16)),
                  const SizedBox(height: 8),
                  const Text("Booking lapangan sekarang!",
                      style:
                      TextStyle(color: Colors.grey, fontSize: 13)),
                ],
              ))
              : RefreshIndicator(
            onRefresh: () async => setState(() {}),
            color: const Color(0xFF1E6F3D),
            child: ListView.builder(
              padding:
              const EdgeInsets.symmetric(horizontal: 16),
              itemCount: filtered.length,
              itemBuilder: (context, index) {
                final item = filtered[index];
                Color statusColor = item.status == 'Selesai'
                    ? Colors.blue
                    : item.status == 'Batal'
                    ? Colors.red
                    : Colors.green;
                Color statusBg = item.status == 'Selesai'
                    ? Colors.blue.shade50
                    : item.status == 'Batal'
                    ? Colors.red.shade50
                    : Colors.green.shade50;

                return Container(
                  margin: const EdgeInsets.only(bottom: 14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border:
                    Border.all(color: const Color(0xFFE5E7EB)),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withOpacity(0.03),
                          blurRadius: 8,
                          offset: const Offset(0, 2))
                    ],
                  ),
                  child: Column(children: [
                    Padding(
                      padding: const EdgeInsets.all(14),
                      child: Row(children: [
                        Container(
                          width: 46,
                          height: 46,
                          decoration: BoxDecoration(
                              color: const Color(0xFFF3F4F6),
                              borderRadius:
                              BorderRadius.circular(12)),
                          child: Icon(item.icon,
                              color: Colors.black54, size: 24),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                            child: Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  Text(item.venueName,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15)),
                                  const SizedBox(height: 3),
                                  Text(item.type,
                                      style: const TextStyle(
                                          color: Colors.grey,
                                          fontSize: 12)),
                                ])),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                              color: statusBg,
                              borderRadius:
                              BorderRadius.circular(8)),
                          child: Text(item.status,
                              style: TextStyle(
                                  color: statusColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12)),
                        ),
                      ]),
                    ),
                    const Divider(
                        height: 1,
                        thickness: 1,
                        color: Color(0xFFF3F4F6)),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 12),
                      child: Row(
                        mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                        children: [
                          Text(item.price,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Color(0xFF1E6F3D))),
                          Row(children: [
                            if (item.status == 'Aktif') ...[
                              _actionBtn(
                                "Lihat Tiket",
                                const Color(0xFFE8F5E9),
                                const Color(0xFF1E6F3D),
                                    () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          BookingDetailScreen(
                                            bookingItem: item,
                                            onCancel: () {
                                              setState(() =>
                                              item.status =
                                              'Batal');
                                              globalNotifications
                                                  .insert(
                                                0,
                                                NotificationModel(
                                                  title:
                                                  "Refund Diproses",
                                                  message:
                                                  "Pembatalan ${item.code}. Dana kembali 1-3 hari.",
                                                  time: "Baru saja",
                                                  icon: Icons
                                                      .account_balance_wallet,
                                                  iconBgColor:
                                                  const Color(
                                                      0xFFF3F4F6),
                                                  iconColor:
                                                  Colors.brown,
                                                  isRead: false,
                                                ),
                                              );
                                            },
                                          ),
                                    ),
                                  );
                                },
                              ),
                              const SizedBox(width: 8),
                              _actionBtn(
                                "Batalkan",
                                Colors.red.shade50,
                                Colors.red,
                                    () {
                                  setState(() =>
                                  item.status = 'Batal');
                                  globalNotifications.insert(
                                    0,
                                    NotificationModel(
                                      title: "Refund Diproses",
                                      message:
                                      "Pembatalan ${item.code}. Dana kembali 1-3 hari.",
                                      time: "Baru saja",
                                      icon: Icons
                                          .account_balance_wallet,
                                      iconBgColor:
                                      const Color(0xFFF3F4F6),
                                      iconColor: Colors.brown,
                                      isRead: false,
                                    ),
                                  );
                                },
                              ),
                            ] else if (item.status ==
                                'Selesai') ...[
                              _actionBtn(
                                  "Beri Ulasan",
                                  Colors.blue.shade50,
                                  Colors.blue, () {
                                showReviewDialog(context, item);
                              }),
                              const SizedBox(width: 8),
                              _actionBtn(
                                  "Pesan Lagi",
                                  const Color(0xFFE8F5E9),
                                  const Color(0xFF1E6F3D), () {
                                final matchedVenue = allVenues
                                    .where((v) =>
                                v.name == item.venueName)
                                    .toList();
                                if (matchedVenue.isNotEmpty) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          VenueDetailScreen(
                                              venue: matchedVenue
                                                  .first),
                                    ),
                                  );
                                }
                              }),
                            ] else if (item.status ==
                                'Batal') ...[
                              Container(
                                padding:
                                const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 7),
                                decoration: BoxDecoration(
                                    color: Colors.orange.shade50,
                                    borderRadius:
                                    BorderRadius.circular(8)),
                                child: const Text(
                                    "Refund diproses",
                                    style: TextStyle(
                                        color: Colors.orange,
                                        fontSize: 12,
                                        fontWeight:
                                        FontWeight.bold)),
                              ),
                            ],
                          ]),
                        ],
                      ),
                    ),
                  ]),
                );
              },
            ),
          ),
        ),
      ]),
    );
  }

  Widget _tab(String name) {
    bool sel = activeTab == name;
    return GestureDetector(
      onTap: () => setState(() => activeTab = name),
      child: Container(
        padding:
        const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
        decoration: BoxDecoration(
            color: sel
                ? const Color(0xFF1E6F3D)
                : const Color(0xFFF3F4F6),
            borderRadius: BorderRadius.circular(20)),
        child: Text(name,
            style: TextStyle(
                color: sel ? Colors.white : Colors.black87,
                fontWeight:
                sel ? FontWeight.bold : FontWeight.normal)),
      ),
    );
  }

  Widget _actionBtn(
      String label, Color bg, Color textColor, VoidCallback onTap) =>
      GestureDetector(
        onTap: onTap,
        child: Container(
          padding:
          const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
          decoration: BoxDecoration(
              color: bg, borderRadius: BorderRadius.circular(8)),
          child: Text(label,
              style: TextStyle(
                  color: textColor,
                  fontSize: 12,
                  fontWeight: FontWeight.bold)),
        ),
      );
}