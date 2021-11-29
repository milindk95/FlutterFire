part of 'create_contest_bloc.dart';

abstract class CreateContestEvent extends Equatable {
  const CreateContestEvent();

  @override
  List<Object?> get props => [];
}

class CreateContest extends CreateContestEvent {
  final Map<String, dynamic> body;

  CreateContest(this.body);
}

class ResetCreateContest extends CreateContestEvent {}
