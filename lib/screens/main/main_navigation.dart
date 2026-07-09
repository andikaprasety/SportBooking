import 'package:flutter/material.dart';
import '../home/home_screen.dart';
import '../booking/booking_history_screen.dart';
import '../notification/notification_screen.dart';
import '../profile/profile_screen.dart';
import '../../models/notification_model.dart';

class MainNavigation extends StatefulWidget {
  final int initialIndex;
  const MainNavigation({Key? key, this.initialIndex = 0}) : super(key: key);

  @override
  MainNavigationState createState() => MainNavigationState();
}

class MainNavigationState extends State<MainNavigation> {
  late int currentIndex;

  @override
  void initState() {
    super.initState();
    currentIndex = widget.initialIndex;
  }

  List<Widget> get pages => [
    HomeScreen(onNavigate: (i) => setState(() => currentIndex = i)),
    const BookingHistoryScreen(),
    const NotificationScreen(),
    const ProfileScreen(),
  ];

  int get unreadCount =>
      globalNotifications.where((n) => !n.isRead).length;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (i) => setState(() => currentIndex = i),
        selectedItemColor: const Color(0xFF1E6F3D),
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: [
          const BottomNavigationBarItem(
              icon: Icon(Icons.home_filled), label: "Beranda"),
          const BottomNavigationBarItem(
              icon: Icon(Icons.calendar_month), label: "Booking"),
          BottomNavigationBarItem(
            icon: Stack(children: [
              const Icon(Icons.chat_bubble_outline),
              if (unreadCount > 0)
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: const BoxDecoration(
                        color: Colors.red, shape: BoxShape.circle),
                    constraints:
                    const BoxConstraints(minWidth: 14, minHeight: 14),
                    child: Text('$unreadCount',
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 9,
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center),
                  ),
                ),
            ]),
            label: "Notifikasi",
          ),
          const BottomNavigationBarItem(
              icon: Icon(Icons.person_outline), label: "Profil"),
        ],
      ),
    );
  }
}