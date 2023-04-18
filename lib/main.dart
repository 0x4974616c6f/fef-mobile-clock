import 'package:fef_mobile_clock/src/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'app.dart';

bool isInDevelopment = false;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: isInDevelopment ? '.env.dev' : '.env.prod');
  tz.initializeTimeZones();
  final userProvider = UserProvider();
  await userProvider.init();
  runApp(
    ChangeNotifierProvider(
      create: (context) => UserProvider(),
      child: const MyApp(),
    ),
  );
}
