class PromoModel {
  final String code;
  final String title;
  final String description;
  final int discountPercent;
  final int maxDiscount;
  final String expiry;
  bool isClaimed;
  bool isUsed;

  PromoModel({
    required this.code,
    required this.title,
    required this.description,
    required this.discountPercent,
    required this.maxDiscount,
    required this.expiry,
    this.isClaimed = false,
    this.isUsed = false,
  });
}

List<PromoModel> globalPromos = [
  // ... data promos
];