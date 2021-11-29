import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_fire/blocs/contest/match_credit/match_credit_bloc.dart';
import 'package:flutter_fire/blocs/matches/image_data/image_data_bloc.dart';
import 'package:flutter_fire/core/extensions.dart';
import 'package:flutter_fire/models/models.dart';
import 'package:flutter_fire/ui/resources/resources.dart';
import 'package:flutter_fire/ui/screens/contest/contest_app_header.dart';
import 'package:flutter_fire/ui/screens/match/team_preview_screen.dart';
import 'package:flutter_fire/ui/screens/teams/select_captain_vice_captain_screen.dart';
import 'package:flutter_fire/ui/widgets/widgets.dart';

part 'create_team_bottom_rounded_clipper.dart';

class CreateTeamScreenData {
  final Team? team;
  final bool isCopied;

  CreateTeamScreenData({
    this.team,
    this.isCopied = false,
  });
}

class CreateTeamScreen extends StatefulWidget {
  static const route = '/create-team';
  final CreateTeamScreenData data;

  const CreateTeamScreen({Key? key, required this.data}) : super(key: key);

  @override
  _CreateTeamScreenState createState() => _CreateTeamScreenState();
}

class _CreateTeamScreenState extends State<CreateTeamScreen> {
  final _pageCtrl = PageController();
  int _selectedIndex = 0;

  late List<FantasyPoint> _players;
  late List<TeamDetails> _teamDetails;
  late ImageData _imageData;

  final List<String> _selectedWK = [],
      _selectedBAT = [],
      _selectedAR = [],
      _selectedBOWL = [];

  final _minWK = 1, _maxWK = 4;
  final _minBAT = 3, _maxBAT = 6;
  final _minAR = 1, _maxAR = 4;
  final _minBOWL = 3, _maxBOWL = 6;
  final _maxPlayer = 11, _maxPlayerPerTeam = 7;

  bool _disableWK = false, _disableBAT = false;
  bool _disableAR = false, _disableBOWL = false;

  int _firstTeamTotalPlayers = 0, _secondTeamTotalPlayers = 0;

  bool _sortByPlayers = false, _sortByPoints = false, _sortByCredits = false;

  double _credit = 100;

  @override
  void initState() {
    super.initState();
    _imageData =
        (context.read<ImageDataBloc>().state as ImageDataFetchingSuccess)
            .imageData;
    if (widget.data.team != null) {
      final team = widget.data.team!;
      _selectedWK.addAll(team.wicketKeepers.map((wk) => wk.id).toList());
      _selectedBAT.addAll(team.batsmen.map((bat) => bat.id).toList());
      _selectedAR.addAll(team.allRounders.map((ar) => ar.id).toList());
      _selectedBOWL.addAll(team.bowlers.map((bowl) => bowl.id).toList());
      _disableWK = _disableBAT = _disableAR = _disableBOWL = true;
    }
  }

