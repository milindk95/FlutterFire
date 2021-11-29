class Coupon {
  Coupon({
    this.offerId = '',
    this.depositBonus = 0,
    this.cashBonus = 0,
  });

  final String offerId;
  final double depositBonus;
  final double cashBonus;

  factory Coupon.fromJson(Map<String, dynamic> json) => Coupon(
        offerId: json["offerId"] ?? '',
        depositBonus: json["depositBonus"] != null
            ? (json["depositBonus"] as num).toDouble()
            : 0,
        cashBonus: json["cashBonus"] != null
            ? (json["cashBonus"] as num).toDouble()
            : 0,
      );
}
