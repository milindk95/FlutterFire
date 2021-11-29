import 'package:equatable/equatable.dart';
import 'package:flutter_fire/core/extensions.dart';
import 'package:flutter_fire/models/models.dart';

class MyTeam {
  MyTeam({
    this.maxTeamAllow = 0,
    this.teams = const [],
    this.teamDetails = const [],
  });

  final int maxTeamAllow;
  final List<Team> teams;
  final List<TeamDetails> teamDetails;

  factory MyTeam.fromJson(Map<String, dynamic> json) => MyTeam(
        maxTeamAllow: json["maxTeamAllow"] ?? 0,
        teams: json["teams"] != null
            ? List<Team>.from(json["teams"].map((x) => Team.fromJson(x)))
            : [],
        teamDetails:
            json["matchCredit"] != null && json["matchCredit"]["teams"] != null
                ? MyMatch.getTeams(json["matchCredit"]["teams"])
                : [],
      );
}

class Team {
  Team({
    this.contest = const [],
    this.teamName = '',
    this.captain = const [''],
    this.viceCaptain = const [''],
    this.wicketKeepers = const [],
    this.batsmen = const [],
    this.allRounders = const [],
    this.bowlers = const [],
    this.totalPoints = 0,
    this.id = '',
  });

  final List<String> contest;
  final String teamName;
  final List<String> captain;
  final List<String> viceCaptain;
  final List<PlayerInfo> wicketKeepers;
  final List<PlayerInfo> batsmen;
  final List<PlayerInfo> allRounders;
  final List<PlayerInfo> bowlers;
  final double totalPoints;
  final String id;

  factory Team.fromJson(Map<String, dynamic> json) => Team(
        contest: json["contest"] != null
            ? List<String>.from(json["contest"].map((x) => x))
            : [],
        teamName: json["teamName"] != null
            ? (json["teamName"] as String).capitalize
            : '',
        captain: json["captain"] != null
            ? List<String>.from(json["captain"].map((x) => x))
            : [],
        viceCaptain: json["viceCaptain"] != null
            ? List<String>.from(json["viceCaptain"].map((x) => x))
            : [],
        wicketKeepers: json["wicketKeepers"] != null
            ? List<PlayerInfo>.from(
                json["wicketKeepers"].map((x) => PlayerInfo.fromJson(x, 'WK')))
            : [],
        batsmen: json["batsmans"] != null
            ? List<PlayerInfo>.from(
                json["batsmans"].map((x) => PlayerInfo.fromJson(x, 'BAT')))
            : [],
        allRounders: json["allRounders"] != null
            ? List<PlayerInfo>.from(
                json["allRounders"].map((x) => PlayerInfo.fromJson(x, 'AR')))
            : [],
        bowlers: json["bowlers"] != null
            ? List<PlayerInfo>.from(
                json["bowlers"].map((x) => PlayerInfo.fromJson(x, 'BOWL')))
            : [],
        totalPoints: json["totalPoints"] != null
            ? (json["totalPoints"] as num).toDouble()
            : 0,
        id: json["_id"] ?? '',
      );

  List<PlayerInfo> get allPlayers =>
      wicketKeepers + batsmen + allRounders + bowlers;
}

class PlayerInfo extends Equatable {
  PlayerInfo({
    this.id = '',
    this.matchPoints = 0,
    this.role = '',
  });

  final String id;
  final num matchPoints;
  final String role;

  factory PlayerInfo.fromJson(Map<String, dynamic> json, String role) =>
      PlayerInfo(
        id: json["id"] ?? '',
        matchPoints: ((json['point']?['match_points'] ?? 0) as num),
        role: role,
      );

  @override
  List<Object?> get props => [this.id, this.matchPoints, this.role];
}
