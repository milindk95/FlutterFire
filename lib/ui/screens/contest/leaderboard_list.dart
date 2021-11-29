import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:the_super11/blocs/contest/leaderboard/leaderboard_bloc.dart';
import 'package:the_super11/blocs/contest/match_credit/match_credit_bloc.dart';
import 'package:the_super11/blocs/matches/image_data/image_data_bloc.dart';
import 'package:the_super11/blocs/team/team_details/team_details_bloc.dart';
import 'package:the_super11/core/providers/user_info_provider.dart';
import 'package:the_super11/models/models.dart';
import 'package:the_super11/ui/resources/resources.dart';
import 'package:the_super11/ui/screens/match/team_preview_screen.dart';
import 'package:the_super11/ui/widgets/widgets.dart';

class LeaderboardList extends StatefulWidget {
  const LeaderboardList({Key? key}) : super(key: key);

  @override
  _LeaderboardListState createState() => _LeaderboardListState();
}

class _LeaderboardListState extends State<LeaderboardList> {
  int? _selectedIndex;
  final _refreshController = RefreshController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LeaderboardBloc, LeaderboardState>(
      listener: (context, state) {
        _refreshController.refreshCompleted();
        _refreshController.loadComplete();
        if (state is LeaderboardFetchingSuccess && state.reachToMaxIndex)
          _refreshController.loadNoData();
        if (state is LeaderboardPagingError)
          showTopSnackBar(context, CustomSnackBar.error(message: state.error));
        if (state is LeaderboardRefreshingError)
          showTopSnackBar(context, CustomSnackBar.error(message: state.error));
      },
      builder: (context, state) {
        if (state is LeaderboardFetchingSuccess) {
          final participants = state.participants;
          if (participants.isNotEmpty)
            return SmartRefresher(
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
                itemBuilder: (context, i) =>
                    _leaderboardItem(i, participants[i]),
                separatorBuilder: (context, i) => Divider(
                  height: 0,
                ),
                itemCount: participants.length,
              ),
            );
          return EmptyView(
            message:
                'Be the first participant in this contest and get chance to win',
            image: imgNoLeaderboardFound,
          );
        } else if (state is LeaderboardFetchingFailure)
          return ErrorView(error: state.error);
        return LoadingIndicator();
      },
    );
  }

  Widget _leaderboardItem(int i, ContestParticipation participation) =>
      AbsorbPointer(
        absorbing: _matchCreditState is MatchCreditFetching ||
            _teamDetailsState is TeamDetailsFetching,
        child: InkWell(
          onTap: _enableTeamView(participation)
              ? () => _showTeamPreview(i, participation)
              : null,
          child: Container(
            height: 44,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    participation.team?.teamName ?? '',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                if (_enableTeamView(participation))
                  (_matchCreditState is MatchCreditFetching ||
                              _teamDetailsState is TeamDetailsFetching) &&
                          _selectedIndex == i
                      ? CupertinoActivityIndicator()
                      : Icon(Icons.remove_red_eye),
                if (_selectedIndex == i)
                  BlocListener<MatchCreditBloc, MatchCreditState>(
                    listener: (context, state) {
                      if (state is MatchCreditFetchingSuccess)
                        context
                            .read<TeamDetailsBloc>()
                            .add(GetTeamDetails(participation.team?.id));
                    },
                    child: Container(),
                  ),
                if (_selectedIndex == i)
                  BlocListener<TeamDetailsBloc, TeamDetailsState>(
                    listener: (context, state) {
                      if (state is TeamDetailsFetchingSuccess)
                        Navigator.of(context).pushNamed(
                          TeamPreviewScreen.route,
                          arguments: TeamPreviewScreenData(
                            team: state.team,
                            teamDetails: (context.read<MatchCreditBloc>().state
                                    as MatchCreditFetchingSuccess)
                                .matchCredit
                                .teamDetails,
                            imageData: (context.read<ImageDataBloc>().state
                                    as ImageDataFetchingSuccess)
                                .imageData,
                            showEdit: false,
                          ),
                        );
                    },
                    child: Container(),
                  )
              ],
            ),
          ),
        ),
      );

  bool _enableTeamView(ContestParticipation participation) =>
      participation.user == context.read<UserInfo>().user.id;

  void _showTeamPreview(int i, ContestParticipation participation) {
    _selectedIndex = i;
    final matchCreditBloc = context.read<MatchCreditBloc>();
    matchCreditBloc.state is MatchCreditFetchingSuccess
        ? context
            .read<TeamDetailsBloc>()
            .add(GetTeamDetails(participation.team?.id))
        : context.read<MatchCreditBloc>().add(GetMatchCredit());
  }

  TeamDetailsState get _teamDetailsState =>
      context.watch<TeamDetailsBloc>().state;

  MatchCreditState get _matchCreditState =>
      context.watch<MatchCreditBloc>().state;
}
