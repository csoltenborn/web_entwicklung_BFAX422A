import 'package:cloud_firestore/cloud_firestore.dart';

class Todo{
  String task;
  bool isDone;
  String? id;
  Timestamp createdOn;
  Timestamp updatedOn;

  Todo({
    required this.task,
    required this.isDone,
    required this.id,
    required this.createdOn,
    required this.updatedOn,
  });

  Todo.fromJason(Map<String, Object?> json): this(
    task: json['task']! as String,
    isDone: json['isDone']! as bool,
    id: json['id']! as String,
    createdOn: json['createdOn']! as Timestamp,
    updatedOn: json['updatedOn']! as Timestamp,
  );

  Todo copyWith({
    String? task,
    bool? isDone,
    String? id,
    Timestamp? createdOn,
    Timestamp? updatedOn,
  }) {
    return Todo(
      task: task ?? this.task,
      isDone: isDone ?? this.isDone,
      id: id ?? this.id,
      createdOn: createdOn ?? this.createdOn,
      updatedOn: updatedOn ?? this.updatedOn,
    );
  }

  Map<String, Object?> toJson() {
    return {
      'task': task,
      'isDone': isDone,
      'id': id,
      'createdOn': createdOn,
      'updatedOn': updatedOn,
    };
  }

}