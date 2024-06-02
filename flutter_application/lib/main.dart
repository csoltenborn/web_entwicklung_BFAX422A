import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';
import 'package:openapi/api.dart';
import 'package:provider/provider.dart';
import 'home_page.dart';




  main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  var apiClient = ApiClient(basePath: 'http://127.0.0.1:8080');
  var api = ChatApi(apiClient);
  runApp(
    Provider<ChatApi>(
      create: (_) => api,
      child: const AiApp(),
    ),
  );
}

class AiApp extends StatelessWidget {
  const AiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chat Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(title: 'Listen App'),
    );
  }
}
