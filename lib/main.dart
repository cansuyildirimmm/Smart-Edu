import 'package:flutter/material.dart';
import 'package:smartedu/OnboardingScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'gemini_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseAuth.instance.setLanguageCode("tr");

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const TestPromptScreen(), // Değiştirilen ekran
    );
  }
}

class TestPromptScreen extends StatefulWidget {
  const TestPromptScreen({super.key});

  @override
  State<TestPromptScreen> createState() => _TestPromptScreenState();
}

class _TestPromptScreenState extends State<TestPromptScreen> {
  final TextEditingController _controller = TextEditingController();
  final GeminiService _geminiService = GeminiService();

  String _response = '';
  bool _isLoading = false;

  void _submitPrompt() async {
    setState(() {
      _isLoading = true;
      _response = '';
    });

    try {
      final result = await _geminiService.generateContent(_controller.text);
      setState(() {
        _response = result;
      });
    } catch (e) {
      setState(() {
        _response = 'Hata oluştu: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _continueToApp() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => OnboardingScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gemini Prompt Test'),
        actions: [
          IconButton(
            icon: const Icon(Icons.arrow_forward),
            onPressed: _continueToApp,
            tooltip: 'Uygulamaya Devam Et',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: 'Prompt girin',
                border: OutlineInputBorder(),
              ),
              minLines: 1,
              maxLines: 5,
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _isLoading ? null : _submitPrompt,
              child: _isLoading
                  ? const CircularProgressIndicator()
                  : const Text('Gönder'),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  _response,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
