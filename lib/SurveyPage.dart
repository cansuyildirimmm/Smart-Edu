import 'package:flutter/material.dart';
import 'package:smartedu/disability_screen.dart';
import 'package:smartedu/question_screen.dart';



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
      }
    });
  }

  void onTestFinished() {
    final Map<String, int> scores = {
      'Görsel': visualScore,
      'İşitsel': auditoryScore,
      'Kinestetik': kinestheticScore,
      'Sözel': verbalScore,
      'Mantıksal': logicalScore,
    };

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DisabilityScreen(scores: scores),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return QuestionScreen(
      onAnswerQuestion: answerQuestion,
      onFinished: onTestFinished,
    );
  }
}