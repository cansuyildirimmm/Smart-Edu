import 'package:flutter/material.dart';

class TAddStudent extends StatelessWidget {
  const TAddStudent({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFCFEFF2),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
          child: Column(
            children: [
              // Geri Butonu
              Align(
                alignment: Alignment.topLeft,
                child: Container(
                  decoration: const BoxDecoration(
                    color: Color(0xFFF8F2FF), // Yuvarlak çerçeve rengi
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new),
                    color: const Color(0xFF4A08B5), // Geri tuşunun rengi
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
              ),

              const SizedBox(height: 40),

              // Başlık
              const Center(
                child: Text(
                  "Öğrenci Ekle",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4A08B5),
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // Öğrenci Adı
              _buildTextField("Öğrenci Adı", Icons.person),

              const SizedBox(height: 20),

              // Okulu
              _buildTextField("Okulu", Icons.school),

              const SizedBox(height: 20),

              // Sınıfı
              _buildTextField("Sınıfı", Icons.notifications),

              const SizedBox(height: 20),

              // Okul Numarası
              _buildTextField("Okul Numarası", Icons.account_circle),

              const SizedBox(height: 20),

              // Sağlık/Engel Durumu
              _buildTextField("Sağlık/Engel Durumu", Icons.accessibility),

              const SizedBox(height: 40),

              // Ekle Butonu
              Container(
                height: 70,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFF4A08B5),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Center(
                  child: Text(
                    "Ekle",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Yardımcı fonksiyon: TextField'ları oluşturmak için
  Widget _buildTextField(String label, IconData icon) {
    return Container(
      height: 70,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF4A08B5), width: 2), // Mor çerçeve
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF4A08B5)),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: label,
                border: InputBorder.none,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
