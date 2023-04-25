import 'dart:async';
import 'dart:convert';
import 'package:fef_mobile_clock/src/classes/end_time_records.dart';
import 'package:fef_mobile_clock/src/components/notification_handler.dart';
import 'package:fef_mobile_clock/src/providers/global_state_provider.dart';
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
import 'package:fef_mobile_clock/src/classes/start_time_records.dart';
import 'package:fef_mobile_clock/src/utils/format_time_utils.dart';

class HomeScreen extends StatefulWidget {
  final NotificationHandlerController notificationController;
  const HomeScreen({Key? key, required this.notificationController})
      : super(key: key);

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
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
    super.dispose();
  }

  void _startTimer(GlobalState state) {
    // String formattedTime = formatDuration(Duration(seconds: state.counter));

    state.startTimer(onTimeUpdate: (formattedTime) {
      widget.notificationController.showTimeNotification(formattedTime);
    });
  }

  void _stopTimer(GlobalState state) async {
    final timestamp = DateTime.now();

    state.stopTimer(
        onTimeStop: () =>
            widget.notificationController.cancelTimeNotification());

    var connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult == ConnectivityResult.none) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      List<String> timeRecordsEnd = prefs.getStringList('timeRecordsEnd') ?? [];
      EndTimeRecords endTimeRecords =
          EndTimeRecords(timestamp: timestamp, id: timeId);
      timeRecordsEnd.add(jsonEncode(endTimeRecords.toJson()));
      await prefs.setStringList('timeRecordsEnd', timeRecordsEnd);
    } else {
      if (!mounted) return;
      final result = await updateTimeRecordToApi(timestamp, timeId);
      if (!mounted) return;
      if (result['success']) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result['message'])),
        );
      } else {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        List<String> timeRecordsEnd =
            prefs.getStringList('timeRecordsEnd') ?? [];
        EndTimeRecords endTimeRecords =
            EndTimeRecords(timestamp: timestamp, id: timeId);
        timeRecordsEnd.add(jsonEncode(endTimeRecords.toJson()));
        await prefs.setStringList('timeRecordsEnd', timeRecordsEnd);
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result['message'])),
        );
      }
    }
    state.resetTimer();
  }

  Future<void> _syncTimeRecordsWithApi(BuildContext context) async {
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // List<String> timeRecordsStart =
    //     prefs.getStringList('timeRecordsStart') ?? [];

    // if (timeRecordsStart.isEmpty) {
    //   return;
    // } else {
    //   for (final timeRecordString in timeRecordsStart) {
    //     DateTime timeRecord = DateTime.parse(timeRecordString);
    //     if (!mounted) return;
    //     final userId = Provider.of<UserProvider>(context, listen: false).userId;
    //     final result = await addTimeRecordToApi(timeRecord, userId!);

    //     if (result['success']) {
    //     } else {
    //       return;
    //     }
    //   }

    //   await prefs.setStringList('timeRecordsStart', []);
    // }
  }

  Future<void> _handleTimeRecord(
      BuildContext context, String accessToken, GlobalState state) async {
    final timestamp = DateTime.now();
    final picture = await takePicture();
    final location = await getCurrentLocation();

    state.resetTimer();

    var connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult == ConnectivityResult.none) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      List<String> startTimeRecordsStrings =
          prefs.getStringList('timeRecordsStart') ?? [];
      StartTimeRecords newRecord = StartTimeRecords(
        picture: picture,
        location: location,
        timestamp: timestamp,
      );
      startTimeRecordsStrings.add(jsonEncode(newRecord.toJson()));
      prefs.setStringList('timeRecordsStart', startTimeRecordsStrings);
    } else {
      final result =
          await addTimeRecordToApi(timestamp, accessToken, picture, location);
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

    _startTimer(state);
  }

  @override
  Widget build(BuildContext context) {
    final globalState = context.watch<GlobalState>();
    final accessToken =
        Provider.of<UserProvider>(context, listen: false).accessToken;

    String timerText = formatDuration(Duration(seconds: globalState.counter));

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
                  _handleTimeRecord(context, accessToken!, globalState);
                } else {
                  _stopTimer(globalState);
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
