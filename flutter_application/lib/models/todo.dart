import 'package:cloud_firestore/cloud_firestore.dart';

class Todo{
  String task;
  Timestamp createdOn;
  Timestamp updatedOn;

  Todo({
    required this.task,
    required this.createdOn,
    required this.updatedOn,
  });

  Todo.fromJason(Map<String, Object?> json): this(
    task: json['task']! as String,
    createdOn: json['createdOn']! as Timestamp,
    updatedOn: json['updatedOn']! as Timestamp,
  );

  Todo copyWith({
    String? task,
    Timestamp? createdOn,
    Timestamp? updatedOn,
  }) {
    return Todo(
      task: task ?? this.task,
      createdOn: createdOn ?? this.createdOn,
      updatedOn: updatedOn ?? this.updatedOn,
    );
  }

  Map<String, Object?> toJson() {
    return {
      'task': task,
      'createdOn': createdOn,
      'updatedOn': updatedOn,
    };
  }

}