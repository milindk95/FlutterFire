part of 'score_details_bloc.dart';

abstract class ScoreDetailsState extends Equatable {
  const ScoreDetailsState();

  @override
  List<Object> get props => [];
}

class ScoreDetailsFetching extends ScoreDetailsState {}

class ScoreDetailsFetchingSuccess extends ScoreDetailsState {
  final Score score;

  ScoreDetailsFetchingSuccess(this.score);
}

class ScoreDetailsRefreshing extends ScoreDetailsFetchingSuccess {
  final Score score;

  ScoreDetailsRefreshing(this.score) : super(score);
}

class ScoreDetailsFetchingFailure extends ScoreDetailsState {
  final String error;

  ScoreDetailsFetchingFailure(this.error);
}
