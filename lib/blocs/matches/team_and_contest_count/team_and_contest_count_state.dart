part of 'team_and_contest_count_bloc.dart';

abstract class TeamAndContestCountState extends Equatable {
  const TeamAndContestCountState();

  @override
  List<Object> get props => [];
}

class TeamAndContestCountFetching extends TeamAndContestCountState {}

class TeamAndContestCountFetchingSuccess extends TeamAndContestCountState {
  final int team;
  final int contest;

  TeamAndContestCountFetchingSuccess(this.team, this.contest);
}

class TeamAndContestCountFetchingFailure extends TeamAndContestCountState {
  final String error;

  TeamAndContestCountFetchingFailure(this.error);
}
