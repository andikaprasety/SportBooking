import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore db = FirebaseFirestore.instance;

  // ======================
  // GET DATA VENUES
  // ======================
  Stream<QuerySnapshot> getVenues() {
    return db.collection("venues").snapshots();
  }

  // ======================
  // SAVE BOOKING
  // ======================
  Future<void> addBooking({
    required String userId,
    required String venueId,
    required String venueName,
    required String date,
    required String time,
    required int duration,
    required int totalPrice,
  }) async {
    try {
      await db.collection("bookings").add({
        "userId": userId,
        "venueId": venueId,
        "venueName": venueName,
        "date": date,
        "time": time,
        "duration": duration,
        "totalPrice": totalPrice,
        "status": "Menunggu Pembayaran",
        "createdAt": FieldValue.serverTimestamp(),
      });

      print("✅ Booking berhasil disimpan");
    } catch (e) {
      print("❌ ERROR Booking: $e");
    }
  }

  // ======================
  // GET RIWAYAT BOOKING USER
  // ======================
  Stream<QuerySnapshot> getUserBookings(String userId) {
    return db
        .collection("bookings")
        .where("userId", isEqualTo: userId)
        .orderBy("createdAt", descending: true)
        .snapshots();
  }

  // ======================
  // SAVE USER GOOGLE LOGIN
  // ======================
  Future<void> saveUser({
    required String uid,
    required String name,
    required String email,
  }) async {
    try {
      await db.collection("users").doc(uid).set({
        "name": name,
        "email": email,
        "role": "user",
        "createdAt": FieldValue.serverTimestamp(),
      });

      print("✅ User berhasil disimpan");
    } catch (e) {
      print("❌ ERROR User: $e");
    }
  }
}
