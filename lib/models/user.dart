import 'package:flutter_fire/core/extensions.dart';

class User {
  User({
    this.name = '',
    this.teamName = '',
    this.mobile = '',
    this.avatar = '',
    this.birthDate = '',
    this.gender = '',
    this.address = '',
    this.city = '',
    this.state = '',
    this.zip = '',
    this.userReferralCode = '',
    this.referredBy = '',
    this.referralAmount = 0,
    this.role = '',
    this.panCard,
    this.razorpayContactId = '',
    this.payFundAccounts = const [],
    this.realAmount = 0,
    this.redeemAmount = 0,
    this.winningAmount = 0,
    this.totalContestWin = 0,
    this.totalContestParticipant = 0,
    this.totalMatches = 0,
    this.totalSeries = 0,
    this.userLevel = 0,
    this.validEmail = false,
    this.validMobile = false,
    this.isAffiliate = false,
    this.affiliateCommission = 0,
    this.id = '',
    this.email = '',
    this.panCardStatus = '',
  });

  final String name;
  final String teamName;
  final String mobile;
  final String avatar;
  final String birthDate;
  final String gender;
  final String address;
  final String city;
  final String state;
  final String zip;
  final String userReferralCode;
  final String referredBy;
  final double referralAmount;
  final String role;
  final PanCard? panCard;
  final String razorpayContactId;
  final List<String> payFundAccounts;
  final double realAmount;
  final double redeemAmount;
  final double winningAmount;
  final int totalContestWin;
  final int totalContestParticipant;
  final int totalMatches;
  final int totalSeries;
  final int userLevel;
  final bool validEmail;
  final bool validMobile;
  final bool isAffiliate;
  final int affiliateCommission;
  final String id;
  final String email;
  final String panCardStatus;

  factory User.fromJson(Map<String, dynamic> json) => User(
        name: json["name"] ?? '',
        teamName: json["teamName"] ?? '',
        mobile: json["mobile"] ?? '',
        avatar: json["avatar"] ?? '',
        birthDate: json["birthDate"] ?? '',
        gender:
            json["gender"] != null ? (json["gender"] as String).capitalize : '',
        address: json["address"] ?? '',
        city: json["city"] ?? '',
        state: json["state"] ?? '',
        zip: json["zip"] ?? '',
        userReferralCode: json["userReferralCode"] ?? '',
        referredBy: json["referredBy"] ?? '',
        referralAmount: json["referralAmount"] != null
            ? double.parse(
                (json["referralAmount"] as num).toDouble().toStringAsFixed(2))
            : 0,
        role: json["role"] ?? '',
        panCard: json["validPancard"] != null
            ? PanCard.fromJson(json["validPancard"])
            : null,
        razorpayContactId: json["razorpayContactId"] ?? '',
        payFundAccounts: json["payFundAccounts"] != null &&
                (json["payFundAccounts"] as List).isNotEmpty
            ? List<String>.from(json["payFundAccounts"].map((x) => x))
            : [],
        realAmount: json["realAmount"] != null
            ? double.parse(
                (json["realAmount"] as num).toDouble().toStringAsFixed(2))
            : 0,
        redeemAmount: json["redeemAmount"] != null
            ? double.parse(
                (json["redeemAmount"] as num).toDouble().toStringAsFixed(2))
            : 0,
        winningAmount: json["winningAmount"] != null
            ? double.parse(
                (json["winningAmount"] as num).toDouble().toStringAsFixed(2))
            : 0,
        totalContestWin: json["totalContestWin"] ?? 0,
        totalContestParticipant: json["totalContestParticipant"] ?? 0,
        totalMatches: json["totalMatches"] ?? 0,
        totalSeries: json["totalSeries"] ?? 0,
        userLevel: json["userLevel"] ?? 0,
        validEmail: json["validEmail"] ?? false,
        validMobile: json["validMobile"] ?? false,
        isAffiliate: json["isAffiliate"] ?? false,
        affiliateCommission: json["affiliateCommission"] ?? 0,
        id: json["_id"] ?? 0,
        email: json["email"] ?? '',
        panCardStatus: json["pancardStatus"] != null
            ? json["pancardStatus"].toString().toLowerCase()
            : '',
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "teamName": teamName,
        "mobile": mobile,
        "avatar": avatar,
        "birthDate": birthDate,
        "gender": gender,
        "address": address,
        "city": city,
        "state": state,
        "zip": zip,
        "userReferralCode": userReferralCode,
        "referredBy": referredBy,
        "referralAmount": referralAmount,
        "role": role,
        "validPancard": panCard?.toJson(),
        "razorpayContactId": razorpayContactId,
        "payFundAccounts": payFundAccounts.isNotEmpty
            ? List<String>.from(payFundAccounts.map((x) => x))
            : [],
        "realAmount": realAmount,
        "redeemAmount": redeemAmount,
        "winningAmount": winningAmount,
        "totalContestWin": totalContestWin,
        "totalContestParticipant": totalContestParticipant,
        "totalMatches": totalMatches,
        "totalSeries": totalSeries,
        "userLevel": userLevel,
        "validEmail": validEmail,
        "validMobile": validMobile,
        "isAffiliate": isAffiliate,
        "affiliateCommission": affiliateCommission,
        "_id": id,
        "email": email,
        "pancardStatus": panCardStatus,
      };

  double get totalAmount =>
      double.parse((this.redeemAmount + this.realAmount + this.winningAmount)
          .toStringAsFixed(2));

