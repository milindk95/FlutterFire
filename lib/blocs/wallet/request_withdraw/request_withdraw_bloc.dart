import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_fire/repository/wallet/accounts_repository.dart';

part 'request_withdraw_event.dart';

part 'request_withdraw_state.dart';

class RequestWithdrawBloc
    extends Bloc<RequestWithdrawEvent, RequestWithdrawState> {
  AccountsRepository _accountsRepo = AccountsRepository();

  RequestWithdrawBloc() : super(RequestWithdrawInitial());

  @override
  Stream<RequestWithdrawState> mapEventToState(
      RequestWithdrawEvent event) async* {
    if (event is RequestForWithdraw) {
      yield RequestWithdrawProcessing();
      final result = await _accountsRepo.requestForWithdraw({
        'withdrawAmount': event.withdrawAmount,
        'fundAccountId': event.selectedAccountId
      });
      if (result.data != null)
        yield RequestWithdrawSuccess(result.data!);
      else
        yield RequestWithdrawFailure(result.error);
    }
  }
}
