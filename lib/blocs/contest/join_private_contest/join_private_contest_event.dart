part of 'join_private_contest_bloc.dart';

abstract class JoinPrivateContestEvent extends Equatable {
  const JoinPrivateContestEvent();

  @override
  List<Object?> get props => [];
}

class JoinPrivateContest extends JoinPrivateContestEvent {
  final String contestCode;
  final Map<String, dynamic> body;

  JoinPrivateContest({required this.contestCode, required this.body});
}
