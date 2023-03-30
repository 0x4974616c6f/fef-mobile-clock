import 'package:fef_mobile_clock/src/services/time_record.dart';

Future<Map<String, dynamic>> addTimeRecord(DateTime timestamp, String userId) {
  return addTimeRecordToApi(timestamp, userId);
}

Future<Map<String, dynamic>> updateTimeRecord(
    DateTime timestamp, String userId, String timeId) {
  return updateTimeRecordToApi(timestamp, userId, timeId);
}
