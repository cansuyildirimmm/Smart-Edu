import 'package\:flutter/material.dart';
import 'question\_screen.dart';

class StartScreen extends StatelessWidget {
const StartScreen({super.key});

@override
Widget build(BuildContext context) {
return Scaffold(
backgroundColor: const Color(0xFFEEDCFF),
body: Center(
child: Padding(
padding: const EdgeInsets.symmetric(horizontal: 32.0),
child: Column(
mainAxisAlignment: MainAxisAlignment.center,
children: [
const Text(
'Öğrenme Stili ve\nEngel Durumu Anketi',
textAlign: TextAlign.center,
style: TextStyle(
fontSize: 22,
fontWeight: FontWeight.bold,
color: Colors.black87,
),
),

          const SizedBox(height: 24),

          // GENİŞ GÖRSEL (Yazılar kadar büyük olacak şekilde ayarlandı)
          SizedBox(
            width: double.infinity,
            height: 150,
            child: Image.asset(
              'assets/bookss.jpg',
              fit: BoxFit.contain,
            ),
          ),

          const SizedBox(height: 24),

          const Text(
            'Test sonuçlarına göre Smart Edu,\nsana en uygun eğitim materyalini getirecek',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.black87,
            ),
          ),

          const SizedBox(height: 30),

      ElevatedButton(
  style: ElevatedButton.styleFrom(
    backgroundColor: const Color(0xFF00A9FF),
    foregroundColor: Colors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(30),
    ),
    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 14),
    elevation: 10,
    shadowColor: const Color(0x8000A9FF), // yarı şeffaf mavi gölge
  ),
  onPressed: () {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const QuestionScreen()),
    );
  },
  child: const Text(
    'Teste Başla',
    style: TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 16,
    ),
  ),
)

        ],
      ),
    ),
  ),
);

}
} 




