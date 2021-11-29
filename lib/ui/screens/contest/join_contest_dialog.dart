import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:the_super11/blocs/contest/all_contests/all_contests_bloc.dart';
import 'package:the_super11/blocs/contest/create_contest/create_contest_bloc.dart';
import 'package:the_super11/blocs/contest/join_contest/join_contest_bloc.dart';
import 'package:the_super11/blocs/contest/user_contests/user_contests_bloc.dart';
import 'package:the_super11/blocs/matches/recent_matches/recent_matches_bloc.dart';
import 'package:the_super11/blocs/matches/team_and_contest_count/team_and_contest_count_bloc.dart';
import 'package:the_super11/core/extensions.dart';
import 'package:the_super11/core/providers/user_info_provider.dart';
import 'package:the_super11/models/models.dart';
import 'package:the_super11/ui/resources/resources.dart';
import 'package:the_super11/ui/screens/contest/contest_list_screen.dart';
import 'package:the_super11/ui/screens/wallet/add_money_screen.dart';
import 'package:the_super11/ui/widgets/snackbar/top_snack_bar.dart';
import 'package:the_super11/ui/widgets/ui_blocker.dart';
import 'package:the_super11/ui/widgets/widgets.dart';

class JoinContestDialog {
  final BuildContext context;
  final Contest contest;
  final bool fromMyContests;
  final bool createContest;
  late User user;

  JoinContestDialog({
    required this.context,
    required this.contest,
    this.fromMyContests = false,
    this.createContest = false,
  }) {
    user = context.read<UserInfo>().user;
  }

