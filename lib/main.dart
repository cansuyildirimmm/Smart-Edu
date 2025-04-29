import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Öğrenme Stili ve Engel Durumu',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SurveyPage(),
    );
  }
}

class SurveyPage extends StatefulWidget {
  @override
  _SurveyPageState createState() => _SurveyPageState();
}

class _SurveyPageState extends State<SurveyPage> {
  int visualScore = 0;
  int auditoryScore = 0;
  int kinestheticScore = 0;
  int verbalScore = 0;
  int logicalScore = 0;
  int mixedScore = 0;
  int exploratoryScore = 0;
  int repetitiveScore = 0;
  int disabilityScore = 0;

  String selectedDisability = '';

  void answerQuestion(int points, String category) {
    setState(() {
      switch (category) {
        case 'Visual':
          visualScore += points;
          break;
        case 'Auditory':
          auditoryScore += points;
          break;
        case 'Kinesthetic':
          kinestheticScore += points;
          break;
        case 'Verbal':
          verbalScore += points;
          break;
        case 'Logical':
          logicalScore += points;
          break;
        case 'Mixed':
          mixedScore += points;
          break;
        case 'Exploratory':
          exploratoryScore += points;
          break;
        case 'Repetitive':
          repetitiveScore += points;
          break;
      }
    });
  }

  void handleDisabilitySelection(String disability) {
    setState(() {
      selectedDisability = disability;
      disabilityScore = 5;
    });
  }

  void showResults() {
    Map<String, int> scores = {
      'Görsel': visualScore,
      'İşitsel': auditoryScore,
      'Kinestetik': kinestheticScore,
      'Sözel': verbalScore,
      'Mantıksal': logicalScore,
      'Karma': mixedScore,
      'Keşfetme': exploratoryScore,
      'Tekrar': repetitiveScore,
    };

    String dominantStyle = scores.entries
        .reduce((a, b) => a.value >= b.value ? a : b)
        .key;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Sonuçlar"),
        content: Text(
          "Baskın Öğrenme Stiliniz: $dominantStyle\n"
          "Engel Durumunuz: ${selectedDisability.isEmpty ? 'Belirtilmedi' : selectedDisability}\n"
          "Engel Puanı: $disabilityScore",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text("Tamam"),
          ),
        ],
      ),
    );
  }

  Widget buildQuestion(String question, String category) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(question),
        Row(
          children: [
            ElevatedButton(
              onPressed: () => answerQuestion(3, category),
              child: Text("Evet"),
            ),
            SizedBox(width: 10),
            ElevatedButton(
              onPressed: () => answerQuestion(0, category),
              child: Text("Hayır"),
            ),
          ],
        ),
        SizedBox(height: 15),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Öğrenme Stili ve Engel Durumu Anketi"),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            buildQuestion(
              "1. Görsellerle daha iyi öğrenirim.",
              "Visual",
            ),
            buildQuestion(
              "2. Sesli anlatımlar bana yardımcı olur.",
              "Auditory",
            ),
            buildQuestion(
              "3. Uygulamalı çalışarak öğrenirim.",
              "Kinesthetic",
            ),
            buildQuestion(
              "4. Yazılı materyallerle daha iyi öğrenirim.",
              "Verbal",
            ),
            buildQuestion(
              "5. Problem çözerek öğrenirim.",
              "Logical",
            ),
            buildQuestion(
              "6. Görsel ve sesli anlatım birleşimi faydalı.",
              "Mixed",
            ),
            buildQuestion(
              "7. Konuyu keşfederek öğrenmeyi severim.",
              "Exploratory",
            ),
            buildQuestion(
              "8. Sık tekrarlar öğrenmeyi kolaylaştırır.",
              "Repetitive",
            ),
            SizedBox(height: 20),
            Text("9. Engel Durumunuzu Seçin:"),
            DropdownButton<String>(
              value: selectedDisability.isEmpty ? null : selectedDisability,
              hint: Text("Engel Durumu"),
              onChanged: (value) {
                handleDisabilitySelection(value!);
              },
              items: [
                'Görme Engelli',
                'İşitme Engelli',
                'Fiziksel Engelli',
                'Dikkat Eksikliği/Hiperaktivite',
                'Öğrenme Güçlüğü'
              ]
                  .map((disability) => DropdownMenuItem(
                        value: disability,
                        child: Text(disability),
                      ))
                  .toList(),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: showResults,
              child: Text("Sonuçları Göster"),
            ),
          ],
        ),
      ),
    );
  }
}
// lib/main.dart

