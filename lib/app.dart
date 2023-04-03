import 'package:fef_mobile_clock/src/screens/home_screen.dart';
import 'package:fef_mobile_clock/src/screens/login_screen.dart';
import 'package:fef_mobile_clock/src/components/notification_handler.dart';
import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final notificationController = NotificationHandlerController();
    return NotificationHandler(
      controller: notificationController,
      child: MaterialApp(
        title: 'MyApp',
        theme: ThemeData(
          primaryColor: Colors.blue,
          fontFamily: 'Montserrat',
          textTheme: const TextTheme(
            displayLarge:
                TextStyle(fontSize: 32.0, fontWeight: FontWeight.bold),
            titleLarge: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            bodyLarge: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
          ),
          inputDecorationTheme: const InputDecorationTheme(
            border: OutlineInputBorder(),
          ),
          buttonTheme: ButtonThemeData(
            buttonColor: Colors.blue,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18.0),
            ),
          ),
          colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Colors.red),
        ),
        routes: {
          '/': (context) => const LoginPage(),
          '/home': (context) => HomeScreen(
                notificationController: notificationController,
              )
        },
      ),
    );
  }
}
