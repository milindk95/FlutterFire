import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:the_super11/core/extensions.dart';
import 'package:the_super11/core/providers/match_info_provider.dart';
import 'package:the_super11/core/utility.dart';
import 'package:the_super11/models/models.dart';
import 'package:the_super11/ui/resources/resources.dart';
import 'package:the_super11/ui/widgets/widgets.dart';

import 'match_status_live.dart';
import 'match_timer.dart';

class MatchItem extends StatelessWidget {
  final MyMatch match;
  final VoidCallback onPressed;

  const MatchItem({Key? key, required this.match, required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: match.contests > 0
          ? () {
              context.read<MatchInfo>().setMatchInfo(match);
              onPressed.call();
            }
          : () => showTopSnackBar(
                context,
                CustomSnackBar.error(
                  message: 'Contests for this match will open soon. Stay tuned',
                ),
              ),
      borderRadius: BorderRadius.circular(8),
      child: Opacity(
        opacity: match.contests > 0 ? 1.0 : 0.6,
        child: Card(
          child: Column(
            children: [
              Container(
                width: double.infinity,
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondary,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
                ),
                child: Text(
                  match.season?.name ?? '',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Divider(
                height: 0,
              ),
              SizedBox(
                height: 12,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  teamView(
                    index: 0,
                    color: match.teams.first.color
                        .getHexColor(defaultColor: team1Color),
                    url: match.teams.first.image,
                    placeholder: imgTeam1Placeholder,
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 8,
                        ),
                        Text(
                          match.shortName,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(
                          height: 12,
                        ),
                        if (match.status == matchNotStarted)
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.timer,
                                size: 18,
                                color: Utility.getTimerColor(
                                    context, match.startDate),
                              ),
                              MatchTimer(startTime: match.startDate),
                            ],
                          ),
                        if (match.status == matchStarted) MatchStatusLive(),
                        if (match.status != matchNotStarted &&
                            match.status != matchStarted)
                          _matchStatus(),
                      ],
                    ),
                  ),
                  teamView(
                    index: 1,
                    color: match.teams.last.color
                        .getHexColor(defaultColor: team2Color),
                    left: false,
                    url: match.teams.last.image,
                    placeholder: imgTeam2Placeholder,
                  ),
                ],
              ),
              SizedBox(
                height: 12,
              ),
              if (!match.status.contains(matchNotStarted))
                Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 4,
                    horizontal: 12,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondary,
                    borderRadius:
                        BorderRadius.vertical(bottom: Radius.circular(8)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(
                            '${match.totalMyTeams}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(' Teams'),
                          SizedBox(
                            width: 8,
                          ),
                          Text(
                            '${match.totalMyContest}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(' Contests'),
                        ],
                      ),
                      Row(
                        children: [
                          if (match.totalRefundAmount > 0)
                            Row(
                              children: [
                                Text(
                                  'Refund ',
                                  style: TextStyle(color: Colors.red),
                                ),
                                Text(
                                  '₹${match.totalRefundAmount}',
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                if (match.totalRefundAmount > 0 &&
                                    match.totalWinningAmount > 0)
                                  SizedBox(
                                    width: 8,
                                  ),
                              ],
                            ),
                          if (match.totalWinningAmount > 0)
                            Row(
                              children: [
                                Text(
                                  'You won ',
                                  style: TextStyle(color: Colors.green),
                                ),
                                Text(
                                  '₹${match.totalWinningAmount}',
                                  style: TextStyle(
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              if (match.status.contains(matchNotStarted))
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    vertical: 4,
                    horizontal: 12,
                  ),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondary,
                    borderRadius:
                        BorderRadius.vertical(bottom: Radius.circular(8)),
                  ),
                  child: Row(
                    children: [
                      Text(
                        match.format,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          match.venue,
                          textAlign: TextAlign.end,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget teamView({
    required int index,
    required Color color,
    required String url,
    required String placeholder,
    bool left = true,
  }) =>
      Expanded(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              left: index == 0 ? 0 : null,
              right: index == 1 ? 0 : null,
              top: 22,
              child: Container(
                width: 24,
                height: 8,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.horizontal(
                    left: Radius.circular(index == 1 ? 50 : 0),
                    right: Radius.circular(index == 0 ? 50 : 0),
                  ),
                  color: color,
                ),
              ),
            ),
            Column(
              children: [
                AppNetworkImage(
                  url: match.teams[index].image,
                  height: 44,
                  errorIcon: placeholder,
                ),
                SizedBox(
                  height: 4,
                ),
                Text(
                  match.teams[index].name,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      );

  Widget _matchStatus() {
    Color getStatusColor() {
      if (match.isCancelled == true)
        return Colors.red;
      else if (match.statusOverview.contains(matchAbandoned) ||
          match.statusOverview.contains(matchPostponed))
        return Colors.orange.shade600;
      else
        return Colors.green;
    }

    String getStatus() {
      if (match.isCancelled == true)
        return 'Cancelled';
      else if (match.statusOverview.contains(matchAbandoned) ||
          match.statusOverview.contains(matchPostponed))
        return match.statusOverview.capitalize;
      else
        return match.status.capitalize;
    }

    return Text(
      getStatus(),
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: getStatusColor(),
      ),
    );
  }
}
