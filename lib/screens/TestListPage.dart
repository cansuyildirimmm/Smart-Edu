import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:smartedu/screens/TestSolvePage.dart';
import 'package:smartedu/services/recommendation_service.dart';

class TestListPage extends StatelessWidget {
  final String subject;
  final int grade;
  final String topic;
  final String title;
  final bool isBanaOzel;

  const TestListPage({
    super.key,
    required this.subject,
    required this.grade,
    required this.topic,
    required this.title,
    this.isBanaOzel = false,
  });

  /// 🔹 Matris kurallarına göre filtrelenmiş testleri getiren fonksiyon
  Future<QuerySnapshot<Map<String, dynamic>>> _getPersonalizedTests() async {
    final userId = FirebaseAuth.instance.currentUser?.uid ?? "";
    
    Query<Map<String, dynamic>> query = FirebaseFirestore.instance
        .collection('tests')
        .where('subject', isEqualTo: subject)
        .where('grade', isEqualTo: grade)
        .where('topic', isEqualTo: topic);

    if (isBanaOzel) {
      final userDoc = await FirebaseFirestore.instance
          .collection('students')
          .doc(userId)
          .collection('testResults')
          .limit(1)
          .get();

      if (userDoc.docs.isNotEmpty) {
        final data = userDoc.docs.first.data();
        final String style = data['learningStyle'] ?? "";
        final String disability = data['disabilityStatus'] ?? "";

        final filters = RecommendationService.getTestFilters(style, disability);

        // Sorguyu filtrelerle güncelliyoruz
        query = query.where('difficulty', isEqualTo: filters['difficulty']);
        query = query.where('isVisual', isEqualTo: filters['isVisual']);

        if (filters['limit'] != null) {
          return query.orderBy('order').limit(filters['limit']).get();
        }
      }
    }

    return query.orderBy('order').get();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FF),
      appBar: AppBar(
        title: Text(
          isBanaOzel ? "Senin İçin Seçilenler" : title,
          style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF2C3E50)),
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
            const SizedBox(height: 30),
            _buildSearchBar(),
            const SizedBox(height: 32),
            Expanded(
              child: FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
                future: _getPersonalizedTests(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    debugPrint("Sorgu Hatası: ${snapshot.error}");
                    return const Center(child: Text('Veriler yüklenirken bir hata oluştu.'));
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(child: Text('Seviyene uygun test bulunamadı.'));
                  }

                  final tests = snapshot.data!.docs;

                  return ListView.separated(
                    physics: const BouncingScrollPhysics(),
                    itemCount: tests.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final test = tests[index].data();
                      
                      return _buildTestListItem(
                        context,
                        testTitle: test['testTitle'] ?? "Test",
                        difficulty: test['difficulty'] ?? "orta",
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTestListItem(BuildContext context, {required String testTitle, required String difficulty}) {
    if (isBanaOzel) {
      // 🌟 SADECE BANA ÖZEL: Şık, Gradyanlı ve Gölgeli Tasarım
      return _buildModernButton(
        context,
        text: testTitle,
        subtitle: "Zorluk: ${difficulty.toUpperCase()}",
        icon: Icons.auto_awesome,
        colors: [const Color(0xFF4facfe), const Color(0xFF00f2fe)],
        onTap: () => _navigateToTest(context, testTitle),
      );
    } else {
      // 📄 STANDART: Senin Orijinal Sade Tasarımın
      return Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: InkWell(
          onTap: () => _navigateToTest(context, testTitle),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            height: 80,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFFF5C5C), width: 2),
            ),
            child: Row(
              children: [
                const Icon(Icons.assignment, color: Color(0xFFFF5C5C), size: 32),
                const SizedBox(width: 16),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      testTitle,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFFFF5C5C)),
                    ),
                    Text(difficulty.toUpperCase(), style: const TextStyle(fontSize: 12, color: Colors.grey)),
                  ],
                ),
                const Spacer(),
                const Icon(Icons.arrow_forward_ios, size: 18, color: Colors.grey),
              ],
            ),
          ),
        ),
      );
    }
  }

  void _navigateToTest(BuildContext context, String testTitle) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TestSolvePage(
          subject: subject,
          grade: grade,
          topic: topic,
          testTitle: testTitle,
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
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: Colors.white, size: 28),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        text,
                        style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        subtitle,
                        style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 13),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white, size: 18),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      height: 52,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: const TextField(
        decoration: InputDecoration(
          hintText: 'Testlerde ara...',
          prefixIcon: Icon(Icons.search, color: Colors.grey),
          border: InputBorder.none,
        ),
      ),
    );
  }
}