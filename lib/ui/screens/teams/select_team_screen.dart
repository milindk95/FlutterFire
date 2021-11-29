import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_fire/blocs/contest/all_contests/all_contests_bloc.dart';
import 'package:flutter_fire/blocs/matches/my_teams/my_teams_bloc.dart';
import 'package:flutter_fire/core/extensions.dart';
import 'package:flutter_fire/ui/screens/match/my_teams.dart';
import 'package:flutter_fire/ui/screens/teams/create_team_screen.dart';
import 'package:flutter_fire/ui/widgets/widgets.dart';

class SelectTeamScreenData {
  final String? contestId;

  SelectTeamScreenData({this.contestId});
}

class SelectTeamScreen extends StatefulWidget {
  static const route = '/select-team';
  final SelectTeamScreenData? data;

  const SelectTeamScreen({Key? key, this.data}) : super(key: key);

  @override
  _SelectTeamScreenState createState() => _SelectTeamScreenState();
}

class _SelectTeamScreenState extends State<SelectTeamScreen> {
  String? _selectedTeamId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppHeader(
        title: 'Select Team',
      ),
      body: Stack(
        children: [
          MyTeams(
            enableSelection: true,
            bottomPadding: 64,
            joinedContestId: widget.data?.contestId,
            onTeamChanged: (teamId) => setState(() => _selectedTeamId = teamId),
          ),
          if (context.watch<MyTeamsBloc>().state is MyTeamsFetchingSuccess)
            Positioned(
              bottom: context.bottomPadding(12),
              left: 12,
              right: 12,
              child: _bottomButtons(),
            )
        ],
      ),
    );
  }

  Widget _bottomButtons() => Row(
        children: [
          Expanded(
            child: MaterialButton(
              onPressed: _createTeam,
              child: Text('Create Team'),
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
              absorbing: _selectedTeamId == null,
              child: Opacity(
                opacity: _selectedTeamId != null ? 1 : 0.6,
                child: MaterialButton(
                  onPressed: () => Navigator.of(context).pop(_selectedTeamId),
                  child: Text(
                    'Join Contest',
                    style: TextStyle(color: Colors.white),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                  color: Theme.of(context).primaryColor,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
          )
        ],
      );

  void _createTeam() {
    final team =
        (context.read<AllContestsBloc>().state as AllContestsFetchingSuccess)
            .contestData
            .maxTeamSize;
    final availableTeam =
        (context.read<MyTeamsBloc>().state as MyTeamsFetchingSuccess)
            .myTeam
            .teams
            .length;
    if (team == availableTeam) {
      context.showAlert(
        title: 'Maximum Team',
        message: 'You can create maximum $team teams for this match.',
      );
      return;
    }
    Navigator.of(context).pushNamed(
      CreateTeamScreen.route,
      arguments: CreateTeamScreenData(isCopied: true),
    );
  }
}
