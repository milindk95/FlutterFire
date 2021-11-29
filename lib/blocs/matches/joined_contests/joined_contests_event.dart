part of 'joined_contests_bloc.dart';

@immutable
abstract class JoinedContestsEvent {}

class GetJoinedContests extends JoinedContestsEvent {}

class RefreshJoinedContests extends JoinedContestsEvent {}

class PagingJoinedContests extends JoinedContestsEvent {}
