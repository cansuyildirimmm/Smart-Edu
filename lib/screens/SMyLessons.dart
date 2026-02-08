import 'package:flutter/material.dart';
import 'SHome.dart';
import 'lesson_mode.dart';

import '../services/tts_service.dart';

class SMyLessons extends StatefulWidget {
  final LessonMode mode;

  const SMyLessons({
    super.key,
    this.mode = LessonMode.derslerim,
  });

  @override
  State<SMyLessons> createState() => _SMyLessonsState();
}

class _SMyLessonsState extends State<SMyLessons> {
  final TtsService _ttsService = TtsService();

  @override
  void initState() {
    super.initState();
    _announcePage();
  }

  void _announcePage() async {
    if (_ttsService.isEnabled) {
      await Future.delayed(Duration(milliseconds: 500));
      if (widget.mode == LessonMode.banaOzel) {
        _ttsService.speak("Bana özel kısmına hoşgeldiniz. Sizin için hazırlanan içerikleri burada bulabilirsiniz.");
      } else {
        _ttsService.speak("Ders seçimi ekranındasınız. Lütfen bir ders seçin.");
      }
    }
  }

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

  /// 🟦 BANA ÖZEL İKONLAR
  final Map<String, String> banaOzelIcons = {
    'matematik': 'assets/Ruler.png',
    'turkce': 'assets/turkcebanaozel.png',
    'fen_bilimleri': 'assets/fen.png',
    'sosyal_bilgiler': 'assets/bookapple.png',
    'ingilizce': 'assets/bb.png',
  };

  @override
  Widget build(BuildContext context) {
    final bool isBanaOzel = widget.mode == LessonMode.banaOzel;

    return Scaffold(
      backgroundColor:
          isBanaOzel ? const Color(0xFFFFF6E5) : const Color(0xFFEDEAFF),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              /// 🔙 GERİ
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

              /// 🟨 HEADER
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: isBanaOzel
                      ? const Color(0xFFFFC875)
                      : const Color(0xFFDAD4F7),
                  borderRadius: BorderRadius.circular(26),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              isBanaOzel ? 'BANA ÖZEL' : 'DERSLERİM',
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            if (isBanaOzel) ...[
                              const SizedBox(height: 6),
                              const Text(
                                'Senin için\nHazırlananlar',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ],
                        ),
                        if (isBanaOzel)
                          Image.asset(
                            'assets/giraffe.png',
                            height: 70,
                          ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Container(
                      height: 45,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
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

              /// 📚 DERSLER
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
                              mode: widget.mode, // 🔥 KRİTİK SATIR
                            ),
                          ),
                        );
                      },
                      child: Container(
                        height: 80,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        decoration: BoxDecoration(
                          color: lesson['color'],
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              lesson['title'],
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(
                              width: isBanaOzel ? 72 : 56,
                              height: isBanaOzel ? 72 : 56,
                              child: Image.asset(
                                isBanaOzel
                                    ? banaOzelIcons[lesson['subjectKey']]!
                                    : lesson['image'],
                                fit: BoxFit.contain,
                              ),
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
