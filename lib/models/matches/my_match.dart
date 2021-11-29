import 'package:the_super11/core/extensions.dart';

class MyMatch {
  MyMatch({
    this.season,
    this.shortName = '',
    this.startDate = '',
    this.format = '',
    this.venue = '',
    this.status = '',
    this.statusOverview = '',
    this.contests = 0,
    this.isCancelled = false,
    this.cancelReason = '',
    this.id = '',
    this.teams = const [],
    this.totalMyTeams = 0,
    this.totalMyContest = 0,
    this.totalWinningAmount = 0,
    this.totalRefundAmount = 0,
  });

  final Season? season;
  final String shortName;
  final String startDate;
  final String format;
  final String venue;
  final String status;
  final String statusOverview;
  final int contests;
  final bool isCancelled;
  final String cancelReason;
  final String id;
  final List<TeamDetails> teams;
  final int totalMyTeams;
  final int totalMyContest;
  final num totalWinningAmount;
  final num totalRefundAmount;

  factory MyMatch.fromJson(Map<String, dynamic> json) => MyMatch(
        season: json["season"] != null ? Season.fromJson(json["season"]) : null,
        shortName: json["shortName"] ?? '',
        startDate: json["startDate"] ?? '',
        format:
            json["format"] != null ? (json["format"] as String).capitalize : '',
        venue: json["venue"] ?? '',
        status: json["status"] != null
            ? (json["status"] as String).toLowerCase()
            : '',
        statusOverview: json["statusOverview"] != null
            ? (json["statusOverview"] as String).toLowerCase()
            : '',
        contests: json["contests"] ?? 0,
        isCancelled: json["isCancelled"] ?? false,
        cancelReason: json["cancelReason"] ?? '',
        id: json["_id"] ?? '',
        teams: json["teams"] != null ? getTeams(json["teams"]) : [],
        totalMyTeams: json["totalMyTeams"] ?? 0,
        totalMyContest: json["totalMyContest"] ?? 0,
        totalWinningAmount: json["totalWinningAmount"] ?? 0,
        totalRefundAmount: json["totalRefundAmount"] ?? 0,
      );

  static List<TeamDetails> getTeams(Map<String, dynamic> json) {
    final teams = <TeamDetails>[];
    json.forEach((key, value) {
      teams.add(TeamDetails.fromJson(value as Map<String, dynamic>));
    });
    return teams;
  }
}

class Season {
  Season({
    this.key,
    this.name,
    this.cardName,
  });

  final String? key;
  final String? name;
  final String? cardName;

  factory Season.fromJson(Map<String, dynamic> json) => Season(
        key: json["key"],
        name: json["name"],
        cardName: json["cardName"],
      );
}

class TeamDetails {
  TeamDetails({
    this.key = '',
    this.name = '',
    this.shortName = '',
    this.color = '',
    this.image = '',
  });

  final String key;
  final String name;
  final String shortName;
  final String color;
  final String image;

  factory TeamDetails.fromJson(Map<String, dynamic> json) => TeamDetails(
        key: json["key"] ?? '',
        name: json["name"] ?? '',
        shortName: json["shortName"] ?? json['short_name'] ?? '',
        color: json["color"] ?? '',
        image: json["image"] ?? '',
      );
}
