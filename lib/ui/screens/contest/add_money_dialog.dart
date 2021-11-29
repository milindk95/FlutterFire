import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_fire/core/providers/user_info_provider.dart';
import 'package:flutter_fire/ui/screens/wallet/add_money_screen.dart';

Future<bool?> showAddMoneyDialog(BuildContext context) {
  final user = context.read<UserInfo>().user;
  Widget label(String label, double amount) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 12,
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(
            height: 4,
          ),
          Text(
            '₹$amount',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            height: 8,
          ),
          DottedBorder(
            child: Container(),
            padding: EdgeInsets.zero,
            dashPattern: [4, 8],
            color: Theme.of(context).colorScheme.primaryVariant,
          ),
        ],
      );
  return showGeneralDialog(
    context: context,
    barrierLabel: 'Add-Money',
    barrierDismissible: true,
    barrierColor: Colors.black.withOpacity(0.3),
    transitionDuration: Duration(milliseconds: 500),
    pageBuilder: (context, anim1, anim2) => Align(
      alignment: Alignment.topCenter,
      child: Material(
        color: Colors.transparent,
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.fromLTRB(
              12, MediaQuery.of(context).padding.top + 12, 12, 0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(16),
            ),
            color: Theme.of(context).colorScheme.secondary,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Total Wallet Balance',
                style: TextStyle(fontSize: 16),
              ),
              Text(
                '₹${user.totalAmount}',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
              SizedBox(
                height: 12,
              ),
              MaterialButton(
                color: Theme.of(context).primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 12,
                ),
                child: Text(
                  'Add Money',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pushNamed(AddMoneyScreen.route);
                },
              ),
              label('Deposit', user.realAmount),
              label('Cash Bonus', user.redeemAmount),
              label('Winning', user.winningAmount),
              Container(
                padding: const EdgeInsets.all(4),
                margin: const EdgeInsets.only(top: 18),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(
                    width: 0.5,
                    color: Theme.of(context).colorScheme.primaryVariant,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.money,
                      color: Theme.of(context).primaryColor,
                    ),
                    SizedBox(
                      width: 4,
                    ),
                    Expanded(
                      child: Text(
                        'Maximum usable cash bonus per match = 10% of Entry Fees',
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 12,
              ),
              IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: RotatedBox(
                  quarterTurns: 1,
                  child: Icon(Icons.arrow_back_ios),
                ),
              )
            ],
          ),
        ),
      ),
    ),
    transitionBuilder: (context, anim1, anim2, child) {
      return SlideTransition(
        position: Tween(
          begin: Offset(0.0, -0.8),
          end: Offset(0.0, 0.0),
        ).animate(anim1),
        child: child,
      );
    },
  );
}