  User copyWith({
    String? name,
    String? teamName,
    String? mobile,
    String? avatar,
    String? birthDate,
    String? gender,
    String? address,
    String? city,
    String? state,
    String? zip,
    String? userReferralCode,
    String? referredBy,
    double? referralAmount,
    String? role,
    PanCard? panCard,
    String? razorpayContactId,
    List<String>? payFundAccounts,
    double? realAmount,
    double? redeemAmount,
    double? winningAmount,
    int? totalContestWin,
    int? totalContestParticipant,
    int? totalMatches,
    int? totalSeries,
    int? userLevel,
    bool? validEmail,
    bool? validMobile,
    bool? isAffiliate,
    int? affiliateCommission,
    String? id,
    String? email,
    String? panCardStatus,
  }) {
    if ((name == null || identical(name, this.name)) &&
        (teamName == null || identical(teamName, this.teamName)) &&
        (mobile == null || identical(mobile, this.mobile)) &&
        (avatar == null || identical(avatar, this.avatar)) &&
        (birthDate == null || identical(birthDate, this.birthDate)) &&
        (gender == null || identical(gender, this.gender)) &&
        (address == null || identical(address, this.address)) &&
        (city == null || identical(city, this.city)) &&
        (state == null || identical(state, this.state)) &&
        (zip == null || identical(zip, this.zip)) &&
        (userReferralCode == null ||
            identical(userReferralCode, this.userReferralCode)) &&
        (referredBy == null || identical(referredBy, this.referredBy)) &&
        (referralAmount == null ||
            identical(referralAmount, this.referralAmount)) &&
        (role == null || identical(role, this.role)) &&
        (panCard == null || identical(panCard, this.panCard)) &&
        (razorpayContactId == null ||
            identical(razorpayContactId, this.razorpayContactId)) &&
        (payFundAccounts == null ||
            identical(payFundAccounts, this.payFundAccounts)) &&
        (realAmount == null || identical(realAmount, this.realAmount)) &&
        (redeemAmount == null || identical(redeemAmount, this.redeemAmount)) &&
        (winningAmount == null ||
            identical(winningAmount, this.winningAmount)) &&
        (totalContestWin == null ||
            identical(totalContestWin, this.totalContestWin)) &&
        (totalContestParticipant == null ||
            identical(totalContestParticipant, this.totalContestParticipant)) &&
        (totalMatches == null || identical(totalMatches, this.totalMatches)) &&
        (totalSeries == null || identical(totalSeries, this.totalSeries)) &&
        (userLevel == null || identical(userLevel, this.userLevel)) &&
        (validEmail == null || identical(validEmail, this.validEmail)) &&
        (validMobile == null || identical(validMobile, this.validMobile)) &&
        (isAffiliate == null || identical(isAffiliate, this.isAffiliate)) &&
        (affiliateCommission == null ||
            identical(affiliateCommission, this.affiliateCommission)) &&
        (id == null || identical(id, this.id)) &&
        (email == null || identical(email, this.email)) &&
        (panCardStatus == null ||
            identical(panCardStatus, this.panCardStatus))) {
      return this;
    }

    return User(
      name: name ?? this.name,
      teamName: teamName ?? this.teamName,
      mobile: mobile ?? this.mobile,
      avatar: avatar ?? this.avatar,
      birthDate: birthDate ?? this.birthDate,
      gender: gender ?? this.gender,
      address: address ?? this.address,
      city: city ?? this.city,
      state: state ?? this.state,
      zip: zip ?? this.zip,
      userReferralCode: userReferralCode ?? this.userReferralCode,
      referredBy: referredBy ?? this.referredBy,
      referralAmount: referralAmount ?? this.referralAmount,
      role: role ?? this.role,
      panCard: panCard ?? this.panCard,
      razorpayContactId: razorpayContactId ?? this.razorpayContactId,
      payFundAccounts: payFundAccounts ?? this.payFundAccounts,
      realAmount: realAmount ?? this.realAmount,
      redeemAmount: redeemAmount ?? this.redeemAmount,
      winningAmount: winningAmount ?? this.winningAmount,
      totalContestWin: totalContestWin ?? this.totalContestWin,
      totalContestParticipant:
          totalContestParticipant ?? this.totalContestParticipant,
      totalMatches: totalMatches ?? this.totalMatches,
      totalSeries: totalSeries ?? this.totalSeries,
      userLevel: userLevel ?? this.userLevel,
      validEmail: validEmail ?? this.validEmail,
      validMobile: validMobile ?? this.validMobile,
      isAffiliate: isAffiliate ?? this.isAffiliate,
      affiliateCommission: affiliateCommission ?? this.affiliateCommission,
      id: id ?? this.id,
      email: email ?? this.email,
      panCardStatus: panCardStatus ?? this.panCardStatus,
    );
  }
}

class PanCard {
  PanCard({
    this.panCardImage = '',
    this.panCardUsername = '',
    this.panCardNumber = '',
    this.id = '',
  });

  final String panCardImage;
  final String panCardUsername;
  final String panCardNumber;
  final String id;

  factory PanCard.fromJson(Map<String, dynamic> json) => PanCard(
        panCardImage: json["panCardImage"] ?? '',
        panCardUsername: json["panCardUsername"] ?? '',
        panCardNumber: json["panCardNumber"] ?? '',
        id: json["_id"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "panCardImage": panCardImage,
        "panCardUsername": panCardUsername,
        "panCardNumber": panCardNumber,
        "_id": id,
      };
}
