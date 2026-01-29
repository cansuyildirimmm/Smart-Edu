import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart'; 
import 'package:smartedu/screens/PDFViewerPage.dart';
import 'package:smartedu/screens/VideoPlayerPage.dart';
import 'package:smartedu/screens/PodcastPlayerPage.dart';
import 'package:smartedu/services/recommendation_service.dart';

class SMaterialTypePage extends StatelessWidget {
  final String title;
  final String subject;
  final String contentType;
  final int testGrade;
  final bool isBanaOzel; 

  const SMaterialTypePage({
    super.key,
    required this.title,
    required this.subject,
    required this.contentType,
    required this.testGrade,
    this.isBanaOzel = false, 
  });

  @override
  Widget build(BuildContext context) {
    String userId = FirebaseAuth.instance.currentUser?.uid ?? "";

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FF),
      appBar: AppBar(
        title: Text(
          isBanaOzel ? "Senin İçin Önerilenler" : title,
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
      body: isBanaOzel
          ? _buildBanaOzelBody(context, userId)
          : _buildNormalBody(context),
    );
  }

  Widget _buildNormalBody(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _pinkButton(
            context,
            text: 'PDF',
            icon: Icons.picture_as_pdf,
            onTap: () => _openMaterial(context, 'pdf'),
          ),
          const SizedBox(height: 20),
          _pinkButton(
            context,
            text: 'VİDEO',
            icon: Icons.play_circle_fill,
            onTap: () => _openMaterial(context, 'video'),
          ),
          const SizedBox(height: 20),
          _pinkButton(
            context,
            text: 'PODCAST',
            icon: Icons.headphones,
            onTap: () => _openMaterial(context, 'podcast'),
          ),
        ],
      ),
    );
  }

  Widget _buildBanaOzelBody(BuildContext context, String userId) {
    return FutureBuilder<QuerySnapshot>(
      future: FirebaseFirestore.instance
          .collection('students')
          .doc(userId)
          .collection('testResults')
          .limit(1)
          .get(),
      builder: (context, snapshot) {
        List<String> allowedTypes = ['pdf', 'video', 'podcast'];

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
          final testDoc = snapshot.data!.docs.first.data() as Map<String, dynamic>;
          allowedTypes = RecommendationService.getRecommendedMaterials(
            testDoc['learningStyle'] ?? "",
            testDoc['disabilityStatus'] ?? "",
          );
        }

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 30),
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      if (allowedTypes.contains('pdf'))
                        _buildModernButton(
                          context,
                          text: 'DERS NOTLARI (PDF)',
                          subtitle: 'Konu özetleri ve dökümanlar',
                          icon: Icons.picture_as_pdf_rounded,
                          colors: [const Color(0xFF4facfe), const Color(0xFF00f2fe)],
                          onTap: () => _openMaterial(context, 'pdf'),
                        ),
                      if (allowedTypes.contains('video'))
                        _buildModernButton(
                          context,
                          text: 'GÖRSEL ANLATIM (VİDEO)',
                          subtitle: 'Videolu konu anlatımları',
                          icon: Icons.play_circle_outline_rounded,
                          colors: [const Color(0xFFfa709a), const Color(0xFFfee140)],
                          onTap: () => _openMaterial(context, 'video'),
                        ),
                      if (allowedTypes.contains('podcast'))
                        _buildModernButton(
                          context,
                          text: 'SESLİ DİNLE (PODCAST)',
                          subtitle: 'Sesli konu özetleri',
                          icon: Icons.mic_external_on_rounded,
                          colors: [const Color(0xFF667eea), const Color(0xFF764ba2)],
                          onTap: () => _openMaterial(context, 'podcast'),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _openMaterial(BuildContext context, String fileType) async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('materials')
          .where('subject', isEqualTo: subject)
          .where('contentType', isEqualTo: contentType)
          .where('title', isEqualTo: title)
          .where('fileType', isEqualTo: fileType)
          .where('grade', isEqualTo: testGrade)
          .limit(1)
          .get();

      if (querySnapshot.docs.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${fileType.toUpperCase()} bulunamadı')),
        );
        return;
      }

      final data = querySnapshot.docs.first.data();
      final storagePath = data['storageUrl'];

      Widget page;
      if (fileType == 'pdf') {
        page = PDFViewerPage(storagePath: storagePath, title: title);
      } else if (fileType == 'video') {
        page = VideoPlayerPage(storagePath: storagePath, title: title);
      } else {
        page = PodcastPlayerPage(storagePath: storagePath, title: title);
      }

      Navigator.push(context, MaterialPageRoute(builder: (context) => page));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Hata: $e')),
      );
    }
  }

  Widget _pinkButton(
    BuildContext context, {
    required String text,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 70,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFFFF5C5C), width: 2),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: const Color(0xFFFF5C5C)),
            const SizedBox(width: 12),
            Text(
              text,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFFFF5C5C),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModernButton(
    BuildContext context, {
    required String text,
    required String subtitle,
    required IconData icon,
    required List<Color> colors,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          height: 100,
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: colors,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: colors[0].withOpacity(0.3),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Icon(icon, color: Colors.white, size: 32),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        text,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        subtitle,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
