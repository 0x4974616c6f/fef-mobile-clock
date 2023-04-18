import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class UserProvider with ChangeNotifier {
  final String? apiurl = dotenv.env['API_URL'];
  UserProvider() {
    init();
  }

  String? _accessToken;
  String? _userId;
  String? _email;

  String? get accessToken => _accessToken;
  String? get userId => _userId;
  String? get email => _email;

  static const _storageKey = 'dev';
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<bool> isAuth(String? accessToken) async {
    if (accessToken == null) {
      return false;
    }
    final response = await http.post(
      Uri.parse('$apiurl/mobile/auth/auth'),
      body: jsonEncode(<String, String>{
        'accessToken': accessToken,
      }),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);

      final accessToken = jsonResponse['accessToken'];
      final userId = jsonResponse['userId'];
      final email = jsonResponse['email'];

      setUserData(accessToken, userId, email);

      return true;
    } else {
      return false;
    }
  }

  Future<void> init() async {
    _accessToken = await _storage.read(key: _storageKey);
    final response = isAuth(_accessToken);
    // ignore: unrelated_type_equality_checks
    if (response == false) {
      cleanUserData();
    }
    notifyListeners();
  }

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
