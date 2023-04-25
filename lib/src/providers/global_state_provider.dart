import 'dart:async';

import 'package:fef_mobile_clock/src/utils/format_time_utils.dart';
import 'package:flutter/foundation.dart';

class GlobalState extends ChangeNotifier {
  int _counter = 0;
  Timer? _timer;
  bool _isStarted;

  GlobalState({bool isStarted = false}) : _isStarted = isStarted;

  bool get isStarted => _isStarted;
  int get counter => _counter;

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

  void stopTimer({Function() ? onTimeStop}) {
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
