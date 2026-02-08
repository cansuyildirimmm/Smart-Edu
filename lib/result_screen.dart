import 'package:flutter/material.dart';
import 'package:smartedu/SurveyPage.dart'; // 'Tekrar Dene' için SurveyPage'i import edin
import 'package:smartedu/screens/SMainMenuScreen.dart';
import 'package:smartedu/screens/SMainMenuScreen.dart';
import 'package:smartedu/services/auth.dart';
import 'package:smartedu/services/tts_service.dart';

class ResultScreen extends StatefulWidget {
  final Map<String, int> scores;
  final String disability;
  const ResultScreen({
    super.key,
    required this.scores,
    required this.disability,
  });

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  final TtsService _ttsService = TtsService();
  late String dominantStyle;

  @override
  void initState() {
    super.initState();
    _calculateDominantStyle();
    _announceResults();
  }

  void _calculateDominantStyle() {
    final sortedScores = widget.scores.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    dominantStyle = sortedScores.first.key;
  }

  void _announceResults() async {
    if (_ttsService.isEnabled) {
      await Future.delayed(Duration(milliseconds: 500));
      String text =
          "Test sonuçlarınız: Öğrenme biçiminiz $dominantStyle. Engel durumunuz ${widget.disability}.";
      _ttsService.speak(text);
    }
  }

  @override
  Widget build(BuildContext context) {
    // dominantStyle zaten initState'te hesaplandı
    final disability = widget.disability;

    return Scaffold(
      backgroundColor: const Color(0xFFEDF1FF),
      body: SafeArea(
        child: Center(
          child: Container(
            width: 320,
            margin: const EdgeInsets.all(12),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Color(0xFFEDF1FF)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back_ios_new, size: 18),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    Spacer(),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  "SONUÇLARIM",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF004D40),
                  ),
                ),
                const SizedBox(height: 24),

                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 6,
                            backgroundColor: Colors.purple,
                          ),
                          SizedBox(width: 8),
                          Text(
                            "Öğrenme Biçimi",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Colors.purple,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 4),
                      Padding(
                        padding: const EdgeInsets.only(left: 16.0),
                        child: Text(
                          dominantStyle,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black54,
                          ),
                        ),
                      ),
                      SizedBox(height: 16),
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 6,
                            backgroundColor: Colors.green,
                          ),
                          SizedBox(width: 8),
                          Text(
                            "Engel Durumu",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Colors.green,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 4),
                      Padding(
                        padding: const EdgeInsets.only(left: 16.0),
                        child: Text(
                          disability,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black54,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // Butonlar
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SurveyPage(),
                          ),
                          (route) => route.isFirst,
                        );
                      },
                      borderRadius:
                          BorderRadius.circular(30), // Ripple efekti için
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 24,
                            backgroundColor: Color(0xFF249FD7),
                            child: Icon(Icons.refresh, color: Colors.white),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: Color(0xFF249FD7),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              "Tekrar Dene",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: () async {
                        saveTestResult(
                            kullaniciTuru: 'students',
                            learningStyle: dominantStyle,
                            disabilityStatus: disability);

                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                SMainMenuScreen(), // SHome.dart'taki class adınız
                          ),
                          (Route<dynamic> route) => false,
                        );
                      },
                      borderRadius:
                          BorderRadius.circular(30), // Ripple efekti için
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 24,
                            backgroundColor: Color(0xFFB9F16C),
                            child: Icon(Icons.check, color: Colors.black),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: Color(0xFF00B84A),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              "Testi Tamamla",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
