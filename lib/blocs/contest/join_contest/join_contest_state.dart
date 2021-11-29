part of 'join_contest_bloc.dart';

abstract class JoinContestState extends Equatable {
  const JoinContestState();

  @override
  List<Object> get props => [];
}

class JoinContestInitial extends JoinContestState {}

class JoinContestInProgress extends JoinContestState {}

class JoinContestSuccess extends JoinContestState {
  final String message;

  JoinContestSuccess(this.message);
}

class JoinContestFailure extends JoinContestState {
  final String error;

  JoinContestFailure(this.error);
}
