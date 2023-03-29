import 'package:fef_mobile_clock/src/providers/user_provider.dart';
import 'package:fef_mobile_clock/src/screens/home_screen.dart';
import 'package:fef_mobile_clock/src/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => UserProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MyApp',
      theme: ThemeData(
        primaryColor: Colors.blue,
        fontFamily: 'Montserrat',
        textTheme: const TextTheme(
          displayLarge: TextStyle(fontSize: 32.0, fontWeight: FontWeight.bold),
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
        '/home': (context) => const HomeScreen()
      },
    );
  }
}
