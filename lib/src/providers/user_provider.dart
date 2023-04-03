import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UserProvider with ChangeNotifier {
  String? _accessToken;
  String? _userId;
  String? _email;

  String? get accessToken => _accessToken;
  String? get userId => _userId;
  String? get email => _email;

  static const _storageKey = 'dev';
  final FlutterSecureStorage _storage = FlutterSecureStorage();

  void setUserData(String? accessToken, String? userId, String? email) async {
    _accessToken = accessToken;
    _userId = userId;
    _email = email;
    await _storage.write(key: _storageKey, value: accessToken);
    notifyListeners();
  }

  void cleanUserData() async {
    _accessToken = null;
    _userId = null;
    _email = null;
    await _storage.delete(key: _storageKey);
    notifyListeners();
  }

  Future<String?> getAccessToken() async {
    return await _storage.read(key: _storageKey);
  }
}
