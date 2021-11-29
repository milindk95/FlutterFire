import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:the_super11/blocs/wallet/approved_accounts/approved_accounts_bloc.dart';
import 'package:the_super11/blocs/wallet/request_withdraw/request_withdraw_bloc.dart';
import 'package:the_super11/core/providers/user_info_provider.dart';
import 'package:the_super11/models/models.dart';
import 'package:the_super11/ui/resources/resources.dart';
import 'package:the_super11/ui/screens/wallet/transaction_history_screen.dart';
import 'package:the_super11/ui/widgets/widgets.dart';

class WithdrawMoneyScreen extends StatefulWidget {
  static const route = '/withdraw-money';

  const WithdrawMoneyScreen({Key? key}) : super(key: key);

  @override
  _WithdrawMoneyScreenState createState() => _WithdrawMoneyScreenState();
}

class _WithdrawMoneyScreenState extends State<WithdrawMoneyScreen> {
  final _formKey = GlobalKey<FormState>();
  AutovalidateMode _autoValidateMode = AutovalidateMode.disabled;
  final _amountCtrl = TextEditingController();
  late double _winningAmount;
  String _selectedAccountId = '';

  @override
  void initState() {
    super.initState();
    _winningAmount = context.read<UserInfo>().user.winningAmount;
  }

  @override
  Widget build(BuildContext context) {
    return UIBlocker(
      block: BlocProvider.of<RequestWithdrawBloc>(context, listen: true).state
          is RequestWithdrawProcessing,
      child: Scaffold(
        appBar: AppHeader(
          title: 'Withdraw Money',
        ),
        body: SafeArea(
          child: BlocConsumer<ApprovedAccountsBloc, ApprovedAccountsState>(
            listener: (context, state) {
              if (state is ApprovedAccountsFetchingSuccess) {
                final defaultAccount =
                    state.accounts.where((account) => account.isDefault);
                if (defaultAccount.isNotEmpty)
                  _selectedAccountId = defaultAccount.first.id ?? '';
              }
            },
            builder: (context, state) {
              if (state is ApprovedAccountsFetchingSuccess)
                return Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      _topView(state.accounts),
                      SizedBox(
                        height: 12,
                      ),
                      Expanded(
                        child: Container(
                          width: double.infinity,
                          child: _bottomView(state.accounts),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      if (state.accounts.isNotEmpty || _winningAmount >= 100)
                        _requestWithDrawButton()
                    ],
                  ),
                );
              else if (state is ApprovedAccountsFetching)
                return LoadingIndicator();
              else if (state is ApprovedAccountsFetchingFailure)
                return ErrorView(error: state.error);
              return Container();
            },
          ),
        ),
      ),
    );
  }

  Widget _topView(List<Account> accounts) => Card(
        elevation: 8,
        color: Theme.of(context).colorScheme.secondary,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Winning Amount'),
                        SizedBox(
                          height: 4,
                        ),
                        Text(
                          '₹$_winningAmount',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                  ),
                  TextButton(
                    child: Text(
                      'Transaction History',
                      style: TextStyle(fontSize: 15),
                    ),
                    onPressed: () => Navigator.of(context)
                        .pushNamed(TransactionHistoryScreen.route),
                  )
                ],
              ),
              if (accounts.isNotEmpty || _winningAmount >= 100)
                Form(
                  key: _formKey,
                  autovalidateMode: _autoValidateMode,
                  child: AppTextField(
                    controller: _amountCtrl,
                    hintText: 'Amount to withdraw',
                    keyboardType:
                        TextInputType.numberWithOptions(signed: false),
                    maxLength: 10,
                    formatters: Formatters.acceptNumbers,
                    validator: (value) {
                      if (value!.isEmpty ||
                          (value.isNotEmpty && int.parse(value) < 100))
                        return 'Withdraw amount should be minimum ₹100';
                      else if (int.parse(value) > _winningAmount)
                        return 'Your available balance to withdraw is ₹$_winningAmount';
                    },
                  ),
                ),
              if (_winningAmount < 100)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    'Winning amount should be minimum ₹100 to withdraw',
                    style: TextStyle(
                      color: Colors.red,
                    ),
                  ),
                )
            ],
          ),
        ),
      );

  Widget _bottomView(List<Account> accounts) => Card(
        elevation: 8,
        color: Theme.of(context).colorScheme.secondary,
        child: accounts.isNotEmpty
            ? _accountsView(accounts)
            : Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'You have not any approved accounts. Go to profile and add bank details',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
      );

  Widget _accountsView(List<Account> accounts) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Text(
              'Select Account',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Divider(
            height: 0,
          ),
          Expanded(
            child: ListView.separated(
              itemCount: accounts.length,
              itemBuilder: (context, i) => InkWell(
                onTap: () => setState(() =>
                    _selectedAccountId = accounts[i].id ?? _selectedAccountId),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Transform.scale(
                        scale: 1.2,
                        child: Radio<String>(
                          groupValue: _selectedAccountId,
                          value: accounts[i].id ?? '',
                          onChanged: (value) => setState(() =>
                              _selectedAccountId = value ?? _selectedAccountId),
                        ),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            _upiORBankName(accounts[i]),
                            SizedBox(
                              height: 4,
                            ),
                            Text(
                              accounts[i].mode == 'upi'
                                  ? 'Mobile: ${accounts[i].upiMobileNumber}'
                                  : 'Account: ${accounts[i].bankAcNumber}',
                            ),
                            if (accounts[i].mode != 'upi')
                              Padding(
                                padding: const EdgeInsets.only(top: 2),
                                child: Text(
                                  'IFSC: ${accounts[i].bankIfsc}',
                                ),
                              ),
                          ],
                          crossAxisAlignment: CrossAxisAlignment.start,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.asset(
                          accounts[i].mode == 'upi' ? icUPI : icBank,
                          width: 36,
                        ),
                      )
                    ],
                  ),
                ),
              ),
              separatorBuilder: (context, i) => Divider(
                height: 0,
              ),
            ),
          ),
        ],
      );

  Widget _upiORBankName(Account account) => Row(
        children: [
          Text(
            account.mode == 'upi'
                ? account.upiId ?? ''
                : account.bankName ?? '',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          if (account.isDefault)
            Container(
              child: Text(
                'Default',
                style: TextStyle(color: Colors.white),
              ),
              margin: const EdgeInsets.only(left: 8),
              padding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 2,
              ),
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(4),
              ),
            )
        ],
      );

  Widget _requestWithDrawButton() =>
      BlocConsumer<RequestWithdrawBloc, RequestWithdrawState>(
        listener: (context, state) async {
          if (state is RequestWithdrawFailure)
            showTopSnackBar(
              context,
              CustomSnackBar.error(
                message: state.error,
              ),
            );
          else if (state is RequestWithdrawSuccess) {
            showTopSnackBar(
              context,
              CustomSnackBar.success(
                message: state.message,
              ),
            );
            final info = context.read<UserInfo>();
            await info.updateAmounts(
              winningAmount: _winningAmount - double.parse(_amountCtrl.text),
            );
            Navigator.of(context).pop();
          }
        },
        builder: (context, state) {
          return SubmitButton(
            label: 'Request Withdraw',
            progress: state is RequestWithdrawProcessing,
            onPressed: _requestForWithdraw,
          );
        },
      );

  void _requestForWithdraw() {
    if (_formKey.currentState!.validate()) {
      context
          .read<RequestWithdrawBloc>()
          .add(RequestForWithdraw(_amountCtrl.text, _selectedAccountId));
    } else
      setState(() => _autoValidateMode = AutovalidateMode.onUserInteraction);
  }
}
