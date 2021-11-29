import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_fire/blocs/contest/all_contests/all_contests_bloc.dart';
import 'package:flutter_fire/blocs/contest/user_contests/user_contests_bloc.dart';
import 'package:flutter_fire/blocs/matches/image_data/image_data_bloc.dart';
import 'package:flutter_fire/blocs/matches/my_teams/my_teams_bloc.dart';
import 'package:flutter_fire/blocs/matches/team_and_contest_count/team_and_contest_count_bloc.dart';
import 'package:flutter_fire/core/extensions.dart';
import 'package:flutter_fire/core/providers/match_info_provider.dart';
import 'package:flutter_fire/models/models.dart';
import 'package:flutter_fire/ui/screens/contest/all_contest_list.dart';
import 'package:flutter_fire/ui/screens/contest/contest_app_header.dart';
import 'package:flutter_fire/ui/screens/contest/create_contest_screen.dart';
import 'package:flutter_fire/ui/screens/contest/join_contest_screen.dart';
import 'package:flutter_fire/ui/screens/contest/my_contest_list.dart';
import 'package:flutter_fire/ui/screens/match/my_teams.dart';
import 'package:flutter_fire/ui/screens/teams/create_team_screen.dart';
import 'package:flutter_fire/ui/widgets/widgets.dart';

class ContestListScreen extends StatefulWidget {
  static const route = '/contest-list';

  const ContestListScreen({Key? key}) : super(key: key);

  @override
  _ContestListScreenState createState() => _ContestListScreenState();
}

class _ContestListScreenState extends State<ContestListScreen> {
  late final MyMatch _match;
  late final TeamAndContestCountBloc _countBloc;
  late final ImageDataBloc _imageDataBloc;
  late final AllContestsBloc _allContestsBloc;
  late final UserContestsBloc _userContestsBloc;
  int _selectedIndex = 0;
  GlobalKey _slidingControlKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _match = context.read<MatchInfo>().match;
    _countBloc = context.read<TeamAndContestCountBloc>();
    _imageDataBloc = context.read<ImageDataBloc>();
    _allContestsBloc = context.read<AllContestsBloc>();
    _userContestsBloc = context.read<UserContestsBloc>();
    _countBloc.setMatchId(_match.id);
    _imageDataBloc.setMatchId(_match.id);
  }

  @override
  void dispose() {
    _countBloc.add(ResetTeamAndContestCount());
    _imageDataBloc.add(ResetImageData());
    _allContestsBloc.add(ResetAllContests());
    _userContestsBloc.add(ResetUserContests());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ContestAppHeader(
        showAddMoney: true,
        actions: [
          if (context.watch<AllContestsBloc>().state
              is AllContestsFetchingSuccess)
            IconButton(
              onPressed: _createORJoinContest,
              splashRadius: 22,
              icon: Icon(
                Icons.emoji_events_outlined,
                size: 24,
              ),
            ),
        ],
      ),
      body: Column(
        children: [
          BlocBuilder<TeamAndContestCountBloc, TeamAndContestCountState>(
            builder: (context, state) {
              return SlidingControl(
                key: _slidingControlKey,
                labels: [
                  'Contests',
                  'Teams ${state is TeamAndContestCountFetchingSuccess ? '(${state.team})' : ''}',
                  'My Contests ${state is TeamAndContestCountFetchingSuccess ? '(${state.contest})' : ''}',
                ],
                onIndexChanged: (i) => setState(() => _selectedIndex = i),
              );
            },
          ),
          if (_selectedIndex == 0)
            Expanded(
              child: AllContestList(),
            ),
          if (_selectedIndex == 1)
            Expanded(
              child: MyTeams(topPadding: 0, bottomPadding: 64),
            ),
          if (_selectedIndex == 2)
            Expanded(
              child: MyContestList(
                onJoinContest: () {
                  _slidingControlKey = GlobalKey();
                  setState(() => _selectedIndex = 0);
                },
              ),
            ),
        ],
      ),
      floatingActionButton: Visibility(
        visible: _showCreateTeamButton,
        child: FloatingActionButton(
          onPressed: () async {
            final team =
                (_countBloc.state as TeamAndContestCountFetchingSuccess).team;
            final maxTeamAllow = _selectedIndex == 0
                ? (context.read<AllContestsBloc>().state
                        as AllContestsFetchingSuccess)
                    .contestData
                    .maxTeamSize
                : (context.read<MyTeamsBloc>().state as MyTeamsFetchingSuccess)
                    .myTeam
                    .maxTeamAllow;
            if (team >= maxTeamAllow) {
              context.showAlert(
                title: 'Maximum',
                message:
                    'You can create maximum $maxTeamAllow teams for one match.',
              );
              return;
            }
            Navigator.of(context).pushNamed(
              CreateTeamScreen.route,
              arguments: CreateTeamScreenData(isCopied: true),
            );
          },
          tooltip: 'Create Team',
          child: Icon(
            Icons.add,
            color: Theme.of(context).colorScheme.primaryVariant,
          ),
        ),
      ),
    );
  }

  bool get _showCreateTeamButton {
    final countBloc = context.watch<TeamAndContestCountBloc>();
    if (countBloc.state is TeamAndContestCountFetchingSuccess) {
      if (_selectedIndex == 0) {
        return context.watch<AllContestsBloc>().state
            is AllContestsFetchingSuccess;
      } else if (_selectedIndex == 1)
        return context.watch<MyTeamsBloc>().state is MyTeamsFetchingSuccess;
    }
    return false;
  }

  void _createORJoinContest() => showCupertinoModalPopup<void>(
        context: context,
        builder: (BuildContext context) => CupertinoActionSheet(
          actions: <CupertinoActionSheetAction>[
            CupertinoActionSheetAction(
              child: const Text('Create a Contest'),
              onPressed: () {
                Navigator.pop(context);
                Navigator.of(context).pushNamed(
                  CreateContestScreen.route,
                  arguments: CreateContestScreenData(
                    commission: (context.read<AllContestsBloc>().state
                            as AllContestsFetchingSuccess)
                        .contestData
                        .privateContestCommission,
                  ),
                );
              },
            ),
            CupertinoActionSheetAction(
              child: Text('Enter Contest Code'),
              onPressed: () {
                Navigator.pop(context);
                Navigator.of(context).pushNamed(JoinContestScreen.route);
              },
            )
          ],
          cancelButton: CupertinoActionSheetAction(
            isDestructiveAction: true,
            child: const Text('Cancel'),
            onPressed: () => Navigator.pop(context),
          ),
        ),
      );
}
