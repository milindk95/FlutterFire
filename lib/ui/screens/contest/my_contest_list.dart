import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:the_super11/blocs/contest/user_contests/user_contests_bloc.dart';
import 'package:the_super11/core/providers/match_info_provider.dart';
import 'package:the_super11/ui/resources/resources.dart';
import 'package:the_super11/ui/screens/contest/contest_details_screen.dart';
import 'package:the_super11/ui/widgets/widgets.dart';

import 'contest_item.dart';

class MyContestList extends StatefulWidget {
  final VoidCallback onJoinContest;

  const MyContestList({Key? key, required this.onJoinContest})
      : super(key: key);

  @override
  _MyContestListState createState() => _MyContestListState();
}

class _MyContestListState extends State<MyContestList> {
  final _refreshController = RefreshController();

  @override
  void initState() {
    super.initState();
    context.read<UserContestsBloc>()
      ..setMatchId(context.read<MatchInfo>().match.id);
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UserContestsBloc, UserContestsState>(
      listener: (context, state) {
        _refreshController.refreshCompleted();
        _refreshController.loadComplete();
        if (state is UserContestsFetchingSuccess && state.reachToMaxIndex)
          _refreshController.loadNoData();
        if (state is UserContestsRefreshingError)
          showTopSnackBar(context, CustomSnackBar.error(message: state.error));
        else if (state is UserContestsPagingError)
          showTopSnackBar(context, CustomSnackBar.error(message: state.error));
      },
      builder: (context, state) {
        if (state is UserContestsFetchingSuccess) {
          final contests = state.contests;
          if (contests.isNotEmpty)
            return SmartRefresher(
              controller: _refreshController,
              enablePullUp: true,
              header: RefreshHeader(),
              footer: RefreshFooter(),
              onRefresh: () =>
                  context.read<UserContestsBloc>().add(RefreshUserContests()),
              onLoading: () {
                final bloc = context.read<UserContestsBloc>();
                if (!(bloc.state as UserContestsFetchingSuccess)
                    .reachToMaxIndex) bloc.add(PagingUserContests());
              },
              child: ListView.separated(
                itemCount: contests.length,
                padding: EdgeInsets.fromLTRB(12, 0, 12, 12),
                itemBuilder: (context, i) => ContestItem(
                  contest: contests[i],
                  onTap: () => Navigator.of(context).pushNamed(
                    ContestDetailsScreen.route,
                    arguments: ContestDetailsScreenData(
                      contest: contests[i],
                      fromMyContests: true,
                    ),
                  ),
                  fromMyContests: true,
                ),
                separatorBuilder: (context, i) => SizedBox(
                  height: 16,
                ),
              ),
            );
          return EmptyView(
            message: 'You have not joined any contest for this match',
            image: imgNoContestFound,
            buttonText: 'Join Contest',
            onPressed: widget.onJoinContest,
          );
        } else if (state is UserContestsFetchingFailure)
          return ErrorView(error: state.error);
        return LoadingIndicator();
      },
    );
  }
}
