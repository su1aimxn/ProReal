class EventModel {
  final String id;
  final String eventName;
  final String? description;
  final DateTime eventDate;
  final String startTime;
  final String endTime;

  EventModel({
    required this.id,
    required this.eventName,
    this.description,
    required this.eventDate,
    required this.startTime,
    required this.endTime,
  });

  factory EventModel.fromJson(Map<String, dynamic> json) {
    print("Received JSON: $json");

    return EventModel(
      id: json['_id'] ?? '',
      eventName: json['eventName'] ?? 'No Name',
      description: json['description'],
      eventDate: json['eventDate'] != null 
          ? DateTime.parse(json['eventDate'])
          : DateTime.now(),
      startTime: json['startTime'] ?? '',
      endTime: json['endTime'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'eventName': eventName,
      'description': description,
      'eventDate': eventDate.toIso8601String(),
      'startTime': startTime,
      'endTime': endTime,
    };
  }
}
