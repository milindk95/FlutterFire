import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:the_super11/core/providers/match_info_provider.dart';
import 'package:the_super11/ui/screens/home/match_timer.dart';

import 'add_money_dialog.dart';

class ContestAppHeader extends StatelessWidget implements PreferredSizeWidget {
  final List<Widget> actions;
  final bool transparentBg;
  final bool showAddMoney;
  final VoidCallback? onBack;

  const ContestAppHeader({
    Key? key,
    this.actions = const [],
    this.transparentBg = false,
    this.showAddMoney = false,
    this.onBack,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final match = context.read<MatchInfo>().match;
    return AppBar(
      backgroundColor: transparentBg ? Colors.transparent : null,
      shadowColor: transparentBg ? Colors.transparent : null,
      leading: IconButton(
        onPressed: () =>
            onBack != null ? onBack?.call() : Navigator.of(context).pop(),
        splashRadius: 22,
        icon: Icon(
          Icons.arrow_back,
          size: 24,
        ),
      ),
      centerTitle: false,
      titleSpacing: 4,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            match.shortName,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          MatchTimer(
            startTime: match.startDate,
            showLeft: true,
            allowBack: true,
            textStyle: TextStyle(
              fontSize: 14,
              color: Colors.white,
            ),
          ),
        ],
      ),
      actions: [
        ...actions,
        if (showAddMoney)
          Padding(
            padding: const EdgeInsets.only(right: 4),
            child: IconButton(
              onPressed: () => showAddMoneyDialog(context),
              splashRadius: 22,
              icon: Icon(
                Icons.account_balance_wallet_outlined,
                size: 24,
              ),
            ),
          ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
