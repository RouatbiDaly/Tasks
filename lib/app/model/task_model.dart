import 'package:tasks/app/controller/formatting_date.dart';

class Task {
  final int? id;
  final String title;
  final String description;
  final DateTime date;
  final DateTime startTime;
  final DateTime endTime;
  final bool notification;

  Task({
    this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.notification,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'date': FormattingDate().formatDate(date), // Format to YYYY-MM-DD
        'startTime': startTime.toIso8601String(),
        'endTime': endTime.toIso8601String(),
        'notification': notification ? 1 : 0,
      };

  factory Task.fromJson(Map<String, dynamic> json) => Task(
        id: json['id'],
        title: json['title'],
        description: json['description'],
        date: DateTime.parse(json['date']),
        startTime: DateTime.parse(json['startTime']),
        endTime: DateTime.parse(json['endTime']),
        notification: json['notification'] == 1,
      );

  Task copyWith({
    int? id,
    String? title,
    String? description,
    DateTime? date,
    DateTime? startTime,
    DateTime? endTime,
    bool? notification,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      date: date ?? this.date,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      notification: notification ?? this.notification,
    );
  }
}
