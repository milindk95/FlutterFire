import 'package:flutter/material.dart';
import 'package:flutter_fire/models/models.dart';

class RankingList extends StatefulWidget {
  final Contest contest;

  const RankingList({Key? key, required this.contest}) : super(key: key);

  @override
  _RankingListState createState() => _RankingListState();
}

class _RankingListState extends State<RankingList> {
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      itemBuilder: (context, i) => _rankingItems(i),
      separatorBuilder: (context, i) => Divider(
        height: 20,
      ),
      itemCount: widget.contest.winningPrizes.length,
    );
  }

  Widget _rankingItems(int i) {
    final price = (widget.contest.winningPrizes)[i];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('# Rank ${price.startRank}' +
            (price.totalRank != 1 ? ' to ${price.endRank}' : '')),
        Text(
          '₹${price.winningAmount}',
          style: TextStyle(
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
