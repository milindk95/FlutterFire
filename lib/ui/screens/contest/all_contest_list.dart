import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:the_super11/blocs/contest/all_contests/all_contests_bloc.dart';
import 'package:the_super11/core/providers/match_info_provider.dart';
import 'package:the_super11/models/models.dart';
import 'package:the_super11/ui/screens/contest/contest_details_screen.dart';
import 'package:the_super11/ui/widgets/widgets.dart';

import 'contest_item.dart';

class AllContestList extends StatefulWidget {
  const AllContestList({Key? key}) : super(key: key);

  @override
  _AllContestListState createState() => _AllContestListState();
}

class _AllContestListState extends State<AllContestList> {
  final _refreshController = RefreshController();
  final _autoScrollController = AutoScrollController();
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    final allContestsBloc = context.read<AllContestsBloc>();
    if (allContestsBloc.state is! AllContestsFetchingSuccess)
      allContestsBloc.setMatchId(context.read<MatchInfo>().match.id);
  }

  @override
  void dispose() {
    _refreshController.dispose();
    _autoScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AllContestsBloc, AllContestsState>(
      listener: (context, state) {
        _refreshController.refreshCompleted();
        if (state is AllContestsRefreshingError)
          showTopSnackBar(context, CustomSnackBar.error(message: state.error));
      },
      builder: (context, state) {
        if (state is AllContestsFetchingSuccess)
          return Column(
            children: [
              SizedBox(
                height: 34,
                child: ListView.separated(
                  itemCount: _getContestLength(state.contestData),
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  itemBuilder: (context, i) => ActionChip(
                    label: Text(
                      _getContestTitles(state.contestData)[i],
                      style: TextStyle(
                        color: _selectedIndex == i
                            ? Colors.white
                            : Theme.of(context).colorScheme.primaryVariant,
                      ),
                    ),
                    backgroundColor: _selectedIndex == i
                        ? Theme.of(context).primaryColor
                        : null,
                    onPressed: () {
                      setState(() => _selectedIndex = i);
                      _autoScrollController.scrollToIndex(
                        i,
                        preferPosition: AutoScrollPosition.begin,
                      );
                    },
                  ),
                  separatorBuilder: (context, i) => SizedBox(width: 12),
                ),
              ),
              SizedBox(
                height: 6,
              ),
              Expanded(
                child: SmartRefresher(
                  controller: _refreshController,
                  header: RefreshHeader(),
                  onRefresh: () =>
                      context.read<AllContestsBloc>().add(RefreshAllContests()),
                  child: ListView.separated(
                    controller: _autoScrollController,
                    itemCount: _getContestLength(state.contestData),
                    padding: EdgeInsets.fromLTRB(
                        12, 0, 12, MediaQuery.of(context).padding.bottom + 76),
                    itemBuilder: (context, i) => AutoScrollTag(
                      key: ValueKey(i),
                      controller: _autoScrollController,
                      index: i,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _getContestTitles(state.contestData)[i],
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          _contests(_getContests(state.contestData, i)),
                        ],
                      ),
                    ),
                    separatorBuilder: (context, i) => SizedBox(
                      height: 16,
                    ),
                  ),
                ),
              ),
            ],
          );
        else if (state is AllContestsFetching)
          return LoadingIndicator();
        else if (state is AllContestsFetchingFailure)
          return ErrorView(error: state.error);
        return Container();
      },
    );
  }

  int _getContestLength(ContestData contestData) {
    final groupBy = contestData.contestGroupBy;
    if (groupBy == null) return 0;
    final totalMega = groupBy.megaContest.isEmpty ? 0 : 1;
    final totalHot = groupBy.hotContest.isEmpty ? 0 : 1;
    final totalHeadToHead = groupBy.headToHead.isEmpty ? 0 : 1;
    final totalWinnerTakesAll = groupBy.winnerTakesAllContest.isEmpty ? 0 : 1;
    final totalPractice = groupBy.practiceContest.isEmpty ? 0 : 1;
    return totalMega +
        totalHot +
        totalHeadToHead +
        totalWinnerTakesAll +
        totalPractice;
  }

  List<Contest> _getContests(ContestData contestData, int i) {
    final groupBy = contestData.contestGroupBy;
    if (groupBy == null) return [];
    switch (i) {
      case 0:
        return groupBy.megaContest;
      case 1:
        return groupBy.hotContest;
      case 2:
        return groupBy.headToHead;
      case 3:
        return groupBy.winnerTakesAllContest;
      case 4:
        return groupBy.practiceContest;
      default:
        return [];
    }
  }

  List<String> _getContestTitles(ContestData contestData) {
    final groupBy = contestData.contestGroupBy;
    if (groupBy == null) return [];
    final _titles = <String>[];
    if (groupBy.megaContest.isNotEmpty) _titles.add('Mega Contests');
    if (groupBy.hotContest.isNotEmpty) _titles.add('Hot Contests');
    if (groupBy.headToHead.isNotEmpty) _titles.add('Head to Head');
    if (groupBy.winnerTakesAllContest.isNotEmpty)
      _titles.add('Winner Takes All');
    if (groupBy.winnerTakesAllContest.isNotEmpty)
      _titles.add('Practice Contests');
    return _titles;
  }

  Widget _contests(List<Contest> contest) => ListView.separated(
        itemCount: contest.length,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.only(top: 8),
        itemBuilder: (context, i) => ContestItem(
          contest: contest[i],
          onTap: () => Navigator.of(context).pushNamed(
            ContestDetailsScreen.route,
            arguments: ContestDetailsScreenData(
              contest: contest[i],
            ),
          ),
        ),
        separatorBuilder: (context, i) => SizedBox(
          height: 12,
        ),
      );
}
