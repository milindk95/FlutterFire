part of 'transaction_history_bloc.dart';

@immutable
abstract class TransactionHistoryEvent {}

class GetTransactionHistory extends TransactionHistoryEvent {
  final String type;

  GetTransactionHistory(this.type);
}

class RefreshTransactionHistory extends TransactionHistoryEvent {
  final String type;

  RefreshTransactionHistory(this.type);
}

class PagingTransactionHistory extends TransactionHistoryEvent {
  final String type;

  PagingTransactionHistory(this.type);
}
