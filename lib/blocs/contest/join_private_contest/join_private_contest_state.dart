part of 'join_private_contest_bloc.dart';

abstract class JoinPrivateContestState extends Equatable {
  const JoinPrivateContestState();

  @override
  List<Object> get props => [];
}

class JoinPrivateContestInitial extends JoinPrivateContestState {}

class JoinPrivateContestInProgress extends JoinPrivateContestState {}

class JoinPrivateContestSuccess extends JoinPrivateContestState {
  final String message;

  JoinPrivateContestSuccess(this.message);
}

class JoinPrivateContestFailure extends JoinPrivateContestState {
  final String error;

  JoinPrivateContestFailure(this.error);
}
