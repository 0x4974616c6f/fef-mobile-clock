import 'dart:async';

import 'package:fef_mobile_clock/src/utils/format_time_utils.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GlobalState extends ChangeNotifier {
  int _counter = 0;
  Timer? _timer;
  bool _isStarted;

  GlobalState({bool isStarted = false}) : _isStarted = isStarted;

  bool get isStarted => _isStarted;
  int get counter => _counter;

  Future<void> saveState() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('counter', _counter);
    prefs.setInt('timestamp', DateTime.now().millisecondsSinceEpoch);
    prefs.setBool('isStarted', _isStarted);
  }

  Future<void> loadState() async {
    final prefs = await SharedPreferences.getInstance();
    final savedCounter = prefs.getInt('counter');
    final savedTimestamp = prefs.getInt('timestamp');
    final savedIsStarted = prefs.getBool('isStarted');

    if (savedCounter != null &&
        savedTimestamp != null &&
        savedIsStarted != null) {
      if (savedIsStarted) {
        final elapsedTime =
            DateTime.now().millisecondsSinceEpoch - savedTimestamp;
        _counter = savedCounter + (elapsedTime ~/ 1000);
        _isStarted = true;
      } else {
        _counter = savedCounter;
      }
    } else {
      _counter = 0;
    }
  }

  void toggleIsStarted() {
    _isStarted = !_isStarted;
    notifyListeners();
  }

  void startTimer({Function(String)? onTimeUpdate}) {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _counter++;
      if (onTimeUpdate != null) {
        onTimeUpdate(formatDuration(Duration(seconds: _counter)));
      }
      notifyListeners();
    });
  }

  void stopTimer({Function()? onTimeStop}) {
    _timer?.cancel();
    if (onTimeStop != null) {
      onTimeStop();
    }
  }

  void resetTimer() {
    _counter = 0;
    notifyListeners();
  }
}
