part of 'team_details_bloc.dart';

abstract class TeamDetailsEvent extends Equatable {
  const TeamDetailsEvent();

  @override
  List<Object?> get props => [];
}

class GetTeamDetails extends TeamDetailsEvent {
  final String? teamId;

  GetTeamDetails(this.teamId);
}
