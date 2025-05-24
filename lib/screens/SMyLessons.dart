import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'SHome.dart'; // SHome'u unutma

class SMyLessons extends StatelessWidget {
  final List<Map<String, dynamic>> lessons = [
    {'title': 'MATEMATİK', 'color': Color(0xFF30BFC1), 'image': 'assets/mat_icon.png', 'mainAxisCellCount': 1.6},
    {'title': 'TÜRKÇE', 'color': Color(0xFFFE6250), 'image': 'assets/turkce_icon.png', 'mainAxisCellCount': 1.8},
    {'title': 'FEN BİLİMLERİ', 'color': Color(0xFFB18CFE), 'image': 'assets/fen_icon.png', 'mainAxisCellCount': 1.6},
    {'title': 'SOSYAL BİLGİLER', 'color': Color(0xFFEE719E), 'image': 'assets/ogrenci_sonuc.png', 'mainAxisCellCount': 1.8},
    {'title': 'MÜZİK', 'color': Color(0xFFFFAB01), 'image': 'assets/muzik_icon.png', 'mainAxisCellCount': 1.6},
    {'title': 'İNGİLİZCE', 'color': Color(0xFF6CB28E), 'image': 'assets/bireysel_rapor.png', 'mainAxisCellCount': 1.2},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEFF1FF),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Geri Dön Butonu
              Padding(
                padding: EdgeInsets.only(bottom: 12),
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Icon(Icons.arrow_back, color: Colors.black),
                  ),
                ),
              ),
              // Başlık + Arama Kutusu
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Color(0xFF4E74F9).withOpacity(0.9),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "DERSLERİM",
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    SizedBox(height: 24),
                    TextField(
                      decoration: InputDecoration(
                        hintText: "Ders ara...",
                        prefixIcon: Icon(Icons.search),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),

              // DERS KARTLARI
              StaggeredGrid.count(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                children: lessons.map((lesson) {
                  return StaggeredGridTile.count(
                    crossAxisCellCount: 1,
                    mainAxisCellCount: lesson['mainAxisCellCount'],
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SHome(lessonTitle: lesson['title']),
                          ),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: lesson['color'],
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 16),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 8),
                                child: Text(
                                  lesson['title'],
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                              SizedBox(height: 10),
                              Image.asset(
                                lesson['image'],
                                height: 80,
                                width: 80,
                                fit: BoxFit.cover,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}