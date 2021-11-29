import 'package:the_super11/models/models.dart';

class ContestData {
  ContestData({
    this.maxTeamSize = 0,
    this.privateContestCommission = 0,
    this.contestGroupBy,
  });

  final int maxTeamSize;
  final double privateContestCommission;
  final ContestGroupBy? contestGroupBy;

  factory ContestData.fromJson(Map<String, dynamic> json) => ContestData(
        maxTeamSize: json["maxTeamSize"] ?? 0,
        privateContestCommission: json["privateContestCommission"] != null
            ? (json["privateContestCommission"] as num).toDouble()
            : 0,
        contestGroupBy: json["contestGroupBy"] != null
            ? ContestGroupBy.fromJson(json["contestGroupBy"])
            : null,
      );
}

class ContestGroupBy {
  ContestGroupBy({
    this.headToHead = const [],
    this.winnerTakesAllContest = const [],
    this.practiceContest = const [],
    this.megaContest = const [],
    this.hotContest = const [],
  });

  final List<Contest> headToHead;
  final List<Contest> winnerTakesAllContest;
  final List<Contest> practiceContest;
  final List<Contest> megaContest;
  final List<Contest> hotContest;

  factory ContestGroupBy.fromJson(Map<String, dynamic> json) => ContestGroupBy(
        headToHead: json["head to head"] != null
            ? List<Contest>.from(
                json["head to head"].map((x) => Contest.fromJson(x)))
            : [],
        winnerTakesAllContest: json["winner takes all contest"] != null
            ? List<Contest>.from(json["winner takes all contest"]
                .map((x) => Contest.fromJson(x)))
            : [],
        practiceContest: json["practice contest"] != null
            ? List<Contest>.from(
                json["practice contest"].map((x) => Contest.fromJson(x)))
            : [],
        megaContest: json["mega contest"] != null
            ? List<Contest>.from(
                json["mega contest"].map((x) => Contest.fromJson(x)))
            : [],
        hotContest: json["hot contest"] != null
            ? List<Contest>.from(
                json["hot contest"].map((x) => Contest.fromJson(x)))
            : [],
      );
}
