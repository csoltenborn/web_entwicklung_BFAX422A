import 'dart:convert';

import 'package:http/http.dart';
import 'package:openapi/api.dart';
import 'package:test/test.dart';
import 'package:test_process/test_process.dart';

import '../bin/ai/mock_ai.dart';
import '../bin/server.dart';

void main() {
  final port = '8080';
  final host = 'http://127.0.0.1:$port';
  late TestProcess process;

  setUp(() async {
    process = await TestProcess.start(
      'dart',
      ['run', 'bin/server.dart'],
      environment: {
        EnvVariables.port: port, 
        EnvVariables.useMockAi: 'true',},
      forwardStdio: true,
    );

    await expectLater(process.stdout, emitsThrough(startsWith('Server listening on port')));
  });

  tearDown(() async => await process.kill());

  test('Root', () async {
    final response = await get(Uri.parse('$host/'));
    expect(response.statusCode, 200);
    expect(response.body.startsWith('Chat Server'), true);
  });

  test('404', () async {
    final response = await get(Uri.parse('$host/doesnotexist'));
    expect(response.statusCode, 404);
  });

  test('Chat', () async {
    var message = Message(
        timestamp: DateTime.now().toUtc(),
        author: MessageAuthorEnum.user,
        message: "whatever");
    var body = json.encode(message.toJson());

    final response = await post(Uri.parse('$host/chat'), body: body);

    expect(response.statusCode, 200);
    var answer = Message.fromJson(json.decode(response.body));
    expect(answer?.message, MockAi.message);
  });
}
