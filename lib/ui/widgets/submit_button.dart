import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SubmitButton extends StatelessWidget {
  final String label;
  final bool progress;
  final VoidCallback? onPressed;

  const SubmitButton({
    Key? key,
    required this.label,
    this.progress = false,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: !progress ? onPressed : () {},
      padding: const EdgeInsets.symmetric(
        vertical: 18,
      ),
      minWidth: double.infinity,
      color: Theme.of(context).primaryColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: progress
          ? CupertinoTheme(
              data: CupertinoThemeData(brightness: Brightness.dark),
              child: CupertinoActivityIndicator(),
            )
          : Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
    );
  }
}
