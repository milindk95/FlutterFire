import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_fire/core/api/api_handler.dart';
import 'package:flutter_fire/repository/profile/user_accounts_repository.dart';

part 'add_account_event.dart';
part 'add_account_state.dart';

class AddAccountBloc extends Bloc<AddAccountEvent, AddAccountState> {
  final _accountsRepo = UserAccountsRepository();

  AddAccountBloc() : super(AddAccountInitial());

  @override
  Stream<AddAccountState> mapEventToState(AddAccountEvent event) async* {
    yield AddAccountInProgress();
    if (event is AddUPIAccount) {
      final result = await _accountsRepo.addUPIAccount(event.body);
      yield* _handleResult(result);
    } else if (event is AddBankAccount) {
      final result = await _accountsRepo.addBankAccount(
        photoFilePath: event.photoFilePath,
        fields: event.fields,
      );
      yield* _handleResult(result);
    }
  }

  Stream<AddAccountState> _handleResult(ApiResponse<String> result) async* {
    if (result.data != null)
      yield AddAccountSuccess(result.data!);
    else
      yield AddAccountFailure(result.error);
  }
}
