class TransactionHistory {
  TransactionHistory({
    this.description = '',
    this.amount = 0,
    this.transactionType = '',
    this.status = '',
    this.offerCode = '',
    this.createdAt = '',
    this.transactionData,
  });

  final String description;
  final double amount;
  final String transactionType;
  final String status;
  final String offerCode;
  final String createdAt;
  final TransactionData? transactionData;

  factory TransactionHistory.fromJson(Map<String, dynamic> json) =>
      TransactionHistory(
        description: json["description"] ?? '',
        amount: json["amount"] != null
            ? double.parse(
                (json["amount"] as num).toDouble().toStringAsFixed(2))
            : 0,
        transactionType: json["transactionType"] != null
            ? (json["transactionType"] as String).toLowerCase()
            : '',
        status: json["status"] != null
            ? (json["status"] as String).toLowerCase()
            : '',
        offerCode: json["offerCode"] ?? '',
        createdAt: json["createdAt"] ?? '',
        transactionData: json["transactionData"] != null
            ? TransactionData.fromJson(json["transactionData"])
            : null,
      );
}

class TransactionData {
  TransactionData({
    this.id = '',
    this.method = '',
    this.bank = '',
    this.vpa = '',
    this.razorpayOrderId = '',
    this.razorpayPaymentId = '',
    this.razorpayPayoutId = '',
    this.fundAccountId = '',
    this.depositBonus = 0,
    this.cashBonus = 0,
    this.isOfferApplied = false,
  });

  final String id;
  final String method;
  final String bank;
  final String vpa;
  final String razorpayOrderId;
  final String razorpayPaymentId;
  final String razorpayPayoutId;
  final String fundAccountId;
  final double depositBonus;
  final double cashBonus;
  final bool isOfferApplied;

  factory TransactionData.fromJson(Map<String, dynamic> json) =>
      TransactionData(
        id: json["_id"] ?? '',
        method: json["method"] ?? '',
        bank: json["bank"] ?? '',
        vpa: json["vpa"] ?? '',
        razorpayOrderId: json["razorpayOrderId"] ?? '',
        razorpayPaymentId: json["razorpayPaymentId"] ?? '',
        razorpayPayoutId: json["razorpayPayoutId"] ?? '',
        fundAccountId: json["fundAccountId"] ?? '',
        depositBonus: json["depositBonus"] != null
            ? (json["depositBonus"] as num).toDouble()
            : 0,
        cashBonus: json["cashBonus"] != null
            ? (json["cashBonus"] as num).toDouble()
            : 0,
        isOfferApplied: json["isOfferApplied"] ?? false,
      );
}
