import 'package:flutter_application/models/TodoItem.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;

  Future<Database?> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  Future<Database> _initDatabase() async {
    try {
      Directory documentsDirectory = await getApplicationDocumentsDirectory();
      String path = join(documentsDirectory.path, 'todo.db');
      return await openDatabase(path, version: 1, onCreate: _onCreate);
    } catch (e) {
      print("Error initializing database: $e");
      rethrow;
    }
  }

  Future _onCreate(Database db, int version) async {
    try {
      await db.execute('''
        CREATE TABLE todos(
          id INTEGER PRIMARY KEY,
          text TEXT,
          completed BIT
        )
      ''');
    } catch (e) {
      print("Error creating table: $e");
      rethrow;
    }
  }

  Future<List<TodoItem>> getToDos() async {
    try {
      Database? db = await instance.database;
      var todoItems = await db!.query('todos', orderBy: 'id');
      List<TodoItem> todoItemsList = todoItems.isNotEmpty
          ? todoItems.map((e) => TodoItem.fromMap(e)).toList()
          : [];
      return todoItemsList;
    } catch (e) {
      print("Error fetching todos: $e");
      rethrow;
    }
  }

  Future<int> add(TodoItem item) async {
    try {
      Database? db = await instance.database;
      return await db!.insert('todos', item.toMap());
    } catch (e) {
      print("Error adding todo: $e");
      rethrow;
    }
  }

  Future<int> update(TodoItem item) async {
    try {
      Database? db = await instance.database;
      return await db!.update('todos', item.toMap(),
          where: 'id = ?', whereArgs: [item.id]);
    } catch (e) {
      print("Error updating todo: $e");
      rethrow;
    }
  }

  Future<int> delete(int id) async {
    try {
      Database? db = await instance.database;
      return await db!.delete('todos', where: 'id = ?', whereArgs: [id]);
    } catch (e) {
      print("Error deleting todo: $e");
      rethrow;
    }
  }
}
