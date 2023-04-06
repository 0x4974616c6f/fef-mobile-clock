import 'package:fef_mobile_clock/src/services/time_record.dart';
import 'package:geolocator/geolocator.dart';

Future<Map<String, dynamic>> addTimeRecord(DateTime timestamp,
    String accessToken, String? picture, Position? location) {
  return addTimeRecordToApi(timestamp, accessToken, picture, location);
}

Future<Map<String, dynamic>> updateTimeRecord(
    DateTime timestamp, String timeId) {
  return updateTimeRecordToApi(timestamp, timeId);
}
