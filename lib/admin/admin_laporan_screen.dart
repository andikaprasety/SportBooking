import 'package:flutter/material.dart';
import '../../utils/constants.dart';
import '../../models/booking_model.dart';

class AdminLaporanScreen extends StatefulWidget {
  const AdminLaporanScreen({Key? key}) : super(key: key);

  @override
  AdminLaporanScreenState createState() => AdminLaporanScreenState();
}

class AdminLaporanScreenState extends State<AdminLaporanScreen> {
  String selectedPeriod = 'Minggu Ini';
  String selectedMonth = 'Apr';

  String _fmt(int p) {
    if (p >= 1000000) return 'Rp ${(p / 1000000).toStringAsFixed(1)}jt';
    if (p >= 1000) return 'Rp ${(p / 1000).round()}rb';
    return 'Rp $p';
  }

  @override
  Widget build(BuildContext context) {
    final totalRevenue = AdminStats.totalRevenue;
    final maxAmount = weeklyData
        .map((d) => d['amount'] as int)
        .reduce((a, b) => a > b ? a : b);
    final maxMonthly = monthlyData
        .map((d) => d['amount'] as int)
        .reduce((a, b) => a > b ? a : b);

    // Venue booking count (real data from globalBookingHistory)
    final Map<String, int> venueCount = {};
    for (var b in globalBookingHistory) {
      venueCount[b.venueName] = (venueCount[b.venueName] ?? 0) + 1;
    }
    final sortedVenues = venueCount.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text('Laporan & Statistik',
            style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 20)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Period selector ───────────────────────────────────────
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(children: [
                for (final p in ['Jan', 'Feb', 'Mar', 'Apr', 'Mei']) ...[
                  _monthChip(p),
                  const SizedBox(width: 8),
                ]
              ]),
            ),
            const SizedBox(height: 12),