import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Öğrenme Stili ve Engel Durumu',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SurveyPage(),
    );
  }
}

class SurveyPage extends StatefulWidget {
  @override
  _SurveyPageState createState() => _SurveyPageState();
}

class _SurveyPageState extends State<SurveyPage> {
  int visualScore = 0;
  int auditoryScore = 0;
  int kinestheticScore = 0;
  int verbalScore = 0;
  int logicalScore = 0;
  int mixedScore = 0;
  int exploratoryScore = 0;
  int repetitiveScore = 0;
  int disabilityScore = 0;

  String selectedDisability = '';

  void answerQuestion(int points, String category) {
    setState(() {
      switch (category) {
        case 'Visual':
          visualScore += points;
          break;
        case 'Auditory':
          auditoryScore += points;
          break;
        case 'Kinesthetic':
          kinestheticScore += points;
          break;
        case 'Verbal':
          verbalScore += points;
          break;
        case 'Logical':
          logicalScore += points;
          break;
        case 'Mixed':
          mixedScore += points;
          break;
        case 'Exploratory':
          exploratoryScore += points;
          break;
        case 'Repetitive':
          repetitiveScore += points;
          break;
      }
    });
  }

  void handleDisabilitySelection(String disability) {
    setState(() {
      selectedDisability = disability;
      disabilityScore = 5;
    });
  }

  void showResults() {
    Map<String, int> scores = {
      'Görsel': visualScore,
      'İşitsel': auditoryScore,
      'Kinestetik': kinestheticScore,
      'Sözel': verbalScore,
      'Mantıksal': logicalScore,
      'Karma': mixedScore,
      'Keşfetme': exploratoryScore,
      'Tekrar': repetitiveScore,
    };

    String dominantStyle = scores.entries
        .reduce((a, b) => a.value >= b.value ? a : b)
        .key;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Sonuçlar"),
        content: Text(
          "Baskın Öğrenme Stiliniz: $dominantStyle\n"
          "Engel Durumunuz: ${selectedDisability.isEmpty ? 'Belirtilmedi' : selectedDisability}\n"
          "Engel Puanı: $disabilityScore",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text("Tamam"),
          ),
        ],
      ),
    );
  }

  Widget buildQuestion(String question, String category) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(question),
        Row(
          children: [
            ElevatedButton(
              onPressed: () => answerQuestion(3, category),
              child: Text("Evet"),
            ),
            SizedBox(width: 10),
            ElevatedButton(
              onPressed: () => answerQuestion(0, category),
              child: Text("Hayır"),
            ),
          ],
        ),
        SizedBox(height: 15),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Öğrenme Stili ve Engel Durumu Anketi"),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            buildQuestion(
              "1. Görsellerle daha iyi öğrenirim.",
              "Visual",
            ),
            buildQuestion(
              "2. Sesli anlatımlar bana yardımcı olur.",
              "Auditory",
            ),
            buildQuestion(
              "3. Uygulamalı çalışarak öğrenirim.",
              "Kinesthetic",
            ),
            buildQuestion(
              "4. Yazılı materyallerle daha iyi öğrenirim.",
              "Verbal",
            ),
            buildQuestion(
              "5. Problem çözerek öğrenirim.",
              "Logical",
            ),
            buildQuestion(
              "6. Görsel ve sesli anlatım birleşimi faydalı.",
              "Mixed",
            ),
            buildQuestion(
              "7. Konuyu keşfederek öğrenmeyi severim.",
              "Exploratory",
            ),
            buildQuestion(
              "8. Sık tekrarlar öğrenmeyi kolaylaştırır.",
              "Repetitive",
            ),
            SizedBox(height: 20),
            Text("9. Engel Durumunuzu Seçin:"),
            DropdownButton<String>(
              value: selectedDisability.isEmpty ? null : selectedDisability,
              hint: Text("Engel Durumu"),
              onChanged: (value) {
                handleDisabilitySelection(value!);
              },
              items: [
                'Görme Engelli',
                'İşitme Engelli',
                'Fiziksel Engelli',
                'Dikkat Eksikliği/Hiperaktivite',
                'Öğrenme Güçlüğü'
              ]
                  .map((disability) => DropdownMenuItem(
                        value: disability,
                        child: Text(disability),
                      ))
                  .toList(),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: showResults,
              child: Text("Sonuçları Göster"),
            ),
          ],
        ),
      ),
    );
  }
}

