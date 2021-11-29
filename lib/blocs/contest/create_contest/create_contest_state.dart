part of 'create_contest_bloc.dart';

abstract class CreateContestState extends Equatable {
  const CreateContestState();

  @override
  List<Object> get props => [];
}

class CreateContestInitial extends CreateContestState {}

class CreateContestInProgress extends CreateContestState {}

class CreateContestSuccess extends CreateContestState {
  final String message;

  CreateContestSuccess(this.message);
}

class CreateContestFailure extends CreateContestState {
  final String error;

  CreateContestFailure(this.error);
}
