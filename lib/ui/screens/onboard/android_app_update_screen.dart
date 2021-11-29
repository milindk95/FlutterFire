import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_fire/blocs/app_update/app_update_bloc.dart';
import 'package:provider/provider.dart';
import 'package:flutter_fire/core/utility.dart';
import 'package:flutter_fire/ui/resources/resources.dart';
import 'package:flutter_fire/ui/widgets/widgets.dart';

class AndroidAppUpdateScreen extends StatefulWidget {
  static const route = '/android-app-update';

  const AndroidAppUpdateScreen({Key? key}) : super(key: key);

  @override
  _AndroidAppUpdateScreenState createState() => _AndroidAppUpdateScreenState();
}

class _AndroidAppUpdateScreenState extends State<AndroidAppUpdateScreen> {
  @override
  Widget build(BuildContext context) {
    final state =
    context.read<AppUpdateBloc>().state as AppUpdateFetchingSuccess;
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: MediaQuery.of(context).padding.top + 40,
            ),
            Image.asset(
              icAndroid,
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
            SubmitButton(
              label: 'Update App',
              onPressed: () => Utility.launchUrl(androidApkUrl),
            ),
            if (state is AppHasSoftUpdate)
              Container(
                margin: const EdgeInsets.only(top: 12),
                child: SubmitButton(
                  label: 'No Thanks',
                  onPressed: () => Utility.initialNavigation(context),
                ),
              ),
            if (state is AppHasForceUpdate)
              Container(
                margin: const EdgeInsets.only(top: 12),
                child: SubmitButton(
                  label: 'Exit',
                  onPressed: () => SystemNavigator.pop(),
                ),
              )
          ],
        ),
      ),
    );
  }
}
