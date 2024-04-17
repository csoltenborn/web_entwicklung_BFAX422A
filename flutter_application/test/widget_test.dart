import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_application/main.dart';
import 'package:openapi/api.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';

// mock generation is triggered by executing the follwoing command in the flutter_application dir:
// dart run build_runner build
@GenerateNiceMocks([MockSpec<ChatApi>()])
import 'widget_test.mocks.dart';


MockChatApi? _mockApi;
Provider<ChatApi>? _provider;

void main() {

  setUp(() {
    _mockApi = MockChatApi();
    _provider = Provider<ChatApi>(
          create: (_) => _mockApi!,
          child: const AiApp(),
        );
  });

  testWidgets('End to end', (WidgetTester tester) async {
    const expectedAnswer = "The AI's answer";
    when(_mockApi!.chat(any)).thenAnswer((_) async => Message(
        timestamp: DateTime.now().toUtc(),
        author: MessageAuthorEnum.ai,
        message: expectedAnswer));

    await tester.pumpWidget(_provider!);

    expect(find.text('Enter text here'), findsOneWidget);

    await tester.enterText(
        find.byKey(const Key('UserInputTextField')), "Question to the AI");
    await tester.tap(find.byIcon(Icons.send));
    await tester.pump();

    sleep(300);
//    await _sleep(300);

    var text =
        find.byKey(const Key('AiAnswerText')).evaluate().single.widget as Text;
    expect(text.data, expectedAnswer);
  });
}

// for some reason, the sleep approach below blocks indefinitely - 
// thus this embarassing workaround...
void sleep(int ms) {
  int target = DateTime.now().millisecondsSinceEpoch + ms;
  int dummy = 0;
  while (DateTime.now().millisecondsSinceEpoch < target) {
    dummy++;
  }
  target = dummy;
}

Future<void> _sleep(int ms) async {
  await Future.delayed(Duration(milliseconds: ms));
}
