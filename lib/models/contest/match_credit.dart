import 'package:the_super11/models/models.dart';

class MatchCredit {
  MatchCredit({
    this.fantasyPoints = const [],
    this.teamDetails = const [],
    this.finalPlayers = const [],
  });

  final List<FantasyPoint> fantasyPoints;
  final List<TeamDetails> teamDetails;
  final List<String> finalPlayers;

  factory MatchCredit.fromJson(Map<String, dynamic> json) => MatchCredit(
        finalPlayers: json["finalPlayers"] is Map<String, dynamic>
            ? getFinalPlayers(json["finalPlayers"])
            : [],
        fantasyPoints: json["fantasyPoints"] is List
            ? List<FantasyPoint>.from(
                json["fantasyPoints"].map((x) => FantasyPoint.fromJson(x)))
            : [],
        teamDetails:
            json["teams"] != null ? MyMatch.getTeams(json["teams"]) : [],
      );

  static List<String> getFinalPlayers(Map<String, dynamic> json) {
    final finalPlayers = <String>[];
    json.forEach((key, value) {
      if (value is List<dynamic>) finalPlayers.addAll(value.cast());
    });
    return finalPlayers;
  }
}

class FantasyPoint {
  FantasyPoint({
    this.creditValue = 0,
    this.player,
    this.seasonPoints = 0,
  });

  final double creditValue;
  final Player? player;
  final double seasonPoints;

  factory FantasyPoint.fromJson(Map<String, dynamic> json) => FantasyPoint(
        creditValue: json["credit_value"] != null
            ? (json["credit_value"] as num).toDouble()
            : 0,
        player: json["player"] != null ? Player.fromJson(json["player"]) : null,
        seasonPoints: json["season_points"] != null
            ? (json["season_points"] as num).toDouble()
            : 0,
      );
}
