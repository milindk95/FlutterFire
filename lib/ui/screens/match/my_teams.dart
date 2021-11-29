import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_fire/blocs/matches/image_data/image_data_bloc.dart';
import 'package:flutter_fire/blocs/matches/my_teams/my_teams_bloc.dart';
import 'package:flutter_fire/blocs/matches/team_and_contest_count/team_and_contest_count_bloc.dart';
import 'package:flutter_fire/core/extensions.dart';
import 'package:flutter_fire/core/providers/match_info_provider.dart';
import 'package:flutter_fire/models/models.dart';
import 'package:flutter_fire/ui/resources/resources.dart';
import 'package:flutter_fire/ui/screens/match/team_preview_screen.dart';
import 'package:flutter_fire/ui/screens/teams/create_team_screen.dart';
import 'package:flutter_fire/ui/widgets/widgets.dart';

class MyTeams extends StatefulWidget {
  final double topPadding;
  final double bottomPadding;
  final bool enableSelection;
  final String? joinedContestId;
  final ValueChanged<String>? onTeamChanged;

  const MyTeams({
    Key? key,
    this.topPadding = 12,
    this.bottomPadding = 0,
    this.enableSelection = false,
    this.joinedContestId,
    this.onTeamChanged,
  }) : super(key: key);

  @override
  _MyTeamsState createState() => _MyTeamsState();
}

class _MyTeamsState extends State<MyTeams> {
  late final MyMatch _match;
  late ImageData _imageData;
  late List<Team> _teams = [];
  late List<TeamDetails> _teamDetails;
  late MyTeamsBloc _teamsBloc;
  late int _maxTeamAllow;
  int? _selectedIndex;

  @override
  void initState() {
    super.initState();
    _match = context.read<MatchInfo>().match;
    _teamsBloc = context.read<MyTeamsBloc>();
    _teamsBloc.setMatchId(_match.id);
  }

  @override
  void dispose() {
    _teamsBloc.add(ResetMyTeams());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MyTeamsBloc, MyTeamsState>(
      listener: (context, state) {
        if (state is MyTeamsFetchingSuccess) {
          _teams = state.myTeam.teams;
          _teamDetails = state.myTeam.teamDetails;
          _maxTeamAllow = state.myTeam.maxTeamAllow;
          if (widget.enableSelection) {
            for (Team team in _teams) {
              if (!team.contest.contains(widget.joinedContestId)) {
                _selectedIndex = _teams.indexOf(team);
                break;
              }
            }
            if (_selectedIndex != null)
              widget.onTeamChanged?.call(_teams[_selectedIndex!].id);
          }
        }
      },
      builder: (context, state) {
        if (state is MyTeamsFetchingSuccess) {
          return BlocBuilder<ImageDataBloc, ImageDataState>(
            builder: (context, imageDataState) {
              if (imageDataState is ImageDataFetchingSuccess) {
                _imageData = imageDataState.imageData;
                if (_teams.isNotEmpty) return _teamsView();
                return EmptyView(
                  message: 'No teams available',
                  image: imgNoTeamFound,
                );
              } else if (imageDataState is ImageDataFetchingFailure)
                return ErrorView(error: imageDataState.error);
              return LoadingIndicator();
            },
          );
        } else if (state is MyTeamsFetchingFailure)
          return ErrorView(error: state.error);
        return LoadingIndicator();
      },
    );
  }

