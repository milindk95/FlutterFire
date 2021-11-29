import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';
import 'package:the_super11/core/providers/match_info_provider.dart';
import 'package:the_super11/models/models.dart';
import 'package:the_super11/ui/resources/resources.dart';
import 'package:the_super11/ui/screens/contest/join_contest_dialog.dart';
import 'package:the_super11/ui/screens/match/max_entry_and_bonus_view.dart';
import 'package:the_super11/ui/screens/teams/select_team_screen.dart';
import 'package:the_super11/ui/widgets/widgets.dart';

import 'contest_progress_bar.dart';

class ContestItem extends StatelessWidget {
  final Contest contest;
  final GestureTapCallback? onTap;
  final bool fromMyContests;

  const ContestItem({
    Key? key,
    required this.contest,
    this.onTap,
    this.fromMyContests = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Total Price'),
                  Text('Entry Fee'),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '₹${contest.winningAmount.toInt()}',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  AbsorbPointer(
                    absorbing: !_ableToJoin,
                    child: _contestEntryButton(context),
                  ),
                ],
              ),
              if (contest.contestType != practiceContest)
                _minimumEntryText(contest),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: ContestProgressBar(contest: contest),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '${contest.noOfEntry}',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        width: 4,
                      ),
                      Text('Entries'),
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '${contest.noOfEntry - contest.contestParticipants}',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        width: 4,
                      ),
                      Text('Left'),
                    ],
                  ),
                ],
              ),
              Row(
                children: [
                  if (contest.contestType != practiceContest)
                    _firstPrice(context),
                  if (contest.contestType != practiceContest)
                    _winningTeamCount(context),
                  if (contest.maxEntryPerUser > 1) _maxEntry(context),
                  Spacer(),
                  if (contest.maxEntryPerUser > 1 || contest.bonusPerEntry > 0)
                    MaxEntryAndBonusView(contest: contest),
                  if (_ableToShare)
                    Padding(
                      padding: const EdgeInsets.only(left: 10, right: 2),
                      child: IconButton(
                        onPressed: () => _shareContestCode(context),
                        splashRadius: 20,
                        padding: EdgeInsets.zero,
                        iconSize: 22,
                        constraints: BoxConstraints(
                          maxWidth: 24,
                          maxHeight: 24,
                        ),
                        icon: Icon(Icons.share),
                      ),
                    )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _firstPrice(BuildContext context) => AppTooltip(
        message:
            'First winner will get ₹${contest.winningPrizes.first.winningAmount.toInt()}',
        child: Container(
          padding: const EdgeInsets.fromLTRB(0, 8, 12, 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.military_tech_outlined,
                size: 20,
                color: Colors.blueAccent,
              ),
              Text('₹${_getFirstRankWinningAmount(contest).toInt()}'),
            ],
          ),
        ),
      );

  Widget _winningTeamCount(BuildContext context) => AppTooltip(
        message:
            '${contest.maxNoOfWinner} team${contest.maxNoOfWinner > 1 ? 's' : ''} will win this contest',
        child: Container(
          padding: const EdgeInsets.fromLTRB(0, 8, 12, 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.emoji_events_outlined,
                size: 20,
                color: Colors.deepOrange,
              ),
              Text(
                '${contest.maxNoOfWinner * 100 ~/ contest.noOfEntry}%',
              ),
            ],
          ),
        ),
      );

  Widget _maxEntry(BuildContext context) => AppTooltip(
        message: 'Maximum ${contest.maxEntryPerUser} teams allowed',
        child: Container(
          padding: const EdgeInsets.fromLTRB(0, 8, 12, 8),
          child: Row(
            children: [
              Icon(
                Icons.people_outline,
                size: 22,
                color: Colors.teal,
              ),
              SizedBox(
                width: 4,
              ),
              Text(
                '${contest.maxEntryPerUser}',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      );

  Widget _contestEntryButton(BuildContext context) => TextButton(
        onPressed: () async {
          final joinContest = JoinContestDialog(
            context: context,
            contest: contest,
            fromMyContests: fromMyContests,
          );
          if (!joinContest.ableToJoin) {
            joinContest.showAddMoneyConfirmation();
            return;
          }
          final selectedTeamId = await Navigator.of(context).pushNamed(
            SelectTeamScreen.route,
            arguments: SelectTeamScreenData(contestId: contest.id),
          );
          if (selectedTeamId is String)
            joinContest.showJoinContestDialog(selectedTeamId: selectedTeamId);
        },
        style: TextButton.styleFrom(
          backgroundColor: _ableToJoin
              ? Colors.green
              : Theme.of(context).colorScheme.primaryVariant.withOpacity(0.5),
          primary: Colors.white,
        ),
        child: Text(
          '₹${contest.feePerEntry.toInt()}',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      );

  Widget _minimumEntryText(Contest contest) {
    int participant = 0;
    for (int i = 1; i <= contest.noOfEntry; i++)
      if (contest.winningAmount < contest.feePerEntry * i) {
        participant = i;
        break;
      }
    return Text(
      'Minimum $participant entry needed',
      style: TextStyle(fontWeight: FontWeight.w500),
    );
  }

  double _getFirstRankWinningAmount(Contest contest) {
    final winningPrices = contest.winningPrizes;
    if (winningPrices.isNotEmpty)
      return winningPrices.first.winningAmount;
    return 0;
  }

  bool get _ableToJoin =>
      contest.isAbleToJoin ||
      (contest.contestParticipants != contest.maxEntryPerUser &&
          contest.maxEntryPerUser != 1 &&
          contest.notAbleToJoinMessage != maximumContestJoined);

  bool get _ableToShare =>
      contest.isPrivate && contest.noOfEntry != contest.contestParticipants;

  void _shareContestCode(BuildContext context) {
    final match = context.read<MatchInfo>().match;
    final message =
        'Join the contest of ${match.shortName} using contest code "${contest.referralCode}" in TheSuper11. Download the app from $baseUrl';
    Share.share(message);
  }
}
