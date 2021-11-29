import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_fire/blocs/matches/image_data/image_data_bloc.dart';
import 'package:flutter_fire/blocs/matches/score_details/score_details_bloc.dart';
import 'package:flutter_fire/blocs/team/compare_team/compare_team_bloc.dart';
import 'package:flutter_fire/core/extensions.dart';
import 'package:flutter_fire/models/models.dart';
import 'package:flutter_fire/ui/resources/resources.dart';
import 'package:flutter_fire/ui/widgets/widgets.dart';

class CompareTeamScreenData {
  final List<ContestParticipation> participants;

  CompareTeamScreenData(this.participants);
}

class CompareTeamScreen extends StatefulWidget {
  static const route = '/compare-team';

  final CompareTeamScreenData data;

  const CompareTeamScreen({Key? key, required this.data}) : super(key: key);

  @override
  _CompareTeamScreenState createState() => _CompareTeamScreenState();
}

class _CompareTeamScreenState extends State<CompareTeamScreen> {
  @override
  void initState() {
    super.initState();
    context.read<CompareTeamBloc>().add(CompareTeam(
        widget.data.participants.map((p) => p.team?.id ?? '').toList()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppHeader(
        title: 'Compare Team',
      ),
      body: Column(
        children: [
          Card(
            margin: const EdgeInsets.all(10),
            child: Padding(
              padding: const EdgeInsets.all(6.0),
              child: _teamDetails(),
            ),
          ),
          Divider(
            height: 0,
          ),
          SizedBox(
            height: 10,
          ),
          Expanded(
            child: BlocBuilder<CompareTeamBloc, CompareTeamState>(
              builder: (context, state) {
                if (state is CompareTeamFetchingSuccess)
                  return SingleChildScrollView(
                    child: _playersView(),
                  );
                else if (state is CompareTeamFetchingFailure)
                  return ErrorView(error: state.error);
                return LoadingIndicator();
              },
            ),
          )
        ],
      ),
    );
  }

  Widget _playersView() => Column(
        children: [
          if (_differentPlayers(0).isNotEmpty ||
              _differentPlayers(1).isNotEmpty)
            Column(
              children: [
                _label('Different players'),
                _scoreDescription(0),
                SizedBox(
                  height: 16,
                ),
                Row(
                  children: [
                    Expanded(
                      child:
                          _playerList(players: _differentPlayers(0), index: 0),
                    ),
                    Expanded(
                      child:
                          _playerList(players: _differentPlayers(1), index: 1),
                    )
                  ],
                ),
                SizedBox(
                  height: 16,
                ),
              ],
            ),
          if (_commonPlayersDiffCaps(0).isNotEmpty ||
              _commonPlayersDiffCaps(1).isNotEmpty)
            Column(
              children: [
                Divider(),
                _label('Common players with different caps'),
                _scoreDescription(1),
                SizedBox(
                  height: 16,
                ),
                Row(
                  children: [
                    Expanded(
                      child: _playerList(
                          players: _commonPlayersDiffCaps(0), index: 0),
                    ),
                    Expanded(
                      child: _playerList(
                          players: _commonPlayersDiffCaps(1), index: 1),
                    )
                  ],
                ),
                SizedBox(
                  height: 16,
                ),
              ],
            ),
          if (_commonPlayers.isNotEmpty)
            Column(
              children: [
                Divider(),
                _label('Common players'),
                Text(
                  '${_commonPlayers.map((p) => p.matchPoints).reduce((a, b) => a + b)} Pts',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
                _playerList(players: _commonPlayers, index: 0),
              ],
            ),
          SizedBox(
            height: context.bottomPadding(12),
          )
        ],
      );

  Widget _teamDetails() {
    Widget teamName(int i, [TextAlign? textAlign]) => Expanded(
          child: Text(
            widget.data.participants[i].team?.teamName ?? '',
            textAlign: textAlign,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        );
    Widget teamRank(int i, [TextAlign? textAlign]) => Expanded(
          child: Text(
            '#${widget.data.participants[i].rank}',
            textAlign: textAlign,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Theme.of(context)
                  .colorScheme
                  .primaryVariant
                  .withOpacity(0.74),
            ),
          ),
        );
    Widget teamScore(int i, [TextAlign? textAlign]) => Text(
          '${widget.data.participants[i].team?.totalPoints}',
          textAlign: textAlign,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color:
                Theme.of(context).colorScheme.primaryVariant.withOpacity(0.74),
          ),
        );

    Widget scoreDescription() {
      final team1Points = widget.data.participants[0].team?.totalPoints ?? 0;
      final team2Points = widget.data.participants[1].team?.totalPoints ?? 0;
      int equality = team1Points.compareTo(team2Points);
      String teamName = '';
      if (equality == 1)
        teamName = widget.data.participants[0].team?.teamName ?? '';
      else if (equality == -1)
        teamName = widget.data.participants[1].team?.teamName ?? '';
      if (teamName.isNotEmpty) {
        final points = (team1Points.abs() - team2Points.abs()).abs();
        return Text.rich(
          TextSpan(
            text: '$teamName scored',
            children: [
              TextSpan(
                text: ' $points Pts ',
                style: TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextSpan(
                text: '${teamName.isNotEmpty ? 'more' : ''}',
              )
            ],
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
        );
      }
      return SizedBox.shrink();
    }

    return Column(
      children: [
        Row(
          children: [
            teamName(0),
            teamName(1, TextAlign.end),
          ],
        ),
        SizedBox(
          height: 2,
        ),
        Row(
          children: [
            teamRank(0),
            teamRank(1, TextAlign.end),
          ],
        ),
        SizedBox(
          height: 2,
        ),
        Text('Total Points'),
        SizedBox(
          height: 8,
        ),
        _ScoreShadow(),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(child: teamScore(0, TextAlign.end)),
            Container(
              height: 34,
              width: 2.6,
              color: Theme.of(context).primaryColor,
              margin: const EdgeInsets.symmetric(horizontal: 12),
            ),
            Expanded(child: teamScore(1)),
          ],
        ),
        _ScoreShadow(),
        SizedBox(
          height: 6,
        ),
        scoreDescription()
      ],
    );
  }

  Widget _label(String text) => Text(
        text,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      );

  Widget _scoreDescription(int i) {
    int equality = 0;
    num points = 0;
    final teams =
        (context.read<CompareTeamBloc>().state as CompareTeamFetchingSuccess)
            .teams;
    if (i == 0) {
      final left = _differentPlayers(0)
          .map((p) =>
              p.matchPoints *
              (teams[0].captain.contains(p.id) ? 2 : 1) *
              (teams[0].viceCaptain.contains(p.id) ? 1.5 : 1))
          .reduce((a, b) => a + b);
      final right = _differentPlayers(1)
          .map((p) =>
              p.matchPoints *
              (teams[1].captain.contains(p.id) ? 2 : 1) *
              (teams[1].viceCaptain.contains(p.id) ? 1.5 : 1))
          .reduce((a, b) => a + b);
      equality = left.compareTo(right);
      points = left > right ? left - right : right - left;
    } else {
      final left = _commonPlayersDiffCaps(0)
          .map((p) =>
              p.matchPoints *
              (teams[0].captain.contains(p.id) ? 2 : 1) *
              (teams[0].viceCaptain.contains(p.id) ? 1.5 : 1))
          .reduce((a, b) => a + b);
      final right = _commonPlayersDiffCaps(1)
          .map((p) =>
              p.matchPoints *
              (teams[1].captain.contains(p.id) ? 2 : 1) *
              (teams[1].viceCaptain.contains(p.id) ? 1.5 : 1))
          .reduce((a, b) => a + b);
      equality = left.compareTo(right);
      points = left > right ? left - right : right - left;
    }
    String text() {
      if (equality == 1)
        return widget.data.participants[0].team?.teamName ?? '';
      else if (equality == -1)
        return widget.data.participants[1].team?.teamName ?? '';
      return '';
    }

    return Text.rich(
      TextSpan(
        text: '${text()}${text().isNotEmpty ? ' scored' : ''}',
        children: [
          TextSpan(
            text: ' $points Pts ',
            style: TextStyle(
              color: Colors.green,
              fontWeight: FontWeight.bold,
            ),
          ),
          TextSpan(
            text: '${text().isNotEmpty ? 'more' : ''}',
          )
        ],
        style: TextStyle(fontWeight: FontWeight.w500),
      ),
    );
  }

  Widget _playerList({required List<PlayerInfo> players, required int index}) {
    Widget playerImage(int i) => RoundedShadowImage(
          url: _getPlayerImageUrl(players[i].id),
          errorIcon: imgCricketerPlaceholder,
          size: 36,
        );

    String captainVC(int i) {
      final teams =
          (context.read<CompareTeamBloc>().state as CompareTeamFetchingSuccess)
              .teams;
      if (index == 0)
        return teams[0].captain.contains(players[i].id)
            ? 'C'
            : teams[0].viceCaptain.contains(players[i].id)
                ? 'VC'
                : '';
      return teams[1].captain.contains(players[i].id)
          ? 'C'
          : teams[1].viceCaptain.contains(players[i].id)
              ? 'VC'
              : '';
    }

    Widget captainViceCaptainCircle(int i) => Container(
          width: 16,
          height: 16,
          margin: EdgeInsets.only(
            left: index == 0 ? 4 : 0,
            right: index == 1 ? 4 : 0,
          ),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border.all(
              color: Theme.of(context).colorScheme.secondaryVariant,
            ),
            shape: BoxShape.circle,
          ),
          child: Text(
            captainVC(i),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 8,
              fontWeight: FontWeight.bold,
            ),
          ),
        );

