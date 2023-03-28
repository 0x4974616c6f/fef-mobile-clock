import 'package:flutter/foundation.dart';

class UserProvider with ChangeNotifier {
  String? _accessToken;
  String? _userId;
  String? _email;

  String? get accessToken => _accessToken;
  String? get userId => _userId;
  String? get email => _email;

  void setUserData(String? accessToken, String? userId, String? email) {
    _accessToken = accessToken;
    _userId = userId;
    _email = email;
    notifyListeners();
  }

  void cleanUserData() {
    _accessToken = null;
    _userId = null;
    _email = null;
    notifyListeners();
  }
}
