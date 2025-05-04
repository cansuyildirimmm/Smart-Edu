import 'package:flutter/material.dart';
import 'package:smartedu/screens/SMyLessons.dart';
import 'package:smartedu/screens/SMyNotes.dart';
import 'package:smartedu/screens/SMyProfile.dart'; // Ensure SMyProfile is imported correctly

class SMainMenuScreen extends StatelessWidget {
  const SMainMenuScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFF1FF),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Container(
                  height: 80,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFB3F7E0),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "MERHABA ‘ÖĞRENCİ ADI’",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          // Navigate to SMyProfile without hiding the bottom navigation bar
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SMyProfile(),
                            ),
                          );
                        },
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.grey.withOpacity(0.5),
                          ),
                          child: const Icon(
                            Icons.person_outline,
                            color: Color(0xFF161C2B),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),

                // Son Çalışmalarım
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Color(0x80CACFF5),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    "Son Çalışmalarım",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF6C5CE7),
                    ),
                  ),
                ),
                const SizedBox(height: 8),

                // Yana kaydırılabilir iki kutu
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      Container(
                        width: 220,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFB18CFE),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          children: [
                            const Text(
                              "Over hundred\nnumbers",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    SizedBox(
                                      height: 40,
                                      width: 40,
                                      child: CircularProgressIndicator(
                                        value: 0.7,
                                        strokeWidth: 6,
                                        backgroundColor: Colors.white.withOpacity(0.2),
                                        valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                                      ),
                                    ),
                                    Container(
                                      width: 40,
                                      height: 40,
                                      decoration: const BoxDecoration(
                                        color: Colors.yellow,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    const Icon(Icons.search, size: 32, color: Colors.white),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Image.asset("assets/over_hnumbers.png", height: 80),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        width: 220,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFF46D300).withOpacity(0.6),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          children: [
                            const Text(
                              "Devre\nElemanları",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    SizedBox(
                                      height: 40,
                                      width: 40,
                                      child: CircularProgressIndicator(
                                        value: 1.0,
                                        strokeWidth: 4,
                                        backgroundColor: Colors.white.withOpacity(0.2),
                                        valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF2C2C2E)),
                                      ),
                                    ),
                                    const Icon(Icons.check_circle, size: 32, color: Colors.green),
                                  ],
                                ),
                                Image.asset("assets/devre_elemanlari.png", height: 80),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Derslerim
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SMyLessons()),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Color(0x80CACFF5),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      "Derslerim",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF6C5CE7),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),

                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      dersKarti("Matematik", "assets/mat_icon.png"),
                      const SizedBox(width: 8),
                      dersKarti("Fen Bilimleri", "assets/fen_icon.png"),
                      const SizedBox(width: 8),
                      dersKarti("Türkçe", "assets/turkce_icon.png"),
                      const SizedBox(width: 8),
                      dersKarti("Müzik", "assets/muzik_icon.png"),
                      const SizedBox(width: 8),
                      dersKarti("Beden", "assets/notes.png"),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Notlarım (TIKLANABİLİR)
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const SMyNotes()),
                    );
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Color(0x80CACFF5),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          "Notlarım",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF6C5CE7),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        width: double.infinity,
                        height: 110,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFE7A0),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: "Necip Gözüküçük\n",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: Colors.black,
                                ),
                              ),
                              TextSpan(
                                text: "İyi ilerliyorsun Can. İngilizce 4. yazma çalışmanı bu hafta tamamlamaya çalış ayrıca matematikten de konu anlatımı yap.",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Asistan kutusu
                Container(
                  decoration: BoxDecoration(
                    color: Color(0xFF48484A),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  margin: const EdgeInsets.only(top: 30),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          textAlignVertical: TextAlignVertical.center,
                          decoration: InputDecoration(
                            hintText: "Asistan'a Sor..",
                            hintStyle: TextStyle(color: Colors.white70),
                            border: InputBorder.none,
                            prefixIcon: Icon(Icons.search, color: Colors.white70),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.smart_toy, color: Color(0xFF00A4F0)),
                        onPressed: () {},
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
      // BOTTOM NAVIGATION
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
            // Navigate to the SMyProfile screen when the profile icon is tapped
            if (index == 3) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SMyProfile()), // Open the SMyProfile page
              );
            }
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

  Widget dersKarti(String dersAdi, String imgUrl) {
    return Container(
      width: 150,
      height: 100, // Yüksekliği orantılı olarak değiştirdim
      decoration: BoxDecoration(
        color: Color(0xFF3A3A3C),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center, // İçeriği ortaladım
        children: [
          Image.asset(imgUrl, height: 50),
          const SizedBox(height: 6),
          Text(
            dersAdi,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
