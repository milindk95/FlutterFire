import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:flutter_fire/blocs/matches/score_details/score_details_bloc.dart';
import 'package:flutter_fire/core/extensions.dart';
import 'package:flutter_fire/core/providers/match_info_provider.dart';
import 'package:flutter_fire/core/utility.dart';
import 'package:flutter_fire/models/models.dart';
import 'package:flutter_fire/ui/resources/resources.dart';
import 'package:flutter_fire/ui/screens/home/match_status_live.dart';
import 'package:flutter_fire/ui/widgets/widgets.dart';

class MatchScoreView extends StatefulWidget {
  const MatchScoreView({Key? key}) : super(key: key);

  @override
  _MatchScoreViewState createState() => _MatchScoreViewState();
}

class _MatchScoreViewState extends State<MatchScoreView> {
  late final MyMatch match;

  @override
  void initState() {
    super.initState();
    match = context.read<MatchInfo>().match;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(4),
      child: Card(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: _teamDetails(),
            ),
            Divider(
              height: 0,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              child: _scoreView(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _teamDetails() => Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: match.status == matchStarted
                  ? CrossAxisAlignment.start
                  : CrossAxisAlignment.center,
              children: [
                Text(
                  match.season?.name ?? '',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(
                  height: 2,
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      match.format,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      width: 4,
                    ),
                    Text(
                      Utility.formatDate(
                        dateTime: match.startDate,
                        dateFormat: 'dd MMM, yyyy hh:mm aa',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (match.status == matchStarted) MatchStatusLive(),
        ],
      );

  Widget _scoreView() => BlocBuilder<ScoreDetailsBloc, ScoreDetailsState>(
        builder: (context, state) {
          if (state is ScoreDetailsFetchingSuccess)
            return Column(
              children: [
                _singleTeamScore(state.score, 0),
                SizedBox(
                  height: 4,
                ),
                _singleTeamScore(state.score, 1),
                Text(
                  _getMatchStatus(state.score),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                if (state.score.currentScore != null &&
                    (state.score.currentScore!.striker.isNotEmpty ||
                        state.score.currentScore!.nonStriker.isNotEmpty ||
                        state.score.currentScore!.bowler.isNotEmpty))
                  _playersScoreDetails(state.score),
              ],
            );
          else if (state is ScoreDetailsFetching) return LoadingIndicator();
          return Container();
        },
      );

  Widget _singleTeamScore(Score score, int index) => Row(
        children: [
          AppNetworkImage(
            url: match.teams[index].image,
            errorIcon: index == 0 ? imgTeam1Placeholder : imgTeam2Placeholder,
            height: 30,
          ),
          SizedBox(
            width: 10,
          ),
          Text(
            match.teams[index].shortName,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          Expanded(
            child: Text(
              _getInningsScore(index, score),
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      );

  String _getInningsScore(int teamIndex, Score score) {
    try {
      final inning = score.innings
          ?.where((inning) => inning.key == (teamIndex == 0 ? 'a_1' : 'b_1'))
          .single;
      if (context.read<MatchInfo>().match.format == 'Test') {
        final inning2 = score.innings
            ?.where((inning) => inning.key == (teamIndex == 0 ? 'a_2' : 'b_2'))
            .single;
        return '${inning?.runs}/${inning?.wickets} (${inning?.overs})\n${inning2?.runs}/${inning2?.wickets} (${inning2?.overs})';
      }
      return '${inning?.runs}/${inning?.wickets} (${inning?.overs})';
    } catch (e) {
      return '';
    }
  }

  String _getMatchStatus(Score score) {
    if (score.currentScore?.scoreBreak?.reason == '' &&
        score.statusOverview != 'result') {
      if (score.currentScore?.req != null)
        return score.currentScore?.req?.title ?? '';
      else if (score.currentScore?.innings.split('_').last == '1')
        return score.status.toLowerCase() == matchCompleted
            ? (score.messages?.completed ?? '')
            : '${score.teams[score.toss?.winner == 'a' ? 0 : 1].name} opt to ${score.toss?.elected}';
      else if (score.currentScore?.leadByStr.isNotEmpty ?? false)
        return score.currentScore?.leadByStr ?? '';
      else if (score.currentScore?.trailByStr.isNotEmpty ?? false)
        return score.currentScore?.trailByStr ?? '';
      else
        return '${score.teams[score.toss?.winner == 'a' ? 0 : 1].name} opt to ${score.toss?.elected}';
    } else if (score.statusOverview == 'result')
      return score.messages?.completed ?? '';
    else
      return score.statusOverview.toUpperCase().replaceAll('_', '');
  }

  Widget _playersScoreDetails(Score score) {
    Widget title(
      String text, {
      TextAlign textAlign = TextAlign.center,
      bool isTitle = false,
      bool isStriker = false,
    }) =>
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Text(
            '$text ${isStriker ? '*' : ''}',
            textAlign: textAlign,
            style: isTitle ? TextStyle(fontWeight: FontWeight.bold) : null,
          ),
        );
    return Table(
      border: TableBorder(
        horizontalInside: BorderSide(width: 0.2),
      ),
      columnWidths: {
        0: FlexColumnWidth(2),
        1: FlexColumnWidth(1),
        2: FlexColumnWidth(1),
        3: FlexColumnWidth(1),
        4: FlexColumnWidth(1),
        5: FlexColumnWidth(1),
      },
      children: [
        if (score.currentScore!.striker.isNotEmpty ||
            score.currentScore!.nonStriker.isNotEmpty)
          TableRow(
            children: [
              title('BATSMEN', textAlign: TextAlign.left, isTitle: true),
              title('R', isTitle: true),
              title('B', isTitle: true),
              title('4s', isTitle: true),
              title('6s', isTitle: true),
              title('SR', isTitle: true),
            ],
          ),
        if (score.currentScore!.striker.isNotEmpty)
          TableRow(
            children: [
              title(
                _getStrikerDetails(score)?.name.playerShortName ?? '',
                textAlign: TextAlign.left,
                isStriker: true,
              ),
              title(
                  '${_getStrikerDetails(score)?.innings.last.batting?.runs ?? ''}'),
              title(
                  '${_getStrikerDetails(score)?.innings.last.batting?.balls ?? ''}'),
              title(
                  '${_getStrikerDetails(score)?.innings.last.batting?.fours ?? ''}'),
              title(
                  '${_getStrikerDetails(score)?.innings.last.batting?.sixes ?? ''}'),
              title(
                  '${_getStrikerDetails(score)?.innings.last.batting?.strikeRate ?? ''}'),
            ],
          ),
        if (score.currentScore!.nonStriker.isNotEmpty)
          TableRow(
            children: [
              title(
                _getNonStrikerDetails(score)?.name.playerShortName ?? '',
                textAlign: TextAlign.left,
              ),
              title(
                  '${_getNonStrikerDetails(score)?.innings.last.batting?.runs ?? ''}'),
              title(
                  '${_getNonStrikerDetails(score)?.innings.last.batting?.balls ?? ''}'),
              title(
                  '${_getNonStrikerDetails(score)?.innings.last.batting?.fours ?? ''}'),
              title(
                  '${_getNonStrikerDetails(score)?.innings.last.batting?.sixes ?? ''}'),
              title(
                  '${_getNonStrikerDetails(score)?.innings.last.batting?.strikeRate ?? ''}'),
            ],
          ),
        if (score.currentScore!.bowler.isNotEmpty)
          TableRow(
            children: [
              title('BOWLER', textAlign: TextAlign.left, isTitle: true),
              title('O', isTitle: true),
              title('R', isTitle: true),
              title('W', isTitle: true),
              title('M', isTitle: true),
              title('ECON', isTitle: true),
            ],
          ),
        if (score.currentScore!.bowler.isNotEmpty)
          TableRow(
            children: [
              title(
                '${_getBowlerDetails(score)?.name.playerShortName ?? ''}',
                textAlign: TextAlign.left,
              ),
              title(
                  '${_getBowlerDetails(score)?.innings.last.bowling?.overs ?? ''}'),
              title(
                  '${_getBowlerDetails(score)?.innings.last.bowling?.runs ?? ''}'),
              title(
                  '${_getBowlerDetails(score)?.innings.last.bowling?.runs ?? ''}'),
              title(
                  '${_getBowlerDetails(score)?.innings.last.bowling?.wickets ?? ''}'),
              title(
                  '${_getBowlerDetails(score)?.innings.last.bowling?.economy ?? ''}'),
            ],
          ),
      ],
    );
  }

  Player? _getStrikerDetails(Score score) {
    try {
      return score.players
          ?.where((player) => player.key == score.currentScore!.striker)
          .first;
    } catch (e) {
      return null;
    }
  }

  Player? _getNonStrikerDetails(Score score) {
    try {
      return score.players
          ?.where((player) => player.key == score.currentScore!.nonStriker)
          .first;
    } catch (e) {
      return null;
    }
  }

  Player? _getBowlerDetails(Score score) {
    try {
      return score.players
          ?.where((player) => player.key == score.currentScore!.bowler)
          .first;
    } catch (e) {
      return null;
    }
  }
}
