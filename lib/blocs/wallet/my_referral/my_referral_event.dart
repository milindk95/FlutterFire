part of 'my_referral_bloc.dart';

abstract class MyReferralEvent extends Equatable {
  const MyReferralEvent();

  @override
  List<Object?> get props => [];
}

class GetMyReferral extends MyReferralEvent {}
