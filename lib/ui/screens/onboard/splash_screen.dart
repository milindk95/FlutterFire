import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:the_super11/blocs/app_update/app_update_bloc.dart';
import 'package:the_super11/core/extensions.dart';
import 'package:the_super11/core/firebase_services.dart';
import 'package:the_super11/core/utility.dart';
import 'package:the_super11/ui/resources/resources.dart';
import 'package:the_super11/ui/screens/onboard/android_app_update_screen.dart';
import 'package:the_super11/ui/screens/onboard/ios_app_update_screen.dart';
import 'package:the_super11/ui/widgets/widgets.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _firebaseSetup();
  }

  /// Firebase setup
  Future<void> _firebaseSetup() async {
    final firebaseService = FirebaseServices();
    await firebaseService.setupNotification();
    firebaseService.setupCrashlytics();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Stack(
        children: [
          Center(
            child: Image.asset(
              imgSplashLogo,
              width: MediaQuery.of(context).size.width * 0.82,
              height: MediaQuery.of(context).size.width * 0.82,
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: context.bottomPadding(16),
            child: BlocConsumer<AppUpdateBloc, AppUpdateState>(
              listener: (context, state) {
                if (state is AppIsLatest) {
                  Utility.initialNavigation(context);
                } else if (state is AppHasSoftUpdate ||
                    state is AppHasForceUpdate)
                  Navigator.of(context).pushReplacementNamed(Platform.isIOS
                      ? IosAppUpdateScreen.route
                      : AndroidAppUpdateScreen.route);
                else if (state is AppUpdateFetchingFailure)
                  showTopSnackBar(
                      context, CustomSnackBar.error(message: state.error));
              },
              builder: (context, state) {
                if (state is AppUpdateFetchingFailure)
                  return Center(
                    child: _retryButton(),
                  );
                return CupertinoActivityIndicator();
              },
            ),
          )
        ],
      ),
    );
  }

  Widget _retryButton() => TextButton(
        child: Text(
          'Retry',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        style: TextButton.styleFrom(
          backgroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        onPressed: () => context.read<AppUpdateBloc>().add(CheckAppUpdate()),
      );
}
