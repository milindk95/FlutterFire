class Contest {
  Contest({
    this.winningPrizes = const [],
    this.contestType = '',
    this.isCancelled = false,
    this.cancelReason = '',
    this.id = '',
    this.noOfEntry = 0,
    this.maxNoOfWinner = 0,
    this.winningAmount = 0,
    this.bonusPerEntry = 0,
    this.maxEntryPerUser = 0,
    this.contestParticipants = 0,
    this.feePerEntry = 0,
    this.matchStatus = '',
    this.ranks,
    this.isAbleToJoin = false,
    this.notAbleToJoinMessage = '',
    this.isPrivate = false,
    this.createdBy = '',
    this.referralCode = '',
  });

  final List<WinningPrize> winningPrizes;
  final String contestType;
  final bool isCancelled;
  final String cancelReason;
  final String id;
  final int noOfEntry;
  final int maxNoOfWinner;
  final double winningAmount;
  final int bonusPerEntry;
  final int maxEntryPerUser;
  final int contestParticipants;
  final double feePerEntry;
  final String matchStatus;
  final List<ContestRank>? ranks;
  final bool isAbleToJoin;
  final String notAbleToJoinMessage;
  final bool isPrivate;
  final String createdBy;
  final String referralCode;

  factory Contest.fromJson(Map<String, dynamic> json) => Contest(
        winningPrizes: json["winningPrizes"] != null
            ? List<WinningPrize>.from(
                json["winningPrizes"].map((x) => WinningPrize.fromJson(x)))
            : [],
        contestType: json["contestType"] != null
            ? (json["contestType"] as String).toLowerCase()
            : '',
        isCancelled: json["isCancelled"] ?? false,
        cancelReason: json['cancelReason'] ?? '',
        id: json["_id"] ?? '',
        noOfEntry: json["noOfEntry"] ?? 0,
        maxNoOfWinner: json["maxNoOfWinner"] ?? 0,
        winningAmount: json["winningAmount"] != null
            ? (json["winningAmount"] as num).toDouble()
            : 0,
        bonusPerEntry: json["bonusPerEntry"] ?? 0,
        maxEntryPerUser: json["maxEntryPerUser"] ?? 0,
        contestParticipants:
            _contestParticipantLength(json["contestParticipations"]),
        feePerEntry: json["feePerEntry"] != null
            ? double.parse(
                (json["feePerEntry"] as num).toDouble().toStringAsFixed(2))
            : 0,
        matchStatus: json['matchStatus'] ?? '',
        ranks: json["contestParticipationsRankList"] != null
            ? List<ContestRank>.from(json["contestParticipationsRankList"]
                .map((x) => ContestRank.fromJson(x)))
            : null,
        isAbleToJoin: json['isAbletoJoin'] ?? false,
        notAbleToJoinMessage: json['notAbletoJoinMessage'] ?? '',
        isPrivate: json["isPrivate"] ?? false,
        createdBy: json["createdBy"] ?? '',
        referralCode: json["referralCode"] ?? '',
      );

  static int _contestParticipantLength(dynamic value) {
    if (value is int)
      return value;
    else if (value is List) return value.length;
    return 0;
  }
}

class ContestRank {
  ContestRank({
    this.rank = 0,
    this.winAmount = 0,
    this.team,
  });

  final int rank;
  final double winAmount;
  final ContestTeam? team;

  factory ContestRank.fromJson(Map<String, dynamic> json) => ContestRank(
        rank: json["rank"] ?? 0,
        winAmount: json["winAmount"] != null
            ? (json["winAmount"] as num).toDouble()
            : 0,
        team: json["team"] != null ? ContestTeam.fromJson(json["team"]) : null,
      );
}

class ContestTeam {
  ContestTeam({
    this.teamName = '',
    this.totalPoints = 0,
  });

  final String teamName;
  final double totalPoints;

  factory ContestTeam.fromJson(Map<String, dynamic> json) => ContestTeam(
        teamName: json["teamName"] ?? '',
        totalPoints: json["totalPoints"] != null
            ? (json["totalPoints"] as num).toDouble()
            : 0,
      );
}

class WinningPrize {
  WinningPrize({
    this.startRank = 0,
    this.endRank = 0,
    this.totalRank = 0,
    this.winningPercent = 0,
    this.winningAmount = 0,
  });

  final int startRank;
  final int endRank;
  final int totalRank;
  final double winningPercent;
  final double winningAmount;

  factory WinningPrize.fromJson(Map<String, dynamic> json) => WinningPrize(
        startRank: json["startRank"] ?? 0,
        endRank: json["endRank"] ?? 0,
        totalRank: json["totalRank"] ?? 0,
        winningPercent: json["winningPercent"] != null
            ? (json["winningPercent"] as num).toDouble()
            : 0,
        winningAmount: json["winningAmount"] != null
            ? double.parse(
                (json["winningAmount"] as num).toDouble().toStringAsFixed(2))
            : 0,
      );

  WinningPrize copyWith({
    int? startRank,
    int? endRank,
    int? totalRank,
    double? winningPercent,
    double? winningAmount,
  }) {
    if ((startRank == null || identical(startRank, this.startRank)) &&
        (endRank == null || identical(endRank, this.endRank)) &&
        (totalRank == null || identical(totalRank, this.totalRank)) &&
        (winningPercent == null ||
            identical(winningPercent, this.winningPercent)) &&
        (winningAmount == null ||
            identical(winningAmount, this.winningAmount))) {
      return this;
    }

    return WinningPrize(
      startRank: startRank ?? this.startRank,
      endRank: endRank ?? this.endRank,
      totalRank: totalRank ?? this.totalRank,
      winningPercent: winningPercent ?? this.winningPercent,
      winningAmount: winningAmount ?? this.winningAmount,
    );
  }

  Map<String, dynamic> toJson() => {
        "startRank": startRank,
        "endRank": endRank,
        "winningAmount": winningAmount
      };
}
