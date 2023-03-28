import 'dart:convert';
import 'package:http/http.dart' as http;

Future<Map<String, dynamic>> addTimeRecord(
    DateTime timestamp, String userId) async {
  final date =
      "${timestamp.year.toString().padLeft(4, '0')}-${timestamp.month.toString().padLeft(2, '0')}-${timestamp.day.toString().padLeft(2, '0')}";
  final response = await http.post(
    Uri.parse('http://10.0.2.2:5050/clock/time-records'),
    body: jsonEncode(<String, dynamic>{
      'date': date,
      'employeeId': userId,
    }),
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer your-access-token',
    },
  );

  if (response.statusCode == 201) {
    // Registro de ponto adicionado com sucesso
    return {'success': true, 'message': 'Registro de ponto adicionado'};
  } else {
    // Trate os erros ao adicionar o registro de ponto
    String errorMessage = 'Erro ao adicionar registro de ponto.';
    if (response.statusCode == 400) {
      errorMessage = 'Requisição inválida.';
    } else if (response.statusCode == 401) {
      errorMessage = 'Usuário não autorizado.';
    } else if (response.statusCode == 500) {
      errorMessage = 'Erro no servidor.';
    }

    return {'success': false, 'message': errorMessage};
  }
}
