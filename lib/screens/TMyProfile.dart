import 'package:flutter/material.dart';

class TMyProfile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFD2F3F4),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 40),
            SizedBox(height: 10),
            Text(
              "Profilim",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF223344),
              ),
            ),
            SizedBox(height: 20),
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.grey[300],
                  child: Icon(Icons.person, size: 70, color: Colors.white),
                ),
                Positioned(
                  bottom: 0,
                  right: 4,
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 16,
                    child: Icon(Icons.camera_alt, size: 16, color: Color(0xFF50D4DB)),
                  ),
                )
              ],
            ),
            SizedBox(height: 16),
            Text("Öğretmen İsmi", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Text("Deneme@mail.com", style: TextStyle(color: Colors.grey[600])),
            SizedBox(height: 30),
            _buildInfoCard("Okul", "Öğretmenin Okulu"),
            _buildInfoCard("Branş", "Öğretmenin Branşı"),
            _buildInfoCard("Telefon Numarası", "Telefon Numarası"),
            _buildInfoCard("Şifre", "****************", isPassword: true),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(String title, String content, {bool isPassword = false}) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 40, vertical: 8),
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Color(0xFFB6E2DC),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF223344))),
              SizedBox(height: 4),
              Text(content, style: TextStyle(color: Color(0xFF223344))),
            ],
          ),
          if (isPassword)
            Icon(Icons.visibility_off, color: Colors.black54),
        ],
      ),
    );
  }
}
