import 'package:flutter/material.dart';

// TMyStudentss Ekranı
class TMyStudentss extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ÖĞRENCİLERİM"),
        backgroundColor: Color(0xFF50D4DB),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Başlık
            Text(
              "ÖĞRENCİLERİM",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF50D4DB),
              ),
            ),
            SizedBox(height: 20),

            // Öğrenci kutuları
            Expanded(
              child: ListView(
                children: [
                  _buildStudentCard("Öğrenci 1", "Detay 1"),
                  _buildStudentCard("Öğrenci 2", "Detay 2"),
                  _buildStudentCard("Öğrenci 3", "Detay 3"),
                  _buildStudentCard("Öğrenci 4", "Detay 4"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Öğrenci kutusu widget'ı
  Widget _buildStudentCard(String studentName, String details) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              studentName,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              details,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

