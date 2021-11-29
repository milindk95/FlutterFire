import 'package:flutter/material.dart';

class MatchStatusLive extends StatefulWidget {
  const MatchStatusLive({Key? key}) : super(key: key);

  @override
  _MatchStatusLiveState createState() => _MatchStatusLiveState();
}

class _MatchStatusLiveState extends State<MatchStatusLive>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;
  final double _width = 50;
  final _color = Colors.blue;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _animation = Tween<double>(begin: _width * -0.5, end: _width * 0.5)
        .animate(_controller);

    _controller.forward();

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed)
        _controller.reverse();
      else if (status == AnimationStatus.dismissed) _controller.forward();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'LIVE',
          style: TextStyle(
            color: _color,
            fontWeight: FontWeight.bold,
            fontSize: 13,
          ),
        ),
        SizedBox(
          height: 2,
        ),
        AnimatedBuilder(
          animation: _animation,
          builder: (context, child) => ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: SizedBox(
              height: 4,
              width: _width,
              child: Stack(
                children: [
                  Container(color: Colors.grey.shade400),
                  Positioned.fill(
                    left: _animation.value,
                    right: -_animation.value,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: _color,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
