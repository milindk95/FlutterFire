import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_fire/blocs/contest/match_credit/match_credit_bloc.dart';
import 'package:flutter_fire/blocs/matches/image_data/image_data_bloc.dart';
import 'package:flutter_fire/core/extensions.dart';
import 'package:flutter_fire/core/providers/match_info_provider.dart';
import 'package:flutter_fire/models/models.dart';
import 'package:flutter_fire/ui/resources/resources.dart';
import 'package:flutter_fire/ui/widgets/widgets.dart';

class AllPlayersStatsScreenData {
  final MatchPoint matchPoint;
  final int selectedIndex;

  AllPlayersStatsScreenData({
    required this.matchPoint,
    required this.selectedIndex,
  });
}

class AllPlayersStatsScreen extends StatefulWidget {
  static const route = '/all-players-stats';

  final AllPlayersStatsScreenData data;

  const AllPlayersStatsScreen({Key? key, required this.data}) : super(key: key);

  @override
  _AllPlayersStatsScreenState createState() => _AllPlayersStatsScreenState();
}

class _AllPlayersStatsScreenState extends State<AllPlayersStatsScreen> {
  final _pageCtrl = PageController(viewportFraction: 0.9);
  late final List<num> _pointDivider;

  @override
  void initState() {
    super.initState();
    _pointDivider = _setPointsDivider();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppHeader(
        title: context.read<MatchInfo>().match.shortName,
      ),
      body: BlocConsumer<MatchCreditBloc, MatchCreditState>(
        listener: (context, state) {
          if (state is MatchCreditFetchingSuccess)
            Future.delayed(
              const Duration(milliseconds: 100),
              () => _pageCtrl.animateToPage(
                widget.data.selectedIndex,
                duration: const Duration(milliseconds: 100),
                curve: Curves.linear,
              ),
            );
        },
        builder: (context, state) {
          if (state is MatchCreditFetchingSuccess)
            return PageView.builder(
              controller: _pageCtrl,
              itemCount: widget.data.matchPoint.fantasy.length,
              itemBuilder: (context, i) => _playerInfo(i),
            );
          else if (state is MatchCreditFetchingFailure)
            return ErrorView(error: state.error);
          return LoadingIndicator();
        },
      ),
    );
  }

  Widget _playerInfo(int i) {
    final fantasy = widget.data.matchPoint.fantasy[i];
    final player = fantasy.player;
    return Padding(
      padding: EdgeInsets.fromLTRB(2, 8, 2, context.bottomPadding(8)),
      child: Card(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: Row(
                children: [
                  RoundedShadowImage(
                    url: _getPlayerImageUrl(player?.key),
                    errorIcon: imgCricketerPlaceholder,
                    size: 50,
                  ),
                  SizedBox(
                    width: 16,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          player?.name ?? '',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        Text(
                          '${_playerType(player)} | ${_countryName(player?.teamKey)}',
                        ),
                        Text('Season Points: ${fantasy.seasonPoints}'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Divider(),
            SizedBox(
              height: 8,
            ),
            Row(
              children: [
                _pointCredit('Points', fantasy.matchPoints),
                _pointCredit('Credits', _matchCredit(player?.key)),
              ],
            ),
            Expanded(
              child: Column(
                children: [
                  Container(
                    child: _tableTitles(
                      event: 'Event',
                      actual: 'Actual',
                      points: 'Points',
                      title: true,
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    margin: const EdgeInsets.only(top: 8),
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  Expanded(
                    child: ListView.separated(
                      itemCount: playerStats.length,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      itemBuilder: (context, index) => _tableTitles(
                        event: playerStats[index],
                        actual: _pointsValues(fantasy)[index] ~/
                            _pointDivider[index],
                        points: _pointsValues(fantasy)[index],
                      ),
                      separatorBuilder: (context, i) => Divider(
                        height: 24,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getPlayerImageUrl(String? playerKey) {
    try {
      return (context.read<ImageDataBloc>().state as ImageDataFetchingSuccess)
          .imageData
          .playerImages
          .where((image) => image.playerKey == playerKey)
          .first
          .image;
    } catch (e) {
      return '';
    }
  }

  String _playerType(FantasyPlayer? player) {
    if (player == null) return '';
    if (player.seasonalRole.contains(playerRoles[0]))
      return 'WK';
    else if (player.seasonalRole.contains(playerRoles[1]))
      return 'BAT';
    else if (player.seasonalRole.contains(playerRoles[2])) return 'AR';
    return 'BOWL';
  }

  String _countryName(String? playerTeamKey) {
    try {
      return widget.data.matchPoint.teams
          .where((team) => team.key == playerTeamKey)
          .first
          .name;
    } catch (e) {
      return '';
    }
  }

  double _matchCredit(String? playerKey) {
    try {
      return (context.read<MatchCreditBloc>().state
              as MatchCreditFetchingSuccess)
          .matchCredit
          .fantasyPoints
          .where((point) => point.player?.key == playerKey)
          .first
          .creditValue;
    } catch (e) {
      return 0;
    }
  }

  Widget _pointCredit(String label, dynamic value) => Expanded(
        child: Column(
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              '$value',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            )
          ],
        ),
      );

  Widget _tableTitles({
    required String event,
    dynamic actual,
    dynamic points,
    bool title = false,
  }) {
    Widget label(dynamic text, [TextAlign? textAlign]) => Text(
          text,
          textAlign: textAlign,
          style: TextStyle(
            fontWeight: title ? FontWeight.bold : FontWeight.w500,
          ),
        );
    return Padding(
      padding: const EdgeInsets.only(left: 12),
      child: Row(
        children: [
          Expanded(
            flex: 10,
            child: label(event),
          ),
          Expanded(
            flex: 3,
            child: label('$actual', TextAlign.center),
          ),
          Expanded(
            flex: 3,
            child: label('$points', TextAlign.center),
          ),
        ],
      ),
    );
  }

  List<num> _setPointsDivider() {
    final format = context.read<MatchInfo>().match.format;
    switch (format) {
      case matchT10:
        return t10PointDivider;
      case matchT20:
        return t20PointDivider;
      case matchOneDay:
        return oneDayPointDivider;
      default:
        return testPointDivider;
    }
  }

  List<num> _pointsValues(Fantasy fantasy) {
    final breakup = fantasy.breakup;
    return List.generate(playerStats.length, (i) {
      try {
        return breakup.where((data) => data.metricRuleIndex == i).first.points;
      } catch (e) {
        return 0.0;
      }
    });
  }
}
