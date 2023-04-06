class EndTimeRecords {
  late String id;
  late DateTime timestamp;

  EndTimeRecords({
    required this.id,
    required this.timestamp,
  });

  factory EndTimeRecords.fromJson(Map<String, dynamic> json) {
    return EndTimeRecords(
      id: json['id'],
      timestamp: DateTime.parse(json['timestamp']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'timestamp': timestamp.toString(),
    };
  }

  void updatedTimestamp() {
    timestamp = DateTime.now();
  }

  void updatedId(String id) {
    this.id = id;
  }

  @override
  String toString() {
    return 'TimesTamp: $timestamp, Id: $id';
  }
}
