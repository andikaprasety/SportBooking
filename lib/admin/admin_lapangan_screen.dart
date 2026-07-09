import 'package:flutter/material.dart';
import '../../models/venue_model.dart';
import '../../models/booking_model.dart';
import '../../utils/helpers.dart';

class AdminLapanganScreen extends StatefulWidget {
  const AdminLapanganScreen({Key? key}) : super(key: key);

  @override
  AdminLapanganScreenState createState() =>
      AdminLapanganScreenState();
}

class AdminLapanganScreenState extends State<AdminLapanganScreen> {
  String filterStatus = 'Semua';

  List<VenueModel> get filtered {
    if (filterStatus == 'Semua') return allVenues;
    return allVenues
        .where((v) => v.status == filterStatus)
        .toList();
  }

  void _changeStatus(VenueModel venue, String newStatus) {
    setState(() => venue.status = newStatus);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content:
        Text('Status ${venue.name} diubah ke $newStatus'),
        backgroundColor: const Color(0xFF1E6F3D)));
  }

  void _showAddVenueDialog() {
    final nameCtrl = TextEditingController();
    final addressCtrl = TextEditingController();
    final priceCtrl = TextEditingController();
    String selectedType = 'Futsal';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 20,
          bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
        ),
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius:
            BorderRadius.vertical(top: Radius.circular(24))),
        child: StatefulBuilder(
          builder: (ctx2, setS) => Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: SizedBox(
                    width: 40,
                    height: 4,
                    child: DecoratedBox(
                        decoration: BoxDecoration(
                            color: Color(0xFFDDDDDD),
                            borderRadius: BorderRadius.all(
                                Radius.circular(2))))),
              ),
              const SizedBox(height: 16),
              const Text('Tambah Lapangan Baru',
                  style: TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              TextField(
                controller: nameCtrl,
                decoration: InputDecoration(
                    hintText: 'Nama lapangan',
                    filled: true,
                    fillColor: const Color(0xFFF3F4F6),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none)),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: addressCtrl,
                decoration: InputDecoration(
                    hintText: 'Alamat lengkap',
                    filled: true,
                    fillColor: const Color(0xFFF3F4F6),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none)),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: priceCtrl,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    hintText: 'Harga per jam (Rp)',
                    filled: true,
                    fillColor: const Color(0xFFF3F4F6),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none)),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: selectedType,
                decoration: InputDecoration(
                    filled: true,
                    fillColor: const Color(0xFFF3F4F6),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none)),
                items: ['Futsal', 'Badminton', 'Basket', 'Tenis']
                    .map((t) =>
                    DropdownMenuItem(value: t, child: Text(t)))
                    .toList(),
                onChanged: (v) =>
                    setS(() => selectedType = v ?? 'Futsal'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (nameCtrl.text.isNotEmpty) {
                    setState(() {
                      allVenues.add(VenueModel(
                        name: nameCtrl.text,
                        type: selectedType,
                        distance: '0.0 km',
                        distanceValue: 0.0,
                        address: addressCtrl.text,
                        rating: '0.0',
                        status: 'Buka',
                        icon: selectedType == 'Futsal'
                            ? Icons.sports_soccer
                            : selectedType == 'Basket'
                            ? Icons.sports_basketball
                            : Icons.sports_tennis,
                        isIndoor: true,
                        hasParking: false,
                        pricePerHour:
                        int.tryParse(priceCtrl.text) ?? 50000,
                      ));
                    });
                  }
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(
                      content: Text(
                          '${nameCtrl.text} berhasil ditambahkan!'),
                      backgroundColor:
                      const Color(0xFF1E6F3D)));
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1E6F3D),
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12))),
                child: const Text('Tambah Lapangan',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final venues = filtered;
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text('Kelola Lapangan',
            style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 20)),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle,
                color: Color(0xFF1E6F3D)),
            onPressed: _showAddVenueDialog,
          ),
        ],
      ),
      body: Column(children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(
              horizontal: 16, vertical: 10),
          child: Row(children: [
            for (final s in [
              'Semua',
              'Buka',
              'Penuh',
              'Tutup'
            ]) ...[
              _filterChip(s),
              const SizedBox(width: 8),
            ]
          ]),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('${venues.length} lapangan',
                  style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                      fontWeight: FontWeight.w500)),
              Row(children: [
                Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle)),
                const SizedBox(width: 4),
                Text(
                    'Buka: ${allVenues.where((v) => v.status == "Buka").length}',
                    style: const TextStyle(
                        color: Colors.grey, fontSize: 11)),
                const SizedBox(width: 10),
                Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                        color: Colors.orange,
                        shape: BoxShape.circle)),
                const SizedBox(width: 4),
                Text(
                    'Penuh: ${allVenues.where((v) => v.status == "Penuh").length}',
                    style: const TextStyle(
                        color: Colors.grey, fontSize: 11)),
              ]),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: venues.length,
            itemBuilder: (ctx, i) => _venueCard(venues[i]),
          ),
        ),
      ]),
    );
  }

  Widget _filterChip(String s) {
    bool sel = filterStatus == s;
    Color color = s == 'Buka'
        ? Colors.green
        : s == 'Penuh'
        ? Colors.orange
        : s == 'Tutup'
        ? Colors.red
        : const Color(0xFF1E6F3D);
    return GestureDetector(
      onTap: () => setState(() => filterStatus = s),
      child: Container(
        padding: const EdgeInsets.symmetric(
            horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
            color: sel ? color : Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
                color: sel ? color : const Color(0xFFEEEEEE))),
        child: Text(s,
            style: TextStyle(
                color: sel ? Colors.white : Colors.black87,
                fontWeight:
                sel ? FontWeight.bold : FontWeight.normal,
                fontSize: 13)),
      ),
    );
  }

  Widget _venueCard(VenueModel v) {
    final sc = v.status == 'Buka'
        ? Colors.green
        : v.status == 'Penuh'
        ? Colors.orange
        : Colors.red;
    final bookingCount = globalBookingHistory
        .where((b) => b.venueName == v.name)
        .length;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 8,
                offset: const Offset(0, 2))
          ]),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                    color: const Color(0xFFF3F4F6),
                    borderRadius: BorderRadius.circular(12)),
                child:
                Icon(v.icon, color: Colors.black54, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(v.name,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 14)),
                        Text('${v.type} · ${v.address}',
                            style: const TextStyle(
                                color: Colors.grey, fontSize: 11)),
                      ])),
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert, color: Colors.grey),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                onSelected: (val) => _changeStatus(v, val),
                itemBuilder: (ctx) => [
                  const PopupMenuItem(
                      value: 'Buka', child: Text('Set Buka')),
                  const PopupMenuItem(
                      value: 'Penuh', child: Text('Set Penuh')),
                  const PopupMenuItem(
                      value: 'Tutup', child: Text('Set Tutup')),
                ],
              ),
            ]),
            const SizedBox(height: 12),
            Row(children: [
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                    color: sc.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8)),
                child: Text(v.status,
                    style: TextStyle(
                        color: sc,
                        fontWeight: FontWeight.bold,
                        fontSize: 11)),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                    color: const Color(0xFFF3F4F6),
                    borderRadius: BorderRadius.circular(8)),
                child: Row(children: [
                  const Icon(Icons.star,
                      size: 12, color: Colors.orange),
                  const SizedBox(width: 4),
                  Text(v.rating,
                      style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 11,
                          fontWeight: FontWeight.bold)),
                ]),
              ),
              const Spacer(),
              Text('Rp ${formatPrice(v.pricePerHour)}/jam',
                  style: const TextStyle(
                      color: Color(0xFF1E6F3D),
                      fontWeight: FontWeight.bold,
                      fontSize: 13)),
            ]),
            if (bookingCount > 0) ...[
              const SizedBox(height: 8),
              Text('$bookingCount booking total',
                  style:
                  const TextStyle(color: Colors.grey, fontSize: 11)),
            ],
          ]),
    );
  }
}