import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:openapi/api.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});
  
  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

const List<String> list = <String>['C#', 'Java', 'Pyhon', 'Javscript'];

class _HomePageState extends State<HomePage> {
  _HomePageState();

  String _userInput = "";
  String _aiAnswer = "";
  var answer = TextEditingController();
  ChatApi? _api;
  String currentItem = "C#";
  var items = ["C#", "Java", "Python", "JavaScript"];
  

  void _setAiAnswer(Message message) {
    setState(() {
      answer.text = message.message ?? "<no message received>";
      //UnderLineErrors();
      //answer.buildTextSpan(context: context, withComposing: )
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

  void AnalyzeCodeError(){
    _userInput = "Markiere die Fehler im folgenden Programmcode. Gebe mir den Code ohne Erklärung zurück und Schreibe hinter jeden Codeteil der einen Fehler hat mit dem Format 'Code // Error: Errortext.'//'.\n\n$_userInput";
    _askAI();
    //UnderLineErrors();
  }

  void ConvertToOtherLanguage()
  {
    _userInput = "Konvertiere folgenden Code NUR in die Sprache $currentItem: \n\n $_userInput";
    _askAI();
  }

  void UnderLineErrors()
  {
    List<String> codePiece = answer.text.split('\n');
    String newResponse = "";
    for(String s in codePiece){

      if(s.contains("// Error"))
      {
        Text updated = Text(
        "$s", 
        style: TextStyle(
        decoration: TextDecoration.underline,
        ),
        );
         newResponse += updated.data!;

         answer.value = updated as TextEditingValue;
      }
      else newResponse += s;
      
    }
    answer.text = newResponse;

  }

  @override
  Widget build(BuildContext context) {
    _api = Provider.of<ChatApi>(context);
    
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center,children: <Widget>[
          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          Expanded(child: 
          TextButton(
            onPressed: AnalyzeCodeError, 
            child: const Text("Programmcode auf Fehler überprüfen")
          ),
          ),
          Expanded(child:
          TextButton(
            onPressed: ConvertToOtherLanguage, 
            child:const Text("Code in andere Sprache Konvertieren")
          ),
          ),
          
          DropdownButton(
            value: currentItem,
            items: items.map((String items) { 
                return DropdownMenuItem( 
                  value: items, 
                  child: Text(items), 
                ); 
              }).toList(), 
          onChanged: (String? value){
            setState((){
                currentItem = value!;
            });
          },
          ),
          Expanded(child:
          TextButton(
            onPressed: () => {}, 
            child:const Text("Test2")
          ),
          ),
          Expanded(child:
          TextButton(
            onPressed: () => {}, 
            child:const Text("Test2")
          ),
          ),
          ],
          ),
          const SizedBox(height: 100),
          IconButton(onPressed: (){
            Alignment.centerRight;
            Clipboard.setData(ClipboardData(text: answer.text));
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Copied")));
            }, 
            icon: const Icon(Icons.copy)
            ),
          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          Expanded(child: TextField(
            key: const Key('UserInputTextField'),
            maxLines: 20,
            decoration: const InputDecoration(
              hintText: 'Enter text here',
            ),
            onChanged: (String value) {
              _setUserInput(value);
            },
          ),
          ),
          Expanded(child: TextField(
            controller: answer,
            key: const Key('AiAnswerText'),
            maxLines: 20,
            readOnly: true,
            decoration: const InputDecoration(
              hintText: 'Enter text here',
            ),
            onChanged: (String value) {
              _setUserInput(value);
            },
          ),
          
          ),
          ],
          ),
          Expanded(
            child: Text(
              _aiAnswer,
              key: const Key('AiAnswerText'),
            ),
          ),
          
        ],
      ),),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Ask AI',
        onPressed: _askAI,
        child: const Icon(Icons.send),
      ),
    );
  }
}
