import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:the_super11/blocs/app_update/app_update_bloc.dart';
import 'package:the_super11/blocs/contest/all_contests/all_contests_bloc.dart';
import 'package:the_super11/blocs/contest/create_contest/create_contest_bloc.dart';
import 'package:the_super11/blocs/contest/join_contest/join_contest_bloc.dart';
import 'package:the_super11/blocs/contest/user_contests/user_contests_bloc.dart';
import 'package:the_super11/blocs/matches/all_upcoming_matches/all_upcoming_matches_bloc.dart';
import 'package:the_super11/blocs/matches/image_data/image_data_bloc.dart';
import 'package:the_super11/blocs/matches/my_teams/my_teams_bloc.dart';
import 'package:the_super11/blocs/matches/recent_matches/recent_matches_bloc.dart';
import 'package:the_super11/blocs/matches/score_details/score_details_bloc.dart';
import 'package:the_super11/blocs/matches/team_and_contest_count/team_and_contest_count_bloc.dart';
import 'package:the_super11/blocs/theme/theme_bloc.dart';

class GlobalBlocProvider extends MultiProvider {
  GlobalBlocProvider({Key? key, required Widget child})
      : super(
          key: key,
          providers: [
            BlocProvider(
              create: (context) => ThemeBloc()..add(GetTheme()),
            ),
            BlocProvider<AppUpdateBloc>(
              create: (context) => AppUpdateBloc()..add(CheckAppUpdate()),
            ),
            BlocProvider<RecentMatchesBloc>(
              create: (context) => RecentMatchesBloc(),
            ),
            BlocProvider<AllUpcomingMatchesBloc>(
              create: (context) => AllUpcomingMatchesBloc(),
            ),
            BlocProvider<JoinContestBloc>(
              create: (context) => JoinContestBloc(),
            ),
            BlocProvider<TeamAndContestCountBloc>(
              create: (context) => TeamAndContestCountBloc(),
            ),
            BlocProvider<ImageDataBloc>(
              create: (context) => ImageDataBloc(),
            ),
            BlocProvider<MyTeamsBloc>(
              create: (context) => MyTeamsBloc(),
            ),
            BlocProvider<AllContestsBloc>(
              create: (context) => AllContestsBloc(),
            ),
            BlocProvider<UserContestsBloc>(
              create: (context) => UserContestsBloc(),
            ),
            BlocProvider<CreateContestBloc>(
              create: (context) => CreateContestBloc(),
            ),
            BlocProvider<ScoreDetailsBloc>(
              create: (context) => ScoreDetailsBloc(),
            ),
          ],
          child: child,
        );
}
