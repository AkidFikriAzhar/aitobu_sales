import 'package:flutter/material.dart';

class CaptionTitle extends StatelessWidget {
  final String title;
  const CaptionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        color: Theme.of(context).colorScheme.primary,
        fontWeight: FontWeight.bold,
        fontSize: 16,
      ),
    );
  }
}
