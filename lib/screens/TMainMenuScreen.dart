import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:smartedu/screens/TMyStudentss.dart';
import 'package:smartedu/screens/TStudentResults.dart';
import 'package:smartedu/screens/TMyNotes.dart';
import 'package:smartedu/screens/TMyProfile.dart';
import  'package:smartedu/screens/TAddNote.dart' ;

class TeacherMenuScreen extends StatefulWidget {
  @override
  _TeacherMenuScreenState createState() => _TeacherMenuScreenState();
}

class _TeacherMenuScreenState extends State<TeacherMenuScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    HomePageWidget(),
    Container(),
    TMyProfile(),
  ];

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFCFEFF2),
      body: _selectedIndex == 1 ? _pages[0] : _pages[_selectedIndex],
      bottomNavigationBar: Container(
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
            if (index == 1) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TAddNote(
                  onNoteAdded: (title, content) {

                    print("Yeni not: $title - $content");
                  },
                ),),
              );
            } else {
              setState(() {
                _selectedIndex = index;
              });
            }
          },

        ),
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
}

class HomePageWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildHeader(),
          SizedBox(height: 40),
          _buildMenuGrid(context),
        ],
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

              Text("ÖĞRETMEN PLATFORMU", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMenuGrid(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          SizedBox(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildMenuCard(context, "Öğrencilerim", Color(0xFFFA6E5A), 'assets/ogrencilerim.png', TMyStudentss()),
              _buildMenuCard(context, "Öğrenci Sonuçları", Color(0xFF6CB28E), 'assets/ogrenci_sonuc.png', TStudentResults()),
            ],
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildMenuCard(context, "Notlarım", Color(0xFFFFCF86), 'assets/notes.png', TMyNotes()),
              _buildMenuCard(context, "Bireysel Öğrenme\nRaporu", Color(0xFFD9A5B5), 'assets/bireysel_rapor.png', null),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMenuCard(BuildContext context, String title, Color color, String asset, Widget? page) {
    return GestureDetector(
      onTap: () {
        if (page != null) {
          Navigator.push(context, MaterialPageRoute(builder: (context) => page));
        }
      },
      child: Container(
        width: MediaQuery.of(context).size.width * 0.42,
        height: MediaQuery.of(context).size.height * 0.18,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10),
        ),
        padding: EdgeInsets.all(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Image.asset(asset, fit: BoxFit.contain),
            ),
            SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
