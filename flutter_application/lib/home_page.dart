import 'package:flutter/material.dart';
import 'package:flutter_application/database_helper.dart';
import 'package:flutter_application/models/TodoItem.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _todoTextController = TextEditingController();
  late Future<List<TodoItem>> _todoListFuture;

  @override
  void initState() {
    super.initState();
    _refreshTodoList();
  }

  void _refreshTodoList() {
    setState(() {
      _todoListFuture = DatabaseHelper.instance.getToDos();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'To-Do Liste',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _todoTextController,
              decoration: InputDecoration(
                labelText: 'Neue Aufgabe',
              ),
              onSubmitted: (_) async {
                await DatabaseHelper.instance.add(TodoItem(text: _todoTextController.text, completed: false));
                _todoTextController.clear();
                _refreshTodoList();
              },
            ),
          ),
          Expanded(
            child: FutureBuilder<List<TodoItem>>(
              future: _todoListFuture,
              builder: (BuildContext context, AsyncSnapshot<List<TodoItem>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: Text('Loading...'));
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No ToDo Items in list'));
                }
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    var item = snapshot.data![index];
                    return Dismissible(
                      key: ValueKey(item.id),
                      background: Container(
                        color: Colors.red,
                        child: Icon(Icons.delete, color: Colors.white),
                      ),
                      onDismissed: (direction) async {
                        await DatabaseHelper.instance.delete(item.id!);
                        _refreshTodoList();
                      },
                      child: ListTile(
                        leading: Checkbox(
                          value: item.completed,
                          onChanged: (newValue) async {
                            await DatabaseHelper.instance.update(item.copyWith(completed: newValue!));
                            _refreshTodoList();
                          },
                        ),
                        title: Text(
                          item.text,
                          style: TextStyle(
                            decoration: item.completed
                                ? TextDecoration.lineThrough
                                : TextDecoration.none,
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 40.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              tooltip: 'Add to TODO list',
              onPressed: () async {
                await DatabaseHelper.instance.add(TodoItem(text: _todoTextController.text, completed: false));
                _todoTextController.clear();
                _refreshTodoList();
              },
              child: const Icon(Icons.add),
            ),
            const SizedBox(width: 10.0),
            FloatingActionButton(
              tooltip: 'Ask AI (Disabled)',
              onPressed: null,
              child: const Icon(Icons.send),
            ),
          ],
        ),
      ),
    );
  }
}
