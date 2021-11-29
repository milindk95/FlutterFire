import 'package:flutter/material.dart';
import 'package:flutter_fire/ui/resources/resources.dart';
import 'package:flutter_fire/ui/widgets/widgets.dart';

class ComingSoonScreen extends StatelessWidget {
  static const route = '/coming-soon';
  final String title;

  const ComingSoonScreen({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppHeader(
        title: title,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Image.asset(
            imgComingSoon,
            height: MediaQuery.of(context).size.height * 0.4,
          ),
        ),
      ),
    );
  }
}
