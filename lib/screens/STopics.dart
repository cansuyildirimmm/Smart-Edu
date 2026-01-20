// STopics.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smartedu/screens/SMaterialTypePage.dart';
import 'lesson_mode.dart';

class STopics extends StatelessWidget {
  final String lessonTitle;
  final String subject;
  final String contentType;
  final String testGrade;
  final LessonMode mode;

  STopics({
    super.key,
    required this.lessonTitle,
    required this.subject,
    required this.contentType,
    required this.testGrade,
    required this.mode,
  });

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<Map<String, dynamic>>> getTopics() {
    return _firestore
        .collection('materials')
        .where('subject', isEqualTo: subject)
        .where('contentType', isEqualTo: contentType)
        .where('grade', isEqualTo: int.parse(testGrade))
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

  @override
  Widget build(BuildContext context) {
    final bool isBanaOzel = mode == LessonMode.banaOzel;

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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  child: Column(
                    children: topics.map((topic) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SMaterialTypePage(
                                title: topic['title'],
                                subject: subject,
                                contentType: contentType,
                                testGrade: testGrade,
                              ),
                            ),
                          );
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          padding: const EdgeInsets.all(16),
                          width: double.infinity,
                          height: 80,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.redAccent),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Center(
                            child: Text(
                              topic['title'],
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
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

  // ===== DERSLERİM APPBAR (HİÇ DEĞİŞMEDİ) =====
  AppBar _derslerimAppBar() {
    return AppBar(
      title: Text(
        lessonTitle,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Color(0xFF2C3E50),
        ),
      ),
      backgroundColor: const Color(0xFFFF5C5C).withOpacity(0.8),
      iconTheme: const IconThemeData(color: Colors.black),
      centerTitle: true,
      elevation: 0,
    );
  }

  // ===== BANA ÖZEL HEADER (FIGMA – KUŞLU / KOALALI) =====
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
                  icon: const Icon(Icons.arrow_back),
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
}
