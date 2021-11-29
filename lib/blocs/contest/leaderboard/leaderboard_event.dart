part of 'leaderboard_bloc.dart';

@immutable
abstract class LeaderboardEvent {}

class GetLeaderboard extends LeaderboardEvent {}

class RefreshLeaderboard extends LeaderboardEvent {}

class PagingLeaderboard extends LeaderboardEvent {}
