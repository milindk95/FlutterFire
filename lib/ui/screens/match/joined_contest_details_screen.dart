import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_fire/blocs/contest/contest_details/contest_details_bloc.dart';
import 'package:flutter_fire/blocs/contest/leaderboard/leaderboard_bloc.dart';
import 'package:flutter_fire/blocs/matches/match_point/match_point_bloc.dart';
import 'package:flutter_fire/core/providers/match_info_provider.dart';
import 'package:flutter_fire/models/models.dart';
import 'package:flutter_fire/ui/resources/resources.dart';
import 'package:flutter_fire/ui/screens/contest/ranking_list.dart';
import 'package:flutter_fire/ui/screens/match/live_or_complete_leaderboard.dart';
import 'package:flutter_fire/ui/screens/match/match_score_view.dart';
import 'package:flutter_fire/ui/screens/match/player_stats.dart';
import 'package:flutter_fire/ui/widgets/widgets.dart';

class JoinedContestDetailsScreenData {
  final Contest contest;

  JoinedContestDetailsScreenData({required this.contest});
}

class JoinedContestDetailsScreen extends StatefulWidget {
  static const route = '/joined-contest-details';

  final JoinedContestDetailsScreenData data;

  const JoinedContestDetailsScreen({
    Key? key,
    required this.data,
  }) : super(key: key);

  @override
  _JoinedContestDetailsScreenState createState() =>
      _JoinedContestDetailsScreenState();
}

class _JoinedContestDetailsScreenState
    extends State<JoinedContestDetailsScreen> {
  List<String> _labels = ['Leaderboard', 'Player Stats'];
  late int _selectedIndex;
  late final _isPracticeContest;

  @override
  void initState() {
    super.initState();
    _isPracticeContest = widget.data.contest.contestType == practiceContest;
    if (!_isPracticeContest) _labels.insert(0, 'Ranking');
    _selectedIndex = _isPracticeContest ? 0 : 1;
    if (context.read<MatchInfo>().match.status == matchStarted)
      Timer.periodic(const Duration(minutes: 2), (timer) => _refreshDetails);
  }

  void _refreshDetails() {
    final leaderboardBloc = context.read<LeaderboardBloc>();
    final matchPointBloc = context.read<MatchPointBloc>();
    if (leaderboardBloc.state is LeaderboardFetchingSuccess)
      leaderboardBloc.add(RefreshLeaderboard());
    if (matchPointBloc.state is MatchPointFetchingSuccess)
      matchPointBloc.add(RefreshMatchPoint());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppHeader(
        title: context.read<MatchInfo>().match.shortName,
        actions: [
          if (context.read<MatchInfo>().match.status == matchStarted)
            Padding(
              padding: const EdgeInsets.only(right: 4),
              child: IconButton(
                onPressed: _refreshDetails,
                icon: Icon(Icons.refresh),
                splashRadius: 22,
                tooltip: 'Score refresh',
              ),
            )
        ],
      ),
      body: Column(
        children: [
          MatchScoreView(),
          SlidingControl(
            labels: _labels,
            selectedIndex: _selectedIndex,
            onIndexChanged: (i) => setState(() => _selectedIndex = i),
          ),
          Expanded(
            child: _decider(),
          )
        ],
      ),
    );
  }

  Widget _decider() {
    if (_selectedIndex == 0)
      return _isPracticeContest
          ? LiveORCompleteLeaderboard()
          : SingleChildScrollView(
              padding: const EdgeInsets.all(8),
              child: _ranking(),
            );
    else if (_selectedIndex == 1)
      return _isPracticeContest ? PlayerStats() : LiveORCompleteLeaderboard();
    return PlayerStats();
  }

  Widget _ranking() => BlocBuilder<ContestDetailsBloc, ContestDetailsState>(
        builder: (context, state) {
          if (state is ContestDetailsFetchingSuccess)
            return RankingList(contest: state.contest);
          else if (state is ContestDetailsFetchingFailure)
            return ErrorView(error: state.error);
          return LoadingIndicator();
        },
      );
}
