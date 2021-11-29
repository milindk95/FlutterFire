part of 'my_matches_bloc.dart';

@immutable
abstract class MyMatchesEvent {}

class GetMyMatches extends MyMatchesEvent {
  final int index;

  GetMyMatches(this.index);
}

class RefreshMyMatches extends MyMatchesEvent {
  final int index;

  RefreshMyMatches(this.index);
}

class PagingMyMatches extends MyMatchesEvent {
  final int index;

  PagingMyMatches(this.index);
}
