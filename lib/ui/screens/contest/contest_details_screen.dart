import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:the_super11/core/utility.dart';
import 'package:the_super11/models/models.dart';
import 'package:the_super11/ui/resources/resources.dart';
import 'package:the_super11/ui/screens/contest/leaderboard_list.dart';
import 'package:the_super11/ui/screens/contest/ranking_list.dart';
import 'package:the_super11/ui/widgets/widgets.dart';

import 'contest_app_header.dart';
import 'contest_item.dart';

class ContestDetailsScreenData {
  final Contest contest;
  final bool fromMyContests;

  ContestDetailsScreenData({
    required this.contest,
    this.fromMyContests = false,
  });
}

class ContestDetailsScreen extends StatefulWidget {
  static const route = '/contest-details';
  final ContestDetailsScreenData data;

  const ContestDetailsScreen({Key? key, required this.data}) : super(key: key);

  @override
  _ContestDetailsScreenState createState() => _ContestDetailsScreenState();
}

class _ContestDetailsScreenState extends State<ContestDetailsScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: ContestAppHeader(
        showAddMoney: true,
      ),
      body: Column(
        children: [
          ContestItem(
            contest: widget.data.contest,
            fromMyContests: widget.data.fromMyContests,
          ),
          SlidingControl(
            labels: ['Ranking', 'Leaderboard'],
            onIndexChanged: (i) => setState(() => _selectedIndex = i),
          ),
          if (_selectedIndex == 0)
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(8),
                child: Column(
                  children: [
                    RankingList(contest: widget.data.contest),
                    SizedBox(
                      height: 16,
                    ),
                    Text(
                        'In case the number of Participants in particular contest is less than the pre-indicated number at the time of beginning of the match, such Contest or Contests will not be operational and the amount paid by each Participant  will be gotten back to the User without any charge or derivation.'),
                    SizedBox(
                      height: 4,
                    ),
                    _privacyPolicyLink(),
                  ],
                ),
              ),
            ),
          if (_selectedIndex == 1)
            Expanded(
              child: LeaderboardList(),
            )
        ],
      ),
    );
  }

  Widget _privacyPolicyLink() => MaterialButton(
        onPressed: () => Utility.launchUrl(baseUrl),
        padding: EdgeInsets.zero,
        child: Text.rich(
          TextSpan(
            text: 'Please read the privacy policy, terms & conditions at ',
            children: [
              TextSpan(
                text: baseUrl.substring(0, baseUrl.length - 1),
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                ),
              ),
            ],
          ),
          style: TextStyle(
            fontSize: 16,
          ),
        ),
      );
}
