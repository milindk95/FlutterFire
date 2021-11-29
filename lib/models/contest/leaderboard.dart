import 'package:the_super11/core/extensions.dart';

class Leaderboard {
  Leaderboard({
    this.participants = const [],
    this.totalContestParticipants = 0,
  });

  final List<ContestParticipation> participants;
  final int totalContestParticipants;

  factory Leaderboard.fromJson(Map<String, dynamic> json) => Leaderboard(
        participants: json["contestParticipations"] != null
            ? List<ContestParticipation>.from(json["contestParticipations"]
                .map((x) => ContestParticipation.fromJson(x)))
            : [],
        totalContestParticipants: json["totalParticipations"] ?? 0,
      );
}

class ContestParticipation {
  ContestParticipation({
    this.rank = 0,
    this.id = '',
    this.team,
    this.user = '',
  });

  final int rank;
  final String id;
  final LeaderboardTeam? team;
  final String user;

  factory ContestParticipation.fromJson(Map<String, dynamic> json) =>
      ContestParticipation(
        rank: json["rank"] ?? 0,
        id: json["_id"] ?? '',
        team: json["team"] != null
            ? LeaderboardTeam.fromJson(json["team"])
            : null,
        user: json["user"] ?? '',
      );
}

class LeaderboardTeam {
  LeaderboardTeam({
    this.teamName = '',
    this.totalPoints = 0,
    this.id = '',
  });

  final String teamName;
  final double totalPoints;
  final String id;

  factory LeaderboardTeam.fromJson(Map<String, dynamic> json) =>
      LeaderboardTeam(
        teamName: json["teamName"] != null
            ? (json["teamName"] as String).capitalize
            : '',
        totalPoints: json["totalPoints"] != null
            ? (json["totalPoints"] as num).toDouble()
            : 0,
        id: json["_id"] ?? '',
      );
}
