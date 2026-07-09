import 'package:flutter/material.dart';
import '../../models/user_model.dart';
import '../../models/booking_model.dart';
import '../../screens/auth/onboarding_screen.dart';
import 'admin_user_detail_screen.dart';

class AdminUserScreen extends StatefulWidget {
  final VoidCallback? onRefresh;
  const AdminUserScreen({Key? key, this.onRefresh}) : super(key: key);

  @override
  AdminUserScreenState createState() => AdminUserScreenState();
}

class AdminUserScreenState extends State<AdminUserScreen> {
  final searchCtrl = TextEditingController();
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    searchCtrl.addListener(
            () => setState(
                () => searchQuery = searchCtrl.text.toLowerCase()));
  }

  @override
  void dispose() {
    searchCtrl.dispose();
    super.dispose();
  }

  List<AppUser> get filtered {
    if (searchQuery.isEmpty) return globalUsers;
    return globalUsers
        .where((u) =>
    u.name.toLowerCase().contains(searchQuery) ||
        u.email.toLowerCase().contains(searchQuery))
        .toList();
  }

  void _toggleUser(AppUser user) {
    setState(() => user.isActive = !user.isActive);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(user.isActive
            ? '${user.name} diaktifkan kembali'
            : '${user.name} disuspend'),
        backgroundColor:
        user.isActive ? const Color(0xFF1E6F3D) : Colors.orange));
  }

  void _deleteUser(AppUser user) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Hapus pengguna?',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
        ),
        content: RichText(
          text: TextSpan(
            style: const TextStyle(
                color: Colors.black87, fontSize: 14, height: 1.5),
            children: [
              const TextSpan(text: 'Akun '),
              TextSpan(
                text: user.name,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const TextSpan(
                text:
                ' akan dihapus permanen.\nData riwayat booking tetap tersimpan.',
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal',
                style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);

              final isCurrentUser = user.email == CurrentUser.email;

              setState(() => globalUsers.remove(user));

              if (isCurrentUser) {
                CurrentUser.clear();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const OnboardingScreen()),
                      (route) => false,
                );
                return;
              }

              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('${user.name} berhasil dihapus'),
                backgroundColor: Colors.red,
              ));

              widget.onRefresh?.call();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text('Ya, Hapus',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final users = filtered;
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text('Kelola User',
            style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 20)),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                  color: const Color(0xFFE8F5E9),
                  borderRadius: BorderRadius.circular(10)),
              child: Text(
                  'Total: ${globalUsers.length} user',
                  style: const TextStyle(
                      color: Color(0xFF1E6F3D),
                      fontWeight: FontWeight.bold,
                      fontSize: 12)),
            ),
          ),
        ],
      ),
      body: Column(children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
          child: TextField(
            controller: searchCtrl,
            decoration: InputDecoration(
              hintText: 'Cari nama atau email user...',
              hintStyle:
              const TextStyle(color: Colors.grey, fontSize: 13),
              prefixIcon:
              const Icon(Icons.search, color: Colors.grey),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(
                  vertical: 0, horizontal: 16),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide:
                  const BorderSide(color: Color(0xFFEEEEEE))),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide:
                  const BorderSide(color: Color(0xFFEEEEEE))),
            ),
          ),
        ),
        Expanded(
          child: users.isEmpty
              ? const Center(
              child: Text('Tidak ada user ditemukan',
                  style: TextStyle(color: Colors.grey)))
              : ListView.builder(
            padding:
            const EdgeInsets.symmetric(horizontal: 16),
            itemCount: users.length,
            itemBuilder: (ctx, i) => _userCard(users[i]),
          ),
        ),
      ]),
    );
  }

  Widget _userCard(AppUser u) {
    return GestureDetector(
      onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => AdminUserDetailScreen(user: u))),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
                color: u.isActive
                    ? const Color(0xFFEEEEEE)
                    : Colors.red.withOpacity(0.2)),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  blurRadius: 6,
                  offset: const Offset(0, 2))
            ]),
        child: Row(children: [
          CircleAvatar(
            radius: 22,
            backgroundColor:
            u.isActive ? const Color(0xFF1E6F3D) : Colors.grey,
            child: Text(
                u.name.isNotEmpty ? u.name[0].toUpperCase() : 'U',
                style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16)),
          ),
          const SizedBox(width: 12),
          Expanded(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(children: [
                      Flexible(
                        child: Text(u.name,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 14)),
                      ),
                      const SizedBox(width: 6),
                      if (!u.isActive)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                              color: Colors.red.shade50,
                              borderRadius: BorderRadius.circular(6)),
                          child: const Text('Nonaktif',
                              style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 9,
                                  fontWeight: FontWeight.bold)),
                        ),
                      if (u.joinDate == 'Hari ini') ...[
                        const SizedBox(width: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                              color: Colors.blue.shade50,
                              borderRadius: BorderRadius.circular(6)),
                          child: const Text('Baru',
                              style: TextStyle(
                                  color: Colors.blue,
                                  fontSize: 9,
                                  fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ]),
                    Text(u.email,
                        style: const TextStyle(
                            color: Colors.grey, fontSize: 11)),
                    const SizedBox(height: 4),
                    Row(children: [
                      const Icon(Icons.phone, size: 11, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(u.phone,
                          style: const TextStyle(
                              color: Colors.grey, fontSize: 11)),
                      const SizedBox(width: 12),
                      const Icon(Icons.calendar_month,
                          size: 11, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text('${u.totalBooking} booking',
                          style: const TextStyle(
                              color: Colors.grey, fontSize: 11)),
                    ]),
                  ])),
          Column(children: [
            Text(u.joinDate,
                style:
                const TextStyle(color: Colors.grey, fontSize: 10)),
            const SizedBox(height: 6),
            Row(children: [
              GestureDetector(
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) =>
                            AdminUserDetailScreen(user: u))),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 5),
                  decoration: BoxDecoration(
                      color: const Color(0xFFE8F5E9),
                      borderRadius: BorderRadius.circular(8)),
                  child: const Text('Detail',
                      style: TextStyle(
                          color: Color(0xFF1E6F3D),
                          fontSize: 10,
                          fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(width: 4),
              GestureDetector(
                onTap: () => _toggleUser(u),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 5),
                  decoration: BoxDecoration(
                      color: u.isActive
                          ? const Color(0xFFFFF3E0)
                          : const Color(0xFFE8F5E9),
                      borderRadius: BorderRadius.circular(8)),
                  child: Text(
                      u.isActive ? 'Suspend' : 'Aktifkan',
                      style: TextStyle(
                          color: u.isActive
                              ? Colors.orange
                              : Colors.green,
                          fontSize: 10,
                          fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(width: 4),
              GestureDetector(
                onTap: () => _deleteUser(u),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 5),
                  decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(8)),
                  child: const Icon(Icons.delete_outline,
                      size: 14, color: Colors.red),
                ),
              ),
            ]),
          ]),
        ]),
      ),
    );
  }
}