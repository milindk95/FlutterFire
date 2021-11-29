part of 'all_contests_bloc.dart';

abstract class AllContestsEvent extends Equatable {
  const AllContestsEvent();

  @override
  List<Object?> get props => [];
}

class GetAllContests extends AllContestsEvent {}

class RefreshAllContests extends AllContestsEvent {}

class ResetAllContests extends AllContestsEvent {}
