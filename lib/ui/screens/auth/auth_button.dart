import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AuthButton extends StatelessWidget {
  final VoidCallback onPressed;
  final bool progress;

  const AuthButton({
    Key? key,
    required this.onPressed,
    required this.progress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      width: double.infinity,
      child: Stack(
        children: [
          Positioned.fill(
            top: 22,
            child: Container(
              height: 60,
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
          Positioned(
            right: 16,
            child: MaterialButton(
              onPressed: onPressed,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              minWidth: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 12,
              ),
              child: progress
                  ? Container(
                      height: 24,
                      width: 24,
                      child: CupertinoActivityIndicator(),
                    )
                  : Icon(
                      Icons.arrow_right_alt,
                      color: Colors.white,
                    ),
              color: Theme.of(context).colorScheme.primary,
              elevation: 0,
            ),
          )
        ],
      ),
    );
  }
}
