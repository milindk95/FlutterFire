class Account {
  Account({
    this.bankName,
    this.bankAcNumber,
    this.bankIfsc,
    this.bankAcHolderName,
    this.upiMobileNumber,
    this.upiId,
    this.isDefault = false,
    this.id,
    this.mode,
  });

  final String? bankName;
  final String? bankAcNumber;
  final String? bankIfsc;
  final String? bankAcHolderName;
  final String? upiMobileNumber;
  final String? upiId;
  final bool isDefault;
  final String? id;
  final String? mode;

  factory Account.fromJson(Map<String, dynamic> json) => Account(
    bankName: json["bankName"],
    bankAcNumber: json["bankAcNumber"],
    bankIfsc: json["bankIFSC"],
    bankAcHolderName: json["bankAcHolderName"],
    upiMobileNumber: json["upiMobileNumber"],
    upiId: json["upiId"],
    isDefault: json["isDefault"] ?? false,
    id: json["_id"],
    mode: json["mode"],
  );

  Map<String, dynamic> toJson() => {
    "bankName": bankName,
    "bankAcNumber": bankAcNumber,
    "bankIFSC": bankIfsc,
    "bankAcHolderName": bankAcHolderName,
    "upiMobileNumber": upiMobileNumber,
    "upiId": upiId,
    "isDefault": isDefault,
    "_id": id,
    "mode": mode,
  };
}
