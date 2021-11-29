import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_super11/blocs/profile/accounts/user_accounts/user_accounts_bloc.dart';
import 'package:the_super11/models/models.dart';
import 'package:the_super11/ui/resources/resources.dart';
import 'package:the_super11/ui/screens/profile/accounts/add_account_screen.dart';
import 'package:the_super11/ui/widgets/widgets.dart';

class AllAccountsScreen extends StatefulWidget {
  static const route = '/all-accounts';

  const AllAccountsScreen({Key? key}) : super(key: key);

  @override
  _AllAccountsScreenState createState() => _AllAccountsScreenState();
}

class _AllAccountsScreenState extends State<AllAccountsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppHeader(
        title: 'Added Bank/UPI Accounts',
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add, color: Colors.white),
        backgroundColor: Theme.of(context).primaryColor,
        tooltip: 'Add Account',
        onPressed: () async {
          final result =
              await Navigator.of(context).pushNamed(AddAccountScreen.route);
          if (result == true)
            context.read<UserAccountsBloc>().add(GetAllAccounts());
        },
      ),
      body: BlocBuilder<UserAccountsBloc, UserAccountsState>(
        builder: (context, state) {
          if (state is UserAccountsFetchingSuccess) {
            final accounts = state.accounts;
            if (accounts.isNotEmpty)
              return ListView.separated(
                padding: const EdgeInsets.all(12),
                itemBuilder: (context, i) => Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                accounts[i].documentType == 'upi'
                                    ? accounts[i].upiId
                                    : accounts[i].bankName.toUpperCase(),
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: 4,
                              ),
                              accounts[i].documentType == 'upi'
                                  ? _upiAccountColumn(accounts[i])
                                  : _bankAccountColumn(accounts[i]),
                            ],
                          ),
                        ),
                        Column(
                          children: [
                            Image.asset(
                              accounts[i].documentType == 'passbook'
                                  ? icBank
                                  : icUPI,
                              width: 36,
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 8),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 4, horizontal: 10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                color: _getStatusColor(
                                  accounts[i].status.toLowerCase(),
                                ),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                accounts[i].status,
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                separatorBuilder: (context, i) => SizedBox(
                  height: 8,
                ),
                itemCount: accounts.length,
              );
            return EmptyView(
              message: 'No any accounts available. Please add your account',
              image: imgNoAccounts,
            );
          } else if (state is UserAccountsFetchingFailure)
            return ErrorView(error: state.error);
          return LoadingIndicator();
        },
      ),
    );
  }

  Widget _upiAccountColumn(UserAccount account) => Column(
        children: [
          Row(
            children: [
              Icon(Icons.call),
              SizedBox(
                width: 4,
              ),
              Expanded(
                child: Text(
                  account.upiMobileNumber,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primaryVariant,
                  ),
                ),
              ),
            ],
          )
        ],
      );

  Widget _bankAccountColumn(UserAccount account) => Column(
        children: [
          Row(
            children: [
              Icon(Icons.account_balance),
              SizedBox(
                width: 4,
              ),
              Text(account.accountNumber)
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              children: [
                Text(
                  'IFSC',
                  style: TextStyle(
                    fontSize: 11.2,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  width: 4,
                ),
                Text(account.ifscCode),
              ],
            ),
          ),
          Row(
            children: [
              Icon(Icons.person),
              SizedBox(
                width: 4,
              ),
              Text(account.holderName),
            ],
          )
        ],
      );

  Color _getStatusColor(String status) {
    if (status == 'accepted')
      return Colors.green;
    else if (status == 'pending')
      return Colors.orange;
    else
      return Colors.red;
  }
}
