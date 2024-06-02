import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_application/models/todo.dart';
import 'package:flutter_application/services/database_services.dart';
import 'package:openapi/api.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _textEditingController = TextEditingController();

  final DatabaseServices _databaseServices = DatabaseServices();
  _HomePageState();

  String _userInput = "";
  String _aiAnswer = "";

  ChatApi? _api;

  void _setAiAnswer(Message message) {
    setState(() {
      _aiAnswer = message.message ?? "<no message received>";
    });
  }

  void _setUserInput(String input) {
    _userInput = input;
  }

  void _askAI() async {
    var message = Message(
      timestamp: DateTime.now().toUtc(),
      author: MessageAuthorEnum.user,
      message: _userInput,
    );

    var response = await _api!.chat(message);

    _setAiAnswer(response!);
  }

  @override
  Widget build(BuildContext context) {
    _api = Provider.of<ChatApi>(context);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: _appBar(),
      body: _buildUI(),
      floatingActionButton: FloatingActionButton(onPressed: _displayTextInputDialog , backgroundColor: Theme.of(context).colorScheme.primary,
          child: const Icon(
            Icons.add,
            color: Colors.white,
          ),
      ),
    );
  }
      
  /**
      body: Column(
        children: <Widget>[
          TextField(
            key: const Key('UserInputTextField'),
            maxLines: 5,
            decoration: const InputDecoration(
              hintText: 'Enter text here',
            ),
            onChanged: (String value) {
              _setUserInput(value);
            },
          ),
          Expanded(
            child: Text(
              _aiAnswer,
              key: const Key('AiAnswerText'),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Ask AI',
        onPressed: _askAI,
        child: const Icon(Icons.send),
      ),
    );
  }
*/
  PreferredSizeWidget _appBar() {
    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.primary,
      title: const Text(
        "Todo",
        style: TextStyle(
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildUI(){
    return SafeArea(child: Column(
      children: [
        _messagesListView(),
      ],
      ));
  }

  Widget _messagesListView(){
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.8,
      width: MediaQuery.of(context).size.width,
      child: StreamBuilder(
        stream: _databaseServices.getTodos(),
        builder: (context,snapshot){
          List todos = snapshot.data?.docs ?? [];
          if(todos.isEmpty){
            return const Center(
              child: Text("No todos found"),
            );
          }
          return ListView.builder(
            itemCount: todos.length,
            itemBuilder: (context, indext){ 
              Todo todo = todos[indext].data();
              String todoId = todos[indext].id;
              return Padding(
                padding: const EdgeInsets.symmetric(
                  vertical:10,
                  horizontal:10,
                ),
                child:ListTile(
                  tileColor: Theme.of(context).colorScheme.primaryContainer,
                  title: Text(todo.task),
                  subtitle: Text(
                    DateFormat("dd-MM-yyyy h:mm a").format(
                      todo.updatedOn.toDate(),
                      ),
                    ),
                    trailing: Checkbox(
                      value: todo.isDone, 
                      onChanged:(value){
                        Todo updatedTodo = todo.copyWith(
                          isDone: !todo.isDone,
                          updatedOn: Timestamp.now(),
                        );
                        _databaseServices.updateTodo(todoId, updatedTodo);
                      }
                    ),
                    onLongPress: () {
                      _databaseServices.deleteTodo(todoId);
                    },
                ),
              );
            }
          );
        }
      ),
    );
  }

  void _displayTextInputDialog() async{
    return showDialog(
      context: context, 
      builder: (context){
        return AlertDialog(
          title: const Text("Add a Todo"),
          content: TextField(
            controller: _textEditingController,
            decoration: const InputDecoration(
              hintText: "Enter your todo",
            ),
          ),
          actions: <Widget>[
            MaterialButton(
              color: Theme.of(context).colorScheme.primary,
              textColor: Colors.white,
              child: const Text("Add"),
              onPressed: () {
                Todo todo = Todo(
                  task: _textEditingController.text,
                  isDone: false,
                  createdOn: Timestamp.now(),
                  updatedOn: Timestamp.now(),
                );
                _databaseServices.addTodo(todo);
                Navigator.pop(context);
                _textEditingController.clear();
              },
            )
          ],
        );
      },
    );
  }
}
