import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = 'http://localhost:5050';

  Future<Map<String, dynamic>> login(String email, String password) async {
    final String apiUrl = '$baseUrl/login';
    final response = await http.post(
      apiUrl as Uri,
      body: {
        'email': email,
        'password': password,
      },
    );

    final responseBody = json.decode(response.body);

    if (response.statusCode == 200) {
      return responseBody;
    } else {
      throw Exception(responseBody['message']);
    }
  }

  Future<Map<String, dynamic>> register(
      String email, String password, String name) async {
    final String apiUrl = '$baseUrl/register';
    final response = await http.post(
      apiUrl as Uri,
      body: {
        'email': email,
        'password': password,
        'name': name,
      },
    );

    final responseBody = json.decode(response.body);

    if (response.statusCode == 200) {
      return responseBody;
    } else {
      throw Exception(responseBody['message']);
    }
  }
}
