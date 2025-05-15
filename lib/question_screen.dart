import 'package:flutter/material.dart';
import 'package:smartedu/disability_screen.dart';

class QuestionScreen extends StatelessWidget {
  const QuestionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFF3FF),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 50),
        child: Column(
          children: [
            // Geri butonu
            Align(
              alignment: Alignment.topLeft,
              child: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            const SizedBox(height: 10),

            const Text(
              '05/10',
              style: TextStyle(
                fontSize: 18,
                color: Colors.teal,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),

            // Soru Metni (Daha kısa ve genişliği butonlarla uyumlu)
            Container(
              padding: const EdgeInsets.all(16),
              width: 300, // Butonlarla aynı genişlikte
              decoration: BoxDecoration(
                color: const Color(0xFFD0D9DD),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                'Soru Metni: Örneğin, "1. Görsellerle daha iyi öğrenirim."',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                  fontWeight: FontWeight.bold,  // Kalın metin
                ),
              ),
            ),
            const SizedBox(height: 40),

            // Evet Butonu - Neon Yeşil
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00FF00), // Neon Yeşil
                elevation: 6,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero,  // Kenarlar dikdörtgen olacak
                ),
                padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 16),
                shadowColor: Colors.black, // Gölgeyi siyah yaptık
              ),
              child: const Text(
                'EVET',
                style: TextStyle(
                  color: Colors.black,  // Yazıyı siyah yaptık
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Hayır Butonu - Neon Kırmızı
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF0000), // Neon Kırmızı
                elevation: 6,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero,  // Kenarlar dikdörtgen olacak
                ),
                padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 16),
                shadowColor: Colors.black, // Gölgeyi siyah yaptık
              ),
              child: const Text(
                'HAYIR',
                style: TextStyle(
                  color: Colors.black,  // Yazıyı siyah yaptık
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 30),

                // Sonraki Soru Butonu
            ElevatedButton(
              onPressed: () {
                // Sonraki soru işlemi
                // Burada sonraki soruya geçiş yapabilirsiniz
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>  DisabilityScreen(), // Yeni soru ekranı
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00A9FF),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                elevation: 6,
                shadowColor: Colors.blueAccent,
              ),
              child: const Text(
                'Sonraki Soru',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }}