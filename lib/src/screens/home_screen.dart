import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fef_mobile_clock/src/providers/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:fef_mobile_clock/src/services/time_record.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Timer? _timer;
  int _elapsedSeconds = 0;

  @override
  void initState() {
    super.initState();
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
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _elapsedSeconds++;
      });
    });
  }

  void _stopTimer() {
    _timer?.cancel();
  }

  Future<void> _syncTimeRecordsWithApi() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> timeRecords = prefs.getStringList('timeRecords') ?? [];

    for (final timeRecordString in timeRecords) {
      DateTime timeRecord = DateTime.parse(timeRecordString);
      final userId = Provider.of<UserProvider>(context, listen: false).userId;
      final result = await addTimeRecord(timeRecord, userId!);

      if (result['success']) {
        print('Registro de ponto enviado com sucesso');
      } else {
        print('Erro ao enviar registro de ponto');
        return;
      }
    }

    await prefs.setStringList('timeRecords', []);
  }

  Future<void> _handleTimeRecord(BuildContext context, String userId) async {
    final timestamp = DateTime.now();

    var connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult == ConnectivityResult.none) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      List<String> timeRecords = prefs.getStringList('timeRecords') ?? [];
      timeRecords.add(timestamp.toIso8601String());
      await prefs.setStringList('timeRecords', timeRecords);
    } else {
      final result = await addTimeRecord(timestamp, userId);
      if (result['success']) {
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
              const Text('Bem-vindo(a) à tela inicial!'),
              const SizedBox(height: 20),
              Text(
                  'Contador: ${_formatDuration(Duration(seconds: _elapsedSeconds))}'),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => _handleTimeRecord(context, userId!),
                child: const Text('Registrar Ponto'),
              ),
              ElevatedButton(
                onPressed: _stopTimer,
                child: const Text('Parar Contador'),
              ),
            ],
          ),
        ));
  }
}