  Widget _teamsView() => ListView.separated(
        itemCount: _teams.length,
        padding: EdgeInsets.fromLTRB(12, widget.topPadding, 12,
            context.bottomPadding(12) + widget.bottomPadding),
        itemBuilder: (context, i) => InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: () async {
            final result = await Navigator.of(context).pushNamed(
              TeamPreviewScreen.route,
              arguments: TeamPreviewScreenData(
                imageData: _imageData,
                team: _teams[i],
                teamDetails: _teamDetails,
                showEdit: !widget.enableSelection,
              ),
            );
            if (result == true) _navigateToCreateTeam(i);
          },
          child: Card(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    color: Theme.of(context).colorScheme.secondary,
                    child: _teamNameAndPointsAndOptions(i),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                        width: 12,
                      ),
                      _teamWisePlayerCount(i, 0),
                      SizedBox(
                        width: 30,
                      ),
                      _teamWisePlayerCount(i, 1),
                      Spacer(),
                      _captainViceCaptainInfo(
                        label: 'C',
                        name: _getCaptainName(i),
                        imageUrl: _getCaptainImageUrl(i),
                        teamColor:
                            _getCaptainViceCTeamColor(_teams[i].captain.first),
                      ),
                      SizedBox(
                        width: 12,
                      ),
                      _captainViceCaptainInfo(
                        label: 'VC',
                        name: _getViceCaptainName(i),
                        imageUrl: _getViceCaptainImageUrl(i),
                        teamColor: _getCaptainViceCTeamColor(
                            _teams[i].viceCaptain.first),
                      ),
                      SizedBox(
                        width: 12,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  _bottomCounts(i),
                ],
              ),
            ),
          ),
        ),
        separatorBuilder: (context, i) => SizedBox(
          height: 8,
        ),
      );

  Widget _teamNameAndPointsAndOptions(int i) => Row(
        children: [
          if (widget.enableSelection &&
              !_teams[i].contest.contains(widget.joinedContestId))
            IconButton(
              icon: Icon(
                _selectedIndex == i
                    ? Icons.check_circle
                    : Icons.radio_button_unchecked,
              ),
              onPressed: () {
                setState(() => _selectedIndex = i);
                widget.onTeamChanged?.call(_teams[i].id);
              },
              color: Theme.of(context).primaryColor,
              splashRadius: 12,
              padding: const EdgeInsets.fromLTRB(6, 6, 10, 6),
              constraints: BoxConstraints(maxHeight: 40, maxWidth: 40),
            ),
          Text(
            _teams[i].teamName,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          Spacer(),
          if (_teams[i].contest.contains(widget.joinedContestId))
            Text(
              'JOINED',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
            ),
          if (_match.status != matchNotStarted)
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Points',
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(
                  width: 4,
                ),
                Text(
                  '${_teams[i].totalPoints}',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          if (_match.status == matchNotStarted && !widget.enableSelection)
            Row(
              children: [
                MaterialButton(
                  onPressed: () => _navigateToCreateTeam(i),
                  shape: CircleBorder(),
                  color: Theme.of(context).primaryColor,
                  child: Icon(
                    Icons.edit,
                    color: Colors.white,
                    size: 20,
                  ),
                  minWidth: 0,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  padding: const EdgeInsets.all(6),
                ),
                SizedBox(
                  width: 10,
                ),
                Visibility(
                  visible: context.watch<TeamAndContestCountBloc>().state
                      is TeamAndContestCountFetchingSuccess,
                  child: MaterialButton(
                    onPressed: () {
                      final team = (context
                              .read<TeamAndContestCountBloc>()
                              .state as TeamAndContestCountFetchingSuccess)
                          .team;
                      if (team >= _maxTeamAllow) {
                        context.showAlert(
                          title: 'Maximum Team',
                          message:
                              'You can create maximum $_maxTeamAllow teams for this match.',
                        );
                        return;
                      }
                      _navigateToCreateTeam(i, true);
                    },
                    shape: CircleBorder(),
                    color: Theme.of(context).primaryColor,
                    child: Icon(
                      Icons.copy,
                      color: Colors.white,
                      size: 20,
                    ),
                    minWidth: 0,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    padding: const EdgeInsets.all(6),
                  ),
                ),
              ],
            )
        ],
      );

  Widget _captainViceCaptainInfo({
    required String imageUrl,
    required String name,
    required Color teamColor,
    required String label,
  }) =>
      Column(
        children: [
          Container(
            height: 56,
            width: 56,
            padding: const EdgeInsets.all(4),
            child: Stack(
              children: [
                Positioned.fill(
                  child: ClipOval(
                    child: AppNetworkImage(
                      url: imageUrl,
                      errorIcon: imgCricketerPlaceholder,
                    ),
                  ),
                ),
                Positioned(
                  right: 0,
                  child: CircleAvatar(
                    radius: 10,
                    backgroundColor: teamColor,
                    child: Text(
                      label,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            width: 70,
            child: Text(
              name,
              textAlign: TextAlign.center,
              maxLines: 1,
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      );

  Widget _teamWisePlayerCount(int i, int teamIndex) => Column(
        children: [
          Text(
            _match.teams[teamIndex].shortName,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          Row(
            children: [
              CircleAvatar(
                radius: 4,
                backgroundColor:
                    _getTeamColor(teamIndex, _match.teams[teamIndex].key),
              ),
              SizedBox(
                width: 2,
              ),
              Text(
                '${_getTotalTeamPlayers(i, _getTeamKey(teamIndex))}',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          )
        ],
      );

  String _getTeamKey(int teamIndex) {
    try {
      return _imageData.teamImages[teamIndex].teamKey;
    } catch (e) {
      return '';
    }
  }

  String _getCaptainImageUrl(int index) {
    try {
      final playerImage = _imageData.playerImages
          .where((playerImage) =>
              playerImage.playerKey == _teams[index].captain.first)
          .first;
      return playerImage.image;
    } catch (e) {
      return '';
    }
  }

  String _getViceCaptainImageUrl(int index) {
    try {
      final playerImage = _imageData.playerImages
          .where((playerImage) =>
              playerImage.playerKey == _teams[index].viceCaptain.first)
          .first;
      return playerImage.image;
    } catch (e) {
      return '';
    }
  }

  String _getCaptainName(int index) {
    try {
      return _imageData.playerImages
          .where((image) => image.playerKey == _teams[index].captain.first)
          .first
          .fullName
          .playerShortName;
    } catch (e) {
      return '';
    }
  }

  String _getViceCaptainName(int index) {
    try {
      return _imageData.playerImages
          .where((image) => image.playerKey == _teams[index].viceCaptain.first)
          .first
          .fullName
          .playerShortName;
    } catch (e) {
      return '';
    }
  }

  String _getTeamKeyByPlayer(String playerKey) {
    try {
      return _imageData.playerImages
          .where((image) => image.playerKey == playerKey)
          .first
          .teamKey;
    } catch (e) {
      return '';
    }
  }

  int _getTotalTeamPlayers(int index, String teamKey) {
    int totalPlayers = 0;

    final playerImage = _imageData.playerImages
        .where((image) => image.teamKey == teamKey)
        .toList();

    _teams[index].wicketKeepers.forEach((wk) {
      final filtered = playerImage.where((image) => image.playerKey == wk.id);
      if (filtered.isNotEmpty) totalPlayers++;
    });

    _teams[index].batsmen.forEach((bt) {
      final filtered = playerImage.where((image) => image.playerKey == bt.id);
      if (filtered.isNotEmpty) totalPlayers++;
    });

    _teams[index].allRounders.forEach((ar) {
      final filtered = playerImage.where((image) => image.playerKey == ar.id);
      if (filtered.isNotEmpty) totalPlayers++;
    });

    _teams[index].bowlers.forEach((bw) {
      final filtered = playerImage.where((image) => image.playerKey == bw.id);
      if (filtered.isNotEmpty) totalPlayers++;
    });

    return totalPlayers;
  }

  Color _getTeamColor(int teamIndex, String teamKey) {
    final defaultColor = teamIndex == 0 ? team1Color : team2Color;
    try {
      return _imageData.teamImages
          .where((image) => image.teamKey == teamKey)
          .first
          .teamColor
          .getHexColor(defaultColor: defaultColor);
    } catch (e) {
      return defaultColor;
    }
  }

  Color _getCaptainViceCTeamColor(String playerKey) {
    try {
      final teamImage = _imageData.teamImages
          .where((teamImage) =>
              teamImage.teamKey == _getTeamKeyByPlayer(playerKey))
          .first;

      final defaultColor =
          teamImage.teamKey == _teamDetails[0].key ? team1Color : team2Color;

      return teamImage.teamColor.getHexColor(defaultColor: defaultColor);
    } catch (e) {
      return team1Color;
    }
  }

  Widget _bottomCounts(int i) {
    Widget text(String label, int count) => Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(label),
            SizedBox(
              width: 2,
            ),
            Text(
              '$count',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        );
    return Container(
      padding: const EdgeInsets.all(4),
      color: Theme.of(context).colorScheme.secondary,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          text('WK', _teams[i].wicketKeepers.length),
          text('BAT', _teams[i].batsmen.length),
          text('AR', _teams[i].allRounders.length),
          text('BOWL', _teams[i].bowlers.length),
        ],
      ),
    );
  }

  void _navigateToCreateTeam(int i, [bool isCopied = false]) async {
    Navigator.of(context).pushNamed(
      CreateTeamScreen.route,
      arguments: CreateTeamScreenData(team: _teams[i], isCopied: isCopied),
    );
  }
}
