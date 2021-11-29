import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_super11/blocs/matches/my_teams/my_teams_bloc.dart';
import 'package:the_super11/blocs/matches/team_and_contest_count/team_and_contest_count_bloc.dart';
import 'package:the_super11/blocs/team/manage_team/create_update_team_bloc.dart';
import 'package:the_super11/core/extensions.dart';
import 'package:the_super11/core/providers/match_info_provider.dart';
import 'package:the_super11/models/models.dart';
import 'package:the_super11/ui/resources/resources.dart';
import 'package:the_super11/ui/screens/contest/contest_app_header.dart';
import 'package:the_super11/ui/screens/match/team_preview_screen.dart';
import 'package:the_super11/ui/widgets/widgets.dart';

class SelectCaptainViceCaptainScreenData {
  final List<FantasyPoint> players;
  final List<TeamDetails> teamDetails;
  final ImageData imageData;
  final List<String> selectedWK;
  final List<String> selectedBAT;
  final List<String> selectedAR;
  final List<String> selectedBOWL;
  final String captain;
  final String viceCaptain;
  final String? teamId;
  final bool isCopied;

  SelectCaptainViceCaptainScreenData({
    required this.players,
    required this.teamDetails,
    required this.imageData,
    required this.selectedWK,
    required this.selectedBAT,
    required this.selectedAR,
    required this.selectedBOWL,
    required this.captain,
    required this.viceCaptain,
    required this.teamId,
    required this.isCopied,
  });
}

class SelectCaptainViceCaptainScreen extends StatefulWidget {
  static const route = '/select-captain-vice-caption';
  final SelectCaptainViceCaptainScreenData data;

  const SelectCaptainViceCaptainScreen({Key? key, required this.data})
      : super(key: key);

  @override
  _SelectCaptainViceCaptainScreenState createState() =>
      _SelectCaptainViceCaptainScreenState();
}