    Widget playerInfo(int i) => Expanded(
          child: Column(
            crossAxisAlignment:
                index == 0 ? CrossAxisAlignment.start : CrossAxisAlignment.end,
            children: [
              Wrap(
                children: [
                  if (captainVC(i).isNotEmpty && index == 1)
                    captainViceCaptainCircle(i),
                  Text(
                    _getPlayerName(players[i].id),
                  ),
                  if (captainVC(i).isNotEmpty && index == 0)
                    captainViceCaptainCircle(i)
                ],
              ),
              SizedBox(
                height: 2,
              ),
              Text(
                '${_countryName(players[i].id)}-${players[i].role}',
                style: TextStyle(
                  fontSize: 12,
                ),
              ),
            ],
          ),
        );

    Widget matchPoint(int i) => Column(
          crossAxisAlignment:
              index == 0 ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Text(
                '${players[i].matchPoints * (captainVC(i) == 'C' ? 2 : captainVC(i) == 'VC' ? 1.5 : 1)}'),
            if (captainVC(i).isNotEmpty)
              Text(
                '${players[i].matchPoints} x ${captainVC(i) == 'C' ? '2' : '1.5'}',
                style: TextStyle(fontSize: 12),
              )
          ],
        );

    return Container(
      decoration: BoxDecoration(
        border: Border(
          right: index == 0
              ? BorderSide(
                  width: 0.05,
                  color: Theme.of(context).colorScheme.secondaryVariant,
                )
              : BorderSide.none,
          left: index == 1
              ? BorderSide(
                  width: 0.05,
                  color: Theme.of(context).colorScheme.secondaryVariant,
                )
              : BorderSide.none,
        ),
      ),
      child: ListView.separated(
        itemCount: players.length,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.zero,
        itemBuilder: (context, i) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: index == 0
              ? Row(
                  children: [
                    playerImage(i),
                    SizedBox(
                      width: 10,
                    ),
                    playerInfo(i),
                    matchPoint(i),
                  ],
                )
              : Row(
                  children: [
                    matchPoint(i),
                    playerInfo(i),
                    SizedBox(
                      width: 10,
                    ),
                    playerImage(i),
                  ],
                ),
        ),
        separatorBuilder: (context, i) => Divider(),
      ),
    );
  }

  List<PlayerInfo> _differentPlayers(int i) {
    final state =
        context.read<CompareTeamBloc>().state as CompareTeamFetchingSuccess;
    return state.teams[i].allPlayers
        .toSet()
        .difference(state.teams[i == 0 ? 1 : 0].allPlayers.toSet())
        .toList();
  }

  List<PlayerInfo> _commonPlayersDiffCaps(int i) {
    final state =
        context.read<CompareTeamBloc>().state as CompareTeamFetchingSuccess;
    final filtered = state.teams[i].allPlayers.toSet()
      ..removeAll(_commonPlayers)
      ..removeAll(_differentPlayers(i));
    return filtered.toList();
  }

  List<PlayerInfo> get _commonPlayers {
    final state =
        context.read<CompareTeamBloc>().state as CompareTeamFetchingSuccess;
    return state.teams[0].allPlayers.where((player) {
      final contains = state.teams[1].allPlayers.contains(player);
      if (state.teams[0].captain.contains(player.id))
        return state.teams[1].captain.contains(player.id);
      else if (state.teams[0].viceCaptain.contains(player.id))
        return state.teams[1].viceCaptain.contains(player.id);
      else if (state.teams[1].captain.contains(player.id))
        return state.teams[0].captain.contains(player.id);
      else if (state.teams[1].viceCaptain.contains(player.id))
        return state.teams[0].viceCaptain.contains(player.id);
      return contains;
    }).toList();
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

  String _getPlayerName(String? playerKey) {
    try {
      return (context.read<ImageDataBloc>().state as ImageDataFetchingSuccess)
          .imageData
          .playerImages
          .where((image) => image.playerKey == playerKey)
          .first
          .fullName
          .playerShortName;
    } catch (e) {
      return '';
    }
  }

  String _countryName(String? playerKey) {
    try {
      final playerData =
          (context.read<ImageDataBloc>().state as ImageDataFetchingSuccess)
              .imageData
              .playerImages;
      final teamKey =
          playerData.where((data) => data.playerKey == playerKey).first.teamKey;
      final teams = (context.read<ScoreDetailsBloc>().state
              as ScoreDetailsFetchingSuccess)
          .score
          .teams;
      return teams.where((team) => team.key == teamKey).first.shortName;
    } catch (e) {
      return '';
    }
  }
}

class _ScoreShadow extends StatelessWidget {
  const _ScoreShadow({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 2.4,
      width: MediaQuery.of(context).size.width * 0.5,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).primaryColor.withOpacity(0.1),
            Theme.of(context).primaryColor.withOpacity(0.5),
            Theme.of(context).primaryColor,
            Theme.of(context).primaryColor.withOpacity(0.5),
            Theme.of(context).primaryColor.withOpacity(0.1),
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
    );
  }
}
