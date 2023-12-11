/*import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:dart_openai/dart_openai.dart';

class ChatGptApi {
  static final ChatGptApi _instance = ChatGptApi._privateConstructor();

  ChatGptApi._privateConstructor();

  factory ChatGptApi() {
    return _instance;
  }

  Future<String> getFeedback(List<String> responses) async {
    var openAI = OpenAI.instance;
    var request = openAI.createCompletion(
      model: 'text-davinci-003', // Use the appropriate model name
      prompt: responses.join('\n'),
      maxTokens: 60,
      temperature: 0.5,
    );
    var response = await request;
    return response.choices.first.text;
  }
}
*/