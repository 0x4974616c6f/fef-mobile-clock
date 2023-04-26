import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationHandler extends StatefulWidget {
  final Widget child;
  final NotificationHandlerController controller;

  const NotificationHandler({
    Key? key,
    required this.child,
    required this.controller,
  }) : super(key: key);

  @override
  NotificationHandlerState createState() =>
      NotificationHandlerState(); // Atualizado aqui
}

class NotificationHandlerController {
  NotificationHandlerState? _notificationHandlerState; // Atualizado aqui

  void _bindState(NotificationHandlerState state) {
    // Atualizado aqui
    _notificationHandlerState = state;
  }

  Future<void> showTimeNotification(String timeText) async {
    _notificationHandlerState?.showTimeNotification(timeText);
  }

  Future<void> cancelTimeNotification() async {
    _notificationHandlerState?.cancelTimeNotification();
  }
}

class NotificationHandlerState extends State<NotificationHandler> {
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    widget.controller._bindState(this);
    _configureLocalNotifications();
  }

  Future<void> _configureLocalNotifications() async {
    // Configure a inicialização do plugin.
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('drawable/app_icon');
    const IOSInitializationSettings initializationSettingsIOS =
        IOSInitializationSettings();
    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onSelectNotification: _onSelectNotification,
    );
  }

  Future<dynamic> _onSelectNotification(String? payload) async {
    if (payload != null) {
      debugPrint('Notificação tocada: $payload');
    }
  }

  Future<void> showTimeNotification(String timeText) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      '1',
      'Ferrinox Clock',
      // 'Ferrinox Clock',
    );

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
    );

    await _flutterLocalNotificationsPlugin.show(
      1, // Notification ID
      'Contador em execução', // Título da notificação
      'Tempo atual: $timeText', // Conteúdo da notificação
      notificationDetails,
    );
  }

  Future<void> cancelTimeNotification() async {
    await _flutterLocalNotificationsPlugin.cancel(1);
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
