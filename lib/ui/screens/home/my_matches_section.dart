import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flutter_fire/blocs/matches/my_matches/my_matches_bloc.dart';
import 'package:flutter_fire/ui/resources/resources.dart';
import 'package:flutter_fire/ui/screens/contest/contest_list_screen.dart';
import 'package:flutter_fire/ui/screens/home/match_item.dart';
import 'package:flutter_fire/ui/screens/match/match_details_screen.dart';
import 'package:flutter_fire/ui/widgets/widgets.dart';

class MyMatchesSection extends StatefulWidget {
  const MyMatchesSection({Key? key}) : super(key: key);

  @override
  _MyMatchesSectionState createState() => _MyMatchesSectionState();
}

class _MyMatchesSectionState extends State<MyMatchesSection> {
  final _matchTypes = ['Upcoming', 'Live', 'Completed'];
  String _selectedMatchType = 'Upcoming';
  final _refreshController = RefreshController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: Theme.of(context).primaryColor,
          child: SafeArea(
            child: Column(
              children: [
                SizedBox(height: 4),
                Text(
                  'My Matches',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.white),
                ),
                _slidingControl(),
                Divider(
                  height: 0,
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: BlocConsumer<MyMatchesBloc, MyMatchesState>(
            listener: (context, state) {
              _refreshController.loadComplete();
              _refreshController.refreshCompleted();
              if (state is MyMatchesFetchingSuccess && state.reachToMaxIndex)
                _refreshController.loadNoData();
              else if (state is MyMatchesPagingError)
                showTopSnackBar(
                    context, CustomSnackBar.error(message: state.error));
              else if (state is MyMatchesRefreshingError)
                showTopSnackBar(
                    context, CustomSnackBar.error(message: state.error));
            },
            builder: (context, state) {
              if (state is MyMatchesFetchingSuccess) {
                final matches = state.myMatches;
                if (matches.isNotEmpty)
                  return SmartRefresher(
                    controller: _refreshController,
                    enablePullUp: true,
                    header: RefreshHeader(),
                    footer: RefreshFooter(),
                    onRefresh: _onRefresh,
                    onLoading: _onLoading,
                    child: ListView.separated(
                      itemCount: matches.length,
                      padding: const EdgeInsets.all(12),
                      itemBuilder: (context, i) => MatchItem(
                        match: matches[i],
                        onPressed: () => Navigator.of(context).pushNamed(
                          matches[i].status == matchNotStarted
                              ? ContestListScreen.route
                              : MatchDetailsScreen.route,
                        ),
                      ),
                      separatorBuilder: (context, i) => SizedBox(
                        height: 6,
                      ),
                    ),
                  );
                return EmptyView(
                  message: 'No matches available',
                  image: imgNoTeamFound,
                );
              } else if (state is MyMatchesFetching)
                return LoadingIndicator();
              else if (state is MyMatchesFetchingFailure)
                return ErrorView(error: state.error);
              return Container();
            },
          ),
        )
      ],
    );
  }

  Widget _slidingControl() {
    Widget slider(int index) => Text(
          _matchTypes[index],
          style: TextStyle(
            color: _matchTypes[index] == _selectedMatchType
                ? Colors.black
                : Colors.white,
          ),
        );
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      child: CupertinoSlidingSegmentedControl<String>(
        groupValue: _selectedMatchType,
        children: {
          _matchTypes[0]: slider(0),
          _matchTypes[1]: slider(1),
          _matchTypes[2]: slider(2),
        },
        padding: const EdgeInsets.all(4),
        backgroundColor: Colors.white24,
        thumbColor: Colors.white,
        onValueChanged: (value) {
          setState(() => _selectedMatchType = value ?? _selectedMatchType[0]);
          if (value == _matchTypes[0])
            context.read<MyMatchesBloc>().add(GetMyMatches(0));
          else if (value == _matchTypes[1])
            context.read<MyMatchesBloc>().add(GetMyMatches(1));
          else
            context.read<MyMatchesBloc>().add(GetMyMatches(2));
        },
      ),
    );
  }

  void _onRefresh() => context
      .read<MyMatchesBloc>()
      .add(RefreshMyMatches(_matchTypes.indexOf(_selectedMatchType)));

  void _onLoading() {
    final bloc = context.read<MyMatchesBloc>();
    if (!(bloc.state as MyMatchesFetchingSuccess).reachToMaxIndex)
      bloc.add(PagingMyMatches(_matchTypes.indexOf(_selectedMatchType)));
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }
}
