import 'dart:convert';
import 'package:fef_mobile_clock/src/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

Future<Map<String, dynamic>> loginUser(
    BuildContext context, String email, String password) async {
  final response = await http.post(
    Uri.parse('${dotenv.env['API_URL']}/mobile/auth/login'),
    body: jsonEncode(<String, String>{
      'email': email,
      'password': password,
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

    // ignore: use_build_context_synchronously
    Provider.of<UserProvider>(context, listen: false)
        .setUserData(accessToken, userId, email);

    return {'success': true, 'message': 'Login realizado com sucesso'};
  } else {
    String errorMessage = 'Ocorreu um erro ao fazer login';
    if (response.statusCode == 400) {
      errorMessage = 'Dados inválidos';
    } else if (response.statusCode == 401) {
      errorMessage = 'Usuário não autorizado';
    } else if (response.statusCode == 404) {
      errorMessage = 'Usuário não encontrado';
    }
    return {'success': false, 'message': errorMessage};
  }
}
