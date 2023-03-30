import 'dart:io';
import 'dart:async';
import 'package:fef_mobile_clock/src/components/notification_handler.dart';
import 'package:flutter/material.dart';
import 'package:fef_mobile_clock/src/providers/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:fef_mobile_clock/src/services/time_record.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:image_picker/image_picker.dart';

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

  Future<void> _takePicture() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile == null) {
      print('Nenhuma imagem selecionada.');
      return;
    }

    final File image = File(pickedFile.path);
    print(image.path);
    // Você pode usar a variável 'image' para exibir a imagem no aplicativo ou fazer upload para um servidor.
  }

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
      final result = await updateTimeRecord(timestamp, userId!, timeId);
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
        final result = await addTimeRecord(timeRecord, userId!);

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
      final result = await addTimeRecord(timestamp, userId);
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
    _takePicture();
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
              'Contador: ${_formatDuration(Duration(seconds: _elapsedSeconds))}',
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _handleTimeRecord(context, userId!),
              child: const Text('Registrar Ponto'),
            ),
            ElevatedButton(
              onPressed: _stopTimer,
              child: const Text('Parar Contador'),
            ),
            // Adicionando o FutureBuilder para carregar os dados da API
            FutureBuilder(
              future: _syncTimeRecordsWithApi(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else {
                  // Aqui você pode adicionar o código para exibir os dados carregados
                  return const SizedBox(height: 20);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
