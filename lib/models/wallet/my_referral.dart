class MyReferral {
  MyReferral({
    this.teamName,
    this.referralAmount = 0,
    this.createdAt,
    this.status = '',
  });

  final String? teamName;
  final double referralAmount;
  final String? createdAt;
  final String status;

  factory MyReferral.fromJson(Map<String, dynamic> json) => MyReferral(
        teamName: json["teamName"],
        referralAmount: json["referralAmount"] != null
            ? double.parse(
                (json["referralAmount"] as num).toDouble().toStringAsFixed(2))
            : 0,
        createdAt: json["createdAt"],
        status: json["status"] != null
            ? (json["status"] as String).toLowerCase()
            : '',
      );
}
