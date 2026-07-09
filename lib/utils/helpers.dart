import 'package:flutter/material.dart';
import '../models/booking_model.dart';
import '../models/venue_model.dart';
import '../models/notification_model.dart';

String formatPrice(int price) {
  final s = price.toString();
  if (s.length <= 3) return s;
  return '${s.substring(0, s.length - 3)}.${s.substring(s.length - 3)}';
}

void showReviewDialog(BuildContext context, BookingModel item) {
  int selectedStars = 0;
  final commentCtrl = TextEditingController();

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (ctx) => StatefulBuilder(
      builder: (ctx2, setS) => Container(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 20,
          bottom: MediaQuery.of(ctx2).viewInsets.bottom + 24,
        ),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFFDDDDDD),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            const Text('Beri Ulasan',
                style:
                TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 4),
            Text(item.venueName,
                style:
                const TextStyle(color: Colors.grey, fontSize: 13)),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                5,
                    (i) => GestureDetector(
                  onTap: () => setS(() => selectedStars = i + 1),
                  child: Padding(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 6),
                    child: Icon(
                      i < selectedStars
                          ? Icons.star
                          : Icons.star_border,
                      color: Colors.amber,
                      size: 36,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              selectedStars == 0
                  ? 'Ketuk bintang untuk memberi nilai'
                  : selectedStars == 5
                  ? 'Luar biasa!'
                  : selectedStars >= 4
                  ? 'Sangat bagus!'
                  : selectedStars >= 3
                  ? 'Cukup baik'
                  : selectedStars >= 2
                  ? 'Kurang memuaskan'
                  : 'Sangat buruk',
              style: TextStyle(
                color: selectedStars == 0 ? Colors.grey : Colors.amber,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: commentCtrl,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'Ceritakan pengalamanmu di sini...',
                filled: true,
                fillColor: const Color(0xFFF3F4F6),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: selectedStars == 0
                  ? null
                  : () {
                final venueIdx = allVenues
                    .indexWhere((v) => v.name == item.venueName);
                if (venueIdx >= 0) {
                  final currentRating =
                  double.parse(allVenues[venueIdx].rating);
                  final newRating =
                  ((currentRating + selectedStars) / 2)
                      .toStringAsFixed(1);
                  allVenues[venueIdx].rating = newRating;
                }
                globalNotifications.insert(
                  0,
                  NotificationModel(
                    title: 'Ulasan Terkirim!',
                    message:
                    'Terima kasih atas ulasan untuk ${item.venueName}.',
                    time: 'Baru saja',
                    icon: Icons.star,
                    iconBgColor: const Color(0xFFFFF9C4),
                    iconColor: Colors.amber,
                    isRead: false,
                  ),
                );
                Navigator.pop(ctx2);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content:
                    Text('Ulasan berhasil dikirim! Terima kasih.'),
                    backgroundColor: Color(0xFF1E6F3D),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1E6F3D),
                disabledBackgroundColor: Colors.grey.shade300,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Kirim Ulasan',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    ),
  );
}