import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:smartedu/screens/TMyStudents.dart';


// TMyStudents Ekranı
class TMyStudents extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Öğrencilerim'),
      ),
      body: Center(
        child: Text('Öğrencilerim Ekranı'),
      ),
    );
  }
}

class TeacherMenuScreen extends StatefulWidget {
  @override
  _TeacherMenuScreenState createState() => _TeacherMenuScreenState();
}

class _TeacherMenuScreenState extends State<TeacherMenuScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFCFEFF2),
      body: Column(
        children: [
          _buildHeader(),
          SizedBox(height: 40),
          _buildMenuGrid(),
        ],
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 35, vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(50),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: CurvedNavigationBar(
        backgroundColor: Colors.transparent,
        color: Colors.white,
        buttonBackgroundColor: Color(0xFF50D4DB),
        height: 70,
        index: _selectedIndex,
        items: <Widget>[
          _buildIconInCircle(Icons.home, 0),
          _buildIconInCircle(Icons.add, 1),
          _buildIconInCircle(Icons.person, 2),
        ],
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }

  Widget _buildIconInCircle(IconData icon, int index) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: _selectedIndex == index ? Colors.white : Color(0xFF50D4DB),
      ),
      padding: EdgeInsets.all(12),
      child: Icon(
        icon,
        size: 30,
        color: _selectedIndex == index ? Colors.black87 : Colors.white,
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      margin: EdgeInsets.only(top: 20, left: 16, right: 16),
      padding: EdgeInsets.symmetric(horizontal: 16),
      height: 120,
      decoration: BoxDecoration(
        color: Color(0xFF50D4DB),
        borderRadius: BorderRadius.circular(21),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Merhaba,", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
              Text("ÖĞRETMEN İSMİ", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
            ],
          ),
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xDDFFFFFF),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 5,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: Icon(Icons.person, color: Color(0x800A2E58), size: 40),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuGrid() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          SizedBox(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildMenuCard("Öğrencilerim", Color(0xFFFA6E5A), 'assets/ogrencilerim.png'),
              _buildMenuCard("Öğrenci Sonuçları", Color(0xFF6CB28E), 'assets/ogrenci_sonuc.png'),
            ],
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildMenuCard("Notlarım", Color(0xFFFFCF86), 'assets/notes.png'),
              _buildMenuCard("Bireysel Öğrenme\nRaporu", Color(0xFFD9A5B5), 'assets/bireysel_rapor.png'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMenuCard(String title, Color color, String asset) {
    return GestureDetector(
      onTap: () {
        if (title == "Öğrencilerim") {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => TMyStudents()),
          );
        }
        // Diğer butonlar için de benzer şekilde işlemler ekleyebilirsin
      },
      child: Container(
        width: MediaQuery.of(context).size.width * 0.4,
        height: MediaQuery.of(context).size.height * 0.2,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(asset, width: 100, height: 100),
            SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
