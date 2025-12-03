import 'package:flutter/material.dart';
import 'package:smartedu/screens/GeminiEğitimSayfasi.dart';
import 'package:smartedu/screens/STopics.dart'; 

class SHome extends StatelessWidget {
  final String lessonTitle;
  final String subject;     
  final String testGrade;   

  const SHome({
    super.key,
    required this.lessonTitle,
    required this.subject,
    this.testGrade = '3',   // default olarak 1. sınıf
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFF1FF),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Üst bar
              Container(
                height: 70,
                color: const Color(0xFFCFEFF2),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Row(
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white54,
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.arrow_back,
                              color: Color(0xFF040415)),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),
                      Expanded(
                        child: Center(
                          child: Text(
                            lessonTitle,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2C3E50),
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      const SizedBox(width: 48),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Kartlar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    _buildCard(
                      context: context,
                      color: const Color(0xFF30BFC1),
                      text: 'KONU ANLATIMI',
                      image: 'assets/konu-anlatim.png',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => STopics(
                              lessonTitle: lessonTitle,
                              subject: subject,
                              contentType: 'konu_anlatimi',
                              testGrade: testGrade,
                            ),
                          ),
                        );
                      },
                      isImageBig: true,
                      imageHeight: 110,
                      textSize: 24,
                    ),
                    const SizedBox(height: 20),
                    _buildCard(
                      context: context,
                      color: const Color(0xFFEE719E),
                      text: 'SORU BANKASI',
                      image: 'assets/soru-b.png',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => STopics(
                              lessonTitle: lessonTitle,
                              subject: subject,
                              contentType: 'soru_bankasi',
                              testGrade: testGrade,
                            ),
                          ),
                        );
                      },
                      isImageBig: true,
                      imageHeight: 110,
                      textSize: 24,
                    ),
                    const SizedBox(height: 20),
                    _buildCard(
                      context: context,
                      color: const Color(0xFF46D300).withOpacity(0.7),
                      text: 'ALIŞTIRMALAR',
                      image: 'assets/alistirma.png',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => STopics(
                              lessonTitle: lessonTitle,
                              subject: subject,
                              contentType: 'alistirmalar',
                              testGrade: testGrade,
                            ),
                          ),
                        );
                      },
                      isImageBig: true,
                      textSize: 24,
                    ),
                    const SizedBox(height: 20),
                    _buildCard(
                      context: context,
                      color: const Color(0xFFFFAB01).withOpacity(0.9),
                      text: 'LABORATUVAR',
                      image: 'assets/lab.png',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => STopics(
                              lessonTitle: lessonTitle,
                              subject: subject,
                              contentType: 'laboratuvar',
                              testGrade: testGrade,
                            ),
                          ),
                        );
                      },
                      isImageBig: true,
                      textSize: 24,
                    ),
                    const SizedBox(height: 30),
                    _buildCard(
                      context: context,
                      color: const Color(0xFF2AA3DF),
                      text: 'YAPAY ZEKA İLE ÖĞREN',
                      image: 'assets/ai_robot.png',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const GeminiEgitimSayfasi()),
                        );
                      },
                      isImageBig: false,
                      height: 100,
                      textSize: 19,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCard({
    required BuildContext context,
    required Color color,
    required String text,
    required String image,
    required VoidCallback onTap,
    required bool isImageBig,
    double height = 140,
    double? imageHeight,
    required double textSize,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        height: height,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(isImageBig ? 20 : 60),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(width: 20),
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: textSize,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(0),
              child: isImageBig
                  ? Image.asset(
                      image,
                      height: imageHeight ?? 180,
                      fit: BoxFit.contain,
                    )
                  : Container(
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFFEBF7FF),
                      ),
                      padding: const EdgeInsets.all(20),
                      child: Image.asset(
                        image,
                        height: 90,
                        fit: BoxFit.contain,
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
