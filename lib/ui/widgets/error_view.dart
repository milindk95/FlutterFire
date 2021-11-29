import 'package:flutter/material.dart';
import 'package:the_super11/ui/resources/resources.dart';

class ErrorView extends StatelessWidget {
  final String error;
  final double? height;

  const ErrorView({Key? key, required this.error, this.height})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            imgError,
            height: height ?? MediaQuery.of(context).size.height * 0.24,
          ),
          SizedBox(
            height: 12,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              error,
              style: TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
