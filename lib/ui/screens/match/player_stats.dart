import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flutter_fire/blocs/matches/image_data/image_data_bloc.dart';
import 'package:flutter_fire/blocs/matches/match_point/match_point_bloc.dart';
import 'package:flutter_fire/models/models.dart';
import 'package:flutter_fire/ui/resources/resources.dart';
import 'package:flutter_fire/ui/screens/match/all_players_stats_screen.dart';
import 'package:flutter_fire/ui/widgets/widgets.dart';

class PlayerStats extends StatefulWidget {
  const PlayerStats({Key? key}) : super(key: key);

  @override
  _PlayerStatsState createState() => _PlayerStatsState();
}

class _PlayerStatsState extends State<PlayerStats> {
  final _refreshController = RefreshController();

  @override
  void initState() {
    super.initState();
    context.read<MatchPointBloc>().add(GetMatchPoint());
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MatchPointBloc, MatchPointState>(
      listener: (context, state) {
        _refreshController.refreshCompleted();
        if (state is MatchPointRefreshingError)
          showTopSnackBar(context, CustomSnackBar.error(message: state.error));
      },
      builder: (context, state) {
        if (state is MatchPointFetchingSuccess)
          return Column(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondary,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 6,
                      child: Text(
                        'Players',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        'Points',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SmartRefresher(
                  controller: _refreshController,
                  header: RefreshHeader(),
                  onRefresh: () =>
                      context.read<MatchPointBloc>().add(RefreshMatchPoint()),
                  child: _playerList(state.matchPoint),
                ),
              ),
            ],
          );
        else if (state is MatchPointFetchingFailure)
          return ErrorView(error: state.error);
        return LoadingIndicator();
      },
    );
  }

  Widget _playerList(MatchPoint matchPoint) => ListView.separated(
        itemCount: matchPoint.fantasy.length,
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
        itemBuilder: (context, i) => InkWell(
          onTap: () => Navigator.of(context).pushNamed(
            AllPlayersStatsScreen.route,
            arguments: AllPlayersStatsScreenData(
              matchPoint: matchPoint,
              selectedIndex: i,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                RoundedShadowImage(
                  url: _getPlayerImageUrl(matchPoint.fantasy[i].player?.key),
                  errorIcon: imgCricketerPlaceholder,
                  size: 40,
                ),
                SizedBox(
                  width: 12,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        matchPoint.fantasy[i].player?.name ?? '',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        '${_playerType(matchPoint.fantasy[i].player)} | ${_countryName(matchPoint.teams, matchPoint.fantasy[i].player?.teamKey)}',
                        style: TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ),
                Text(
                  '${matchPoint.fantasy[i].matchPoints}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  width: 16,
                )
              ],
            ),
          ),
        ),
        separatorBuilder: (context, i) => Divider(
          height: 0,
        ),
      );

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

  String _countryName(List<TeamDetails> teamDetails, String? playerTeamKey) {
    try {
      return teamDetails
          .where((team) => team.key == playerTeamKey)
          .first
          .shortName;
    } catch (e) {
      return '';
    }
  }
}
