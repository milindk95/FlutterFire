import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:the_super11/blocs/matches/all_upcoming_matches/all_upcoming_matches_bloc.dart';
import 'package:the_super11/core/utility.dart';

class MatchTimer extends StatefulWidget {
  final String startTime;
  final TextStyle? textStyle;
  final bool showLeft;
  final bool allowBack;

  const MatchTimer({
    Key? key,
    required this.startTime,
    this.textStyle,
    this.showLeft = false,
    this.allowBack = false,
  }) : super(key: key);

  @override
  _MatchTimerState createState() => _MatchTimerState();
}

class _MatchTimerState extends State<MatchTimer> {
  late final Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {});
      if (Utility.getRemainTimeFromCurrent(widget.startTime) == '0s') {
        context.read<AllUpcomingMatchesBloc>().add(GetAllUpcomingMatches());
        if (widget.allowBack) Navigator.of(context).pop();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      '${Utility.getRemainTimeFromCurrent(widget.startTime)}${widget.showLeft ? ' Left' : ''}',
      style: widget.textStyle ??
          TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Utility.getTimerColor(context, widget.startTime),
          ),
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
}
