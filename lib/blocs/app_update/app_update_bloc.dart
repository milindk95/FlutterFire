import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:package_info/package_info.dart';
import 'package:the_super11/models/models.dart';
import 'package:the_super11/repository/app_update/app_update_repository.dart';

part 'app_update_event.dart';
part 'app_update_state.dart';

class AppUpdateBloc extends Bloc<AppUpdateEvent, AppUpdateState> {
  final _appUpdateRepo = AppUpdateRepository();

  AppUpdateBloc() : super(AppUpdateFetching());

  @override
  Stream<AppUpdateState> mapEventToState(AppUpdateEvent event) async* {
    if (event is CheckAppUpdate) {
      yield AppUpdateFetching();
      final result = await _appUpdateRepo.checkAppUpdate();
      if (result.data != null) {
        final packageInfo = await PackageInfo.fromPlatform();
        final currentVersion = packageInfo.version.replaceAll('.', '');
        final version = ((Platform.isIOS
                    ? result.data!.iOsVersion?.version
                    : result.data!.androidVersion?.version) ??
                '0')
            .replaceAll('.', '');
        if (int.parse(currentVersion) >= int.parse(version))
          yield AppIsLatest(result.data!);
        else if ((Platform.isIOS
                ? result.data!.iOsVersion?.isForceUpdate
                : result.data!.androidVersion?.isForceUpdate) ??
            false)
          yield AppHasForceUpdate(result.data!);
        else
          yield AppHasSoftUpdate(result.data!);
      } else
        yield AppUpdateFetchingFailure(result.error);
    }
  }
}
