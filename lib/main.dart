import 'package:flutter/material.dart';
import 'gemini_service.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gemini Test',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: GeminiTestScreen(),
    );
  }
}

class GeminiTestScreen extends StatefulWidget {
  @override
  _GeminiTestScreenState createState() => _GeminiTestScreenState();
}

class _GeminiTestScreenState extends State<GeminiTestScreen> {
  final TextEditingController _controller = TextEditingController();
  String _response = '';
  bool _isLoading = false;

  final gemini = GeminiService();

  void _sendPrompt() async {
    setState(() {
      _isLoading = true;
      _response = '';
    });

    try {
      final result = await gemini.getGeminiResponse(_controller.text);
      setState(() {
        _response = result;
      });
    } catch (e) {
      setState(() {
        _response = 'Hata: $e';
      });
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Gemini API Test")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(labelText: 'Bir şeyler yaz...'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _isLoading ? null : _sendPrompt,
              child: Text('Gönder'),
            ),
            SizedBox(height: 24),
            _isLoading
                ? CircularProgressIndicator()
                : Expanded(
                    child: SingleChildScrollView(child: Text(_response))),
          ],
        ),
      ),
    );
  }
}
