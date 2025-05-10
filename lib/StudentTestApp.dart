import 'package:flutter/material.dart';

void main() {
  runApp(const StudentTestApp());
}

class StudentTestApp extends StatelessWidget {
  const StudentTestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const WelcomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF9C27B0), // Mor zemin
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Öğrenci Platformuna Hoş Geldiniz',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const BlindTestScreen()));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFCDDC39), // Açık yeşil buton
                padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 30),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              ),
              child: const Text('Teste Başla', style: TextStyle(color: Colors.black)),
            ),
          ],
        ),
      ),
    );
  }
}

class BlindTestScreen extends StatefulWidget {
  const BlindTestScreen({super.key});

  @override
  State<BlindTestScreen> createState() => _BlindTestScreenState();
}

class _BlindTestScreenState extends State<BlindTestScreen> {
  int currentQuestion = 0;
  String? selectedAnswer;

  final List<Map<String, dynamic>> questions = [
    {
      'text': 'Sesleri dinleyerek mi daha iyi öğrenirsiniz?',
      'options': ['Evet', 'Hayır']
    },
    {
      'text': 'Eğitim materyallerinin sesli olarak anlatılması sizin için faydalı olur mu?',
      'options': ['Evet', 'Hayır']
    },
    {
      'text': 'Hikayeleri dinleyerek mi, yoksa birine anlatarak mı daha iyi öğrenirsiniz?',
      'options': ['Dinleyerek', 'Anlatarak']
    },
    {
      'text': 'Şekilleri ve nesneleri dokunarak keşfetmek öğrenmenize yardımcı olur mu?',
      'options': ['Evet', 'Hayır']
    },
    {
      'text': 'Bir şeyi hareket ederek öğrenmek size yardımcı olur mu?',
      'options': ['Evet', 'Hayır']
    },
    {
      'text': 'Tekrar ederek ve yüksek sesle söyleyerek mi daha iyi öğrenirsiniz?',
      'options': ['Evet', 'Hayır']
    },
  ];

  void nextQuestion() {
    if (currentQuestion < questions.length - 1) {
      setState(() {
        currentQuestion++;
        selectedAnswer = null;
      });
    } else {
      // Testi bitir, sonuç ekranına geç
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Test tamamlandı!")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final question = questions[currentQuestion];

    return Scaffold(
      backgroundColor: const Color(0xFFFFCFC5),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: BackButton(color: Colors.black),
        title: const Text("Öğrenci Test", style: TextStyle(color: Colors.black)),
        centerTitle: true,
      ),
      body: Center(
        child: Container(
          width: 320,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFFFFCFC5),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '${currentQuestion + 1}. Soru',
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  question['text'],
                  style: const TextStyle(fontSize: 14),
                ),
              ),
              const SizedBox(height: 16),
              Column(
                children: List.generate(question['options'].length, (index) {
                  String option = question['options'][index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6.0),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedAnswer = option;
                        });
                      },
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: selectedAnswer == option ? Colors.grey[300] : Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(option),
                      ),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: selectedAnswer != null ? nextQuestion : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE57373),
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 40),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text("SONRAKİ"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

