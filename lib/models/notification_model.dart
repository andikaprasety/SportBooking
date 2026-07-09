import 'package:flutter/material.dart';

class NotificationModel {
  final String title;
  final String message;
  final String time;
  final IconData icon;
  final Color iconBgColor;
  final Color iconColor;
  bool isRead;

  NotificationModel({
    required this.title,
    required this.message,
    required this.time,
    required this.icon,
    required this.iconBgColor,
    required this.iconColor,
    this.isRead = false,
  });
}

List<NotificationModel> globalNotifications = [
  // ... data notifications
];