import 'package:flutter/material.dart';

// Soru Model Sınıfı

class Question {
  final String text;
  final String category;

  Question(this.text, this.category);
}

//Soruların Listesi

final List<Question> smartEduQuestions = [
  Question("1. Görselleri kullanarak mı daha iyi öğrenirsiniz?", "Visual"),
  Question("2. Harita, tablo veya grafiklerle çalışmak size yardımcı olur mu?", "Visual"),
  Question("3. Bilgileri dinleyerek mi daha iyi öğrenirsiniz?", "Auditory"),
  Question("4. Bir konuyu anlamak için yüksek sesle tekrar eder misiniz?", "Auditory"),
  Question("5. Öğrenirken uygulamalı etkinlikler yapmayı tercih eder misiniz?", "Kinesthetic"),
  Question("6. Deneyerek veya dokunarak mı daha iyi öğrenirsiniz?", "Kinesthetic"),
  Question("7. Yeni bilgileri yazarak veya okuyarak mı daha iyi öğrenirsiniz?", "Verbal"),
  Question("8. Öğrendiklerinizi başkalarına anlatmak konuyu pekiştirir mi?", "Verbal"),
  Question("9. Problemleri neden-sonuç ilişkisiyle mi öğrenirsiniz?", "Logical"),
  Question("10. Öğrenirken sistematik planlar yapar mısınız?", "Logical"),
];

class QuestionScreen extends StatefulWidget {
  final Function(int points, String category) onAnswerQuestion;

  final VoidCallback onFinished;

  const QuestionScreen({
    Key? key,
    required this.onAnswerQuestion,
    required this.onFinished,
  }) : super(key: key);

  @override
  _QuestionScreenState createState() => _QuestionScreenState();
}

class _QuestionScreenState extends State<QuestionScreen> {
  int _currentIndex = 0;
  int? _selectedPoints;

  void _nextQuestion() {
    if (_selectedPoints == null) return;

    widget.onAnswerQuestion(
      _selectedPoints!,
      smartEduQuestions[_currentIndex].category,
    );

    if (_currentIndex < smartEduQuestions.length - 1) {
      setState(() {
        _currentIndex++;
        _selectedPoints = null;
      });
    } else {
      widget.onFinished();
    }
  }

  Widget _buildAnswerButton(String text, int points) {
    final isSelected = _selectedPoints == points;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            _selectedPoints = points;
          });
        },
        child: Text(text),
        style: ElevatedButton.styleFrom(
          backgroundColor: isSelected ? Colors.indigoAccent : Colors.grey[300],
          foregroundColor: isSelected ? Colors.white : Colors.black,
          minimumSize: Size(double.infinity, 50),
          textStyle: TextStyle(fontSize: 16),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentQuestion = smartEduQuestions[_currentIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text("Öğrenme Stili Testi"),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            //  Soru Numarası
            Text(
              "Soru ${_currentIndex + 1} / ${smartEduQuestions.length}",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.indigo,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),

            //  Soru İçeriği
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.indigo.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                currentQuestion.text,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 30),

            // Cevap Butonları (Evet/Kısmen/Hayır)
            _buildAnswerButton("Evet", 3),
            _buildAnswerButton("Kısmen", 1),
            _buildAnswerButton("Hayır", 0),

            Spacer(),

            // Sonraki Soru Butonu
            ElevatedButton(
              onPressed: _selectedPoints != null ? _nextQuestion : null,
              child: Text(
                _currentIndex == smartEduQuestions.length - 1
                    ? "Testi Bitir"
                    : "Sonraki Soru",
              ),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 16),
                textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                backgroundColor: Colors.white,
                disabledBackgroundColor: Colors.grey.shade400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}