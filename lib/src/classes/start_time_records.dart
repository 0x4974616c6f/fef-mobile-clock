import 'package:geolocator/geolocator.dart';

class StartTimeRecords {
  late DateTime timestamp;
  late String? picture;
  Position? location;

  StartTimeRecords({
    required this.timestamp,
    required this.picture,
    this.location,
  });

  factory StartTimeRecords.fromJson(Map<String, dynamic> json) {
    return StartTimeRecords(
      timestamp: DateTime.parse(json['timestamp']),
      picture: json['picture'],
      location:
          json['location'] != null ? Position.fromMap(json['location']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'timestamp': timestamp.toString(),
      'picture': picture,
      'location': location?.toJson(),
    };
  }

  void updatedTimestamp() {
    timestamp = DateTime.now();
  }

  void updatedPicture(String picture) {
    this.picture = picture;
  }

  void updatedLocation(Position location) {
    this.location = location;
  }

  @override
  String toString() {
    return 'TimesTamp: $timestamp, Picture: $picture, Location: $location';
  }
}
