part of 'contest_details_bloc.dart';

abstract class ContestDetailsState extends Equatable {
  const ContestDetailsState();

  @override
  List<Object> get props => [];
}

class ContestDetailsInitial extends ContestDetailsState {}

class ContestDetailsFetching extends ContestDetailsState {}

class ContestDetailsFetchingSuccess extends ContestDetailsState {
  final Contest contest;

  ContestDetailsFetchingSuccess(this.contest);
}

class ContestDetailsFetchingFailure extends ContestDetailsState {
  final String error;

  ContestDetailsFetchingFailure(this.error);
}
