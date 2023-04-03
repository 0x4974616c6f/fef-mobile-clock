import 'package:flutter/material.dart';

class StartMessage extends StatelessWidget {
  const StartMessage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Text(
      'Comece a contagem',
      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      textAlign: TextAlign.center,
    );
  }
}
