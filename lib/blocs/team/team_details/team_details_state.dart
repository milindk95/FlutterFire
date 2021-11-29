part of 'team_details_bloc.dart';

abstract class TeamDetailsState extends Equatable {
  const TeamDetailsState();

  @override
  List<Object> get props => [];
}

class TeamDetailsInitial extends TeamDetailsState {}

class TeamDetailsFetching extends TeamDetailsState {}

class TeamDetailsFetchingSuccess extends TeamDetailsState {
  final Team team;

  TeamDetailsFetchingSuccess(this.team);
}

class TeamDetailsFetchingFailure extends TeamDetailsState {
  final String error;

  TeamDetailsFetchingFailure(this.error);
}
