import 'package:flutter/material.dart';

class TDetailedResults extends StatelessWidget {
  const TDetailedResults({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFCFEFF2),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: Container(
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFFB2E4EA),
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("‘Öğrenci Adı’", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        const Text("‘Öğrenci Numarası’"),
                        const SizedBox(height: 16),
                        const Text("Bugün Çalışılan Süre", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        Row(
                          children: const [
                            Text("46dk", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                            Text("   / 60dk"),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Container(
                          height: 6,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: FractionallySizedBox(
                            alignment: Alignment.centerLeft,
                            widthFactor: 46 / 60,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.orange,
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: _buildTaskCard(
                            color: const Color(0xFFFFE7EE),
                            title: "Üslü Sayılar\nKonu Kavrama Testi",
                            status: "Devam Ediyor",
                            icon: Icons.search,
                            iconColor: Colors.white,
                            height: 230,
                            progressValue: 14 / 24,
                            progressText: "14/24",
                            iconBackgroundColor: Color(0xFFF6EE00),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildTaskCard(
                            color: const Color(0xFFBAD6FF),
                            title: "Eş Anlamlı\nSözcükler Video 1",
                            status: "Devam Ediyor",
                            icon: Icons.search,
                            iconColor: Colors.white,
                            height: 230,
                            progressValue: 12 / 18,
                            progressText: "12dk/18dk",
                            iconBackgroundColor: Color(0xFFF6EE00),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _buildTaskCard(
                            color: const Color(0xFFBAE0DB),
                            title: "Genel Tarama\nTesti",
                            status: "Tamamlandı",
                            icon: Icons.check,
                            iconColor: Colors.white,
                            height: 230,
                            progressValue: 1.0,
                            progressText: "40/40",
                            iconBackgroundColor: Color(0xFF4DD42F),
                          ),
                        ),
                        const SizedBox(width: 16),
                        const Expanded(child: SizedBox()),
                      ],
                    ),
                    const SizedBox(height: 80),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: const [
                Icon(Icons.note, color: Colors.teal),
                SizedBox(width: 8),
                Text("Not ekle", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Spacer(),
                Icon(Icons.share, color: Colors.grey),
                SizedBox(width: 8),
                Icon(Icons.insert_drive_file, color: Colors.grey),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              height: 100,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.all(12),
              child: const Text("Not ekle...", style: TextStyle(color: Colors.grey)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskCard({
    required Color color,
    required String title,
    required String status,
    required IconData icon,
    required Color iconColor,
    required double height,
    required double progressValue,
    required String progressText,
    required Color iconBackgroundColor,
  }) {
    return Container(
      height: height,
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              LinearProgressIndicator(
                value: progressValue,
                backgroundColor: Colors.white,
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.orangeAccent),
              ),
              const SizedBox(height: 4),
              Text(status, style: const TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          Positioned(
            bottom: 1,
            left: 6,
            child: Text(
              progressText,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.black,
              ),
            ),
          ),
          Positioned(
            bottom: 10, // Buradaki değeri değiştirdim
            right: 0,
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: iconBackgroundColor,
                border: Border.all(color: Colors.black, width: 2),
              ),
              child: Icon(icon, color: iconColor, size: 20),
            ),
          ),
        ],
      ),
    );
  }
}
