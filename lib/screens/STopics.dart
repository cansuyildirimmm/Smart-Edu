import 'package:flutter/material.dart';

class STopics extends StatelessWidget {
  final String lessonTitle;

  const STopics({super.key, required this.lessonTitle});

  final List<String> topics = const [
    'Doğal Sayılar',
    'Toplama ve Çıkarma İşlemi',
    'Çarpma ve Bölme İşlemi',
    'Kesirler',
    'Geometrik Şekiller',
    'Alan Hesaplama',
    'Zaman Ölçme',
    'Paralarımız',
    'Tartma',
    'Geometrik Cisimler Ve Şekiller',
    'Geometrik Örüntüler',
    'Geometrik Temel Kavramlar',
    'Uzamsal İlişkiler',
    'Uzunluk - Çevre - Alan Ölçme',
    'Sıvı Ölçme',
  ];

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
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        child: Column(
          children: topics.map((topic) {
            return Container(
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
                  topic,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,  
                    color: Colors.black,  
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
