import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

String apiUrl = '${dotenv.env['API_URL']}/';

Future<Map<String, dynamic>> changePassword(
  String employeeToken, String password, String newPassword, String confirmNewPassword
) async {
  final response = await http.post(
    Uri.parse('${apiUrl}auth/change-password'),
    headers: {
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode({
      'employeeToken': employeeToken,
      'password': password,
      'newPassword': newPassword,
      'confirmNewPassword': confirmNewPassword,
    }),
  );

  if (response.statusCode == 200) {
    return {'success': true, 'message': 'Senha alterada com sucesso'};
  } else {
    return {'success': false, 'message': 'Erro ao alterar senha'};
  }
}
