import 'package:flutter/material.dart';

class VenueModel {
  final String name;
  final String type;
  final String distance;
  final double distanceValue;
  final String address;
  String rating;
  String status;
  String? closingTime;
  final IconData icon;
  final bool isIndoor;
  final bool hasParking;
  int pricePerHour;

  VenueModel({
    required this.name,
    required this.type,
    required this.distance,
    required this.distanceValue,
    required this.address,
    required this.rating,
    required this.status,
    this.closingTime,
    required this.icon,
    required this.isIndoor,
    required this.hasParking,
    required this.pricePerHour,
  });
}

List<VenueModel> allVenues = [
  VenueModel(
    name: 'Arena Futsal Pekanbaru',
    type: 'Futsal',
    distance: '0.8 km',
    distanceValue: 0.8,
    address: 'Jl. Amal No.5',
    rating: '4.5',
    status: 'Buka',
    closingTime: 'Tutup 23.00',
    icon: Icons.sports_soccer,
    isIndoor: true,
    hasParking: true,
    pricePerHour: 80000,
  ),
  VenueModel(
    name: 'Mekar Badminton Center',
    type: 'Badminton',
    distance: '1.5 km',
    distanceValue: 1.5,
    address: 'Jl. Melati No.3',
    rating: '4.6',
    status: 'Buka',
    closingTime: 'Tutup 22.00',
    icon: Icons.sports_tennis,
    isIndoor: true,
    hasParking: false,
    pricePerHour: 50000,
  ),
  // Tambahkan venue lainnya sesuai kebutuhan
];