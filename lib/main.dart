import 'package:flutter/material.dart';
import 'package:fef_mobile_clock/screens/login_screen.dart';
import 'package:fef_mobile_clock/screens/register_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ferrinox Clock',
      initialRoute: '/',
      routes: {
        '/': (context) => LoginScreen(),
        '/register': (context) => RegisterScreen(),
      },
    );
  }
}
