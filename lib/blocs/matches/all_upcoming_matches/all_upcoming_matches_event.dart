part of 'all_upcoming_matches_bloc.dart';

@immutable
abstract class AllUpcomingMatchesEvent {}

class GetAllUpcomingMatches extends AllUpcomingMatchesEvent {}

class RefreshAllUpcomingMatches extends AllUpcomingMatchesEvent {}

class PagingAllUpcomingMatches extends AllUpcomingMatchesEvent {}
