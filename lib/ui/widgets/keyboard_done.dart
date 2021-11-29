import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NumberKeyboardAction extends StatelessWidget {
  final VoidCallback? action;

  const NumberKeyboardAction({Key? key, this.action}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: Platform.isIOS ? null : 0,
      alignment: Alignment.centerRight,
      child: CupertinoButton(
        onPressed: () =>
            action != null ? action!.call() : FocusScope.of(context).unfocus(),
        child: Text(
          action != null ? 'NEXT' : 'DONE',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).primaryColor,
          ),
        ),
        minSize: 0,
        padding: const EdgeInsets.all(12),
      ),
    );
  }
}
