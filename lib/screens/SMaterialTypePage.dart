import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smartedu/screens/PDFViewerPage.dart';
import 'package:smartedu/screens/VideoPlayerPage.dart';
import 'package:smartedu/screens/PodcastPlayerPage.dart';

class SMaterialTypePage extends StatelessWidget {
  final String title;
  final String subject;
  final String contentType;
  final String testGrade;

  const SMaterialTypePage({
    super.key,
    required this.title,
    required this.subject,
    required this.contentType,
    required this.testGrade,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFF1FF),
      appBar: AppBar(
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF2C3E50),
          ),
        ),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            const SizedBox(height: 80),

            /// 🔍 Arama Çubuğu
            Container(
              height: 48,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 6,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: const TextField(
                decoration: InputDecoration(
                  hintText: 'Ara...',
                  prefixIcon: Icon(Icons.search),
                  border: InputBorder.none,
                ),
              ),
            ),

            const SizedBox(height: 40),

            /// 🔘 Butonlar
            Expanded(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildButton(
                      context,
                      text: 'PDF',
                      icon: Icons.picture_as_pdf,
                      onTap: () async {
                        try {
                          final querySnapshot = await FirebaseFirestore.instance
                              .collection('materials')
                              .where('subject', isEqualTo: subject)
                              .where('contentType', isEqualTo: contentType)
                              .where('title', isEqualTo: title)
                              .where('fileType', isEqualTo: 'pdf')
                              .where('grade', isEqualTo: int.parse(testGrade))
                              .limit(1)
                              .get();

                          if (querySnapshot.docs.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('PDF materyali bulunamadı')),
                            );
                            return;
                          }

                          final data = querySnapshot.docs.first.data();
                          final storagePath = data['storageUrl'];

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PDFViewerPage(
                                storagePath: storagePath,
                                title: title,
                              ),
                            ),
                          );
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content:
                                    Text('PDF açılırken hata oluştu: $e')),
                          );
                        }
                      },
                    ),
                    const SizedBox(height: 20),
                    _buildButton(
                      context,
                      text: 'VİDEO',
                      icon: Icons.play_circle_fill,
                      onTap: () async {
                        try {
                          final querySnapshot = await FirebaseFirestore.instance
                              .collection('materials')
                              .where('subject', isEqualTo: subject)
                              .where('contentType', isEqualTo: contentType)
                              .where('title', isEqualTo: title)
                              .where('fileType', isEqualTo: 'video')
                              .where('grade', isEqualTo: int.parse(testGrade))
                              .limit(1)
                              .get();

                          if (querySnapshot.docs.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Video materyali bulunamadı')),
                            );
                            return;
                          }

                          final data = querySnapshot.docs.first.data();
                          final storagePath = data['storageUrl'];

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => VideoPlayerPage(
                                storagePath: storagePath,
                                title: title,
                              ),
                            ),
                          );
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content:
                                    Text('Video açılırken hata oluştu: $e')),
                          );
                        }
                      },
                    ),
                    const SizedBox(height: 20),
                    _buildButton(
                      context,
                      text: 'PODCAST',
                      icon: Icons.headphones,
                      onTap: () async {
                        try {
                          final querySnapshot = await FirebaseFirestore.instance
                              .collection('materials')
                              .where('subject', isEqualTo: subject)
                              .where('contentType', isEqualTo: contentType)
                              .where('title', isEqualTo: title)
                              .where('fileType', isEqualTo: 'podcast')
                              .where('grade', isEqualTo: int.parse(testGrade))
                              .limit(1)
                              .get();

                          if (querySnapshot.docs.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Podcast bulunamadı')),
                            );
                            return;
                          }

                          final data = querySnapshot.docs.first.data();
                          final storagePath = data['storageUrl'];

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PodcastPlayerPage(
                                storagePath: storagePath,
                                title: title,
                              ),
                            ),
                          );
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content:
                                    Text('Podcast açılırken hata oluştu: $e')),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButton(
    BuildContext context, {
    required String text,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        height: 70,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: const Color(0xFFFF5C5C),
            width: 2,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: const Color(0xFFFF5C5C), size: 30),
            const SizedBox(width: 12),
            Text(
              text,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFFFF5C5C),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
