import 'package:flutter/material.dart';

class StyledTimer extends StatelessWidget {
  final String timerText;

  const StyledTimer({Key? key, required this.timerText}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      timerText,
      style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
      textAlign: TextAlign.center,
    );
  }
}