class _SelectCaptainViceCaptainScreenState
    extends State<SelectCaptainViceCaptainScreen> {
  late final List<FantasyPoint> _players;
  String _selectedCaption = '', _selectedViceCaptain = '';
  bool _sortByPoints = false;

  @override
  void initState() {
    super.initState();
    _players = widget.data.players;
    if (_players
        .where((player) => player.player?.key == widget.data.captain)
        .isNotEmpty) _selectedCaption = widget.data.captain;
    if (_players
        .where((player) => player.player?.key == widget.data.viceCaptain)
        .isNotEmpty) _selectedViceCaptain = widget.data.viceCaptain;
  }

  @override
  Widget build(BuildContext context) {
    return UIBlocker(
      block: context.watch<CreateUpdateTeamBloc>().state
          is CreateUpdateTeamInProgress,
      child: Scaffold(
        appBar: ContestAppHeader(),
        body: Column(
          children: [
            SizedBox(
              height: 4,
            ),
            Text('Captain(C) get 2x points'),
            Text('Vice Captain(VC) get 1.5x points'),
            SizedBox(
              height: 4,
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Players',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  MaterialButton(
                    onPressed: () {
                      _players.sort((a, b) => (_sortByPoints ? b : a)
                          .seasonPoints
                          .compareTo((_sortByPoints ? a : b).seasonPoints));
                      _sortByPoints = !_sortByPoints;
                      setState(() {});
                    },
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    child: Row(
                      children: [
                        Text('Points'),
                        Icon(
                          Icons.swap_vert,
                          size: 20,
                          color: Theme.of(context).primaryColor,
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 4,
                  ),
                  Text(
                    'C',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    width: 30,
                  ),
                  Text(
                    'VC',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    width: 8,
                  )
                ],
              ),
            ),
            Expanded(
              child: Stack(
                children: [
                  Positioned.fill(
                    child: ListView.builder(
                      itemCount: playerTypes.length,
                      padding: EdgeInsets.only(bottom: 100),
                      itemBuilder: (context, i) => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                              vertical: 8,
                              horizontal: 12,
                            ),
                            color: Theme.of(context)
                                .colorScheme
                                .secondary
                                .withOpacity(0.5),
                            child: Text(playerTypes[i]),
                          ),
                          _playersView(i),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: context.bottomPadding(12),
                    left: 12,
                    right: 12,
                    child: _bottomButtons(),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _playersView(int i) {
    final players = _players
        .where((player) =>
            player.player?.seasonalRole.contains(playerRoles[i]) ?? true)
        .toList();

    String playerImageUrl(String playerKey) {
      try {
        return widget.data.imageData.playerImages
            .where((image) => image.playerKey == playerKey)
            .first
            .image;
      } catch (e) {
        return '';
      }
    }

    String playerCountryName(String teamKey) {
      try {
        return widget.data.teamDetails
            .where((team) => team.key == teamKey)
            .first
            .shortName;
      } catch (e) {
        return '';
      }
    }

    return ListView.separated(
      itemCount: players.length,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(8),
      itemBuilder: (context, i) {
        final playerKey = players[i].player?.key ?? '';
        return Row(
          children: [
            RoundedShadowImage(
              url: playerImageUrl(playerKey),
              errorIcon: imgCricketerPlaceholder,
              size: 40,
            ),
            SizedBox(
              width: 4,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    players[i].player?.name ?? '',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    playerCountryName(players[i].player?.teamKey ?? ''),
                    style: TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 4,
            ),
            Text(
              '${players[i].seasonPoints}',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(
              width: 26,
            ),
            _selectorButton(
              onPressed: () {
                if (_selectedViceCaptain == playerKey)
                  _selectedViceCaptain = '';
                _selectedCaption = playerKey;
                setState(() {});
              },
              label: 'C',
              points: '2',
              selectedKey: _selectedCaption,
              playerKey: playerKey,
            ),
            SizedBox(
              width: 12,
            ),
            _selectorButton(
              onPressed: () {
                if (_selectedCaption == playerKey) _selectedCaption = '';
                _selectedViceCaptain = playerKey;
                setState(() {});
              },
              label: 'VC',
              points: '1.5',
              selectedKey: _selectedViceCaptain,
              playerKey: playerKey,
            )
          ],
        );
      },
      separatorBuilder: (context, i) => Divider(
        height: 12,
      ),
    );
  }

  Widget _selectorButton({
    required VoidCallback onPressed,
    required String label,
    required String points,
    required String selectedKey,
    required String playerKey,
  }) =>
      SizedBox(
        width: 36,
        height: 36,
        child: MaterialButton(
          onPressed: onPressed,
          shape: CircleBorder(
            side: BorderSide(color: Theme.of(context).primaryColor),
          ),
          minWidth: 0,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          padding: EdgeInsets.zero,
          child: Text(
            selectedKey == playerKey ? '${points}X' : label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: selectedKey == playerKey ? Colors.white : null,
            ),
          ),
          color:
              selectedKey == playerKey ? Theme.of(context).primaryColor : null,
        ),
      );

  Widget _bottomButtons() => Row(
        children: [
          Expanded(
            child: MaterialButton(
              onPressed: _teamPreview,
              child: Text('Team Preview'),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
                side: BorderSide(color: Theme.of(context).primaryColor),
              ),
              color: Theme.of(context).colorScheme.secondary,
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
          ),
          SizedBox(
            width: 16,
          ),
          Expanded(
            child: AbsorbPointer(
              absorbing:
                  _selectedCaption.isEmpty || _selectedViceCaptain.isEmpty,
              child: Opacity(
                opacity:
                    _selectedCaption.isEmpty || _selectedViceCaptain.isEmpty
                        ? 0.5
                        : 1,
                child: _saveTeam(),
              ),
            ),
          )
        ],
      );

  void _teamPreview() {
    final selectedWK = widget.data.selectedWK;
    final selectedBAT = widget.data.selectedBAT;
    final selectedAR = widget.data.selectedAR;
    final selectedBOWL = widget.data.selectedBOWL;
    Navigator.of(context).pushNamed(
      TeamPreviewScreen.route,
      arguments: TeamPreviewScreenData(
        imageData: widget.data.imageData,
        teamDetails: widget.data.teamDetails,
        team: Team(
          captain: [_selectedCaption],
          viceCaptain: [_selectedViceCaptain],
          wicketKeepers: List.generate(
              selectedWK.length, (i) => PlayerInfo(id: selectedWK[i])),
          batsmen: List.generate(
              selectedBAT.length, (i) => PlayerInfo(id: selectedBAT[i])),
          allRounders: List.generate(
              selectedAR.length, (i) => PlayerInfo(id: selectedAR[i])),
          bowlers: List.generate(
              selectedBOWL.length, (i) => PlayerInfo(id: selectedBOWL[i])),
        ),
      ),
    );
  }

  Widget _saveTeam() =>
      BlocConsumer<CreateUpdateTeamBloc, CreateUpdateTeamState>(
        listener: (context, state) {
          if (state is CreateUpdateTeamFailure)
            showTopSnackBar(
                context, CustomSnackBar.error(message: state.error));
          else if (state is CreateUpdateTeamSuccess) {
            showTopSnackBar(
                context, CustomSnackBar.success(message: state.message));
            context.read<MyTeamsBloc>().add(GetMyTeams());
            if (widget.data.isCopied)
              context
                  .read<TeamAndContestCountBloc>()
                  .add(GetTeamAndContestCount());
            Navigator.of(context).pop();
            Navigator.of(context).pop();
          }
        },
        builder: (context, state) {
          return MaterialButton(
            onPressed: () {
              final update =
                  widget.data.teamId != null && !widget.data.isCopied;
              final body = {
                'captain': _selectedCaption,
                'viceCaptain': _selectedViceCaptain,
                'wicketKeepers':
                    widget.data.selectedWK.map((wk) => {'id': wk}).toList(),
                'batsmans':
                    widget.data.selectedBAT.map((bat) => {'id': bat}).toList(),
                'allRounders':
                    widget.data.selectedAR.map((ar) => {'id': ar}).toList(),
                'bowlers': widget.data.selectedBOWL
                    .map((bowl) => {'id': bowl})
                    .toList()
              }..addAll(
                  update ? {} : {'match': context.read<MatchInfo>().match.id});
              context.read<CreateUpdateTeamBloc>().add(update
                  ? UpdateTeam(widget.data.teamId!, body)
                  : CreateTeam(body));
            },
            child: state is CreateUpdateTeamInProgress
                ? CupertinoActivityIndicator()
                : Text(
                    'Save Team',
                    style: TextStyle(color: Colors.white),
                  ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
            color: Theme.of(context).primaryColor,
            padding: const EdgeInsets.symmetric(vertical: 14),
          );
        },
      );
}
