import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class SMyLessons extends StatelessWidget {
  final List<Map<String, dynamic>> lessons = [
    {'title': 'MATEMATİK', 'color': Color(0xFF30BFC1), 'image': 'assets/mat_icon.png', 'mainAxisCellCount': 1.6},
    {'title': 'TÜRKÇE', 'color': Color(0xFFFE6250), 'image': 'assets/turkce_icon.png', 'mainAxisCellCount': 1.8},
    {'title': 'FEN\nBİLİMLERİ', 'color': Color(0xFFB18CFE), 'image': 'assets/fen_icon.png', 'mainAxisCellCount': 1.6},
    {'title': 'SOSYAL\nBİLGİLER', 'color': Color(0xFFEE719E), 'image': 'assets/ogrenci_sonuc.png', 'mainAxisCellCount': 1.8},
    {'title': 'MÜZİK', 'color': Color(0xFFFFAB01), 'image': 'assets/muzik_icon.png', 'mainAxisCellCount': 1.6},
    {'title': 'İNGLİZCE', 'color': Color(0xFF6CB28E), 'image': 'assets/bireysel_rapor.png', 'mainAxisCellCount': 1.2},
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
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Color(0xFF4E74F9).withOpacity(0.9),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 8),
                    Text(
                      "DERSLERİM",
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    SizedBox(height: 40),
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
              StaggeredGrid.count(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                children: lessons.map((lesson) {
                  return StaggeredGridTile.count(
                    crossAxisCellCount: 1,
                    mainAxisCellCount: lesson['mainAxisCellCount'],
                    child: Container(
                      decoration: BoxDecoration(
                        color: lesson['color'],
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // Yazıyı kutunun üst kısmında ortalıyoruz
                            Padding(
                              padding: EdgeInsets.only(bottom: 8),
                              child: Text(
                                lesson['title'],
                                style: TextStyle(
                                  color: Colors.white, 
                                  fontWeight: FontWeight.bold, 
                                  fontSize: 25,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            // Görseli kutunun sağ alt kısmında ortalıyoruz
                            Align(
                              alignment: Alignment.bottomRight,
                              child: Padding(
                                padding: EdgeInsets.only(right: 16, bottom: 16),
                                child: Image.asset(
                                  lesson['image'],
                                  height: 100,
                                  width: 100,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ],
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
