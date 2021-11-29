part of 'app_update_bloc.dart';

abstract class AppUpdateState extends Equatable {
  const AppUpdateState();

  @override
  List<Object> get props => [];
}

class AppUpdateFetching extends AppUpdateState {}

class AppUpdateFetchingSuccess extends AppUpdateState {
  final AppUpdate appUpdate;

  AppUpdateFetchingSuccess(this.appUpdate);
}

class AppHasSoftUpdate extends AppUpdateFetchingSuccess {
  AppHasSoftUpdate(AppUpdate appUpdate) : super(appUpdate);
}

class AppHasForceUpdate extends AppUpdateFetchingSuccess {
  AppHasForceUpdate(AppUpdate appUpdate) : super(appUpdate);
}

class AppIsLatest extends AppUpdateFetchingSuccess {
  AppIsLatest(AppUpdate appUpdate) : super(appUpdate);
}

class AppUpdateFetchingFailure extends AppUpdateState {
  final String error;

  AppUpdateFetchingFailure(this.error);
}
