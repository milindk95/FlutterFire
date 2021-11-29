part of 'match_credit_bloc.dart';

abstract class MatchCreditState extends Equatable {
  const MatchCreditState();

  @override
  List<Object> get props => [];
}

class MatchCreditInitial extends MatchCreditState {}

class MatchCreditFetching extends MatchCreditState {}

class MatchCreditFetchingSuccess extends MatchCreditState {
  final MatchCredit matchCredit;

  MatchCreditFetchingSuccess(this.matchCredit);
}

class MatchCreditFetchingFailure extends MatchCreditState {
  final String error;

  MatchCreditFetchingFailure(this.error);
}
