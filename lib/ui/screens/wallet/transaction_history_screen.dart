import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flutter_fire/blocs/wallet/transaction_history/transaction_history_bloc.dart';
import 'package:flutter_fire/core/extensions.dart';
import 'package:flutter_fire/core/utility.dart';
import 'package:flutter_fire/models/models.dart';
import 'package:flutter_fire/ui/resources/resources.dart';
import 'package:flutter_fire/ui/widgets/widgets.dart';

class TransactionHistoryScreen extends StatefulWidget {
  static const route = '/transaction-history';

  const TransactionHistoryScreen({Key? key}) : super(key: key);

  @override
  _TransactionHistoryScreenState createState() =>
      _TransactionHistoryScreenState();
}

class _TransactionHistoryScreenState extends State<TransactionHistoryScreen> {
  final _transactionTypes = [
    'All',
    'Deposited',
    'Winning',
    'Refunded',
    'Joined Contest',
    'Bonus',
    'Withdraw'
  ];
  final _colorTypes = [
    Colors.grey,
    Colors.red,
    Colors.green,
    Colors.deepOrange,
    Colors.blueAccent,
    Colors.pinkAccent,
    Colors.deepPurpleAccent
  ];
  int _selectedTransactionIndex = 0;
  final _refreshController = RefreshController();
  int _expandedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppHeader(
        title: 'Transaction History',
      ),
      body: Column(
        children: [
          Container(
            height: 60,
            child: _transactionTypesView(),
          ),
          Divider(
            height: 0,
          ),
          Expanded(child: _transactions()),
        ],
      ),
    );
  }

  Widget _transactionTypesView() => ListView.separated(
        itemCount: _transactionTypes.length,
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemBuilder: (context, i) => ActionChip(
          backgroundColor: _colorTypes[i],
          pressElevation: 10,
          elevation: 4,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          label: Row(
            children: [
              if (_selectedTransactionIndex == i)
                Padding(
                  padding: const EdgeInsets.only(right: 4),
                  child: Icon(
                    Icons.check,
                    color: Colors.white,
                  ),
                ),
              Text(
                _transactionTypes[i],
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          onPressed: () {
            if (i != _selectedTransactionIndex) {
              _selectedTransactionIndex = i;
              _expandedIndex = -1;
              setState(() {});
              context.read<TransactionHistoryBloc>().add(GetTransactionHistory(
                  _transactionTypes[_selectedTransactionIndex]));
            }
          },
        ),
        separatorBuilder: (context, i) => SizedBox(width: 12),
      );

  Widget _transactions() =>
      BlocConsumer<TransactionHistoryBloc, TransactionHistoryState>(
        listener: (context, state) {
          _refreshController.refreshCompleted();
          _refreshController.loadComplete();
          if (state is TransactionHistoryFetchingSuccess &&
              state.reachToMaxIndex) _refreshController.loadNoData();
          if (state is TransactionHistoryPagingError)
            showTopSnackBar(
                context, CustomSnackBar.error(message: state.error));
          if (state is TransactionHistoryRefreshingError)
            showTopSnackBar(
                context, CustomSnackBar.error(message: state.error));
        },
        builder: (context, state) {
          if (state is TransactionHistoryFetchingSuccess) {
            final transactions = state.transactionHistories;
            if (transactions.isNotEmpty)
              return SmartRefresher(
                controller: _refreshController,
                enablePullUp: true,
                header: RefreshHeader(),
                footer: RefreshFooter(),
                onRefresh: () => context.read<TransactionHistoryBloc>().add(
                    RefreshTransactionHistory(
                        _transactionTypes[_selectedTransactionIndex])),
                onLoading: () {
                  final bloc = context.read<TransactionHistoryBloc>();
                  if (!(bloc.state as TransactionHistoryFetchingSuccess)
                      .reachToMaxIndex)
                    bloc.add(PagingTransactionHistory(
                        _transactionTypes[_selectedTransactionIndex]));
                },
                child: ListView.separated(
                  itemCount: transactions.length,
                  itemBuilder: (context, i) =>
                      _transactionItem(i, transactions[i]),
                  separatorBuilder: (context, i) => Divider(
                    height: 0,
                  ),
                ),
              );
            else
              return EmptyView(
                message: 'No transactions available',
                image: imgNoTransactionsFound,
              );
          } else if (state is TransactionHistoryFetching)
            return LoadingIndicator();
          else if (state is TransactionHistoryFetchingFailure)
            return ErrorView(error: state.error);
          return Container();
        },
      );

  Widget _transactionItem(int i, TransactionHistory transaction) => InkWell(
        onTap: () {
          if (_showExpansion(transaction)) {
            setState(() => _expandedIndex = _expandedIndex == i ? -1 : i);
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      transaction.description,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text(Utility.formatDate(
                        dateTime: transaction.createdAt,
                        dateFormat: 'dd-MMM-yyyy hh:mm aa')),
                    if (transaction.transactionType
                        .contains(transactionTypeWithdraw))
                      _transactionStatus(transaction),
                    if (_expandedIndex == i) _expansionView(transaction)
                  ],
                ),
              ),
              SizedBox(
                width: 4,
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  _rupees(transaction),
                  if (_showExpansion(transaction))
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Icon(
                        _expandedIndex == i
                            ? Icons.keyboard_arrow_up
                            : Icons.keyboard_arrow_down,
                      ),
                    )
                ],
              )
            ],
          ),
        ),
      );

  Widget _expansionView(TransactionHistory transaction) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 12,
          ),
          Text.rich(
            TextSpan(
              text:
                  '${transaction.transactionType == transactionTypeWithdraw ? 'Payout' : 'Order'} ID: ',
              children: [
                TextSpan(
                  text: transaction.transactionType == transactionTypeWithdraw
                      ? transaction.transactionData?.razorpayPayoutId
                      : transaction.transactionData?.razorpayOrderId ?? '',
                  style: TextStyle(fontWeight: FontWeight.normal),
                ),
              ],
            ),
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 4,
          ),
          Text.rich(
            TextSpan(
              text:
                  '${transaction.transactionType == transactionTypeWithdraw ? 'Fund Account' : 'Payment'} ID: ',
              children: [
                TextSpan(
                  text: transaction.transactionType == transactionTypeWithdraw
                      ? transaction.transactionData?.fundAccountId
                      : transaction.transactionData?.razorpayPaymentId ?? '',
                  style: TextStyle(fontWeight: FontWeight.normal),
                ),
              ],
            ),
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          if (transaction.transactionType == transactionTypeWithdraw)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text.rich(
                TextSpan(
                  text:
                      '${transaction.transactionData?.method == 'upi' ? 'UPI' : 'Bank'}: ',
                  children: [
                    TextSpan(
                      text: transaction.transactionData?.method == 'upi'
                          ? transaction.transactionData?.vpa
                          : transaction.transactionData?.bank ?? '',
                      style: TextStyle(fontWeight: FontWeight.normal),
                    ),
                  ],
                ),
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          if (transaction.transactionData!.isOfferApplied)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text.rich(
                    TextSpan(
                      text: 'Offer Code: ',
                      children: [
                        TextSpan(
                          text: transaction.offerCode,
                          style: TextStyle(fontWeight: FontWeight.normal),
                        ),
                      ],
                    ),
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Text.rich(
                    TextSpan(
                      text: 'Offer Bonus: ',
                      children: [
                        TextSpan(
                          text:
                              '₹${transaction.transactionData!.cashBonus + transaction.transactionData!.depositBonus}',
                          style: TextStyle(fontWeight: FontWeight.normal),
                        ),
                      ],
                    ),
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
        ],
      );

  bool _showExpansion(TransactionHistory transaction) =>
      transaction.transactionData != null &&
      transaction.transactionData!.id.isNotEmpty &&
      (transaction.transactionType == transactionTypeDeposit ||
          transaction.transactionType == transactionTypeWithdraw);

  Widget _transactionStatus(TransactionHistory transaction) {
    Color color(TransactionHistory transaction) {
      if (transaction.status.contains(transactionStatusSuccess))
        return Colors.green;
      else if (transaction.status.contains(transactionStatusRejected))
        return Colors.red;
      else
        return Colors.orange;
    }

    return Text(
      transaction.status.capitalize,
      style: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: color(transaction),
      ),
    );
  }

  Widget _rupees(TransactionHistory transaction) {
    String rupeesPrefix() {
      if (transaction.transactionType.contains(transactionTypeJoinedContest) ||
          (transaction.transactionType.contains(transactionTypeWithdraw) &&
              transaction.status.contains(transactionStatusSuccess)))
        return '-';
      else if (transaction.transactionType.contains(transactionTypeWithdraw) &&
          !transaction.status.contains(transactionStatusSuccess)) return '';
      return '+';
    }

    Color? color() {
      if (transaction.transactionType.contains(transactionTypeJoinedContest) ||
          (transaction.transactionType.contains(transactionTypeWithdraw) &&
              transaction.status.contains(transactionStatusSuccess)))
        return Colors.red;
      else if (transaction.transactionType.contains(transactionTypeWithdraw) &&
          !transaction.status.contains(transactionStatusSuccess)) return null;
      return Colors.green;
    }

    final offerApplied = _showExpansion(transaction) &&
        transaction.transactionData!.isOfferApplied;
    final additionalAmount = offerApplied
        ? transaction.transactionData!.cashBonus +
            transaction.transactionData!.depositBonus
        : 0;

    return Text(
      '${rupeesPrefix()}₹${transaction.amount + additionalAmount}',
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: color(),
      ),
    );
  }

  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }
}
