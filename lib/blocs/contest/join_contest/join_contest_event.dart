part of 'join_contest_bloc.dart';

abstract class JoinContestEvent extends Equatable {
  const JoinContestEvent();

  @override
  List<Object?> get props => [];
}

class JoinContest extends JoinContestEvent {
  final Map<String, dynamic> body;

  JoinContest(this.body);
}
