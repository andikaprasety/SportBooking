class CurrentUser {
  static String name = '';
  static String email = '';
  static String phone = '';
  static String address = '';
  static String gender = '';
  static String birthDate = '';
  static String joinDate = '';

  static String get initials {
    if (name.isEmpty) return '?';
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name[0].toUpperCase();
  }

  static void clear() {
    name = '';
    email = '';
    phone = '';
    address = '';
    gender = '';
    birthDate = '';
    joinDate = '';
  }
}

class AppUser {
  final String id;
  String name;
  String email;
  String phone;
  String password;
  int totalBooking;
  String joinDate;
  bool isActive;
  double rating;
  int totalSpend;
  String city;
  String lastLogin;

  AppUser({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.password,
    required this.totalBooking,
    required this.joinDate,
    this.isActive = true,
    this.rating = 4.5,
    this.totalSpend = 0,
    this.city = 'Pekanbaru',
    this.lastLogin = 'Hari ini',
  });
}

List<AppUser> globalUsers = [
  // ... data users
];