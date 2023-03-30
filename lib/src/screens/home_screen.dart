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

import '../components/home_screen/widgets/welcome_text.dart';
import '../components/home_screen/widgets/counter_text.dart';
import '../components/home_screen/widgets/register_button.dart';
import '../components/home_screen/widgets/stop_button.dart';

class HomeScreen extends StatefulWidget {
  final NotificationHandlerController notificationController;
  const HomeScreen({Key? key, required this.notificationController})
      : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Timer? _timer;
  int _elapsedSeconds = 0;
  String timeId = '';

  @override
  void initState() {
    super.initState();
    requestLocationPermission();
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      if (result != ConnectivityResult.none) {
        _syncTimeRecordsWithApi();
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
      final userId = Provider.of<UserProvider>(context, listen: false).userId;
      final result = await updateTimeRecordToApi(timestamp, userId!, timeId);
      if (result['success']) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result['message'])),
        );
      } else {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        List<String> timeRecords = prefs.getStringList('timeRecordsEnd') ?? [];
        timeRecords.add(timestamp.toIso8601String());
        await prefs.setStringList('timeRecordsEnd', timeRecords);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result['message'])),
        );
      }
    }
    setState(() {
      _elapsedSeconds = 0;
    });
  }

  Future<void> _syncTimeRecordsWithApi() async {
    // @ItaloCobains: Colocar o timeRecordsEnd aqui tbm.
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> timeRecordsStart =
        prefs.getStringList('timeRecordsStart') ?? [];
    // List<String> timeRecordEnd = prefs.getStringList('timeRecordEnd') ?? [];

    if (timeRecordsStart.isEmpty) {
    } else {
      for (final timeRecordString in timeRecordsStart) {
        DateTime timeRecord = DateTime.parse(timeRecordString);
        // ignore: use_build_context_synchronously
        final userId = Provider.of<UserProvider>(context, listen: false).userId;
        final result = await addTimeRecordToApi(timeRecord, userId!);

        if (result['success']) {
          print('Registro de ponto enviado com sucesso');
        } else {
          print('Erro ao enviar registro de ponto');
          return;
        }
      }

      await prefs.setStringList('timeRecordsStart', []);
    }
  }

  Future<void> _handleTimeRecord(BuildContext context, String userId) async {
    final timestamp = DateTime.now();

    var connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult == ConnectivityResult.none) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      List<String> timeRecords = prefs.getStringList('timeRecordsStart') ?? [];
      timeRecords.add(timestamp.toIso8601String());
      await prefs.setStringList('timeRecordsStart', timeRecords);
    } else {
      final result = await addTimeRecordToApi(timestamp, userId);
      if (result['success']) {
        timeId = result['idTime'];
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result['message'])),
        );
      } else {
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
    final userId = Provider.of<UserProvider>(context).userId;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const WelcomeText(),
            const SizedBox(height: 30),
            CounterText(counterValue: _elapsedSeconds),
            const SizedBox(height: 30),
            RegisterButton(
              onPressed: () => _handleTimeRecord(context, userId!),
            ),
            const SizedBox(height: 10),
            StopButton(
              onPressed: _stopTimer,
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
