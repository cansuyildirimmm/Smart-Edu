import 'package:flutter/material.dart';
import 'package:smartedu/screens/PDFViewerPage.dart';

class STopics extends StatelessWidget {
  final String lessonTitle;

  const STopics({super.key, required this.lessonTitle});

  final Map<String, String> topicToPdf = const {
    'Doğal Sayılar': 'assets/materials/dogal_sayilar.pdf',
    'Toplama ve Çıkarma İşlemi': 'assets/materials/toplama_cikarma.pdf',
    'Çarpma ve Bölme İşlemi': 'assets/materials/carpma_bolme.pdf',
    'Kesirler': 'assets/materials/kesirler.pdf',
    'Geometrik Şekiller': 'assets/materials/geometrik_sekiller.pdf',
    'Alan Hesaplama': 'assets/materials/alan_hesaplama.pdf',
    'Zaman Ölçme': 'assets/materials/zaman_olcme.pdf',
    'Paralarımız': 'assets/materials/paralarimiz.pdf',
    'Tartma': 'assets/materials/tartma.pdf',
    'Geometrik Cisimler Ve Şekiller': 'assets/materials/geometrik_cisimler.pdf',
    'Geometrik Örüntüler': 'assets/materials/geometrik_oruntuler.pdf',
    'Geometrik Temel Kavramlar': 'assets/materials/temel_kavramlar.pdf',
    'Uzamsal İlişkiler': 'assets/materials/uzamsal_iliskiler.pdf',
    'Uzunluk - Çevre - Alan Ölçme': 'assets/materials/uzunluk_cevce_alan.pdf',
    'Sıvı Ölçme': 'assets/materials/sivi_olcme.pdf',
  };

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
          children: topicToPdf.keys.map((topic) {
            return GestureDetector(
              onTap: () {
                final path = topicToPdf[topic];
                if (path != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PDFViewerPage(
                        assetPath: topicToPdf[topic]!,
                        title: topic,
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
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
