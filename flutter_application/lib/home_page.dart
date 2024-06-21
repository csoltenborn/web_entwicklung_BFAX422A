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
  String _prompt = "";
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
        if(errorindex.length <= 0) isErrorRequest = false;
      } 
      setSpans();
    });
  }

  void _setUserInput(String input) {
    _userInput = input;
  }

  void _askAI() async {
    var message = Message(
      timestamp: DateTime.now().toUtc(),
      author: MessageAuthorEnum.user,
      message: _prompt,
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
  void AnalyseCodeError(){
    isErrorRequest = true;
    _prompt = "Vergesse die vorherige Konversation. Markiere nur Semantische Fehler im Code." 
    "Gebe mir den generierten Code ohne Erklärung zurück und " 
    "schreibe hinter jeden Codeteil der einen Semantischen Fehler hat mit dem Format" 
    "'Code // Error: Errortext.'//'.\n\n$_userInput";
    _askAI();
  }

  void ConvertToOtherLanguage()
  {
    isErrorRequest = false;
    _prompt = "Vergesse die vorherige Konversation. Gebe mir den Code ohne erklärung zurück." 
    "Konvertiere folgenden Code nur in die Programmiersprache $currentItem: \n\n $_userInput";
    _askAI();
  }

  void WriteUnitTests()
  {
    isErrorRequest = false;
    _prompt = "Vergesse die vorherige Konversation." 
    "Schreibe unit tests nur in der Programmiersprache $currentItem zu den nun folgenden Methoden und gebe diese ohne erklärung und zusätze zurück."
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
    _prompt = "Gebe mir einen Codevorschlag zur Behebung der Fehler aus der vorherigen Antwort zurück. Gebe mir nur den Codevorschlag zurück. $answerSpans";
    _askAI();
  }
  
  void GetDocumentation(){
    isErrorRequest = false;
    _prompt = "Vergesse die vorherige Konversation. Schreibe eine kleine Dokumentation zu dem folgenden Code: \n$_userInput";
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
          TextButton.icon(
            onPressed: (){
                AnalyseCodeError();
            }, 
            label: const Text("Code auf Fehler überprüfen"),
            icon: const Icon(Icons.bug_report),
            style: TextButton.styleFrom(
                  foregroundColor: Colors.white,
                  elevation: 10,                     
                  shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(30.0)),
                  backgroundColor: Colors.deepPurple,
                  textStyle: const TextStyle(
                      fontSize: 14, fontStyle: FontStyle.normal)),
          ),
          ),
          const SizedBox(width: 15),
          Expanded(child:
          TextButton.icon(
            onPressed: ConvertToOtherLanguage, 
            label:const Text("Code in eine andere Sprache Konvertieren"),
            icon: const Icon(Icons.change_circle),
            style: TextButton.styleFrom(
                  foregroundColor: Colors.white,
                  elevation: 10,                     
                  shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(30.0)),
                  backgroundColor: Colors.deepPurple,
                  textStyle: const TextStyle(
                      fontSize: 14, fontStyle: FontStyle.normal)),
          ),
          ),
          const SizedBox(width: 25),
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
          const SizedBox(width: 25),
          Expanded(child:
          TextButton.icon(
            onPressed: WriteUnitTests, 
            label:const Text("Unit Tests generieren"),
            icon: const Icon(Icons.code),
            style: TextButton.styleFrom(
                  foregroundColor: Colors.white,
                  elevation: 10,                     
                  shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(30.0)),
                  backgroundColor: Colors.deepPurple,
                  textStyle: const TextStyle(
                      fontSize: 14, fontStyle: FontStyle.normal)),
          ),
          ),
          const SizedBox(width: 15),
          Expanded(child:
          TextButton.icon(
            onPressed: GetDocumentation, 
            label:const Text("Code dokumentieren"),
            icon: const Icon(Icons.edit_document),
            style: TextButton.styleFrom(
                  foregroundColor: Colors.white,
                  elevation: 10,                     
                  shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(30.0)),
                  backgroundColor: Colors.deepPurple,
                  textStyle: const TextStyle(
                      fontSize: 14, fontStyle: FontStyle.normal)),
          ),
          ),
          ],
          ),
          const SizedBox(height: 25),
          Align(
            alignment: Alignment.bottomCenter,
            child: Visibility(
              visible: isErrorRequest,
              child: TextButton.icon(
                label: const Text("Vorschlag zur behebung des Fehlers erhalten"),
                onPressed: GetSuggestion,
                icon: const Icon(Icons.fire_extinguisher),
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white,
                  elevation: 10,                     
                  shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(30.0)),
                  backgroundColor: Colors.deepPurple,
                  textStyle: const TextStyle(
                      fontSize: 14, fontStyle: FontStyle.normal)),
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
              border: OutlineInputBorder(),
              hintText: 'Enter text here',
              filled: true,
              fillColor: Colors.white70
            ),
            onChanged: (String value) {
              _setUserInput(value);
            },
          ),
          ),
          const SizedBox(width: 15),
          Expanded(child: SingleChildScrollView(
            key: const Key('AiAnswerText'),
            child: Expanded( child: RichText(
              text: TextSpan(
                children: answerSpans,
                )
                ),),
            
            )
          )],
          ),
        ],
      ),),
    );
  }
}
