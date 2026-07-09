import 'package:flutter/material.dart';
import '../../models/venue_model.dart';
import '../venue/venue_detail_screen.dart';

class SearchFilterScreen extends StatefulWidget {
  final String? initialType;
  const SearchFilterScreen({Key? key, this.initialType}) : super(key: key);

  @override
  SearchFilterScreenState createState() => SearchFilterScreenState();
}

class SearchFilterScreenState extends State<SearchFilterScreen> {
  final searchCtrl = TextEditingController();
  String selectedType = 'Semua';
  String selectedDistance = 'Semua';
  bool onlyOpen = false;
  bool sortByRating = false;
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    if (widget.initialType != null) selectedType = widget.initialType!;
    searchCtrl.addListener(
        () => setState(() => searchQuery = searchCtrl.text.trim().toLowerCase()));
  }

  @override
  void dispose() {
    searchCtrl.dispose();
    super.dispose();
  }

  List<VenueModel> get filteredVenues {
    List<VenueModel> result = List.from(allVenues);
    
    // Filter berdasarkan pencarian
    if (searchQuery.isNotEmpty) {
      result = result
          .where((v) =>
      v.name.toLowerCase().contains(searchQuery) ||
          v.address.toLowerCase().contains(searchQuery) ||
          v.type.toLowerCase().contains(searchQuery))
          .toList();
    }
    
    // Filter berdasarkan tipe
    if (selectedType != 'Semua') {
      result = result.where((v) => v.type == selectedType).toList();
    }
    
    // Filter berdasarkan jarak
    if (selectedDistance == '≤ 2 km') {
      result = result.where((v) => v.distanceValue <= 2.0).toList();
    } else if (selectedDistance == '2-5 km') {
      result = result
          .where((v) => v.distanceValue > 2.0 && v.distanceValue <= 5.0)
          .toList();
    } else if (selectedDistance == '> 5 km') {
      result = result.where((v) => v.distanceValue > 5.0).toList();
    }
    
    // Filter hanya yang buka
    if (onlyOpen) result = result.where((v) => v.status == 'Buka').toList();
    
    // Sorting
    if (sortByRating) {
      result.sort(
              (a, b) => double.parse(b.rating).compareTo(double.parse(a.rating)));
    } else {
      result.sort((a, b) => a.distanceValue.compareTo(b.distanceValue));
    }
    return result;
  }

  void _resetFilters() {
    setState(() {
      selectedType = 'Semua';
      selectedDistance = 'Semua';
      onlyOpen = false;
      sortByRating = false;
      searchCtrl.clear();
      searchQuery = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    final results = filteredVenues;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
            onPressed: () => Navigator.pop(context)),
        title: SizedBox(
          height: 45,
          child: TextField(
            controller: searchCtrl,
            autofocus: widget.initialType == null,
            decoration: InputDecoration(
                hintText: "Cari lapangan, lokasi...",
                hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
                filled: true,
                fillColor: const Color(0xFFF3F4F6),
                contentPadding:
                const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none)),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.clear, color: Colors.grey),
            onPressed: _resetFilters,
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Filter Chips - Horizontal Scroll
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                for (final t in ['Semua', 'Futsal', 'Badminton', 'Basket', 'Tenis'])
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: _chip(
                      t,
                      selectedType == t,
                          () => setState(() => selectedType = t),
                    ),
                  ),
              ],
            ),
          ),
          
          // Filter Jarak & Lainnya
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                for (final d in ['Semua', '≤ 2 km', '2-5 km', '> 5 km'])
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: _chip(
                      d,
                      selectedDistance == d,
                          () => setState(() => selectedDistance = d),
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: _chip(
                    'Hanya Buka',
                    onlyOpen,
                        () => setState(() => onlyOpen = !onlyOpen),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: _chip(
                    '⭐ Rating',
                    sortByRating,
                        () => setState(() => sortByRating = !sortByRating),
                  ),
                ),
                GestureDetector(
                  onTap: _resetFilters,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                        color: const Color(0xFFFFEBEE),
                        borderRadius: BorderRadius.circular(20)),
                    child: const Text(
                      'Reset All',
                      style: TextStyle(
                          color: Colors.red,
                          fontSize: 13,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 8),
          
          // Jumlah hasil
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "${results.length} lapangan ditemukan",
                  style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Colors.black54),
                ),
                if (results.isNotEmpty)
                  Text(
                    'Urutkan: ${sortByRating ? "Rating Tertinggi" : "Terdekat"}',
                    style: const TextStyle(
                      fontSize: 11,
                      color: Colors.grey,
                    ),
                  ),
              ],
            ),
          ),
          
          const SizedBox(height: 8),
          
          // List hasil
          Expanded(
            child: results.isEmpty
                ? _emptyState()
                : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: results.length,
              itemBuilder: (ctx, i) => _venueCard(ctx, results[i]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _emptyState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 60, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            'Tidak ada lapangan ditemukan',
            style: TextStyle(color: Colors.grey, fontSize: 16),
          ),
          SizedBox(height: 8),
          Text(
            'Coba ubah filter atau kata kunci pencarian',
            style: TextStyle(color: Colors.grey, fontSize: 13),
          ),
        ],
      ),
    );
  }

  Widget _chip(String label, bool active, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: active ? const Color(0xFF1E6F3D) : const Color(0xFFF3F4F6),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: active ? const Color(0xFF1E6F3D) : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: active ? Colors.white : Colors.black87,
            fontSize: 13,
            fontWeight: active ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _venueCard(BuildContext ctx, VenueModel v) {
    final statusColor = v.status == 'Buka'
        ? Colors.green
        : v.status == 'Penuh'
        ? Colors.orange
        : Colors.red;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          ctx,
          MaterialPageRoute(
            builder: (_) => VenueDetailScreen(venue: v),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFEEEEEE)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Icon
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: const Color(0xFFF3F4F6),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(v.icon, color: const Color(0xFF1E6F3D), size: 28),
            ),
            const SizedBox(width: 14),
            
            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    v.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "${v.distance} · ${v.address}",
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      // Rating
                      const Icon(Icons.star, color: Colors.orange, size: 14),
                      const SizedBox(width: 4),
                      Text(
                        v.rating,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Status
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 3),
                        decoration: BoxDecoration(
                          color: statusColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
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
                      // Harga
                      const Spacer(),
                      Text(
                        'Rp ${_formatPrice(v.pricePerHour)}/jam',
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
          ],
        ),
      ),
    );
  }

  String _formatPrice(int price) {
    final s = price.toString();
    if (s.length <= 3) return s;
    return '${s.substring(0, s.length - 3)}.${s.substring(s.length - 3)}';
  }
}