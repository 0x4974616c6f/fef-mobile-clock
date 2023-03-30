import 'dart:convert';
import 'package:http/http.dart' as http;

const String apiUrl = 'http://10.0.2.2:5050/clock/time-records';

Future<Map<String, dynamic>> addTimeRecordToApi(
    DateTime startTime, String userId) async {
  final response = await http.post(
    Uri.parse('$apiUrl/init'),
    headers: {
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode({
      'startTime': startTime.toIso8601String(),
      'employeeId': userId,
    }),
  );

  if (response.statusCode == 201) {
    return {
      'success': true,
      'message': 'Ponto registrado com sucesso',
      'idTime': jsonDecode(response.body)['timeId']
    };
  } else {
    return {'success': false, 'message': 'Erro ao criar registro de tempo'};
  }
}

Future<Map<String, dynamic>> updateTimeRecordToApi(
    DateTime endTime, String userId, String recordId) async {
  final response = await http.put(
    Uri.parse('$apiUrl/fineshed/$recordId'),
    headers: {
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode({
      'endTime': endTime.toIso8601String(),
    }),
  );

  if (response.statusCode == 200) {
    return {'success': true, 'message': 'Ponto registrado com sucesso'};
  } else {
    return {'success': false, 'message': 'Erro ao criar registro de tempo'};
  }
}
