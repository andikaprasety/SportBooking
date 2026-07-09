import 'package:flutter/material.dart';

class BookingModel {
  final String venueName;
  final String type;
  final String date;
  final String time;
  final String price;
  final String code;
  String status;
  final IconData icon;
  final String userName;
  final String userEmail;

  BookingModel({
    required this.venueName,
    required this.type,
    required this.date,
    required this.time,
    required this.price,
    required this.code,
    required this.status,
    required this.icon,
    this.userName = '',
    this.userEmail = '',
  });
}

List<BookingModel> globalBookingHistory = [
  // ... data bookings
];