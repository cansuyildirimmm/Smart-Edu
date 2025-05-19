import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class GptService {
  static final String? apiKey = dotenv.env['GPT_API_KEY'];

  static Future<String> sendPrompt(String prompt) async {
    final url = Uri.parse('YOUR_GPT_API_ENDPOINT_HERE');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apiKey',
      },
      body: jsonEncode({
        "prompt": prompt,
        "max_tokens": 100,
        // API’nize göre diğer parametreler
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['choices'][0]['text']; // OpenAI GPT için örnek dönüş
    } else {
      throw Exception('API çağrısı başarısız: ${response.statusCode}');
    }
  }
}
