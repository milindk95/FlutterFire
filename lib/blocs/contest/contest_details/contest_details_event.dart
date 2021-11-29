part of 'contest_details_bloc.dart';

abstract class ContestDetailsEvent extends Equatable {
  const ContestDetailsEvent();

  @override
  List<Object?> get props => [];
}

class GetContestDetails extends ContestDetailsEvent {}
