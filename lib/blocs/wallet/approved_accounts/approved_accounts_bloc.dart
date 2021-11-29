import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:the_super11/models/models.dart';
import 'package:the_super11/repository/wallet/accounts_repository.dart';

part 'approved_accounts_event.dart';

part 'approved_accounts_state.dart';

class ApprovedAccountsBloc
    extends Bloc<ApprovedAccountsEvent, ApprovedAccountsState> {
  AccountsRepository _accountsRepo = AccountsRepository();

  ApprovedAccountsBloc() : super(ApprovedAccountsFetching());

  @override
  Stream<ApprovedAccountsState> mapEventToState(
      ApprovedAccountsEvent event) async* {
    if (event is GetApprovedAccounts) {
      final result = await _accountsRepo.getApprovedAccounts();
      if (result.data != null)
        yield ApprovedAccountsFetchingSuccess(result.data!);
      else
        yield ApprovedAccountsFetchingFailure(result.error);
    }
  }
}
