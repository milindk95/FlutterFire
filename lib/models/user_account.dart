class UserAccount {
  UserAccount({
    this.holderName = '',
    this.accountNumber = '',
    this.bankName = '',
    this.ifscCode = '',
    this.upiMobileNumber = '',
    this.upiId = '',
    this.documentType = '',
    this.isValid = false,
    this.status = '',
  });

  final String holderName;
  final String accountNumber;
  final String bankName;
  final String ifscCode;
  final String upiMobileNumber;
  final String upiId;
  final String documentType;
  final bool isValid;
  final String status;

  factory UserAccount.fromJson(Map<String, dynamic> json) => UserAccount(
        holderName: json["holderName"] ?? '',
        accountNumber: json["accountNumber"] ?? '',
        bankName: json["bankName"] ?? '',
        ifscCode: json["ifscCode"] ?? '',
        upiMobileNumber: json["upiMobileNumber"] ?? '',
        upiId: json["upiId"] ?? '',
        documentType: json["documentType"] ?? '',
        isValid: json["isValid"] ?? false,
        status: json["status"] ?? '',
      );
}
