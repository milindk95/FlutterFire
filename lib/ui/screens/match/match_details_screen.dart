import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_fire/blocs/matches/image_data/image_data_bloc.dart';
import 'package:flutter_fire/blocs/matches/joined_contests/joined_contests_bloc.dart';
import 'package:flutter_fire/blocs/matches/score_details/score_details_bloc.dart';
import 'package:flutter_fire/blocs/matches/team_and_contest_count/team_and_contest_count_bloc.dart';
import 'package:flutter_fire/core/providers/match_info_provider.dart';
import 'package:flutter_fire/models/models.dart';
import 'package:flutter_fire/ui/resources/resources.dart';
import 'package:flutter_fire/ui/screens/match/joined_contests.dart';
import 'package:flutter_fire/ui/screens/match/match_score_view.dart';
import 'package:flutter_fire/ui/screens/match/my_teams.dart';
import 'package:flutter_fire/ui/widgets/widgets.dart';

class MatchDetailsScreen extends StatefulWidget {
  static const route = '/match-details';

  const MatchDetailsScreen({Key? key}) : super(key: key);

  @override
  _MatchDetailsScreenState createState() => _MatchDetailsScreenState();
}

class _MatchDetailsScreenState extends State<MatchDetailsScreen> {
  late final MyMatch _match;
  late final TeamAndContestCountBloc _countBloc;
  late final ImageDataBloc _imageDataBloc;
  late final ScoreDetailsBloc _scoreDetailsBloc;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _match = context.read<MatchInfo>().match;
    _countBloc = context.read<TeamAndContestCountBloc>();
    _imageDataBloc = context.read<ImageDataBloc>();
    _scoreDetailsBloc = context.read<ScoreDetailsBloc>();
    _countBloc.setMatchId(_match.id);
    _imageDataBloc.setMatchId(_match.id);
    _scoreDetailsBloc.setMatchId(_match.id);
    if (_match.status == matchStarted)
      Timer.periodic(const Duration(minutes: 2), (timer) => _refreshDetails());
  }

  void _refreshDetails() {
    if (_scoreDetailsBloc.state is ScoreDetailsFetchingSuccess)
      _scoreDetailsBloc.add(RefreshScoreDetails());
  }

  @override
  void dispose() {
    _countBloc.add(ResetTeamAndContestCount());
    _imageDataBloc.add(ResetImageData());
    _scoreDetailsBloc.add(ResetScoreDetails());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppHeader(
        title: _match.shortName,
        actions: [
          if (_match.status == matchStarted)
            Padding(
              padding: const EdgeInsets.only(right: 4),
              child: IconButton(
                onPressed: context.watch<ScoreDetailsBloc>().state
                        is ScoreDetailsRefreshing
                    ? null
                    : _refreshDetails,
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
          BlocBuilder<TeamAndContestCountBloc, TeamAndContestCountState>(
            builder: (context, state) {
              return SlidingControl(
                labels: [
                  'My Contests ${state is TeamAndContestCountFetchingSuccess ? '(${state.contest})' : ''}',
                  'My Teams ${state is TeamAndContestCountFetchingSuccess ? '(${state.team})' : ''}'
                ],
                onIndexChanged: (i) => setState(() => _selectedIndex = i),
              );
            },
          ),
          if (_selectedIndex == 0)
            Expanded(
              child: BlocProvider<JoinedContestsBloc>(
                create: (context) =>
                    JoinedContestsBloc(_match.id)..add(GetJoinedContests()),
                child: JoinedContests(),
              ),
            ),
          if (_selectedIndex == 1)
            Expanded(
              child: MyTeams(),
            ),
        ],
      ),
    );
  }
}
