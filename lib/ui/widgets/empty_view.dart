import 'package:flutter/material.dart';

class EmptyView extends StatelessWidget {
  final String message;
  final String image;
  final double? height;
  final String? buttonText;
  final VoidCallback? onPressed;

  const EmptyView({
    Key? key,
    required this.message,
    required this.image,
    this.height,
    this.buttonText,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            image,
            height: height ?? MediaQuery.of(context).size.height * 0.24,
          ),
          SizedBox(
            height: 12,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
          ),
          if (buttonText != null)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: MaterialButton(
                onPressed: onPressed,
                color: Theme.of(context).primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 20,
                ),
                child: Text(
                  buttonText!,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            )
        ],
      ),
    );
  }
}
