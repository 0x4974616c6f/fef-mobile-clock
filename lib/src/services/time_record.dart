import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

String apiUrl = '${dotenv.env['API_URL']}/clock/time-records';

Future<Map<String, dynamic>> addTimeRecordToApi(DateTime startTime,
    String accessToken, String? picture, Position? location) async {
  final response = await http.post(
    Uri.parse('$apiUrl/init'),
    headers: {
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode({
      'employeeToken': accessToken,
      'startTime': startTime.toIso8601String(),
      'longitude': location?.longitude,
      'latitude': location?.latitude,
      'picture': picture,
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
    DateTime endTime, String recordId) async {
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
