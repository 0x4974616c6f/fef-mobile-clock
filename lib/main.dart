import 'package:fef_mobile_clock/src/providers/global_state_provider.dart';
import 'package:fef_mobile_clock/src/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'app.dart';

bool isInDevelopment = true;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: isInDevelopment ? '.env.dev' : '.env.prod');
  tz.initializeTimeZones();
  final userProvider = UserProvider();
  await userProvider.init();
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(
      create: (context) => UserProvider(),
      lazy: false,
    ),
    ChangeNotifierProvider(create: (context) => GlobalState(), lazy: false)
  ], child: const MyApp()));
}
