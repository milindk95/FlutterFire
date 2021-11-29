import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_fire/core/extensions.dart';
import 'package:flutter_fire/core/providers/match_info_provider.dart';
import 'package:flutter_fire/models/models.dart';
import 'package:flutter_fire/ui/resources/resources.dart';
import 'package:flutter_fire/ui/widgets/widgets.dart';

class TeamPreviewScreenData {
  final ImageData imageData;
  final Team team;
  final List<TeamDetails> teamDetails;
  final bool showEdit;

  TeamPreviewScreenData({
    required this.imageData,
    required this.team,
    required this.teamDetails,
    this.showEdit = true,
  });
}

class TeamPreviewScreen extends StatefulWidget {
  static const route = '/team-preview';
  final TeamPreviewScreenData data;

  const TeamPreviewScreen({Key? key, required this.data}) : super(key: key);

  @override
  _TeamPreviewScreenState createState() => _TeamPreviewScreenState();
}

class _TeamPreviewScreenState extends State<TeamPreviewScreen> {
  late final String _captainKey, _viceCaptainKey;

  @override
  void initState() {
    super.initState();
    _captainKey = widget.data.team.captain.first;
    _viceCaptainKey = widget.data.team.viceCaptain.first;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.black.withOpacity(0.24),
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: Icon(Icons.close),
          splashRadius: 22,
        ),
        title: Text(
          widget.data.team.teamName,
          style: TextStyle(
            fontSize: 16,
            color: Colors.white,
          ),
        ),
        actions: [
          if (context.read<MatchInfo>().match.status != matchNotStarted)
            Container(
              margin: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 12,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.4),
                borderRadius: BorderRadius.circular(4),
              ),
              alignment: Alignment.center,
              child: Text(
                '${widget.data.team.totalPoints}',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          if (context.read<MatchInfo>().match.status == matchNotStarted &&
              widget.data.showEdit)
            Padding(
              padding: const EdgeInsets.only(right: 4),
              child: IconButton(
                onPressed: () => Navigator.of(context).pop(true),
                icon: Icon(Icons.edit),
                splashRadius: 22,
              ),
            ),
        ],
      ),
      body: Stack(
        children: [
          Image.asset(
            imgCricketGround,
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
          ),
          Column(
            children: [
              if (_totalPlayers > 0)
                Expanded(
                  child: SafeArea(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          if (widget.data.team.wicketKeepers.isNotEmpty)
                            _label('Wicket Keeper'),
                          _playerGrid(_getWicketKeeperData()),
                          if (widget.data.team.batsmen.isNotEmpty)
                            _label('Batsman'),
                          _playerGrid(_getBatsmanData()),
                          if (widget.data.team.allRounders.isNotEmpty)
                            _label('All Rounder'),
                          _playerGrid(_getAllRounderData()),
                          if (widget.data.team.bowlers.isNotEmpty)
                            _label('Bowler'),
                          _playerGrid(_getBowlerData()),
                        ],
                      ),
                      padding: const EdgeInsets.only(bottom: 4),
                    ),
                  ),
                ),
              if (_totalPlayers == 0)
                Expanded(
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 16,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.black.withOpacity(0.4),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'No player selected yet',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          MaterialButton(
                            onPressed: () => Navigator.of(context).pop(),
                            color: Colors.white,
                            child: Text('Select Players'),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              _teamsView(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _label(String label) => Padding(
        padding: const EdgeInsets.only(bottom: 4, top: 8),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      );

  Widget _playerGrid(List<_PreviewData> previewData) {
    return Wrap(
      spacing: MediaQuery.of(context).size.width * 0.05,
      alignment: WrapAlignment.center,
      children: List.generate(
        previewData.length,
        (i) => Column(
          children: [
            Stack(
              children: [
                AppNetworkImage(
                  url: previewData[i].playerImageUrl,
                  errorIcon: imgCricketerPlaceholder,
                  height: 54,
                ),
                if (previewData[i].isCaptain || previewData[i].isViceCaptain)
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      width: 18,
                      height: 18,
                      padding: const EdgeInsets.all(2),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: previewData[i].teamColor,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white),
                      ),
                      child: Text(
                        '${previewData[i].isCaptain ? 'C' : 'VC'}',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 8,
                        ),
                      ),
                    ),
                  )
              ],
            ),
            Container(
              constraints: BoxConstraints(
                  minWidth: MediaQuery.of(context).size.width * 0.18),
              padding: const EdgeInsets.symmetric(
                vertical: 2,
                horizontal: 4,
              ),
              decoration: BoxDecoration(
                color: previewData[i].teamColor,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                previewData[i].playerName,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
            Text(
              '${previewData[i].playerPoints * (previewData[i].isCaptain ? 2 : 1) * (previewData[i].isViceCaptain ? 1.5 : 1)}',
              style: TextStyle(color: Colors.white),
            )
          ],
        ),
      ),
    );
  }

  Widget _teamsView() {
    late String firstTeamImage, secondTeamImage;
    try {
      firstTeamImage = widget.data.imageData.teamImages[0].image;
      secondTeamImage = widget.data.imageData.teamImages[1].image;
    } catch (e) {
      firstTeamImage = '';
      secondTeamImage = '';
    }
    Widget teamImage(String url, String placeholder) => AppNetworkImage(
          url: url,
          errorIcon: placeholder,
          height: 24,
        );

    Widget teamName(String teamName) => Text(
          teamName,
          style: TextStyle(
            fontSize: 16,
            color: Colors.white,
          ),
        );
    return Container(
      padding: EdgeInsets.fromLTRB(8, 8, 8, context.bottomPadding(8)),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.24),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          teamImage(firstTeamImage, imgTeam1Placeholder),
          SizedBox(
            width: 4,
          ),
          teamName(widget.data.teamDetails.first.shortName),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              'Vs',
              style: TextStyle(color: Colors.white),
            ),
          ),
          teamImage(secondTeamImage, imgTeam2Placeholder),
          SizedBox(
            width: 4,
          ),
          teamName(widget.data.teamDetails.last.shortName),
        ],
      ),
    );
  }

  List<_PreviewData> _getWicketKeeperData() {
    final List<_PreviewData> previewData = [];
    widget.data.team.wicketKeepers.forEach((keeper) {
      previewData.add(_PreviewData(
        playerImageUrl: _getPlayerImage(keeper.id),
        playerName: _getPlayerName(keeper.id),
        playerPoints: keeper.matchPoints,
        isCaptain: _captainKey == keeper.id,
        isViceCaptain: _viceCaptainKey == keeper.id,
        teamColor: _getTeamColor(keeper.id),
      ));
    });
    return previewData;
  }

  List<_PreviewData> _getBatsmanData() {
    final List<_PreviewData> previewData = [];
    widget.data.team.batsmen.forEach((keeper) {
      previewData.add(_PreviewData(
        playerImageUrl: _getPlayerImage(keeper.id),
        playerName: _getPlayerName(keeper.id),
        playerPoints: keeper.matchPoints,
        isCaptain: _captainKey == keeper.id,
        isViceCaptain: _viceCaptainKey == keeper.id,
        teamColor: _getTeamColor(keeper.id),
      ));
    });
    return previewData;
  }

  List<_PreviewData> _getAllRounderData() {
    final List<_PreviewData> previewData = [];
    widget.data.team.allRounders.forEach((keeper) {
      previewData.add(_PreviewData(
        playerImageUrl: _getPlayerImage(keeper.id),
        playerName: _getPlayerName(keeper.id),
        playerPoints: keeper.matchPoints,
        isCaptain: _captainKey == keeper.id,
        isViceCaptain: _viceCaptainKey == keeper.id,
        teamColor: _getTeamColor(keeper.id),
      ));
    });
    return previewData;
  }

  List<_PreviewData> _getBowlerData() {
    final List<_PreviewData> previewData = [];
    widget.data.team.bowlers.forEach((keeper) {
      previewData.add(_PreviewData(
        playerImageUrl: _getPlayerImage(keeper.id),
        playerName: _getPlayerName(keeper.id),
        playerPoints: keeper.matchPoints,
        isCaptain: _captainKey == keeper.id,
        isViceCaptain: _viceCaptainKey == keeper.id,
        teamColor: _getTeamColor(keeper.id),
      ));
    });
    return previewData;
  }

  String _getPlayerImage(String key) {
    try {
      final playerImage = widget.data.imageData.playerImages
          .where((playerImage) => playerImage.playerKey == key)
          .first;
      return playerImage.image;
    } catch (e) {
      return '';
    }
  }

  String _getPlayerName(String key) {
    try {
      return widget.data.imageData.playerImages
          .where((image) => image.playerKey == key)
          .first
          .fullName
          .playerShortName;
    } catch (e) {
      return '';
    }
  }

  Color _getTeamColor(String key) {
    try {
      final teamKey = widget.data.imageData.playerImages
          .where((image) => image.playerKey == key)
          .first
          .teamKey;
      final teamImage = widget.data.imageData.teamImages
          .where((teamImage) => teamImage.teamKey == teamKey)
          .first;

      final firstTeam = teamImage == widget.data.imageData.teamImages.first;

      return teamImage.teamColor.getHexColor(
          defaultColor: firstTeam ? Colors.deepOrange : Colors.blue);
    } catch (e) {
      return Colors.deepOrange;
    }
  }

  int get _totalPlayers =>
      widget.data.team.wicketKeepers.length +
      widget.data.team.batsmen.length +
      widget.data.team.allRounders.length +
      widget.data.team.bowlers.length;
}

class _PreviewData {
  final String playerImageUrl;
  final String playerName;
  final num playerPoints;
  final Color teamColor;
  final bool isCaptain;
  final bool isViceCaptain;

  _PreviewData({
    required this.playerImageUrl,
    required this.playerName,
    required this.playerPoints,
    required this.teamColor,
    this.isCaptain = false,
    this.isViceCaptain = false,
  });
}
