part of 'leaderboard_bloc.dart';

@immutable
abstract class LeaderboardState {}

class LeaderboardFetching extends LeaderboardState {}

class LeaderboardFetchingSuccess extends LeaderboardState {
  final List<ContestParticipation> participants;
  final int totalParticipants;
  final bool reachToMaxIndex;

  LeaderboardFetchingSuccess({
    required this.participants,
    required this.totalParticipants,
    this.reachToMaxIndex = false,
  });
}

class LeaderboardPagingError extends LeaderboardFetchingSuccess {
  final String error;

  LeaderboardPagingError({
    required List<ContestParticipation> participants,
    required int totalParticipants,
    required this.error,
  }) : super(
          participants: participants,
          totalParticipants: totalParticipants,
        );
}

class LeaderboardRefreshingError extends LeaderboardFetchingSuccess {
  final String error;

  LeaderboardRefreshingError({
    required List<ContestParticipation> participants,
    required int totalParticipants,
    required this.error,
  }) : super(
          participants: participants,
          totalParticipants: totalParticipants,
        );
}

class LeaderboardFetchingFailure extends LeaderboardState {
  final String error;

  LeaderboardFetchingFailure(this.error);
}
