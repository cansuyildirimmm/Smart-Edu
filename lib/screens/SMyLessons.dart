import 'package:flutter/material.dart';
import 'SHome.dart';

class SMyLessons extends StatelessWidget {
  SMyLessons({super.key});

  final List<Map<String, dynamic>> lessons = [
    {
      'title': 'MATEMATİK',
      'color': Color(0xFFB9DCDC),
      'image': 'assets/mat_icon.png',
      'subjectKey': 'matematik',
    },
    {
      'title': 'TÜRKÇE',
      'color': Color(0xFFDDB0BD),
      'image': 'assets/turkce_icon.png',
      'subjectKey': 'turkce',
    },
    {
      'title': 'FEN\nBİLİMLERİ',
      'color': Color(0xFFF4B49B),
      'image': 'assets/fen_icon.png',
      'subjectKey': 'fen_bilimleri',
    },
    {
      'title': 'SOSYAL\nBİLGİLER',
      'color': Color(0xFF5EC4BE),
      'image': 'assets/ogrenci_sonuc.png',
      'subjectKey': 'sosyal_bilgiler',
    },
    {
      'title': 'İNGİLİZCE',
      'color': Color(0xFFBFDCDC),
      'image': 'assets/bireysel_rapor.png',
      'subjectKey': 'ingilizce',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEDEAFF),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              /// 🔙 Geri Butonu
              Align(
                alignment: Alignment.centerLeft,
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Icon(Icons.arrow_back),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              /// 🔵 Header
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFFDAD4F7),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'DERSLERİM',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 14),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: const TextField(
                        decoration: InputDecoration(
                          hintText: 'Ders ara...',
                          prefixIcon: Icon(Icons.search),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              /// 📚 Dersler
              Expanded(
                child: ListView.separated(
                  itemCount: lessons.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 14),
                  itemBuilder: (context, index) {
                    final lesson = lessons[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => SHome(
                              lessonTitle: lesson['title'],
                              subject: lesson['subjectKey'],
                            ),
                          ),
                        );
                      },
                      child: Container(
                        height: 90,
                        padding: const EdgeInsets.symmetric(horizontal: 18),
                        decoration: BoxDecoration(
                          color: lesson['color'],
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              lesson['title'],
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Image.asset(
                              lesson['image'],
                              height: 50,
                              fit: BoxFit.contain,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
