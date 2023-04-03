import 'dart:async';
import 'package:fef_mobile_clock/src/components/notification_handler.dart';
import 'package:fef_mobile_clock/src/services/time_record.dart';
import 'package:fef_mobile_clock/src/utils/camera_utils.dart';
import 'package:fef_mobile_clock/src/utils/location_utils.dart';
import 'package:flutter/material.dart';
import 'package:fef_mobile_clock/src/providers/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

import '../components/home_screen/widgets/start_message.dart';
import '../components/home_screen/widgets/styled_timer.dart';
import '../components/home_screen/widgets/toggle_action_button.dart';
import 'package:fef_mobile_clock/src/components/custom_bottom_navigation_bar.dart';
import 'package:fef_mobile_clock/src/components/custom_app_bar.dart';

class HomeScreen extends StatefulWidget {
  final NotificationHandlerController notificationController;
  const HomeScreen({Key? key, required this.notificationController})
      : super(key: key);

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  Timer? _timer;
  int _elapsedSeconds = 0;
  String timeId = '';
  bool isStarted = false;
  int _currentIndex = 0;

  void _onBottomNavigationTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    requestLocationPermission();
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      if (result != ConnectivityResult.none) {
        _syncTimeRecordsWithApi(context);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _elapsedSeconds++;
      });

      String formattedTime =
          _formatDuration(Duration(seconds: _elapsedSeconds));
      widget.notificationController.showTimeNotification(formattedTime);
    });
  }

  void _stopTimer() async {
    final timestamp = DateTime.now();

    _timer?.cancel();

    var connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult == ConnectivityResult.none) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      List<String> timeRecords = prefs.getStringList('timeRecordsEnd') ?? [];
      timeRecords.add(timestamp.toIso8601String());
      await prefs.setStringList('timeRecordsEnd', timeRecords);
    } else {
      if (!mounted) return;
      final userId = Provider.of<UserProvider>(context, listen: false).userId;
      final result = await updateTimeRecordToApi(timestamp, userId!, timeId);
      if (!mounted) return;
      if (result['success']) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result['message'])),
        );
      } else {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        List<String> timeRecords = prefs.getStringList('timeRecordsEnd') ?? [];
        timeRecords.add(timestamp.toIso8601String());
        await prefs.setStringList('timeRecordsEnd', timeRecords);
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result['message'])),
        );
      }
    }
    setState(() {
      _elapsedSeconds = 0;
    });
  }

  Future<void> _syncTimeRecordsWithApi(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> timeRecordsStart =
        prefs.getStringList('timeRecordsStart') ?? [];

    if (timeRecordsStart.isEmpty) {
      return;
    } else {
      for (final timeRecordString in timeRecordsStart) {
        DateTime timeRecord = DateTime.parse(timeRecordString);
        if (!mounted) return;
        final userId = Provider.of<UserProvider>(context, listen: false).userId;
        final result = await addTimeRecordToApi(timeRecord, userId!);

        if (result['success']) {
        } else {
          return;
        }
      }

      await prefs.setStringList('timeRecordsStart', []);
    }
  }

  Future<void> _handleTimeRecord(
      BuildContext context, String accessToken) async {
    final timestamp = DateTime.now();

    var connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult == ConnectivityResult.none) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      List<String> timeRecords = prefs.getStringList('timeRecordsStart') ?? [];
      timeRecords.add(timestamp.toIso8601String());
      await prefs.setStringList('timeRecordsStart', timeRecords);
    } else {
      final result = await addTimeRecordToApi(timestamp, accessToken);
      if (result['success']) {
        timeId = result['idTime'];
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result['message'])),
        );
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result['message'])),
        );
      }
    }

    setState(() {
      _elapsedSeconds = 0;
    });
    takePicture();
    _startTimer();
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return '$twoDigitMinutes:$twoDigitSeconds';
  }

  @override
  Widget build(BuildContext context) {
    final accessToken =
        Provider.of<UserProvider>(context, listen: false).accessToken;

    String timerText = _formatDuration(Duration(seconds: _elapsedSeconds));

    return Scaffold(
      appBar: const CustomAppBar(title: 'Contagem de tempo'),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const StartMessage(),
            const SizedBox(height: 30),
            StyledTimer(timerText: timerText),
            const SizedBox(height: 30),
            ToggleActionButton(
              onPressed: (isStarted) {
                if (isStarted) {
                  _handleTimeRecord(context, accessToken!);
                } else {
                  _stopTimer();
                }
              },
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
          currentIndex: _currentIndex, onTap: _onBottomNavigationTap),
    );
  }
}
