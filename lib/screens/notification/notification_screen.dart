import 'package:flutter/material.dart';
import '../../models/notification_model.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  NotificationScreenState createState() => NotificationScreenState();
}

class NotificationScreenState extends State<NotificationScreen> {
  void markAllRead() => setState(() {
    for (var n in globalNotifications) {
      n.isRead = true;
    }
  });
  void markOneRead(int i) =>
      setState(() => globalNotifications[i].isRead = true);
  void deleteNotif(int i) =>
      setState(() => globalNotifications.removeAt(i));

  @override
  Widget build(BuildContext context) {
    final hasUnread = globalNotifications.any((n) => !n.isRead);
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text("Notifikasi",
            style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 22)),
        actions: [
          if (hasUnread)
            TextButton(
                onPressed: markAllRead,
                child: const Text("Tandai semua dibaca",
                    style: TextStyle(
                        color: Color(0xFF1E6F3D),
                        fontWeight: FontWeight.w600,
                        fontSize: 13))),
        ],
      ),
      body: globalNotifications.isEmpty
          ? Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                        padding: const EdgeInsets.all(28),
                        decoration: const BoxDecoration(
                            color: Color(0xFFF1F8F4), shape: BoxShape.circle),
                        child: const Icon(Icons.notifications_none_rounded,
                            size: 60, color: Color(0xFF1E6F3D))),
                    const SizedBox(height: 20),
                    const Text("Belum ada notifikasi",
                        style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    const Text(
                        "Notifikasi booking dan promo\nakan muncul di sini",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey, fontSize: 14)),
                  ]))
          : ListView.separated(
        padding: const EdgeInsets.symmetric(
            horizontal: 16, vertical: 12),
        itemCount: globalNotifications.length,
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemBuilder: (context, i) {
          final n = globalNotifications[i];
          return Dismissible(
            key: UniqueKey(),
            direction: DismissDirection.endToStart,
            background: Container(
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.only(right: 20),
                decoration: BoxDecoration(
                    color: Colors.red.shade400,
                    borderRadius: BorderRadius.circular(16)),
                child: const Icon(Icons.delete_outline,
                    color: Colors.white, size: 28)),
            onDismissed: (_) => deleteNotif(i),
            child: GestureDetector(
              onTap: () => markOneRead(i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: n.isRead
                      ? Colors.white
                      : const Color(0xFFF0FBF5),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                      color: n.isRead
                          ? const Color(0xFFEEEEEE)
                          : const Color(0xFFB2DFDB),
                      width: n.isRead ? 1 : 1.5),
                  boxShadow: n.isRead
                      ? []
                      : [
                    BoxShadow(
                        color:
                        Colors.green.withOpacity(0.07),
                        blurRadius: 8,
                        offset: const Offset(0, 2))
                  ],
                ),
                child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                          width: 46,
                          height: 46,
                          decoration: BoxDecoration(
                              color: n.iconBgColor,
                              shape: BoxShape.circle),
                          child: Icon(n.icon,
                              color: n.iconColor, size: 22)),
                      const SizedBox(width: 14),
                      Expanded(
                          child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                Row(children: [
                                  Expanded(
                                      child: Text(n.title,
                                          style: TextStyle(
                                              fontWeight: n.isRead
                                                  ? FontWeight.w600
                                                  : FontWeight.bold,
                                              fontSize: 14,
                                              color: Colors.black87))),
                                  if (!n.isRead)
                                    Container(
                                        width: 8,
                                        height: 8,
                                        decoration: const BoxDecoration(
                                            color: Color(0xFF1E6F3D),
                                            shape: BoxShape.circle)),
                                ]),
                                const SizedBox(height: 4),
                                Text(n.message,
                                    style: const TextStyle(
                                        color: Colors.black54,
                                        fontSize: 13,
                                        height: 1.4)),
                                const SizedBox(height: 6),
                                Text(n.time,
                                    style: const TextStyle(
                                        color: Colors.grey,
                                        fontSize: 11)),
                              ])),
                    ]),
              ),
            ),
          );
        },
      ),
    );
  }
}