import 'package:flutter/material.dart'; 
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smartedu/screens/SMaterialTypePage.dart';
import 'lesson_mode.dart';
import 'package:smartedu/screens/TestListPage.dart';

import '../services/tts_service.dart';

class STopics extends StatefulWidget {
  final String lessonTitle;
  final String subject;
  final String contentType; 
  final int testGrade;
  final LessonMode mode;
  final bool isQuestionBank; 

  const STopics({
    super.key,
    required this.lessonTitle,
    required this.subject,
    required this.contentType,
    required this.testGrade,
    required this.mode,
    required this.isQuestionBank, 
  });

  @override
  State<STopics> createState() => _STopicsState();
}

class _STopicsState extends State<STopics> {
  final TtsService _ttsService = TtsService();

  @override
  void initState() {
    super.initState();
    _announcePage();
  }

  void _announcePage() async {
    if (_ttsService.isEnabled) {
      await Future.delayed(Duration(milliseconds: 500));
      _ttsService.speak("${widget.lessonTitle} dersi, konu seçimi ekranındasınız.");
    }
  }

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<Map<String, dynamic>>> getTopics() {
    if (widget.isQuestionBank) {
      return _firestore
          .collection('tests')
          .where('subject', isEqualTo: widget.subject)
          .where('grade', isEqualTo: widget.testGrade)
          .snapshots()
          .map((snapshot) {
        final docs = snapshot.docs.map((doc) => doc.data()).toList();
        final Map<String, Map<String, dynamic>> uniqueTopics = {};
        for (var item in docs) {
          if (!uniqueTopics.containsKey(item['topic'])) {
            uniqueTopics[item['topic']] = item;
          }
        }
        return uniqueTopics.values.toList();
      });
    } else {
      return _firestore
          .collection('materials')
          .where('subject', isEqualTo: widget.subject)
          .where('contentType', isEqualTo: widget.contentType)
          .where('grade', isEqualTo: widget.testGrade)
          .snapshots()
          .map((snapshot) {
        final docs = snapshot.docs.map((doc) => doc.data()).toList();
        final Map<String, Map<String, dynamic>> uniqueTopics = {};
        for (var item in docs) {
          uniqueTopics[item['title']] = item;
        }
        return uniqueTopics.values.toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isBanaOzel = widget.mode == LessonMode.banaOzel;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F3FF),
      appBar: isBanaOzel ? null : _derslerimAppBar(),
      body: Column(
        children: [
          if (isBanaOzel) _banaOzelHeader(context),
          Expanded(
            child: StreamBuilder<List<Map<String, dynamic>>>(
              stream: getTopics(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                    child: Text('Bu bölümde materyal bulunamadı.'),
                  );
                }

                final topics = snapshot.data!;

                return SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  child: Column(
                    children: topics.map((topic) {
                      final String title = topic['title'];

                      return GestureDetector(
                        onTap: () {
                          if (widget.isQuestionBank) {
                            // 🔹 DÜZELTME: TestListPage'e giderken isBanaOzel parametresini gönderiyoruz
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => TestListPage(
                                  subject: widget.subject,
                                  grade: widget.testGrade,
                                  topic: topic['topic'], 
                                  title: topic['title'], 
                                  isBanaOzel: isBanaOzel, // 🔥 KRİTİK EKLENTİ
                                ),
                              ),
                            );
                          } else {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SMaterialTypePage(
                                  title: title,
                                  subject: widget.subject,
                                  contentType: widget.contentType,
                                  testGrade: widget.testGrade,
                                  isBanaOzel: isBanaOzel, 
                                ),
                              ),
                            );
                          }
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          padding: const EdgeInsets.all(16),
                          width: double.infinity,
                          height: 80,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                              color: isBanaOzel 
                                  ? const Color(0xFF7FE3D6) 
                                  : const Color(0xFFFF5C5C), // RedAccent yerine AppBar rengiyle uyumlu yapıldı
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(12), // Daha modern görünüm için 5'ten 12'ye çekildi
                          ),
                          child: Center(
                            child: Text(
                              title,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18, // 20 biraz büyüktü, 18 daha dengeli
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  AppBar _derslerimAppBar() {
    return AppBar(
      title: Text(
        widget.lessonTitle,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      backgroundColor: const Color(0xFFFF5C5C),
      iconTheme: const IconThemeData(color: Colors.white),
      centerTitle: true,
      elevation: 0,
    );
  }

  Widget _banaOzelHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Color(0xFF7FE3D6),
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
                  icon: const Icon(Icons.arrow_back, color: Color(0xFF4DB6AC)),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Image.asset(
                  'assets/kus.png',
                  height: 80,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            widget.lessonTitle,
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
}