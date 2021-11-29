import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:flutter_fire/models/models.dart';
import 'package:flutter_fire/repository/wallet/transaction_history_repository.dart';

part 'transaction_history_event.dart';
part 'transaction_history_state.dart';

class TransactionHistoryBloc
    extends Bloc<TransactionHistoryEvent, TransactionHistoryState> {
  int _page = 1;
  List<TransactionHistory> _transactions = [];
  final TransactionHistoryRepository _transactionHistoryRepo =
      TransactionHistoryRepository();

  TransactionHistoryBloc() : super(TransactionHistoryFetching());

  @override
  Stream<TransactionHistoryState> mapEventToState(
      TransactionHistoryEvent event) async* {
    if (event is GetTransactionHistory) {
      yield TransactionHistoryFetching();
      _page = 1;
      _transactions.clear();
      final result = await _transactionHistoryRepo.getTransactionHistories(
          status: event.type, pageNumber: _page);
      if (result.data != null) {
        _transactions.addAll(result.data!);
        yield TransactionHistoryFetchingSuccess(_transactions);
      } else
        yield TransactionHistoryFetchingFailure(result.error);
    }

    if (event is PagingTransactionHistory) {
      _page++;
      final result = await _transactionHistoryRepo.getTransactionHistories(
          status: event.type, pageNumber: _page);
      if (result.data != null) {
        _transactions.addAll(result.data!);
        yield TransactionHistoryFetchingSuccess(_transactions,
            reachToMaxIndex: result.data!.isEmpty);
      } else {
        _page--;
        yield TransactionHistoryPagingError(_transactions, result.error);
      }
    }

    if (event is RefreshTransactionHistory) {
      final result = await _transactionHistoryRepo.getTransactionHistories(
          status: event.type, pageNumber: 1);
      if (result.data != null) {
        _page = 1;
        _transactions.clear();
        _transactions.addAll(result.data!);
        yield TransactionHistoryFetchingSuccess(_transactions);
      } else
        yield TransactionHistoryRefreshingError(_transactions, result.error);
    }
  }
}
