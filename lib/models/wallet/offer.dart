class Offer {
  Offer({
    this.title = '',
    this.description = '',
    this.offerCode = '',
    this.offerImage = '',
    this.endDateTime = '',
    this.offerType = '',
    this.depositBonus = 0,
    this.minimumDeposit = 0,
    this.cashBonus = 0,
  });

  final String title;
  final String description;
  final String offerCode;
  final String offerImage;
  final String endDateTime;
  final String offerType;
  final double depositBonus;
  final double minimumDeposit;
  final double cashBonus;

  factory Offer.fromJson(Map<String, dynamic> json) => Offer(
        title: json["title"] ?? '',
        description: json["description"] ?? '',
        offerCode: json["offerCode"] ?? '',
        offerImage: json["offerImage"]?["url"] ?? '',
        endDateTime: json["endDateTime"] ?? '',
        offerType: json["offerType"] ?? '',
        depositBonus: json["depositBonus"] != null
            ? (json["depositBonus"] as num).toDouble()
            : 0,
        minimumDeposit: json["minimumDeposit"] != null
            ? (json["minimumDeposit"] as num).toDouble()
            : 0,
        cashBonus: json["cashBonus"] != null
            ? (json["cashBonus"] as num).toDouble()
            : 0,
      );
}
