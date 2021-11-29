import 'package:flutter/material.dart';
import 'package:flutter_fire/core/extensions.dart';

class AppTooltip extends StatefulWidget {
  final String message;
  final Widget child;

  const AppTooltip({Key? key, required this.message, required this.child})
      : super(key: key);

  @override
  _AppTooltipState createState() => _AppTooltipState();
}

class _AppTooltipState extends State<AppTooltip> {
  // final _controller = JustTheController();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => context.showAlert(message: widget.message),
      child: widget.child,
      );
  }
}
