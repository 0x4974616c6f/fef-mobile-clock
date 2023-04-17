import 'package:fef_mobile_clock/src/components/main_page_view.dart';
import 'package:fef_mobile_clock/src/screens/config_screen.dart';
import 'package:fef_mobile_clock/src/screens/home_screen.dart';
import 'package:fef_mobile_clock/src/screens/login_screen.dart';
import 'package:fef_mobile_clock/src/components/notification_handler.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fef_mobile_clock/src/providers/user_provider.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  Future<String> _getInitialRoute(BuildContext context) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final token = await userProvider.getAccessToken();
    return token != null ? '/home' : '/';
  }

  @override
  Widget build(BuildContext context) {
    final notificationController = NotificationHandlerController();
    return NotificationHandler(
      controller: notificationController,
      child: MaterialApp(
        title: 'Ferrinox Clock',
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
          '/': (context) =>
              _buildInitialScreen(context, notificationController),
          '/home': (context) => MainPageView(),
          '/config': (context) => ConfigScreen(),
        },
      ),
    );
  }

  Widget _buildInitialScreen(BuildContext context,
      NotificationHandlerController notificationController) {
    return FutureBuilder(
      future: _getInitialRoute(context),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else {
          return snapshot.data == '/home'
              ? MainPageView() // Mude para MainPageView aqui
              : const LoginPage();
        }
      },
    );
  }
}
