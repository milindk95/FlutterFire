import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:the_super11/core/api/api_handler.dart';
import 'package:the_super11/ui/routes.dart';

import 'blocs/theme/theme_bloc.dart';
import 'core/providers/global_bloc_provider.dart';
import 'core/providers/match_info_provider.dart';
import 'core/providers/user_info_provider.dart';
import 'ui/resources/resources.dart';

final navigatorKey = GlobalKey<NavigatorState>();

class TheSuper11App extends StatelessWidget {
  final String apiUrl;

  TheSuper11App({Key? key, required this.apiUrl}) : super(key: key) {
    ApiHandler.setBaseUrl(apiUrl);
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<UserInfo>(create: (context) => UserInfo()),
        Provider(create: (context) => MatchInfo())
      ],
      child: GlobalBlocProvider(
        child: BlocBuilder<ThemeBloc, ThemeState>(
          builder: (context, state) {
            SystemChrome.setSystemUIOverlayStyle(state is ThemeLight
                ? SystemUiOverlayStyle.dark
                : SystemUiOverlayStyle.light);
            return MaterialApp(
              title: 'The Super11',
              debugShowCheckedModeBanner: false,
              navigatorKey: navigatorKey,
              theme: themeData(
                context,
                state is ThemeLight ? ThemeMode.light : ThemeMode.dark,
              ),
              onGenerateRoute: onGenerateRoute,
              builder: (context, child) => ScrollConfiguration(
                behavior:
                    ScrollBehavior().copyWith(physics: BouncingScrollPhysics()),
                child: child!,
              ),
            );
          },
        ),
      ),
    );
  }
}