  Future<bool> _onBack() async {
    if (_totalSelectedPlayer > 0) {
      context.showConfirmation(
        title: 'Confirmation',
        message: 'All changes will discard. Are you sure to go back?',
        positiveText: 'Discard',
        positiveAction: () => Navigator.of(context).pop(),
      );
      return false;
    }
    Navigator.of(context).pop();
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBack,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: ContestAppHeader(
          transparentBg: true,
          onBack: _onBack,
        ),
        body: BlocConsumer<MatchCreditBloc, MatchCreditState>(
          listener: (context, state) {
            if (state is MatchCreditFetchingSuccess) {
              _players = state.matchCredit.fantasyPoints;
              _teamDetails = state.matchCredit.teamDetails;
              if (widget.data.team != null) {
                final team = widget.data.team!;
                final players = [
                  ...team.wicketKeepers.map((wk) => wk.id),
                  ...team.batsmen.map((bat) => bat.id),
                  ...team.allRounders.map((ar) => ar.id),
                  ...team.bowlers.map((bowl) => bowl.id)
                ];
                final selectedPlayers = _players
                    .where((player) => players.contains(player.player?.key))
                    .toList();
                selectedPlayers.forEach((player) {
                  _credit = _credit - player.creditValue;
                  _teamDetails[0].key == player.player?.teamKey
                      ? _firstTeamTotalPlayers++
                      : _secondTeamTotalPlayers++;
                });
              }
            }
          },
          builder: (context, state) {
            if (state is MatchCreditFetchingSuccess)
              return Column(
                children: [
                  _cricketStadium(state.matchCredit.teamDetails),
                  Expanded(
                    child: _playerSelectingView(state.matchCredit),
                  ),
                  _selectedPlayerCountView(state.matchCredit.teamDetails),
                ],
              );
            else if (state is MatchCreditFetchingFailure)
              return ErrorView(error: state.error);
            return LoadingIndicator();
          },
        ),
      ),
    );
  }

  Widget _teams(List<TeamDetails> teamDetails) {
    String getTeamImageUrl(String teamKey) {
      try {
        return _imageData.teamImages
            .where((image) => image.teamKey == teamKey)
            .first
            .image;
      } catch (e) {
        return '';
      }
    }

    Widget teamLogoAndName(int i) => Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppNetworkImage(
              url: getTeamImageUrl(teamDetails[i].key),
              errorIcon: i == 0 ? imgTeam1Placeholder : imgTeam2Placeholder,
              height: 36,
            ),
            SizedBox(
              height: 4,
            ),
            Text(
              teamDetails[i].shortName,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            )
          ],
        );
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        teamLogoAndName(0),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: Text(
            'Vs',
            style: TextStyle(
              fontSize: 18,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        teamLogoAndName(1),
      ],
    );
  }

  Widget _cricketStadium(List<TeamDetails> teamDetails) {
    Widget playerSelector({
      required String icon,
      required String name,
      required int count,
      required int index,
    }) =>
        GestureDetector(
          onTap: () async {
            await _pageCtrl.animateToPage(
              index,
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeIn,
            );
            _selectedIndex = index;
          },
          behavior: HitTestBehavior.opaque,
          child: Container(
            width: 56,
            height: 90,
            decoration: BoxDecoration(
              color: _selectedIndex == index
                  ? Theme.of(context).primaryColor
                  : Theme.of(context).colorScheme.secondary,
              borderRadius: BorderRadius.circular(100),
              border: Border.all(
                color:
                    _selectedIndex == index ? Colors.white : Colors.transparent,
                width: 2,
              ),
              boxShadow: [
                if (_selectedIndex == index)
                  BoxShadow(
                    color: Theme.of(context)
                        .colorScheme
                        .primaryVariant
                        .withOpacity(0.2),
                    offset: Offset(1, 4),
                    blurRadius: 8,
                    spreadRadius: 3,
                  )
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  icon,
                  width: 24,
                  height: 24,
                  color: _selectedIndex == index
                      ? Colors.white
                      : Theme.of(context).colorScheme.primaryVariant,
                ),
                SizedBox(
                  height: 4,
                ),
                Text(
                  name,
                  style: TextStyle(
                    fontWeight: _selectedIndex == index
                        ? FontWeight.bold
                        : FontWeight.w500,
                    color: _selectedIndex == index
                        ? Colors.white
                        : Theme.of(context).colorScheme.primaryVariant,
                  ),
                ),
                SizedBox(
                  height: 4,
                ),
                CircleAvatar(
                  backgroundColor: _selectedIndex == index
                      ? Colors.white
                      : Theme.of(context).colorScheme.primaryVariant,
                  radius: 12,
                  child: Text(
                    '$count',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: _selectedIndex == index
                          ? Theme.of(context).primaryColor
                          : Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                )
              ],
            ),
          ),
        );
    return SizedBox(
      height: AppBar().preferredSize.height + 90 + 24 + context.topPadding(16),
      child: Stack(
        children: [
          Positioned.fill(
            bottom: 50,
            child: ClipPath(
              clipper: BottomRoundedClipper(),
              child: Container(
                color: Theme.of(context).primaryColor,
                child: Opacity(
                  child: Image.asset(
                    imgCricketStadium,
                    fit: BoxFit.cover,
                  ),
                  opacity: 0.18,
                ),
              ),
            ),
          ),
          Positioned(
            right: 12,
            top: context.topPadding(16),
            child: _teams(teamDetails),
          ),
          Positioned(
            left: MediaQuery.of(context).size.width * 0.08,
            bottom: 16,
            child: playerSelector(
              icon: icWicketKeeper,
              name: 'WK',
              count: _selectedWK.length,
              index: 0,
            ),
          ),
          Positioned(
            left: MediaQuery.of(context).size.width * 0.32,
            bottom: 0,
            child: playerSelector(
              icon: icBatsman,
              name: 'BAT',
              count: _selectedBAT.length,
              index: 1,
            ),
          ),
          Positioned(
            right: MediaQuery.of(context).size.width * 0.32,
            bottom: 0,
            child: playerSelector(
              icon: icAllRounder,
              name: 'AR',
              count: _selectedAR.length,
              index: 2,
            ),
          ),
          Positioned(
            right: MediaQuery.of(context).size.width * 0.08,
            bottom: 16,
            child: playerSelector(
              icon: icBowler,
              name: 'BOWL',
              count: _selectedBOWL.length,
              index: 3,
            ),
          ),
        ],
      ),
    );
  }

  Widget _playerSelectingView(MatchCredit credit) {
    String selectingText = 'Pick ' +
        (_selectedIndex == 0 || _selectedIndex == 2 ? '1-4' : '3-6') +
        ' ' +
        playerTypes[_selectedIndex];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  selectingText,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              MaterialButton(
                onPressed: _teamPreview,
                minWidth: 0,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    Icon(Icons.remove_red_eye),
                    SizedBox(
                      width: 2,
                    ),
                    Text('Team Preview')
                  ],
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondary,
          ),
          child: Row(
            children: [
              MaterialButton(
                onPressed: () {
                  _players.sort((a, b) =>
                      (_sortByPlayers ? b : a).player?.name.compareTo(
                          (_sortByPlayers ? a : b).player?.name ?? '') ??
                      0);
                  _sortByPlayers = !_sortByPlayers;
                  setState(() {});
                },
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                child: Row(
                  children: [
                    Text('Players'),
                    Icon(
                      Icons.swap_vert,
                      size: 20,
                      color: Theme.of(context).primaryColor,
                    )
                  ],
                ),
              ),
              Spacer(
                flex: 12,
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
                minWidth: 0,
                padding: EdgeInsets.zero,
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
                width: 12,
              ),
              MaterialButton(
                onPressed: () {
                  _players.sort((a, b) => (_sortByCredits ? b : a)
                      .creditValue
                      .compareTo((_sortByCredits ? a : b).creditValue));
                  _sortByCredits = !_sortByCredits;
                  setState(() {});
                },
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                minWidth: 0,
                padding: EdgeInsets.zero,
                child: Row(
                  children: [
                    Text('Credits'),
                    Icon(
                      Icons.swap_vert,
                      size: 20,
                      color: Theme.of(context).primaryColor,
                    )
                  ],
                ),
              ),
              Spacer(
                flex: 2,
              ),
            ],
          ),
        ),
        Expanded(
          child: _playersView(credit),
        ),
      ],
    );
  }

  Widget _playersView(MatchCredit credit) {
    final players = _players
        .where((point) =>
            point.player?.seasonalRole.contains(playerRoles[_selectedIndex]) ??
            false)
        .toList();
    return PageView.builder(
      itemCount: playerTypes.length,
      controller: _pageCtrl,
      onPageChanged: (page) {
        setState(() => _selectedIndex = page);
      },
      itemBuilder: (context, page) => ListView.separated(
        padding: EdgeInsets.zero,
        itemCount: players.length,
        itemBuilder: (context, i) => Opacity(
          opacity: _isDisable(players[i]) ? 0.6 : 1,
          child: GestureDetector(
            onTap: () => _updateOperation(player: players[i]),
            behavior: HitTestBehavior.opaque,
            child: Container(
              color: _selectedPlayerRowColor(players[i].player?.key ?? ''),
              padding: const EdgeInsets.all(8),
              child: Row(
                children: [
                  RoundedShadowImage(
                    url: _playerImageUrl(players[i].player?.key ?? ''),
                    errorIcon: imgCricketerPlaceholder,
                    size: 40,
                  ),
                  SizedBox(
                    width: 4,
                  ),
                  Expanded(
                    flex: 7,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          players[i].player?.name ?? '',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            Text(
                              _playerCountryName(
                                players[i].player?.teamKey ?? '',
                                credit.teamDetails,
                              ),
                              style: TextStyle(fontSize: 12),
                            ),
                            if (credit.finalPlayers
                                .contains(players[i].player?.key))
                              _playing11(),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Text(
                    '${players[i].seasonPoints}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Spacer(
                    flex: 2,
                  ),
                  Text(
                    '${players[i].creditValue}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Spacer(
                    flex: 1,
                  ),
                  _playerSelector(players[i].player?.key ?? ''),
                ],
              ),
            ),
          ),
        ),
        separatorBuilder: (context, i) => Divider(
          height: 0,
        ),
      ),
    );
  }

  Widget _playing11() => Container(
        margin: const EdgeInsets.only(left: 4),
        padding: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          color: Colors.green,
          borderRadius: BorderRadius.circular(50),
        ),
        child: Text(
          'In 11',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
      );

  String _playerImageUrl(String playerKey) {
    try {
      return _imageData.playerImages
          .where((image) => image.playerKey == playerKey)
          .first
          .image;
    } catch (e) {
      return '';
    }
  }

  String _playerCountryName(String teamKey, List<TeamDetails> teamDetails) {
    try {
      return teamDetails.where((team) => team.key == teamKey).first.shortName;
    } catch (e) {
      return '';
    }
  }

  bool _getSelectedFlag(String playerKey) {
    bool selected = false;
    if (_selectedIndex == 0)
      selected = _selectedWK.contains(playerKey);
    else if (_selectedIndex == 1)
      selected = _selectedBAT.contains(playerKey);
    else if (_selectedIndex == 2)
      selected = _selectedAR.contains(playerKey);
    else
      selected = _selectedBOWL.contains(playerKey);
    return selected;
  }

  Widget _playerSelector(String playerKey) {
    final selected = _getSelectedFlag(playerKey);
    return Icon(
      selected ? Icons.check_circle : Icons.radio_button_unchecked,
      color: selected ? Theme.of(context).primaryColor : null,
      size: 22,
    );
  }

  Color? _selectedPlayerRowColor(String playerKey) {
    final selected = _getSelectedFlag(playerKey);
    return selected ? Theme.of(context).colorScheme.secondary : null;
  }

  _updateOperation({required FantasyPoint player}) {
    int remain() => _maxPlayer - _totalSelectedPlayer;
    int minusWK() => _selectedWK.length >= _minWK || _selectedIndex == 0
        ? 0
        : (_minWK - _selectedWK.length);
    int minusBAT() => _selectedBAT.length >= _minBAT || _selectedIndex == 1
        ? 0
        : (_minBAT - _selectedBAT.length);
    int minusAR() => _selectedAR.length >= _minAR || _selectedIndex == 2
        ? 0
        : (_minAR - _selectedAR.length);
    int minusBOWL() => _selectedBOWL.length >= _minBOWL || _selectedIndex == 3
        ? 0
        : (_minBOWL - _selectedBOWL.length);
    int total() => minusWK() + minusBAT() + minusAR() + minusBOWL();

    int playerTeamIndex() =>
        _teamDetails[0].key == (player.player?.teamKey ?? '') ? 0 : 1;

    void maxPlayerFromOneTeamError(int i) => showTopSnackBar(
        context,
        CustomSnackBar.error(
            message:
                'You can select maximum $_maxPlayerPerTeam players from team ${_teamDetails[i].name}'));

    final playerKey = player.player?.key ?? '';
    final playerCredit = player.creditValue;

    late int max;
    if (_selectedIndex == 0)
      max = _maxWK;
    else if (_selectedIndex == 1)
      max = _maxBAT;
    else if (_selectedIndex == 2)
      max = _maxAR;
    else
      max = _maxBOWL;

    late List<String> playerKeys;
    if (_selectedIndex == 0)
      playerKeys = _selectedWK;
    else if (_selectedIndex == 1)
      playerKeys = _selectedBAT;
    else if (_selectedIndex == 2)
      playerKeys = _selectedAR;
    else
      playerKeys = _selectedBOWL;

    if (playerKeys.contains(playerKey)) {
      playerKeys.remove(playerKey);
      _credit = _credit + playerCredit;
      _managePlayerCount(player);
    } else {
      if (_totalSelectedPlayer == _maxPlayer) {
        showTopSnackBar(
            context,
            CustomSnackBar.error(
                message: 'You can maximum select $_maxPlayer players'));
        return;
      }
      if (playerKeys.length < max && (remain() - total()) > 0) {
        if (playerCredit > _credit) {
          showTopSnackBar(context,
              CustomSnackBar.error(message: 'You have only $_credit credit'));
          return;
        }
        if (playerTeamIndex() == 0 &&
            _firstTeamTotalPlayers == _maxPlayerPerTeam) {
          maxPlayerFromOneTeamError(0);
          return;
        }
        if (playerTeamIndex() == 1 &&
            _secondTeamTotalPlayers == _maxPlayerPerTeam) {
          maxPlayerFromOneTeamError(1);
          return;
        }
        playerKeys.add(playerKey);
        _credit = _credit - playerCredit;
        _managePlayerCount(player);
      } else {
        if (minusWK() > 0)
          showTopSnackBar(
              context,
              CustomSnackBar.error(
                  message: 'Select at least $_minWK Wicket-Keeper'));
        else if (minusBAT() > 0)
          showTopSnackBar(
              context,
              CustomSnackBar.error(
                  message: 'Select at least $_minBAT Batsman'));
        else if (minusAR() > 0)
          showTopSnackBar(
              context,
              CustomSnackBar.error(
                  message: 'Select at least $_minAR All-Rounder'));
        else if (minusBOWL() > 0)
          showTopSnackBar(
              context,
              CustomSnackBar.error(
                  message: 'Select at least $_minBOWL Bowler'));
      }
    }

    _disableWK = _selectedWK.length >= _minWK && (remain() - total()) == 0;
    _disableBAT = _selectedBAT.length >= _minBAT && (remain() - total()) == 0;
    _disableAR = _selectedAR.length >= _minAR && (remain() - total()) == 0;
    _disableBOWL =
        _selectedBOWL.length >= _minBOWL && (remain() - total()) == 0;

    setState(() {});
  }

  void _managePlayerCount(FantasyPoint player) {
    final playerTeamKey = player.player?.teamKey ?? '';
    final exist = _selectedPlayers
        .where((playerKey) => playerKey == player.player?.key)
        .isEmpty;
    if (_teamDetails[0].key == playerTeamKey) {
      exist ? _firstTeamTotalPlayers-- : _firstTeamTotalPlayers++;
    } else {
      exist ? _secondTeamTotalPlayers-- : _secondTeamTotalPlayers++;
    }
  }

  bool _isDisable(FantasyPoint player) {
    final playerKey = player.player?.key;
    final playerCredit = player.creditValue;
    final maxPlayerPerTeam = _teamDetails[0].key == player.player?.teamKey
        ? _firstTeamTotalPlayers
        : _secondTeamTotalPlayers;
    if (_selectedIndex == 0 &&
        (_disableWK ||
            _credit < playerCredit ||
            maxPlayerPerTeam == _maxPlayerPerTeam) &&
        !_selectedWK.contains(playerKey))
      return true;
    else if (_selectedIndex == 1 &&
        (_disableBAT ||
            _credit < playerCredit ||
            maxPlayerPerTeam == _maxPlayerPerTeam) &&
        !_selectedBAT.contains(playerKey))
      return true;
    else if (_selectedIndex == 2 &&
        (_disableAR ||
            _credit < playerCredit ||
            maxPlayerPerTeam == _maxPlayerPerTeam) &&
        !_selectedAR.contains(playerKey))
      return true;
    else if (_selectedIndex == 3 &&
        (_disableBOWL ||
            _credit < playerCredit ||
            maxPlayerPerTeam == _maxPlayerPerTeam) &&
        !_selectedBOWL.contains(playerKey)) return true;
    return false;
  }

  Widget _selectedPlayerCountView(List<TeamDetails> teamDetails) {
    Widget label(String label) => Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color:
                Theme.of(context).colorScheme.secondaryVariant.withOpacity(0.8),
          ),
        );
    Widget countText(dynamic count) => Text(
          '$count',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        );
    Widget countDot(Color color) => Padding(
          padding: const EdgeInsets.only(right: 2),
          child: CircleAvatar(
            radius: 3,
            backgroundColor: color,
          ),
        );
    Color _getTeamColor(String teamKey, int i) {
      final defaultColor = i == 0 ? team1Color : team2Color;
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

    return Container(
      color: Theme.of(context).colorScheme.secondary,
      padding: EdgeInsets.fromLTRB(12, 8, 12, context.bottomPadding(8)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              label(teamDetails[0].shortName),
              Row(
                children: [
                  countDot(_getTeamColor(teamDetails[0].key, 0)),
                  countText(_firstTeamTotalPlayers),
                ],
              )
            ],
          ),
          Column(
            children: [
              label(teamDetails[1].shortName),
              Row(
                children: [
                  countDot(_getTeamColor(teamDetails[1].key, 1)),
                  countText(_secondTeamTotalPlayers),
                ],
              )
            ],
          ),
          Column(
            children: [
              label('Players'),
              countText('$_totalSelectedPlayer/11'),
            ],
          ),
          Container(
            width: 1.2,
            height: 40,
            color: Theme.of(context).colorScheme.primaryVariant,
          ),
          Column(
            children: [
              label('Credit Left'),
              countText('$_credit'),
            ],
          ),
          AbsorbPointer(
            absorbing: _totalSelectedPlayer != _maxPlayer,
            child: MaterialButton(
              onPressed: () => Navigator.of(context).pushNamed(
                SelectCaptainViceCaptainScreen.route,
                arguments: SelectCaptainViceCaptainScreenData(
                  players: _players
                      .where((player) =>
                          _selectedPlayers.contains(player.player?.key ?? ''))
                      .toList(),
                  teamDetails: _teamDetails,
                  imageData: _imageData,
                  selectedWK: _selectedWK,
                  selectedBAT: _selectedBAT,
                  selectedAR: _selectedAR,
                  selectedBOWL: _selectedBOWL,
                  captain: widget.data.team?.captain.first ?? '',
                  viceCaptain: widget.data.team?.viceCaptain.first ?? '',
                  teamId: widget.data.team?.id,
                  isCopied: widget.data.isCopied,
                ),
              ),
              child: Text(
                'Next',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
              color: Theme.of(context)
                  .primaryColor
                  .withOpacity(_totalSelectedPlayer == _maxPlayer ? 1.0 : 0.5),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          )
        ],
      ),
    );
  }

  List<String> get _selectedPlayers =>
      [..._selectedWK, ..._selectedBAT, ..._selectedAR, ..._selectedBOWL];

  int get _totalSelectedPlayer =>
      _selectedWK.length +
      _selectedBAT.length +
      _selectedAR.length +
      _selectedBOWL.length;

  void _teamPreview() {
    Navigator.of(context).pushNamed(
      TeamPreviewScreen.route,
      arguments: TeamPreviewScreenData(
        imageData: _imageData,
        teamDetails: _teamDetails,
        team: Team(
          teamName: widget.data.team?.teamName ?? '',
          captain: [widget.data.team?.captain.first ?? ''],
          viceCaptain: [widget.data.team?.viceCaptain.first ?? ''],
          wicketKeepers: List.generate(
              _selectedWK.length, (i) => PlayerInfo(id: _selectedWK[i])),
          batsmen: List.generate(
              _selectedBAT.length, (i) => PlayerInfo(id: _selectedBAT[i])),
          allRounders: List.generate(
              _selectedAR.length, (i) => PlayerInfo(id: _selectedAR[i])),
          bowlers: List.generate(
              _selectedBOWL.length, (i) => PlayerInfo(id: _selectedBOWL[i])),
        ),
      ),
    );
  }
}
