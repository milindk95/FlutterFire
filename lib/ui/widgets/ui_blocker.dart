import 'package:flutter/material.dart';

class UIBlocker extends StatelessWidget {
  final Widget child;
  final bool block;
  final Function? onBack;

  const UIBlocker({
    Key? key,
    required this.child,
    required this.block,
    this.onBack,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (!block) onBack?.call();
        return !block;
      },
      child: AbsorbPointer(
        absorbing: block,
        child: child,
      ),
    );
  }
}
