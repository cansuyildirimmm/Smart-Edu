import 'package:flutter/material.dart';
import 'SMainMenuScreen.dart'; // SMainMenuScreen.dart dosyasını içeri aktar

class SMyProfile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEFF1FF),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 40),
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
            Text("Öğrenci İsmi", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Text("Deneme@mail.com", style: TextStyle(color: Colors.grey[600])),
            SizedBox(height: 30),
            _buildInfoCard("Okul", "Öğrencinin Okulu", cardColor: Color(0xFFA2FF3F).withOpacity(0.7), textColor: Colors.black),
            _buildInfoCard("Sınıf Seviyesi", "Öğrencinin Sınıf Seviyesi", cardColor: Color(0xFFA2FF3F).withOpacity(0.7), textColor: Colors.black),
            _buildInfoCard("Okul Numarası", "Okul Numarası", cardColor: Color(0xFFA2FF3F).withOpacity(0.7), textColor: Colors.black),
            _buildInfoCard("Telefon Numarası", "Telefon Numarası", cardColor: Color(0xFFA2FF3F).withOpacity(0.7), textColor: Colors.black),
            _buildInfoCard("Şifre", "****************", cardColor: Color(0xFFA2FF3F).withOpacity(0.7), textColor: Colors.black, isPassword: true),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        margin: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 20.0),
        decoration: BoxDecoration(
          color: const Color(0xFFFF5C5C),
          borderRadius: BorderRadius.circular(30),
        ),
        child: BottomNavigationBar(
          backgroundColor: Colors.transparent,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white,
          elevation: 0,
          type: BottomNavigationBarType.fixed,
          iconSize: 30,
          onTap: (index) {
            // Eğer ev ikonu seçilirse, ana menüye dönülür
            if (index == 0) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => SMainMenuScreen()),
              );
            }
            // Diğer menü seçenekleri için işlemler eklenebilir
          },
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: ""),
            BottomNavigationBarItem(icon: Icon(Icons.library_books), label: ""),
            BottomNavigationBarItem(icon: Icon(Icons.description), label: ""),
            BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: ""),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(String title, String value, {bool isPassword = false, Color cardColor = Colors.white, Color textColor = Colors.black}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20.0),
      child: Card(
        color: cardColor,  // Kartın rengini buradan değiştirebilirsiniz
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: ListTile(
          title: Text(title, style: TextStyle(fontWeight: FontWeight.bold, color: textColor)), // Başlık rengini buradan değiştirebilirsiniz
          subtitle: Text(isPassword ? "********" : value, style: TextStyle(color: textColor)), // Alt yazı rengini buradan değiştirebilirsiniz
        ),
      ),
    );
  }
}