            // ── Revenue Card ──────────────────────────────────────────
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                  gradient: const LinearGradient(
                      colors: [Color(0xFF0A1A0F), Color(0xFF1E6F3D)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight),
                  borderRadius: BorderRadius.circular(20)),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Pendapatan',
                                style: TextStyle(
                                    color: Colors.white70, fontSize: 12)),
                            Text(_fmt(totalRevenue + 24800000),
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 26,
                                    fontWeight: FontWeight.bold)),
                            const SizedBox(height: 4),
                            Row(children: [
                              const Icon(Icons.trending_up,
                                  color: Colors.greenAccent, size: 14),
                              const SizedBox(width: 4),
                              const Text('12% vs Mar',
                                  style: TextStyle(
                                      color: Colors.greenAccent, fontSize: 11)),
                            ]),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const Text('Total Booking',
                                style: TextStyle(
                                    color: Colors.white70, fontSize: 12)),
                            Text('${AdminStats.totalBooking + 312}',
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold)),
                            const SizedBox(height: 4),
                            const Text('8% vs Mar',
                                style: TextStyle(
                                    color: Colors.greenAccent, fontSize: 11)),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Divider(color: Colors.white24, height: 1),
                    const SizedBox(height: 12),
                    // Bottom stats
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _revenueBottomStat('Lapangan', 'Futsal A', '18.00-20.00'),
                        _revenueBottomStat(
                            'Booking', '${AdminStats.totalBooking}x', '65% padat'),
                      ],
                    ),
                  ]),
            ),
            const SizedBox(height: 16),

            // ── Grafik Tren Pendapatan Mingguan ───────────────────────
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 8,
                        offset: const Offset(0, 2))
                  ]),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Tren pendapatan mingguan',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 14)),
                  const SizedBox(height: 4),
                  const Text('Apr 2026',
                      style: TextStyle(color: Colors.grey, fontSize: 12)),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 120,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: weeklyData.map((d) {
                        final amount = d['amount'] as int;
                        final barH = (amount / maxAmount) * 90;
                        final isHighest = amount == maxAmount;
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            if (isHighest)
                              Text(_fmt(amount),
                                  style: const TextStyle(
                                      color: Color(0xFF1E6F3D),
                                      fontSize: 8,
                                      fontWeight: FontWeight.bold)),
                            const SizedBox(height: 2),
                            Container(
                              width: 30,
                              height: barH,
                              decoration: BoxDecoration(
                                  color: isHighest
                                      ? const Color(0xFF1E6F3D)
                                      : const Color(0xFFB2DFDB),
                                  borderRadius: BorderRadius.circular(6)),
                            ),
                            const SizedBox(height: 6),
                            Text(d['day'],
                                style: TextStyle(
                                    fontSize: 10,
                                    color: isHighest
                                        ? const Color(0xFF1E6F3D)
                                        : Colors.grey,
                                    fontWeight: isHighest
                                        ? FontWeight.bold
                                        : FontWeight.normal)),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // ── Pembayaran per metode ─────────────────────────────────
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 8,
                        offset: const Offset(0, 2))
                  ]),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Pembayaran per metode',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 14)),
                  const SizedBox(height: 12),
                  _payRow('QRIS', 65, Colors.blue),
                  const SizedBox(height: 8),
                  _payRow('Transfer Bank', 35, Colors.orange),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // ── Lapangan Terpopuler (terintegrasi) ────────────────────
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 8,
                        offset: const Offset(0, 2))
                  ]),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Lapangan Terpopuler',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 14)),
                  const SizedBox(height: 12),
                  if (sortedVenues.isEmpty)
                    const Text('Belum ada data',
                        style: TextStyle(color: Colors.grey))
                  else
                    ...sortedVenues.take(5).toList().asMap().entries.map((e) {
                      final idx = e.key;
                      final entry = e.value;
                      final maxCount = sortedVenues.first.value.toDouble();
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(entry.key,
                                        style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500),
                                        overflow: TextOverflow.ellipsis),
                                  ),
                                  Text('${entry.value}x',
                                      style: const TextStyle(
                                          color: Color(0xFF1E6F3D),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12)),
                                ],
                              ),
                              const SizedBox(height: 4),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(4),
                                child: LinearProgressIndicator(
                                  value: entry.value / maxCount,
                                  backgroundColor: const Color(0xFFF3F4F6),
                                  valueColor: const AlwaysStoppedAnimation<Color>(
                                      Color(0xFF1E6F3D)),
                                  minHeight: 6,
                                ),
                              ),
                            ]),
                      );
                    }),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // ── Export Buttons ────────────────────────────────────────
            ElevatedButton.icon(
              onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('Laporan PDF berhasil diekspor!'),
                      backgroundColor: Color(0xFF1E6F3D))),
              icon: const Icon(Icons.picture_as_pdf, size: 18),
              label: const Text('Ekspor Laporan PDF',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1E6F3D),
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12))),
            ),
            const SizedBox(height: 10),
            OutlinedButton.icon(
              onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('Laporan Excel berhasil diekspor!'),
                      backgroundColor: Color(0xFF1E6F3D))),
              icon: const Icon(Icons.table_chart, size: 18),
              label: const Text('Ekspor ke Excel',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFF1E6F3D),
                  side: const BorderSide(color: Color(0xFF1E6F3D)),
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12))),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _monthChip(String m) {
    bool sel = selectedMonth == m;
    return GestureDetector(
      onTap: () => setState(() => selectedMonth = m),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
            color: sel ? const Color(0xFF1E6F3D) : Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
                color: sel ? const Color(0xFF1E6F3D) : const Color(0xFFEEEEEE))),
        child: Text(m,
            style: TextStyle(
                color: sel ? Colors.white : Colors.black87,
                fontWeight: sel ? FontWeight.bold : FontWeight.normal,
                fontSize: 13)),
      ),
    );
  }

  Widget _revenueBottomStat(String title, String main, String sub) =>
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title,
            style: const TextStyle(color: Colors.white54, fontSize: 11)),
        Text(main,
            style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14)),
        Text(sub,
            style: const TextStyle(color: Colors.white54, fontSize: 10)),
      ]);

  Widget _payRow(String method, int percent, Color color) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(method,
            style: const TextStyle(
                fontSize: 12, fontWeight: FontWeight.w500)),
        Text('$percent%',
            style: TextStyle(
                color: color, fontWeight: FontWeight.bold, fontSize: 12)),
      ]),
      const SizedBox(height: 4),
      ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: LinearProgressIndicator(
          value: percent / 100,
          backgroundColor: const Color(0xFFF3F4F6),
          valueColor: AlwaysStoppedAnimation<Color>(color),
          minHeight: 6,
        ),
      ),
    ],
  );
}