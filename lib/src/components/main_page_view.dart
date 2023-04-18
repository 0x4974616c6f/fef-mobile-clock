import 'package:flutter/material.dart';
import 'package:fef_mobile_clock/src/screens/config_screen.dart';
import 'package:fef_mobile_clock/src/screens/home_screen.dart';
import 'package:fef_mobile_clock/src/components/notification_handler.dart';

class MainPageView extends StatefulWidget {
  const MainPageView({Key? key}) : super(key: key);

  @override
  MainPageViewState createState() => MainPageViewState();
}

class MainPageViewState extends State<MainPageView> {
  final _pageController = PageController(initialPage: 0);
  final notificationController = NotificationHandlerController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    setState(() {
    });
  }

  @override
  Widget build(BuildContext context) {
    return NotificationHandler(
      controller: notificationController,
      child: PageView(
        controller: _pageController,
        onPageChanged: _onPageChanged,
        children: [
          HomeScreen(notificationController: notificationController),
          const ConfigScreen(),
        ],
      ),
    );
  }
}