  Future<bool?> showJoinContestDialog({
    required String selectedTeamId,
    Map<String, dynamic>? createContestBody,
  }) {
    Widget priceCount(String label, double price, [double fontSize = 16]) =>
        Padding(
          padding: const EdgeInsets.only(bottom: 6),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: fontSize,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Text(
                '₹$price',
                style: TextStyle(
                  fontSize: fontSize,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        );
    return showGeneralDialog<bool>(
      context: context,
      pageBuilder: (context, anim1, anim2) => UIBlocker(
        block: context.watch<JoinContestBloc>().state is JoinContestInProgress,
        child: Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 20,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'CONFIRMATION',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                              'Amount Added + Winnings = ₹${contest.feePerEntry}'),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.close),
                      padding: EdgeInsets.zero,
                      splashRadius: 24,
                      iconSize: 30,
                      constraints: BoxConstraints(maxWidth: 40, maxHeight: 40),
                      onPressed: () => Navigator.of(context).pop(),
                    )
                  ],
                ),
                SizedBox(
                  height: 8,
                ),
                priceCount('Deposit', payableDepositAmount),
                priceCount('Bonus', usableBonusAmount),
                priceCount('Winning', payableWinningAmount),
                DottedBorder(
                  child: Container(),
                  padding: EdgeInsets.zero,
                  dashPattern: [4, 8],
                ),
                SizedBox(
                  height: 8,
                ),
                priceCount('Total', contest.feePerEntry, 18),
                SizedBox(
                  height: 4,
                ),
                createContest
                    ? _createContestButton(selectedTeamId, createContestBody!)
                    : _joinContestButton(selectedTeamId),
              ],
            ),
          ),
        ),
      ),
      transitionBuilder: (context, anim1, anim2, child) {
        return SlideTransition(
          position:
              Tween(begin: Offset(0, 1), end: Offset(0, 0)).animate(anim1),
          child: child,
        );
      },
    );
  }

  Widget _joinContestButton(String selectedTeamId) =>
      BlocConsumer<JoinContestBloc, JoinContestState>(
        listener: (context, state) async {
          if (state is JoinContestFailure)
            showTopSnackBar(
                context, CustomSnackBar.error(message: state.error));
          else if (state is JoinContestSuccess) {
            final info = context.read<UserInfo>();
            await info.updateAmounts(
              depositAmount: info.user.realAmount - payableDepositAmount,
              bonusAmount: info.user.redeemAmount - usableBonusAmount,
              winningAmount: info.user.winningAmount - payableWinningAmount,
            );
            context.read<RecentMatchesBloc>().add(GetRecentMatches());
            if (fromMyContests)
              context.read<UserContestsBloc>().add(GetUserContests());
            else {
              context.read<AllContestsBloc>().add(GetAllContests());
              context
                  .read<TeamAndContestCountBloc>()
                  .add(GetTeamAndContestCount());
            }
            Navigator.of(context)
                .popUntil(ModalRoute.withName(ContestListScreen.route));
            showTopSnackBar(
                context, CustomSnackBar.success(message: state.message));
          }
        },
        builder: (context, state) {
          return SubmitButton(
            label: 'Join Contest',
            progress: state is JoinContestInProgress,
            onPressed: () {
              final body = {
                'contest': contest.id,
                'team': selectedTeamId,
                'usableDepositAmount': payableDepositAmount,
                'usableBonusAmount': usableBonusAmount,
                'usableWinningAmount': payableWinningAmount,
              };
              context.read<JoinContestBloc>().add(JoinContest(body));
            },
          );
        },
      );

  Widget _createContestButton(
          String selectedTeamId, Map<String, dynamic> body) =>
      BlocConsumer<CreateContestBloc, CreateContestState>(
        listener: (context, state) async {
          if (state is CreateContestFailure)
            showTopSnackBar(
                context, CustomSnackBar.error(message: state.error));
          else if (state is CreateContestSuccess) {
            final info = context.read<UserInfo>();
            await info.updateAmounts(
              depositAmount: info.user.realAmount - payableAmount,
              bonusAmount: info.user.redeemAmount - usableBonusAmount,
              winningAmount: info.user.winningAmount - payableWinningAmount,
            );
            final userContestsBloc = context.read<UserContestsBloc>();
            if (userContestsBloc.state is UserContestsFetchingSuccess)
              userContestsBloc.add(GetUserContests());
            context
                .read<TeamAndContestCountBloc>()
                .add(GetTeamAndContestCount());
            showTopSnackBar(
                context, CustomSnackBar.success(message: state.message));
            Navigator.of(context)
                .popUntil(ModalRoute.withName(ContestListScreen.route));
          }
        },
        builder: (context, state) {
          return SubmitButton(
            label: 'Create Contest & Join',
            progress: state is JoinContestInProgress,
            onPressed: () =>
                context.read<CreateContestBloc>().add(CreateContest(body)),
          );
        },
      );

  /// Bonus amount that will be less from total payable amount
  double get usableBonusAmount {
    final availableBonus = user.redeemAmount;
    final contestBonus = contest.feePerEntry * contest.bonusPerEntry / 100;
    return availableBonus > contestBonus ? contestBonus : availableBonus;
  }

  /// User have to pay this amount from real and winning amount
  /// Priority is real amount and then winning amount
  double get payableAmount => contest.feePerEntry - usableBonusAmount;

  /// Total payable deposit(real) amount
  double get payableDepositAmount =>
      user.realAmount >= payableAmount ? payableAmount : user.realAmount;

  /// Total payable winning amount
  double get payableWinningAmount {
    final remainAmount = payableAmount - payableDepositAmount;
    return user.winningAmount >= remainAmount
        ? remainAmount
        : user.winningAmount;
  }

  /// Getter used to check user is able to join contest
  bool get ableToJoin => payableAmount <= user.realAmount + user.winningAmount;

  void showAddMoneyConfirmation() {
    context.showConfirmation(
      title: 'Add Money',
      message:
          'You have not sufficient balance to join this contest. Do you want to add money?',
      positiveText: 'Add Money',
      positiveAction: () {
        final int amount = requiredAddAmount > addMoneyMinimumAmount
            ? requiredAddAmount.ceil()
            : addMoneyMinimumAmount.ceil();
        Navigator.of(context).pushNamed(AddMoneyScreen.route,
            arguments: AddMoneyScreenData(amount: amount));
      },
    );
  }

  /// Amount need to add by add money flow
  double get requiredAddAmount =>
      payableAmount - payableDepositAmount - payableWinningAmount;
}
