import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_application/models/todo.dart';
import 'package:flutter_application/services/database_services.dart';
import 'package:intl/intl.dart';
import 'package:openapi/api.dart';
import 'package:provider/provider.dart';

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

  List<String> allTodoTexts = [];
  List<String> allTodoTextsnot = [];
  List<String> words =[];
  
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
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: _displayTextInputDialog,
            backgroundColor: Theme.of(context).colorScheme.primary,
            child: const Icon(
              Icons.add,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16), 

          FloatingActionButton(
            onPressed: sortList,
            backgroundColor: Theme.of(context).colorScheme.primary,
            child: const Icon(
              Icons.sort,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
      
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
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Current Todos:",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Expanded(
                child: StreamBuilder(
                  stream: _databaseServices.getTodos(),
                  builder: (context,snapshot){
                    List todos = snapshot.data?.docs ?? [];
                    if(todos.isEmpty){
                      return const Center(
                        child: Text("No todos found"),
                      );
                    }

                    //fügt die Todos in die NotListe ein
                    for (var todo in todos) {
                      if (!allTodoTextsnot.contains(todo['task'])) {
                        allTodoTextsnot.add(todo['task']);
                      }
                    }
                    allTodoTextsnot.removeWhere((task) => !todos.any((todo) => todo['task'] == task));
                    

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
                              DateFormat("dd-MM-yyyy H:mm").format(
                                todo.updatedOn.toDate(),
                              ),
                            ),
                            onLongPress: () {
                              _databaseServices.deleteTodo(todoId);
                              sortList();
                            },
                          ),
                        );
                      }
                    );
                  }
                ),
              ),
            ],
          ),
        ),
        const Divider(thickness: 1, color: Colors.grey,), // Add a vertical divider
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Reihenfolge für die Bearbeitung:",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              
              Expanded(
                child: ListView.builder(
                itemCount: allTodoTexts.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text('${index + 1}. ${allTodoTexts[index]}'),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ],
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
                sortList();
              },
            )
          ],
        );
      },
    );
  }
 
  void sortList(){
    allTodoTexts.clear();
    allTodoTexts = allTodoTextsnot;
    if(allTodoTexts.isNotEmpty){
      StringBuffer promptBuffer = StringBuffer();
      promptBuffer.write("Sortiere die folgenden Todos nach Wichtigkeit der Aufgabe.Gebe mir nur die Todos zurück, die Antwort soll so aussehen: Todo,Todo,und so weiter. "
      +"Die Aufgaben sortiert nach Wichtigkeit lauten:");

      for (int i = 0; i < allTodoTexts.length; i++) {
        String todoTask = allTodoTexts[i];
        promptBuffer.write("$todoTask,");
      }
      
      String prompt = promptBuffer.toString();
      _setUserInput(prompt);
      _askAI();
      
      String filteredText = filterWords(_aiAnswer);

      setState(() {
        allTodoTexts =  filteredText.split(' ');
      });
    }
  }

String filterWords(String text) {
  words.clear();
  String cleanedText = text.replaceAll('TodoTask: ', '').replaceAll(',', '').replaceAll('Die sortierten Todos nach Wichtigkeit lauten:', '').replaceAll('.', '');
  words = cleanedText.split(' ');
  return words.join(' ');
}

}
