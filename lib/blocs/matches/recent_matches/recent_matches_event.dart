part of 'recent_matches_bloc.dart';

abstract class RecentMatchesEvent extends Equatable {
  const RecentMatchesEvent();

  @override
  List<Object?> get props => [];
}

class GetRecentMatches extends RecentMatchesEvent {}
