import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:the_super11/blocs/matches/all_upcoming_matches/all_upcoming_matches_bloc.dart';
import 'package:the_super11/blocs/matches/recent_matches/recent_matches_bloc.dart';
import 'package:the_super11/models/models.dart';
import 'package:the_super11/ui/resources/resources.dart';
import 'package:the_super11/ui/screens/contest/contest_list_screen.dart';
import 'package:the_super11/ui/screens/home/match_item.dart';
import 'package:the_super11/ui/screens/match/match_details_screen.dart';
import 'package:the_super11/ui/widgets/widgets.dart';

class HomeSection extends StatefulWidget {
  final VoidCallback viewAllCallback;

  const HomeSection({Key? key, required this.viewAllCallback})
      : super(key: key);

  @override
  _HomeSectionState createState() => _HomeSectionState();
}

class _HomeSectionState extends State<HomeSection> {
  final _refreshController = RefreshController();

  @override
  void initState() {
    super.initState();
    context.read<RecentMatchesBloc>().add(GetRecentMatches());
    context.read<AllUpcomingMatchesBloc>().add(GetAllUpcomingMatches());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              imgSplashLogo,
              width: 20,
            ),
            SizedBox(
              width: 12,
            ),
            Text('The Super11'),
          ],
        ),
      ),
      body: SmartRefresher(
        controller: _refreshController,
        enablePullUp: true,
        header: RefreshHeader(),
        footer: RefreshFooter(),
        onRefresh: () => context
            .read<AllUpcomingMatchesBloc>()
            .add(RefreshAllUpcomingMatches()),
        onLoading: () {
          final bloc = context.read<AllUpcomingMatchesBloc>();
          if (bloc.state is AllUpcomingMatchesFetchingSuccess &&
              !(bloc.state as AllUpcomingMatchesFetchingSuccess)
                  .reachToMaxIndex) bloc.add(PagingAllUpcomingMatches());
        },
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BlocBuilder<RecentMatchesBloc, RecentMatchesState>(
                builder: (context, state) {
                  if (state is RecentMatchesFetchingSuccess &&
                      state.myMatches.isNotEmpty)
                    return _RecentlyPlayedMatches(
                      matches: state.myMatches,
                      viewAllCallback: widget.viewAllCallback,
                    );
                  else if (state is RecentMatchesFetching)
                    return SizedBox(
                      height: 150,
                      child: LoadingIndicator(),
                    );
                  return Container();
                },
              ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Text(
                  'Upcoming Matches',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              BlocConsumer<AllUpcomingMatchesBloc, AllUpcomingMatchesState>(
                listener: (context, state) {
                  _refreshController.refreshCompleted();
                  _refreshController.loadComplete();
                  if (state is AllUpcomingMatchesFetchingSuccess &&
                      state.reachToMaxIndex) _refreshController.loadNoData();
                  if (state is AllUpcomingMatchesPagingError)
                    showTopSnackBar(
                        context, CustomSnackBar.error(message: state.error));
                  if (state is AllUpcomingMatchesRefreshingError)
                    showTopSnackBar(
                        context, CustomSnackBar.error(message: state.error));
                },
                builder: (context, state) {
                  if (state is AllUpcomingMatchesFetchingSuccess) {
                    if (state.myMatches.isNotEmpty)
                      return ListView.separated(
                        itemCount: state.myMatches.length,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                        itemBuilder: (context, i) => MatchItem(
                          match: state.myMatches[i],
                          onPressed: () => Navigator.of(context)
                              .pushNamed(ContestListScreen.route),
                        ),
                        separatorBuilder: (context, i) => SizedBox(
                          height: 6,
                        ),
                      );
                    return Padding(
                      padding: const EdgeInsets.only(top: 50),
                      child: EmptyView(
                        message: 'No upcoming matches available',
                        image: imgNoTeamFound,
                      ),
                    );
                  } else if (state is AllUpcomingMatchesFetching)
                    return LoadingIndicator();
                  return Container();
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }
}

class _RecentlyPlayedMatches extends StatefulWidget {
  final List<MyMatch> matches;
  final VoidCallback viewAllCallback;

  const _RecentlyPlayedMatches({
    Key? key,
    required this.matches,
    required this.viewAllCallback,
  }) : super(key: key);

  @override
  _RecentlyPlayedMatchesState createState() => _RecentlyPlayedMatchesState();
}

class _RecentlyPlayedMatchesState extends State<_RecentlyPlayedMatches>
    with TickerProviderStateMixin {
  late List<Widget> _children;
  late PageController _pageController;
  late List<double> _heights;
  int _selectedPage = 0;

  double get _currentHeight => _heights[_selectedPage];

  @override
  void initState() {
    _children = List.generate(
      widget.matches.length,
      (i) => MatchItem(
        match: widget.matches[i],
        onPressed: () => Navigator.of(context).pushNamed(
          widget.matches[i].status == matchNotStarted
              ? ContestListScreen.route
              : MatchDetailsScreen.route,
        ),
      ),
    );
    _heights = widget.matches.map((e) => 0.0).toList();
    super.initState();
    _pageController = PageController(viewportFraction: 0.96)
      ..addListener(() {
        final _newPage = _pageController.page?.round() ?? 0;
        if (_selectedPage != _newPage) {
          setState(() => _selectedPage = _newPage);
        }
      });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Recently Played',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: widget.viewAllCallback,
                child: Text('View All'),
                style: TextButton.styleFrom(
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              )
            ],
          ),
        ),
        TweenAnimationBuilder<double>(
          curve: Curves.easeInOutCubic,
          duration: const Duration(milliseconds: 100),
          tween: Tween<double>(begin: _heights[0], end: _currentHeight),
          builder: (context, value, child) =>
              SizedBox(height: value, child: child),
          child: PageView(
            controller: _pageController,
            onPageChanged: (index) => setState(() => _selectedPage = index),
            children: _sizeReportingChildren
                .asMap()
                .map((index, child) => MapEntry(index, child))
                .values
                .toList(),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            children: _pageIndicators(),
            mainAxisAlignment: MainAxisAlignment.center,
          ),
        ),
      ],
    );
  }

  List<Widget> get _sizeReportingChildren => _children
      .asMap()
      .map(
        (index, child) => MapEntry(
          index,
          OverflowBox(
            minHeight: 0,
            maxHeight: double.infinity,
            alignment: Alignment.topCenter,
            child: _SizeReportingWidget(
              onSizeChange: (size) =>
                  setState(() => _heights[index] = size.height),
              child: Align(child: child),
            ),
          ),
        ),
      )
      .values
      .toList();

  List<Widget> _pageIndicators() {
    Widget indicator(bool selected) {
      return AnimatedContainer(
        duration: Duration(microseconds: 150),
        margin: EdgeInsets.symmetric(horizontal: 3),
        height: selected ? 10 : 8,
        width: selected ? 10 : 8,
        decoration: BoxDecoration(
          color: selected ? Theme.of(context).primaryColor : Colors.grey,
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
      );
    }

    List<Widget> indicatorList = [];
    for (int i = 0; i < widget.matches.length; i++) {
      indicatorList
          .add(i == _selectedPage ? indicator(true) : indicator(false));
    }
    return indicatorList;
  }
}

class _SizeReportingWidget extends StatefulWidget {
  final Widget child;
  final ValueChanged<Size> onSizeChange;

  const _SizeReportingWidget({
    Key? key,
    required this.child,
    required this.onSizeChange,
  }) : super(key: key);

  @override
  _SizeReportingWidgetState createState() => _SizeReportingWidgetState();
}

class _SizeReportingWidgetState extends State<_SizeReportingWidget> {
  Size? _oldSize;

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance?.addPostFrameCallback((_) => _notifySize());
    return widget.child;
  }

  void _notifySize() {
    if (!this.mounted) {
      return;
    }
    final size = context.size;
    if (_oldSize != size) {
      _oldSize = size;
      if (size != null) widget.onSizeChange(size);
    }
  }
}
