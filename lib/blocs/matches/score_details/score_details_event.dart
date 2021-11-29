part of 'score_details_bloc.dart';

abstract class ScoreDetailsEvent extends Equatable {
  const ScoreDetailsEvent();

  @override
  List<Object?> get props => [];
}

class GetScoreDetails extends ScoreDetailsEvent {}

class RefreshScoreDetails extends ScoreDetailsEvent {}

class ResetScoreDetails extends ScoreDetailsEvent {}
