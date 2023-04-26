import 'package:fef_mobile_clock/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:fef_mobile_clock/src/providers/user_provider.dart';
import 'package:fef_mobile_clock/src/components/notification_handler.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() {
  testWidgets('Test MaterialApp widget', (WidgetTester tester) async {
    await dotenv.load(fileName: '.env.dev');
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider<UserProvider>(
            create: (_) => UserProvider(),
          ),
          Provider<NotificationHandlerController>(
            create: (_) => NotificationHandlerController(),
          ),
        ],
        child: const MyApp(),
      ),
    );

    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
