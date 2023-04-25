import 'package:flutter/material.dart';
import 'package:fef_mobile_clock/src/providers/user_provider.dart';
import 'package:provider/provider.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final ValueNotifier<int> _currentIndex;
  final Function(int) onTap;

  CustomBottomNavigationBar({super.key, required int currentIndex, required this.onTap})
      : _currentIndex = ValueNotifier<int>(currentIndex);

  void logout(BuildContext context) async {
    Provider.of<UserProvider>(context, listen: false).cleanUserData();
    Navigator.pushNamedAndRemoveUntil(
        context, '/', (Route<dynamic> route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: _currentIndex,
      builder: (BuildContext context, int value, Widget? child) {
        return BottomNavigationBar(
          onTap: (index) {
            if (index == 1) {
              Navigator.pushNamed(context, "/config");
            } else if (index == 0) {
              Navigator.pushNamed(context, "/home");
            } else {
              _currentIndex.value = index;
              onTap(index);
            }
          },
          currentIndex: value,
          items: [
            const BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            const BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Config'),
            BottomNavigationBarItem(
              icon: GestureDetector(
                onTap: () => logout(context),
                child: const Icon(Icons.logout),
              ),
              label: 'Sair',
            ),
          ],
          selectedItemColor: Colors.blue,
          unselectedItemColor: Colors.grey,
          showUnselectedLabels: true,
          type: BottomNavigationBarType.fixed,
        );
      },
    );
  }
}
