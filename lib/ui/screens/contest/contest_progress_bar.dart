import 'package:flutter/material.dart';
import 'package:flutter_fire/models/models.dart';

class ContestProgressBar extends StatefulWidget {
  final Contest contest;

  const ContestProgressBar({Key? key, required this.contest}) : super(key: key);

  @override
  _ContestProgressBarState createState() => _ContestProgressBarState();
}

class _ContestProgressBarState extends State<ContestProgressBar>
    with SingleTickerProviderStateMixin {
  final _progressKey = GlobalKey();
  late final AnimationController _controller;
  late final Animation<double> _animation;
  double _progressWidth = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    late final double progress;
    if (widget.contest.noOfEntry != 0)
      progress = widget.contest.contestParticipants / widget.contest.noOfEntry;
    else
      progress = 0;

    _animation = Tween<double>(begin: 0, end: progress).animate(_controller);

    WidgetsBinding.instance?.addPostFrameCallback((_) {
      _progressWidth = _progressKey.currentContext?.size?.width ?? 0;
      _controller.forward();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      key: _progressKey,
      height: 6,
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        color: Colors.grey.shade300,
      ),
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) => Container(
          width: _animation.value * _progressWidth,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            gradient: LinearGradient(
              colors: [
                Theme.of(context).primaryColor,
                Color(0xFFEA6789),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
