part of 'match_credit_bloc.dart';

abstract class MatchCreditEvent extends Equatable {
  const MatchCreditEvent();

  @override
  List<Object?> get props => [];
}

class GetMatchCredit extends MatchCreditEvent {}
