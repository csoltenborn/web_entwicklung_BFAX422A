// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'package:flutter/material.dart';

class TodoItem {
  final int? id;
  final String text;
  bool completed;

  TodoItem({
    this.id,
    required this.text,
    required this.completed,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'text': text,
      'completed': completed,
    };
  }

  TodoItem copyWith({
    int? id,
    String? text,
    bool? completed,
  }) {
    return TodoItem(
      id: id ?? this.id,
      text: text ?? this.text,
      completed: completed ?? this.completed,
    );
  }

  factory TodoItem.fromMap(Map<String, dynamic> map) {
    return TodoItem(
      id: map['id'] != null ? map['id'] as int : null,
      text: map['text'] as String,
      completed: map['completed'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory TodoItem.fromJson(String source) => TodoItem.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'TodoItem(id: $id, text: $text, completed: $completed)';

  @override
  bool operator ==(covariant TodoItem other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.text == text &&
      other.completed == completed;
  }

  @override
  int get hashCode => id.hashCode ^ text.hashCode ^ completed.hashCode;
}

int generateUniqueId() {
  final uniqueKey = UniqueKey();
  return uniqueKey.hashCode;
}