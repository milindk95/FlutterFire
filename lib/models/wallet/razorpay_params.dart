class RazorpayParams {
  RazorpayParams({
    this.id = '',
    this.currency = '',
    this.amount = '0',
    this.apiKey = '',
  });

  final String id;
  final String currency;
  final String amount;
  final String apiKey;

  factory RazorpayParams.fromJson(Map<String, dynamic> json) => RazorpayParams(
        id: json["id"] ?? '',
        currency: json["currency"],
        amount: json["amount"] ?? '0',
        apiKey: json["apiKey"] ?? '',
      );
}
