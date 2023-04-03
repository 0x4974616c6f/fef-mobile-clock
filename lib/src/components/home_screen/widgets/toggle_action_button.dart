import 'package:flutter/material.dart';

class ToggleActionButton extends StatefulWidget {
  final Function(bool) onPressed;
  const ToggleActionButton({Key? key, required this.onPressed})
      : super(key: key);

  @override
  ToggleActionButtonState createState() => ToggleActionButtonState();
}

class ToggleActionButtonState extends State<ToggleActionButton> {
  bool _isStarted = false;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          _isStarted = !_isStarted;
        });
        widget.onPressed(_isStarted);
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: _isStarted ? Colors.red : Colors.green,
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
      child: Text(
        _isStarted ? 'Finalizar contagem' : 'Começar',
        style: const TextStyle(fontSize: 18),
      ),
    );
  }
}
