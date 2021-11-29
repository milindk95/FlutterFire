part of 'team_and_contest_count_bloc.dart';

abstract class TeamAndContestCountEvent extends Equatable {
  const TeamAndContestCountEvent();

  @override
  List<Object?> get props => [];
}

class GetTeamAndContestCount extends TeamAndContestCountEvent {}

class ResetTeamAndContestCount extends TeamAndContestCountEvent {}
