part of 'transaction_history_bloc.dart';

@immutable
abstract class TransactionHistoryState {}

class TransactionHistoryFetching extends TransactionHistoryState {}

class TransactionHistoryFetchingSuccess extends TransactionHistoryState {
  final List<TransactionHistory> transactionHistories;
  final bool reachToMaxIndex;

  TransactionHistoryFetchingSuccess(
    this.transactionHistories, {
    this.reachToMaxIndex = false,
  });
}

/// Transaction history pagination error
class TransactionHistoryPagingError extends TransactionHistoryFetchingSuccess {
  final String error;

  TransactionHistoryPagingError(
      List<TransactionHistory> transactionHistories, this.error)
      : super(transactionHistories);
}

/// Transaction history refresh error
class TransactionHistoryRefreshingError
    extends TransactionHistoryFetchingSuccess {
  final String error;

  TransactionHistoryRefreshingError(
      List<TransactionHistory> transactionHistories, this.error)
      : super(transactionHistories);
}

class TransactionHistoryFetchingFailure extends TransactionHistoryState {
  final String error;

  TransactionHistoryFetchingFailure(this.error);
}
