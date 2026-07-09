import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../models/user_model.dart';
import '../../models/venue_model.dart';
import '../../models/promo_model.dart';
import '../search/search_filter_screen.dart';
import '../promo/promo_screen.dart';
import '../venue/venue_detail_screen.dart';

class HomeScreen extends StatelessWidget {
  final Function(int) onNavigate;
  const HomeScreen({Key? key, required this.onNavigate}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final firstName = CurrentUser.name.split(' ').first;
    final claimedPromos = globalPromos
        .where((p) => p.isClaimed && !p.isUsed)
        .toList();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(24, 60, 24, 30),
              decoration: const BoxDecoration(
                color: Color(0xFF0A1A0F),
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(30),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Halo, ${FirebaseAuth.instance.currentUser?.displayName ?? 'Pengguna'} 👋\nMau main apa hari ini?",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => onNavigate(3),
                        child: CircleAvatar(
                          backgroundColor: const Color(0xFF1E6F3D),
                          child: Text(
                            CurrentUser.initials,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const SearchFilterScreen(),
                      ),
                    ),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.white10,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.search, color: Colors.white54),
                          SizedBox(width: 12),
                          Expanded(
                            child: TextField(
                              enabled: false,
                              decoration: InputDecoration(
                                hintText: "Cari lapangan, lokasi...",
                                hintStyle: TextStyle(color: Colors.white54),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                          Icon(Icons.tune, color: Colors.white54),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _categoryItem(context, "Semua", Icons.grid_view, true, null),
                  _categoryItem(
                    context,
                    "Futsal",
                    Icons.sports_soccer,
                    false,
                    'Futsal',
                  ),
                  _categoryItem(
                    context,
                    "Badminton",
                    Icons.sports_tennis,
                    false,
                    'Badminton',
                  ),
                  _categoryItem(
                    context,
                    "Basket",
                    Icons.sports_basketball,
                    false,
                    'Basket',
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF0A1A0F),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Promo weekend",
                            style: TextStyle(color: Colors.white70),
                          ),
                          const Text(
                            "Diskon 30% semua lapangan!",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          ElevatedButton(
                            onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const PromoScreen(),
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF1E6F3D),
                            ),
                            child: Text(
                              claimedPromos.isNotEmpty
                                  ? "Promo Saya (${claimedPromos.length})"
                                  : "Klaim promo",
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(
                      Icons.local_offer_outlined,
                      size: 50,
                      color: Colors.white24,
                    ),
                  ],
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(24, 24, 24, 0),
              child: Text(
                "Lapangan terdekat",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            ...allVenues.take(3).map((v) => _venueCard(context, v)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              child: OutlinedButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SearchFilterScreen()),
                ),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 48),
                  side: const BorderSide(color: Color(0xFF1E6F3D)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "Lihat Semua Lapangan",
                  style: TextStyle(
                    color: Color(0xFF1E6F3D),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _categoryItem(
    BuildContext ctx,
    String label,
    IconData icon,
    bool active,
    String? typeFilter,
  ) => GestureDetector(
    onTap: () {
      if (typeFilter != null) {
        Navigator.push(
          ctx,
          MaterialPageRoute(
            builder: (_) => SearchFilterScreen(initialType: typeFilter),
          ),
        );
      } else {
        Navigator.push(
          ctx,
          MaterialPageRoute(builder: (_) => const SearchFilterScreen()),
        );
      }
    },
    child: Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: active ? const Color(0xFF1E6F3D) : const Color(0xFFF3F4F6),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: active ? Colors.white : Colors.grey),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: active ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    ),
  );

  Widget _venueCard(BuildContext ctx, VenueModel v) {
    final statusColor = v.status == 'Buka'
        ? Colors.green
        : v.status == 'Penuh'
        ? Colors.orange
        : Colors.red;
    return ListTile(
      onTap: () => Navigator.push(
        ctx,
        MaterialPageRoute(builder: (_) => VenueDetailScreen(venue: v)),
      ),
      leading: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: const Color(0xFFF3F4F6),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(v.icon, color: Colors.black54),
      ),
      title: Text(v.name, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("${v.distance} · ${v.address}"),
          const SizedBox(height: 4),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  v.status,
                  style: TextStyle(
                    color: statusColor,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              if (v.closingTime != null) ...[
                const SizedBox(width: 6),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    v.closingTime!,
                    style: const TextStyle(
                      color: Colors.green,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.star, color: Colors.orange, size: 16),
          Text(v.rating),
        ],
      ),
    );
  }
}
