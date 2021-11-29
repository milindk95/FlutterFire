import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flutter_fire/blocs/contest/leaderboard/leaderboard_bloc.dart';
import 'package:flutter_fire/blocs/matches/image_data/image_data_bloc.dart';
import 'package:flutter_fire/blocs/matches/score_details/score_details_bloc.dart';
import 'package:flutter_fire/blocs/team/team_details/team_details_bloc.dart';
import 'package:flutter_fire/models/models.dart';
import 'package:flutter_fire/ui/resources/resources.dart';
import 'package:flutter_fire/ui/screens/match/team_preview_screen.dart';
import 'package:flutter_fire/ui/screens/teams/compare_team_screen.dart';
import 'package:flutter_fire/ui/widgets/widgets.dart';

class LiveORCompleteLeaderboard extends StatefulWidget {
  const LiveORCompleteLeaderboard({Key? key}) : super(key: key);

  @override
  _LiveORCompleteLeaderboardState createState() =>
      _LiveORCompleteLeaderboardState();
}

class _LiveORCompleteLeaderboardState extends State<LiveORCompleteLeaderboard> {
  final _refreshController = RefreshController();
  bool _selection = false;
  final List<int> _selectedTeams = [];
  int? _selectedIndex;

  @override
  Widget build(BuildContext context) {
    return AbsorbPointer(
      absorbing: context.watch<TeamDetailsBloc>().state is TeamDetailsFetching,
      child: BlocConsumer<LeaderboardBloc, LeaderboardState>(
        listener: (context, state) {
          _refreshController.refreshCompleted();
          _refreshController.loadComplete();
          if (state is LeaderboardFetchingSuccess && state.reachToMaxIndex)
            _refreshController.loadNoData();
          if (state is LeaderboardPagingError)
            showTopSnackBar(
                context, CustomSnackBar.error(message: state.error));
          if (state is LeaderboardRefreshingError)
            showTopSnackBar(
                context, CustomSnackBar.error(message: state.error));
        },
        builder: (context, state) {
          if (state is LeaderboardFetchingSuccess)
            return Column(
              children: [
                Row(
                  children: [
                    SizedBox(
                      width: 12,
                    ),
                    Expanded(
                      child: Text('Click and select any two teams to compare'),
                    ),
                    IconButton(
                      onPressed: () {
                        if (_selection)
                          _selectedTeams.clear();
                        else
                          _selectedTeams.add(0);
                        setState(() => _selection = !_selection);
                      },
                      icon: SvgPicture.asset(
                        icCompare,
                        width: 22,
                        color: _selection
                            ? Colors.green
                            : Theme.of(context).colorScheme.primaryVariant,
                      ),
                      splashRadius: 22,
                      constraints: BoxConstraints(maxWidth: 30),
                      padding: const EdgeInsets.all(4),
                    ),
                    SizedBox(
                      width: 12,
                    )
                  ],
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                  margin: const EdgeInsets.only(top: 6),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        flex: 6,
                        child: Text(
                          'All Teams(${state.totalParticipants})',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          'Points',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          'Rank',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: _leaderboardList(state.participants),
                ),
              ],
            );
          else if (state is LeaderboardFetchingFailure)
            return ErrorView(error: state.error);
          return LoadingIndicator();
        },
      ),
    );
  }

  Widget _leaderboardList(List<ContestParticipation> participants) =>
      SmartRefresher(
        controller: _refreshController,
        enablePullUp: true,
        header: RefreshHeader(),
        footer: RefreshFooter(),
        onRefresh: () =>
            context.read<LeaderboardBloc>().add(RefreshLeaderboard()),
        onLoading: () {
          final state = context.read<LeaderboardBloc>().state;
          if (!(state as LeaderboardFetchingSuccess).reachToMaxIndex)
            context.read<LeaderboardBloc>().add(PagingLeaderboard());
        },
        child: ListView.separated(
          itemCount: participants.length,
          itemBuilder: (context, i) {
            final participant = participants[i];
            return InkWell(
              onTap: _selection
                  ? () => _manageSelection(participants, i)
                  : () {
                      _selectedIndex = i;
                      context
                          .read<TeamDetailsBloc>()
                          .add(GetTeamDetails(participant.team?.id));
                    },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 14),
                color: _selectedTeams.contains(i)
                    ? Colors.green.withOpacity(0.3)
                    : null,
                child: Row(
                  children: [
                    Expanded(
                      flex: 6,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            participant.team?.teamName ?? '',
                          ),
                          if (_selectedIndex == i)
                            Padding(
                              padding: const EdgeInsets.only(left: 8),
                              child: CupertinoActivityIndicator(),
                            ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        '${participant.team?.totalPoints}',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        '#${participant.rank}',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    if (_selectedIndex == i)
                      BlocListener<TeamDetailsBloc, TeamDetailsState>(
                        listener: (context, state) {
                          if (state is TeamDetailsFetchingSuccess)
                            _showTeamPreview();
                        },
                        child: Container(),
                      )
                  ],
                ),
              ),
            );
          },
          separatorBuilder: (context, i) => Divider(
            height: 0,
          ),
        ),
      );

  void _manageSelection(List<ContestParticipation> participants, int i) {
    if (_selectedTeams.contains(i))
      _selectedTeams.remove(i);
    else
      _selectedTeams.add(i);
    if (_selectedTeams.length == 2) {
      Navigator.of(context).pushNamed(
        CompareTeamScreen.route,
        arguments: CompareTeamScreenData(
          [participants[_selectedTeams[0]], participants[_selectedTeams[1]]],
        ),
      );
      _selection = false;
      _selectedTeams.clear();
    }
    setState(() {});
  }

  void _showTeamPreview() async {
    await Navigator.of(context).pushNamed(
      TeamPreviewScreen.route,
      arguments: TeamPreviewScreenData(
        imageData:
            (context.read<ImageDataBloc>().state as ImageDataFetchingSuccess)
                .imageData,
        team: (context.read<TeamDetailsBloc>().state
                as TeamDetailsFetchingSuccess)
            .team,
        teamDetails: (context.read<ScoreDetailsBloc>().state
                as ScoreDetailsFetchingSuccess)
            .score
            .teams,
      ),
    );
    setState(() => _selectedIndex = null);
  }
}
