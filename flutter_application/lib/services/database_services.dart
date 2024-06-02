import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application/models/todo.dart';

const String TODO_COLLECTION_REF = "todos";

class DatabaseServices{
  final _firestore = FirebaseFirestore.instance;

  late final CollectionReference _todosRef;

  DatabaseServices(){
    _todosRef = _firestore.collection(TODO_COLLECTION_REF).withConverter<Todo>(
      fromFirestore: (snapshots, _) => Todo.fromJason(
        snapshots.data()!,
      ),
      toFirestore: (todo, _) => todo.toJson());
  }

  Stream<QuerySnapshot> getTodos(){
    return _todosRef.snapshots();
  }

  void addTodo(Todo todo){
    _todosRef.add(todo);
  }

  void updateTodo(String todoId, Todo todo){
    _todosRef.doc(todoId).update(todo.toJson());
  }

  void deleteTodo(String todoId){
    _todosRef.doc(todoId).delete();
  }
}