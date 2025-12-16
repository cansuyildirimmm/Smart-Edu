// STopics.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smartedu/screens/SMaterialTypePage.dart';

class STopics extends StatelessWidget {
  final String lessonTitle;
  final String subject;
  final String contentType;
  final String testGrade;

  STopics({
    super.key,
    required this.lessonTitle,
    required this.subject,
    required this.contentType,
    required this.testGrade,
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
    return Scaffold(
      appBar: AppBar(
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
      ),
      backgroundColor: const Color(0xFFF5F3FF),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: getTopics(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Bu bölümde materyal bulunamadı.'));
          }

          final topics = snapshot.data!;

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
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
    );
  }
}
