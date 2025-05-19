import 'dart:convert';
import 'package:http/http.dart' as http;

class GeminiService {
  final String apiKey = 'YOUR_API_KEY'; // Buraya kendi API anahtarını yaz

  Future<String> getGeminiResponse(String userInput) async {
    const url =
        'https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent';

    final headers = {
      'Content-Type': 'application/json',
      'x-goog-api-key': apiKey,
    };

    final body = jsonEncode({
      "contents": [
        {
          "parts": [
            {"text": userInput}
          ]
        }
      ]
    });

    final response =
        await http.post(Uri.parse(url), headers: headers, body: body);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final text = data['candidates'][0]['content']['parts'][0]['text'];
      return text;
    } else {
      throw Exception('API hatası: ${response.body}');
    }
  }
}
