part of 'my_referral_bloc.dart';

abstract class MyReferralState extends Equatable {
  const MyReferralState();

  @override
  List<Object> get props => [];
}

class MyReferralFetching extends MyReferralState {}

class MyReferralFetchingSuccess extends MyReferralState {
  final List<MyReferral> myReferrals;

  MyReferralFetchingSuccess(this.myReferrals);
}

class MyReferralFetchingFailure extends MyReferralState {
  final String error;

  MyReferralFetchingFailure(this.error);
}
