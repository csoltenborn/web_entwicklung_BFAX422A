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
  var answer = "";
  ChatApi? _api;
  String currentItem = "C#";
  var items = ["C#", "Java", "Python", "JavaScript"];
  List<int> errorindex = [];
  List<String> code = [];
  List<TextSpan> answerSpans = [];
  bool isErrorRequest = false;
  bool isDoc = false;

  void _setAiAnswer(Message message) {
    setState(() {
      errorindex.clear();
      _aiAnswer = message.message ?? "<no message received>";
      _aiAnswer = _aiAnswer.trim();
      code = _aiAnswer.split('\n');
      if(isErrorRequest){
      GetLineErrors();
        if(errorindex.length > 0) isErrorRequest = true;
        else isErrorRequest = false;
      } 
      setSpans();
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
  void setSpans(){
    answerSpans = code.asMap().entries.map((entry){
      int i = entry.key;
      String l = entry.value;

      return TextSpan(
        text: "$l\n",
        style: TextStyle(
          color: errorindex.contains(i) ? Colors.red : Colors.black,
        ),
      );

    }).toList();
  }
  void AnalyzeCodeError(){
    isErrorRequest = true;
    _userInput = "Vergesse die vorherigen Fragen. Markiere nur Semantische Fehler im Code." 
    "Gebe mir den generierten Code ohne Erklärung zurück und " 
    "schreibe hinter jeden Codeteil der einen Semantischen Fehler hat mit dem Format" 
    "'Code // Error: Errortext.'//'.\n\n$_userInput";
    _askAI();
    //UnderLineErrors();
  }

  void ConvertToOtherLanguage()
  {
    isErrorRequest = false;
    _userInput = "Vergesse die vorherigen Fragen. Gebe mir den Code ohne erklärung zurück." 
    "Konvertiere folgenden Code nur in die Sprache $currentItem: \n\n $_userInput";
    _askAI();
  }

  void WriteUnitTests()
  {
    isErrorRequest = false;
    _userInput = "Setze deinen Wissensstand von der Konversation zurück." 
    "Schreibe unit tests nur in der Sprache $currentItem zu den nun folgenden Methoden und diese ohne erklärung und zusätze zurück."
    "\n\n $_userInput";
    _askAI();
  }

  void GetLineErrors()
  {

    for(int i = 0; i < code.length;i++){
      if (code[i].contains("// Error")){
          errorindex.add(i);
      }
    }
    
  }
  void GetSuggestion(){
    isErrorRequest = false;
    _userInput = "Gebe mir einen Codevorschlag zur Behebung der Fehler aus der vorherigen Antwort zurück. $answerSpans";
    _askAI();
  }
  
  void GetDocumentation(){
    isErrorRequest = false;
    _userInput = "Vergesse die vorherige Konversation. Schreibe eine kleine Dokumentation zu dem folgenden Code: \n$_userInput";
    _askAI();
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
            onPressed: (){
                AnalyzeCodeError();
            } , 
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
            onPressed: WriteUnitTests, 
            child:const Text("Unit Tests für Methoden schreiben (Sprache in der Liste auswählen)")
          ),
          ),
          Expanded(child:
          TextButton(
            onPressed: GetDocumentation, 
            child:const Text("Code dokumentieren")
          ),
          ),
          ],
          ),
          const SizedBox(height: 50),
          Align(
            alignment: Alignment.bottomCenter,
            child: Visibility(
              visible: isErrorRequest,
              child: TextButton(
                child: const Text("Vorschlag zur behebung des Fehlers erhalten"),
                onPressed: GetSuggestion,
              ),
            ),

          ),
          
          Align( alignment: Alignment.centerRight,
          child:IconButton(onPressed: (){
            Alignment.centerRight;
            Clipboard.setData(ClipboardData(text: _aiAnswer));
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Copied")));
            }, 
            icon: const Icon(Icons.copy)
            ),
          ),
          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, crossAxisAlignment: CrossAxisAlignment.start, children: [
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
          Expanded(child: SingleChildScrollView(
            //controller: answer,
            key: const Key('AiAnswerText'),
            //controller: answer,
            child: RichText(text: TextSpan(children: answerSpans)),      
            )
          )],
          ),
        ],
      ),),
    );
  }
}
