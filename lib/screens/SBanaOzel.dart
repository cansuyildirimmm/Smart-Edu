import 'package:flutter/material.dart';

class SBanaOzel extends StatelessWidget {
  const SBanaOzel({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEAF7F4),
      appBar: AppBar(
        backgroundColor: const Color(0xFFEAF7F4),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "BANA ÖZEL",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // ÜST KART
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF4ED3C6),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  const Expanded(
                    child: Text(
                      "Senin için\nHazırlananlar",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Image.asset(
                    "assets/giraffe.png", // figma görseli
                    height: 70,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            _buton("Ders İsmi Yaz..."),
            _buton("Konu Anlatımı"),
            _buton("Video 1"),
            _buton("Doğal Sayılar Dinleme"),
            _buton("Doğal Sayılar Dinleme 2"),
          ],
        ),
      ),
    );
  }

  Widget _buton(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.black54),
        ),
        child: Center(
          child: Text(
            text,
            style: const TextStyle(fontSize: 16),
          ),
        ),
      ),
    );
  }
}
