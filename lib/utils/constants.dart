import '../models/booking_model.dart';
import '../models/user_model.dart';

class AdminStats {
  static int get totalBooking => globalBookingHistory.length;
  static int get pendingBooking =>
      globalBookingHistory.where((b) => b.status == 'Aktif').length;
  static int get completedBooking =>
      globalBookingHistory.where((b) => b.status == 'Selesai').length;
  static int get cancelledBooking =>
      globalBookingHistory.where((b) => b.status == 'Batal').length;

  static int get totalRevenue {
    int total = 0;
    for (var b in globalBookingHistory) {
      if (b.status != 'Batal') {
        final priceStr =
        b.price.replaceAll('Rp ', '').replaceAll('.', '').trim();
        total += int.tryParse(priceStr) ?? 0;
      }
    }
    return total;
  }

  static String formatRevenue(int amount) {
    if (amount >= 1000000) {
      return 'Rp ${(amount / 1000000).toStringAsFixed(1)}jt';
    } else if (amount >= 1000) {
      return 'Rp ${(amount / 1000).round()}rb';
    }
    return 'Rp $amount';
  }
}

final List<Map<String, dynamic>> weeklyData = [
  {'day': 'Sen', 'amount': 320000},
  {'day': 'Sel', 'amount': 480000},
  {'day': 'Rab', 'amount': 290000},
  {'day': 'Kam', 'amount': 650000},
  {'day': 'Jum', 'amount': 510000},
  {'day': 'Sab', 'amount': 870000},
  {'day': 'Min', 'amount': 420000},
];

final List<Map<String, dynamic>> monthlyData = [
  {'month': 'Jan', 'amount': 4200000},
  {'month': 'Feb', 'amount': 5800000},
  {'month': 'Mar', 'amount': 4900000},
  {'month': 'Apr', 'amount': 6500000},
  {'month': 'Mei', 'amount': 7100000},
];