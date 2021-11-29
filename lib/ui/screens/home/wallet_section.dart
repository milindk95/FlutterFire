import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:the_super11/blocs/profile/user_profile/user_profile_bloc.dart';
import 'package:the_super11/core/providers/user_info_provider.dart';
import 'package:the_super11/models/models.dart';
import 'package:the_super11/ui/resources/resources.dart';
import 'package:the_super11/ui/screens/commons/coming_soon_screen.dart';
import 'package:the_super11/ui/screens/wallet/add_money_screen.dart';
import 'package:the_super11/ui/screens/wallet/my_referral_screen.dart';
import 'package:the_super11/ui/screens/wallet/offer_screen.dart';
import 'package:the_super11/ui/screens/wallet/transaction_history_screen.dart';
import 'package:the_super11/ui/screens/wallet/withdraw_money_screen.dart';
import 'package:the_super11/ui/widgets/widgets.dart';

class WalletSection extends StatefulWidget {
  const WalletSection({Key? key}) : super(key: key);

  @override
  _WalletSectionState createState() => _WalletSectionState();
}

class _WalletSectionState extends State<WalletSection> {
  final _moneyTypes = ['Deposited', 'Cash Bonus', 'Winning'];
  final _moneyIcons = [
    Icons.account_balance,
    Icons.military_tech,
    Icons.emoji_events,
  ];
  final _moneyColors = [
    Colors.deepOrange,
    Colors.green,
    Colors.blueAccent,
  ];
  final _optionsLabels = [
    'Withdraw Money',
    'Transaction History',
    'My Referral',
    'Redeem Coupon',
    'Offers',
  ];
  final _optionsIcons = [
    Icons.money,
    Icons.history,
    Icons.redeem,
    Icons.group_add,
    Icons.local_offer_outlined,
  ];

  late final List<GestureTapCallback> _optionsOnTap;

  @override
  void initState() {
    super.initState();
    _optionsOnTap = [
      () => Navigator.of(context).pushNamed(WithdrawMoneyScreen.route),
      () => Navigator.of(context).pushNamed(TransactionHistoryScreen.route),
      () => Navigator.of(context).pushNamed(MyReferralScreen.route),
      () => Navigator.of(context).pushNamed(
            ComingSoonScreen.route,
            arguments: _optionsLabels[3],
          ),
      () => Navigator.of(context).pushNamed(OfferScreen.route),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<UserProfileBloc, UserProfileState>(
        listener: (context, state) {
          if (state is UserProfileFetchingFailure)
            showTopSnackBar(
                context, CustomSnackBar.error(message: state.error));
          else if (state is UserProfileFetchingSuccess) {
            context.read<UserInfo>().setLoggedUserInfo(state.user);
          }
        },
        builder: (context, state) {
          if (state is UserProfileFetchingSuccess)
            return CustomScrollView(
              slivers: [
                CupertinoSliverNavigationBar(
                  largeTitle: Text(
                    'Wallet',
                    style: homeSectionsHeaderTextStyles,
                  ),
                ),
                Consumer<UserInfo>(
                  builder: (context, state, child) {
                    return SliverList(
                      delegate: SliverChildListDelegate(
                        [
                          SizedBox(
                            height: 16,
                          ),
                          _totalBalance(state.user),
                          SizedBox(
                            height: 10,
                          ),
                          _totalMoneys(state.user),
                          SizedBox(
                            height: 20,
                          ),
                          _walletOptions(),
                          SizedBox(
                            height: 100,
                          )
                        ],
                      ),
                    );
                  },
                )
              ],
            );
          else if (state is UserProfileFetching)
            return LoadingIndicator();
          else if (state is UserProfileFetchingFailure)
            return ErrorView(error: state.error);
          return Container();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context).pushNamed(AddMoneyScreen.route),
        tooltip: 'Add Money',
        child: Image.asset(
          icAddMoney,
          width: 38,
        ),
      ),
    );
  }

  Widget _totalBalance(User user) => Column(
        children: [
          Text(
            '₹${user.totalAmount}',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: 4,
          ),
          Text('Total Wallet Balance'),
        ],
      );

  Widget _totalMoneys(User user) {
    final _moneys = [user.realAmount, user.redeemAmount, user.winningAmount];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: List.generate(
          _moneyTypes.length,
          (i) => Expanded(
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Icon(
                      _moneyIcons[i],
                      color: _moneyColors[i],
                      size: 30,
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      '₹${_moneys[i]}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(
                      height: 2,
                    ),
                    Text(_moneyTypes[i]),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _walletOptions() => ListView.separated(
        itemCount: _optionsLabels.length,
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (context, i) => Container(
          color: Colors.white,
          child: Material(
            child: InkWell(
              onTap: _optionsOnTap[i],
              child: Padding(
                padding: const EdgeInsets.only(left: 12),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 12,
                        bottom: 12,
                        right: 12,
                      ),
                      child: Row(
                        children: [
                          Container(
                            child: Icon(
                              _optionsIcons[i],
                              size: 18,
                              color: Colors.white,
                            ),
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              color: Colors.blueAccent,
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: Text(
                              _optionsLabels[i],
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.grey,
                            size: 18,
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        separatorBuilder: (context, i) => Container(
          margin: const EdgeInsets.only(left: 34),
          child: Divider(
            height: 0,
          ),
        ),
      );
}
