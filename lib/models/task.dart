import 'package:cloud_firestore/cloud_firestore.dart';

enum Priority {low, medium, high}
enum TaskTags {school, personal, others}

// data model - needed for one task/ to-do item
class Task {
  final String id;
  final String title;
  final DateTime dueDateTime;
  final Priority priority;
  final TaskTags tag;
  final bool isDone;
  final DateTime createdAt;

  //constructor - builds a task
  Task ({
    required this.id,
    required this.title,
    required this.dueDateTime,
    required this.priority,
    required this.tag,
    this.isDone = false,
    required this.createdAt,
  });

  // task -> Map so it can be written to Firestore
  Map<String, dynamic> toMap(){
    return {
      'title': title,
      'dueDateTime': Timestamp.fromDate(dueDateTime),
      'priority': priority.name,
      'tag': tag.name,
      'isDone': isDone,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  // rebuilds a task from a firestore document (map + its id)
  factory Task.fromMap(String id, Map<String, dynamic> map) {
    return Task(
      id: id,
      title: map['title'] as String,
      dueDateTime: (map['dueDateTime'] as Timestamp).toDate(),
      priority: Priority.values.byName(map['priority'] as String),
      tag: TaskTags.values.byName(map['tag'] as String),
      isDone: map['isDone'] as bool? ??false,
      createdAt: (map['createdAt'] as Timestamp).toDate(),
    );
  }

  // for edit purposes - return a copy of specific fields
  Task copyWith({
    String? title,
    DateTime? dueDateTime,
    Priority? priority,
    TaskTags? tag,
    bool? isDone,
  }) {
    return Task(
      id: id,
      title: title ?? this.title,
      dueDateTime: dueDateTime ?? this.dueDateTime,
      priority: priority ?? this.priority,
      tag: tag ?? this.tag,
      isDone: isDone ?? this.isDone,
      createdAt: createdAt,
    );
  }
}
