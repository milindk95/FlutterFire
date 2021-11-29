import 'package:the_super11/models/models.dart';

class MatchPoint {
  MatchPoint({
    this.fantasy = const [],
    this.teams = const [],
  });

  final List<Fantasy> fantasy;
  final List<TeamDetails> teams;

  factory MatchPoint.fromJson(Map<String, dynamic> json) => MatchPoint(
        fantasy: json["fantasy"] != null
            ? List<Fantasy>.from(
                json["fantasy"].map((x) => Fantasy.fromJson(x)))
            : [],
        teams: json["teams"] != null ? MyMatch.getTeams(json["teams"]) : [],
      );
}

class Fantasy {
  Fantasy({
    this.matchPoints = 0,
    this.seasonPoints = 0,
    this.player,
    this.rank = 0,
    this.breakup = const [],
  });

  final double matchPoints;
  final double seasonPoints;
  final FantasyPlayer? player;
  final int rank;
  final List<Breakup> breakup;

  factory Fantasy.fromJson(Map<String, dynamic> json) => Fantasy(
        matchPoints: json["match_points"] != null
            ? (json["match_points"] as num).toDouble()
            : 0,
        seasonPoints: json["season_points"] != null
            ? (json["season_points"] as num).toDouble()
            : 0,
        player: json["player"] != null
            ? FantasyPlayer.fromJson(json["player"])
            : null,
        rank: json["rank"] ?? 0,
        breakup: json["breakup"] != null
            ? List<Breakup>.from(
                json["breakup"].map((x) => Breakup.fromJson(x)))
            : [],
      );
}

class Breakup {
  Breakup({
    this.metricRuleIndex = 0,
    this.points = 0,
  });

  final int metricRuleIndex;
  final double points;

  factory Breakup.fromJson(Map<String, dynamic> json) => Breakup(
        metricRuleIndex: json["metric_rule_index"] != null
            ? (json["metric_rule_index"] as num).toInt()
            : 0,
        points: json["points"] != null ? (json["points"] as num).toDouble() : 0,
      );
}

class FantasyPlayer {
  FantasyPlayer({
    this.key = '',
    this.name = '',
    this.teamKey = '',
    this.seasonalRole = '',
    this.fullName = '',
  });

  final String key;
  final String name;
  final String teamKey;
  final String seasonalRole;
  final String fullName;

  factory FantasyPlayer.fromJson(Map<String, dynamic> json) => FantasyPlayer(
        key: json["key"] ?? '',
        name: json["name"] ?? '',
        teamKey: json["team_key"] ?? '',
        seasonalRole: json["seasonal_role"] ?? '',
        fullName: json["fullname"] ?? '',
      );
}
