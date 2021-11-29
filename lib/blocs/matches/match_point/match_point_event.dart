part of 'match_point_bloc.dart';

abstract class MatchPointEvent extends Equatable {
  const MatchPointEvent();

  @override
  List<Object?> get props => [];
}

class GetMatchPoint extends MatchPointEvent {}

class RefreshMatchPoint extends MatchPointEvent {}
