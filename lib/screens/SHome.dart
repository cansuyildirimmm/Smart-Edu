import 'package:flutter/material.dart';
import 'package:smartedu/screens/GeminiEğitimSayfasi.dart';
import 'package:smartedu/screens/STopics.dart';
import 'lesson_mode.dart';

class SHome extends StatelessWidget {
  final String lessonTitle;
  final String subject;
  final int testGrade;
  final LessonMode mode;

  const SHome({
    super.key,
    required this.lessonTitle,
    required this.subject,
    required this.mode,
    this.testGrade = 2,
  });

  @override
  Widget build(BuildContext context) {
    final bool isBanaOzel = mode == LessonMode.banaOzel;

    return Scaffold(
      backgroundColor:
          isBanaOzel ? const Color(0xFFFFF6E5) : const Color(0xFFE6F5F5),
      body: SafeArea(
        child: Column(
          children: [
            /// ===== HEADER =====
            isBanaOzel ? _banaOzelHeader(context) : _derslerimHeader(context),

            /// ===== CONTENT =====
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _menuCard(
                      text: "KONU\nANLATIMI",
                      color: const Color(0xFFD9A6B3),
                      image: "assets/konu-anlatim.png",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => STopics(
                              lessonTitle: lessonTitle,
                              subject: subject,
                              contentType: 'konu_anlatimi',
                              testGrade: testGrade,
                              mode: mode,
                              isQuestionBank: false, // 🔹 otomatik ayarlandı
                            ),
                          ),
                        );
                      },
                    ),
                    _menuCard(
                      text: "SORU\nBANKASI",
                      color: const Color(0xFF43C6C1),
                      image: "assets/soru-b.png",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => STopics(
                              lessonTitle: lessonTitle,
                              subject: subject,
                              contentType: 'soru_bankasi',
                              testGrade: testGrade,
                              mode: mode,
                              isQuestionBank: true, // 🔹 otomatik ayarlandı
                            ),
                          ),
                        );
                      },
                    ),
                    _menuCard(
                      text: "ALIŞTIRMALAR",
                      color: const Color(0xFFFF6B6B),
                      image: "assets/alistirma.png",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => STopics(
                              lessonTitle: lessonTitle,
                              subject: subject,
                              contentType: 'alistirmalar',
                              testGrade: testGrade,
                              mode: mode,
                              isQuestionBank: false, // 🔹 otomatik ayarlandı
                            ),
                          ),
                        );
                      },
                    ),
                    _menuCard(
                      text: "LABORATUVAR",
                      color: const Color(0xFFF2B857),
                      image: "assets/lab.png",
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => STopics(
                              lessonTitle: lessonTitle,
                              subject: subject,
                              contentType: 'laboratuvar',
                              testGrade: testGrade,
                              mode: mode,
                              isQuestionBank: false, // 🔹 otomatik ayarlandı
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 12),
                    _aiCard(context),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ===== DERSLERİM HEADER (HİÇ DEĞİŞMEDİ) =====
  Widget _derslerimHeader(BuildContext context) {
    return Container(
      height: 70,
      decoration: const BoxDecoration(
        color: Color(0xFFBFE8E8),
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(24),
        ),
      ),
      child: Row(
        children: [
          const SizedBox(width: 8),
          Container(
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
            ),
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new,
                  size: 18, color: Colors.black),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          const Spacer(),
          Text(
            lessonTitle,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          const SizedBox(width: 40),
        ],
      ),
    );
  }

  // ===== BANA ÖZEL HEADER (FIGMA UYUMLU – SADECE GÖRSEL) =====
  Widget _banaOzelHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 20),
      decoration: const BoxDecoration(
        color: Color(0xFF7EE1D6), // figma mint tonu
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(30),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.white,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.black),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              const Spacer(),
              Image.asset(
                'assets/koala.png', // figmadaki kuş/koala
                height: 80,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            lessonTitle,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Senin için\nHazırlananlar',
            style: TextStyle(
              fontSize: 14,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  // ===== MENÜ KARTI =====
  Widget _menuCard({
    required String text,
    required Color color,
    required String image,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        height: 110,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Text(
                text,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: Image.asset(
                image,
                height: 80,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ===== AI CARD =====
  Widget _aiCard(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const GeminiEgitimSayfasi(),
          ),
        );
      },
      child: Container(
        height: 90,
        decoration: BoxDecoration(
          color: const Color(0xFF4DD0E1),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 20),
              child: Text(
                "YAPAY ZEKA\nİLE ÖĞREN",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: CircleAvatar(
                radius: 30,
                backgroundColor: Colors.white,
                child: Image.asset(
                  "assets/ai_robot.png",
                  height: 32,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
