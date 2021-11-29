import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flutter_fire/blocs/matches/joined_contests/joined_contests_bloc.dart';
import 'package:flutter_fire/core/extensions.dart';
import 'package:flutter_fire/core/providers/match_info_provider.dart';
import 'package:flutter_fire/models/models.dart';
import 'package:flutter_fire/ui/resources/resources.dart';
import 'package:flutter_fire/ui/screens/match/joined_contest_details_screen.dart';
import 'package:flutter_fire/ui/widgets/widgets.dart';

class JoinedContests extends StatefulWidget {
  const JoinedContests({Key? key}) : super(key: key);

  @override
  _JoinedContestsState createState() => _JoinedContestsState();
}

class _JoinedContestsState extends State<JoinedContests> {
  final _refreshController = RefreshController();
  late bool _showAnim;

  @override
  void initState() {
    super.initState();
    _showAnim = context.read<MatchInfo>().match.totalWinningAmount > 0;
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<JoinedContestsBloc, JoinedContestsState>(
      listener: (context, state) {
        _refreshController.refreshCompleted();
        _refreshController.loadComplete();
        if (state is JoinedContestsFetchingSuccess) {
          if (_showAnim)
            Future.delayed(const Duration(milliseconds: 1500), () {
              if (mounted) setState(() => _showAnim = false);
            });
          if (state.reachToMaxIndex) _refreshController.loadNoData();
        }
        if (state is JoinedContestsPagingError)
          showTopSnackBar(context, CustomSnackBar.error(message: state.error));
        if (state is JoinedContestsRefreshingError)
          showTopSnackBar(context, CustomSnackBar.error(message: state.error));
      },
      builder: (context, state) {
        if (state is JoinedContestsFetchingSuccess) {
          return Stack(
            alignment: Alignment.topCenter,
            children: [
              SmartRefresher(
                controller: _refreshController,
                enablePullUp: true,
                header: RefreshHeader(),
                footer: RefreshFooter(),
                onRefresh: () => context
                    .read<JoinedContestsBloc>()
                    .add(RefreshJoinedContests()),
                onLoading: () {
                  final bloc = context.read<JoinedContestsBloc>();
                  if (!(bloc.state as JoinedContestsFetchingSuccess)
                      .reachToMaxIndex) bloc.add(PagingJoinedContests());
                },
                child: ListView.separated(
                  itemCount: state.contests.length,
                  padding: const EdgeInsets.all(12),
                  itemBuilder: (context, i) => InkWell(
                    borderRadius: BorderRadius.circular(8),
                    onTap: () => Navigator.of(context).pushNamed(
                      JoinedContestDetailsScreen.route,
                      arguments: JoinedContestDetailsScreenData(
                        contest: state.contests[i],
                      ),
                    ),
                    child: Card(
                      child: _item(state.contests[i]),
                    ),
                  ),
                  separatorBuilder: (context, i) => SizedBox(
                    height: 6,
                  ),
                ),
              ),
              if (_showAnim)
                IgnorePointer(
                  child: Lottie.asset(
                    'assets/animations/contest_win.json',
                  ),
                )
            ],
          );
        } else if (state is JoinedContestsFetching)
          return LoadingIndicator();
        else if (state is JoinedContestsFetchingFailure)
          return ErrorView(error: state.error);
        return Container();
      },
    );
  }

  Widget _item(Contest contest) => Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Entries ${contest.noOfEntry}',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      contest.contestType.capitalize,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                if (contest.isCancelled)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      'Cancelled due to : ${contest.cancelReason}',
                      style: TextStyle(
                        color: Colors.redAccent,
                      ),
                    ),
                  ),
                SizedBox(
                  height: 8,
                ),
                Row(
                  children: [
                    Text('Entry Fee: '),
                    Text(
                      '₹${contest.feePerEntry}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Spacer(),
                    Icon(
                      Icons.military_tech_outlined,
                      color: Colors.blueAccent,
                      size: 18,
                    ),
                    Text(
                      contest.winningPrizes.isNotEmpty
                          ? contest.winningPrizes[0].winningAmount.toString()
                          : '0',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent,
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
          if (contest.matchStatus != matchNotStarted &&
              !contest.isCancelled &&
              contest.ranks != null)
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Color(0xFF70523C)
                    : Color(0xFFFFF5ED),
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(8),
                ),
              ),
              child: ListView.separated(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.all(8.0),
                itemBuilder: (context, i) => Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(contest.ranks![i].team?.teamName ?? ''),
                          if (contest.matchStatus == matchStarted &&
                              contest.winningPrizes.isNotEmpty &&
                              contest.ranks![i].rank <=
                                  contest.winningPrizes.last.endRank)
                            Padding(
                              padding: const EdgeInsets.only(top: 2),
                              child: Text(
                                'IN WINNING ZONE',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.green,
                                ),
                              ),
                            ),
                          if (contest.matchStatus == matchCompleted &&
                              contest.ranks![i].winAmount > 0)
                            Padding(
                              padding: const EdgeInsets.only(top: 2),
                              child: Text(
                                'YOU WON ₹ ${contest.ranks![i].winAmount}',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Text(
                        contest.ranks![i].team?.totalPoints.toString() ?? '0',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Text(
                      "#${contest.ranks![i].rank}",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                separatorBuilder: (context, i) => Divider(),
                itemCount: contest.ranks!.length,
              ),
            )
        ],
      );

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }
}
