import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_fire/blocs/app_update/app_update_bloc.dart';
import 'package:flutter_fire/core/utility.dart';
import 'package:flutter_fire/ui/resources/resources.dart';

class IosAppUpdateScreen extends StatefulWidget {
  static const route = '/ios-app-update';

  const IosAppUpdateScreen({Key? key}) : super(key: key);

  @override
  _IosAppUpdateScreenState createState() => _IosAppUpdateScreenState();
}

class _IosAppUpdateScreenState extends State<IosAppUpdateScreen> {
  @override
  Widget build(BuildContext context) {
    final state =
        context.read<AppUpdateBloc>().state as AppUpdateFetchingSuccess;
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: MediaQuery.of(context).padding.top + 40,
            ),
            Image.asset(
              icAppStore,
              width: 60,
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              'App Update available',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(
              height: 8,
            ),
            Text(state.appUpdate.iOsVersion?.description ?? ''),
            SizedBox(
              height: 16,
            ),
            _Button(
              text: 'Update App',
              onPressed: () => Utility.launchUrl(appStoreUrl),
            ),
            if (state is AppHasSoftUpdate)
              _Button(
                text: 'No Thanks',
                onPressed: () => Utility.initialNavigation(context),
              ),
          ],
        ),
      ),
    );
  }
}

class _Button extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const _Button({
    Key? key,
    required this.text,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: CupertinoButton(
        child: Text(text),
        color: CupertinoColors.activeBlue,
        onPressed: onPressed,
      ),
    );
  }
}
