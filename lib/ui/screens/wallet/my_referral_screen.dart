import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_fire/blocs/wallet/my_referral/my_referral_bloc.dart';
import 'package:flutter_fire/core/utility.dart';
import 'package:flutter_fire/models/models.dart';
import 'package:flutter_fire/ui/resources/resources.dart';
import 'package:flutter_fire/ui/widgets/widgets.dart';

class MyReferralScreen extends StatefulWidget {
  static const route = '/my-referral';

  const MyReferralScreen({Key? key}) : super(key: key);

  @override
  _MyReferralScreenState createState() => _MyReferralScreenState();
}

class _MyReferralScreenState extends State<MyReferralScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppHeader(
        title: 'My Referral',
      ),
      body: BlocBuilder<MyReferralBloc, MyReferralState>(
        builder: (context, state) {
          if (state is MyReferralFetchingSuccess)
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: _rewardsCard(state.myReferrals),
                ),
                Expanded(
                  child: state.myReferrals.isNotEmpty
                      ? _referrals(state.myReferrals)
                      : EmptyView(
                          message: 'No referrals available',
                          image: imgReferAndEarn,
                        ),
                )
              ],
            );
          else if (state is MyReferralFetching)
            return LoadingIndicator();
          else if (state is MyReferralFetchingFailure)
            return ErrorView(error: state.error);
          return Container();
        },
      ),
    );
  }

  Widget _rewardsCard(List<MyReferral> myReferrals) => Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  Text(
                    'Total Rewards',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Text(
                    '₹${_getAmount(myReferrals)}',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  Text(
                    'Pending Rewards',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 4,
                  ),
                  Text(
                    '₹${_getAmount(myReferrals, type: 'pending')}',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      );

  Widget _referrals(List<MyReferral> myReferrals) => ListView.separated(
        itemCount: myReferrals.length,
        itemBuilder: (context, i) => ListTile(
          title: Text(myReferrals[i].teamName ?? ''),
          subtitle: Text(
            'Redeemed At: ${Utility.formatDate(dateTime: myReferrals[i].createdAt, dateFormat: 'dd-MMM-yyyy hh:mm aa')}',
          ),
          trailing: Text(
            '₹${myReferrals[i].referralAmount}',
            style: TextStyle(
              fontSize: 16,
              color: Colors.green,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        separatorBuilder: (context, i) => Divider(),
      );

  double _getAmount(List<MyReferral> myReferrals, {String type = 'total'}) {
    double totalRewards = 0, pendingRewards = 0;
    myReferrals.forEach((referral) {
      if (referral.status.contains('pending'))
        pendingRewards += referral.referralAmount;
      else
        totalRewards += referral.referralAmount;
    });
    return type == 'total' ? totalRewards : pendingRewards;
  }
}
