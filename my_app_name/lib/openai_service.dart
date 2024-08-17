import 'dart:convert';

import 'package:http/http.dart' as http;

class OpenAIService {
  final List<Map<String, String>> messages = [];
  static const apiUri = 'https://api.openai.com/v1/chat/completions';
  static const apiKey = 'sk-HASFUAEWgmGmDdKq3KwjcGssyPB79cIFSNM3T3W13ZT3BlbkFJP_gP8lYsKDLaymxjE8tM4Mfcc_8egMunPlJVVpOoIA';

  Future<String> chatGPTAPI(String prompt) async {
    messages.add({
      "role": "user",
      "content":
          "You are a financial advice bot called Younes and you are supposed to only give financial and technological advice to startups.$prompt",
    });
    try {
      final res = await http.post(
        Uri.parse(apiUri),
        headers: {
          'Content-Type': 'application/json',
          "Authorization": 'Bearer $apiKey',
          'OpenAI-Organization': ''
        },
        body: jsonEncode({
          "model": "gpt-4o-mini",
          "messages": messages,
          "temperature": 0.7
        }),
      );

      //print(res.body);

      if (res.statusCode == 200) {
        String content =
            jsonDecode(res.body)['choices'][0]['message']['content'];
        content = content.trim();

        messages.add({
          'role': 'assistant',
          'content': content,
        });
        return content;
      }
      return 'An internal error occurred';
    } catch (e) {
      return e.toString();
    }
  }
}