import 'package:flutter/material.dart';
import '../models/venue_model.dart';

List<VenueModel> venues = [
  VenueModel(
    name: "Futsal Arena",
    type: "Futsal",
    distance: "1.2 km",
    distanceValue: 1.2,
    address: "Jakarta Selatan",
    rating: "4.8",
    status: "Buka",
    closingTime: "Tutup 23.00",
    icon: Icons.sports_soccer,
    isIndoor: true,
    hasParking: true,
    pricePerHour: 100000,
  ),
  VenueModel(
    name: "Badminton Hall",
    type: "Badminton",
    distance: "2.5 km",
    distanceValue: 2.5,
    address: "Bandung",
    rating: "4.6",
    status: "Buka",
    closingTime: "Tutup 22.00",
    icon: Icons.sports_tennis,
    isIndoor: false,
    hasParking: true,
    pricePerHour: 80000,
  ),
];
