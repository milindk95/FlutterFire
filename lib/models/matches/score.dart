import 'package:flutter_fire/models/models.dart';

class Score {
  Score({
    this.messages,
    this.status = '',
    this.statusOverview = '',
    this.toss,
    this.currentScore,
    this.innings,
    this.players,
    this.teams = const [],
  });

  final Messages? messages;
  final String status;
  final String statusOverview;
  final Toss? toss;
  final CurrentScore? currentScore;
  final List<Inning>? innings;
  final List<Player>? players;
  final List<TeamDetails> teams;

  factory Score.fromJson(Map<String, dynamic> json) => Score(
        messages: json["messages"] != null
            ? Messages.fromJson(json["messages"])
            : null,
        status: json["status"] ?? '',
        statusOverview: json["statusOverview"] ?? '',
        toss: json["toss"] != null ? Toss.fromJson(json["toss"]) : null,
        currentScore: json['currentScore'] is Map
            ? CurrentScore.fromJson(json['currentScore'])
            : null,
        innings: json["innings"] != null ? _getInnings(json["innings"]) : null,
        players: json["players"] != null ? _getPlayers(json["players"]) : null,
        teams: json["matchId"] != null && json["matchId"]["teams"] != null
            ? MyMatch.getTeams(json["matchId"]["teams"])
            : [],
      );

  static List<Inning> _getInnings(Map<String, dynamic> json) {
    final innings = <Inning>[];
    json.forEach((key, value) {
      innings.add(Inning.fromJson(value as Map<String, dynamic>));
    });
    return innings;
  }

  static List<Player> _getPlayers(Map<String, dynamic> json) {
    final players = <Player>[];
    json.forEach((key, value) {
      (value as Map<String, dynamic>).addAll({'key': key});
      players.add(Player.fromJson(value));
    });
    return players;
  }
}

class Toss {
  final String winner;
  final String elected;

  Toss({this.winner = '', this.elected = ''});

  factory Toss.fromJson(Map<String, dynamic> json) => Toss(
        winner: json["winner"] ?? '',
        elected: json["elected"] ?? '',
      );
}

class Inning {
  final String key;
  final int runs;
  final int wickets;
  final String overs;

  Inning({
    this.key = '',
    this.runs = 0,
    this.wickets = 0,
    this.overs = '',
  });

  factory Inning.fromJson(Map<String, dynamic> json) => Inning(
        key: json["key"] ?? '',
        runs: json["runs"] ?? 0,
        wickets: json["wickets"] ?? 0,
        overs: json["overs"] ?? '',
      );
}

class Messages {
  Messages({
    this.result = '',
    this.completed = '',
  });

  final String result;
  final String completed;

  factory Messages.fromJson(Map<String, dynamic> json) => Messages(
        result: json["result"] ?? '',
        completed: json["completed"] ?? '',
      );
}

class Player {
  final String key;
  final String teamKey;
  final String seasonalRole;
  final String name;
  final List<PlayerInning> innings;

  Player({
    this.key = '',
    this.teamKey = '',
    this.seasonalRole = '',
    this.name = '',
    this.innings = const [],
  });

  factory Player.fromJson(Map<String, dynamic> json) => Player(
        key: json["key"] ?? '',
        teamKey: json["team_key"] ?? '',
        seasonalRole: json["seasonal_role"] ?? '',
        name: (json["name"] ?? '').toString().trim(),
        innings: json["match"] != null && json["match"]["innings"] != null
            ? _getInnings(json["match"]["innings"])
            : [],
      );

  static List<PlayerInning> _getInnings(Map<String, dynamic> json) {
    final playerInnings = <PlayerInning>[];
    json.forEach((key, value) {
      playerInnings.add(PlayerInning.fromJson(value as Map<String, dynamic>));
    });
    return playerInnings;
  }
}

class PlayerInning {
  final Batting? batting;
  final Bowling? bowling;

  PlayerInning({this.batting, this.bowling});

  factory PlayerInning.fromJson(Map<String, dynamic> json) => PlayerInning(
        batting:
            json["batting"] != null ? Batting.fromJson(json["batting"]) : null,
        bowling:
            json["bowling"] != null ? Bowling.fromJson(json["bowling"]) : null,
      );
}

class Bowling {
  Bowling({
    this.runs = 0,
    this.wickets = 0,
    this.overs = '',
    this.maidens = 0,
    this.economy = 0,
  });

  final int runs;
  final int wickets;
  final String overs;
  final int maidens;
  final num economy;

  factory Bowling.fromJson(Map<String, dynamic> json) => Bowling(
        runs: json["runs"] ?? 0,
        wickets: json["wickets"] ?? 0,
        overs: json["overs"] ?? '',
        maidens: json["maiden_overs"] ?? 0,
        economy: json["economy"] ?? 0,
      );
}

class Batting {
  Batting({
    this.runs = 0,
    this.balls = 0,
    this.fours = 0,
    this.sixes = 0,
    this.strikeRate = 0,
  });

  final int runs;
  final int balls;
  final int fours;
  final int sixes;
  final num strikeRate;

  factory Batting.fromJson(Map<String, dynamic> json) => Batting(
        runs: json["runs"] ?? 0,
        balls: json["balls"] ?? 0,
        fours: json["fours"] ?? 0,
        sixes: json["sixes"] ?? 0,
        strikeRate: json["strike_rate"] ?? 0,
      );
}

class CurrentScore {
  CurrentScore({
    this.innings = '',
    this.runsStr = '',
    this.striker = '',
    this.nonStriker = '',
    this.bowler = '',
    this.scoreBreak,
    this.leadByStr = '',
    this.trailByStr = '',
    this.req,
  });

  final String innings;
  final String runsStr;
  final String striker;
  final String nonStriker;
  final String bowler;
  final Break? scoreBreak;
  final String leadByStr;
  final String trailByStr;
  final Req? req;

  factory CurrentScore.fromJson(Map<String, dynamic> json) => CurrentScore(
        innings: json["innings"] is String ? json["innings"] : '',
        runsStr: json["runs_str"] is String ? json["runs_str"] : '',
        striker: json["striker"] is String ? json["striker"] : '',
        nonStriker: json["nonstriker"] is String ? json["nonstriker"] : '',
        bowler: json["bowler"] is String ? json["bowler"] : '',
        scoreBreak:
            json["break"] != null ? Break.fromJson(json["break"]) : null,
        leadByStr: json["lead_by_str"] is String ? json["lead_by_str"] : '',
        trailByStr: json["trail_by_str"] is String ? json["trail_by_str"] : '',
        req: json["req"] != null ? Req.fromJson(json["req"]) : null,
      );
}

class Break {
  Break({
    this.reason = '',
  });

  final String reason;

  factory Break.fromJson(Map<String, dynamic> json) => Break(
        reason: json["reason"] ?? '',
      );
}

class Req {
  Req({
    this.title = '',
  });

  final String title;

  factory Req.fromJson(Map<String, dynamic> json) => Req(
        title: json["title"] ?? '',
      );
}
