import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:the_super11/models/models.dart';
import 'package:the_super11/repository/profile/user_accounts_repository.dart';

part 'user_accounts_event.dart';
part 'user_accounts_state.dart';

class UserAccountsBloc extends Bloc<AllAccountsEvent, UserAccountsState> {
  final _accountsRepo = UserAccountsRepository();

  UserAccountsBloc() : super(UserAccountsFetching());

  @override
  Stream<UserAccountsState> mapEventToState(AllAccountsEvent event) async* {
    if (event is GetAllAccounts) {
      yield UserAccountsFetching();
      final result = await _accountsRepo.getAllAccounts();
      if (result.data != null)
        yield UserAccountsFetchingSuccess(result.data!);
      else
        yield UserAccountsFetchingFailure(result.error);
    }
  }
}
