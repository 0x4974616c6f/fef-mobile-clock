import 'package:fef_mobile_clock/src/providers/global_state_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ToggleActionButton extends StatefulWidget {
  final Function(bool) onPressed;
  const ToggleActionButton({Key? key, required this.onPressed})
      : super(key: key);

  @override
  ToggleActionButtonState createState() => ToggleActionButtonState();
}

class ToggleActionButtonState extends State<ToggleActionButton> {
  @override
  Widget build(BuildContext context) {
    final globalState = Provider.of<GlobalState>(context);

    return ElevatedButton(
      onPressed: () {
        setState(() {
          globalState.toggleIsStarted();
        });
        widget.onPressed(globalState.isStarted);
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: globalState.isStarted ? Colors.red : Colors.green,
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
      child: Text(
        globalState.isStarted ? 'Finalizar contagem' : 'Começar',
        style: const TextStyle(fontSize: 18),
      ),
    );
  }
}
