import 'package:flutter/material.dart';

class CounterText extends StatelessWidget {
  final int counterValue;

  const CounterText({Key? key, required this.counterValue}) : super(key: key);

  String _formatDuration(int seconds) {
    int hours = (seconds ~/ 3600);
    int minutes = (seconds % 3600) ~/ 60;
    int remainingSeconds = seconds % 60;

    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitHours = twoDigits(hours);
    String twoDigitMinutes = twoDigits(minutes);
    String twoDigitSeconds = twoDigits(remainingSeconds);
    return '$twoDigitHours:$twoDigitMinutes:$twoDigitSeconds';
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      'Contador: ${_formatDuration(counterValue)}',
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}
