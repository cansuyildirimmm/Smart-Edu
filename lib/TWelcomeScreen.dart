import 'package:flutter/material.dart';
import 'package:smartedu/TCreatAccountScreen.dart';
import 'package:smartedu/TLoginScreen.dart';

class TWelcomeScreen extends StatelessWidget {
  const TWelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Hafif degrade ve soft pastel tonlar
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFFE0E3), Color(0xFFFFA8B0)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/smartedu_logo.png',
                  height: 90,
                ),
                SizedBox(height: 30),
                Text(
                  "Öğretmen Platformuna Hoş Geldiniz",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4A2C33), // koyu bordo-kahverengi ton
                    shadows: [
                      Shadow(
                        color: Colors.black12,
                        offset: Offset(1, 2),
                        blurRadius: 3,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 40),

                // Giriş Yap Butonu - pastel mavi ve beyaz yazı
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => TLoginScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF476BF5), // pastel mavi
                    minimumSize: Size(double.infinity, 54),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 6,
                    shadowColor: Colors.blueAccent.withOpacity(0.5),
                  ),
                  child: Text(
                    "Giriş Yap",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.8,
                    ),
                  ),
                ),
                SizedBox(height: 15),

                // Kayıt Ol Butonu - açık pembe zemin, bordo çerçeve, bordo yazı
                OutlinedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => TCreateAccountScreen()),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Color(0xFF7B3540), width: 2),
                    backgroundColor: Color(0xFFFFE4E6), // çok açık pembe
                    minimumSize: Size(double.infinity, 54),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    "Kayıt Ol",
                    style: TextStyle(
                      color: Color(0xFF7B3540),
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.8,
                    ),
                  ),
                ),
                SizedBox(height: 30),

                Text(
                  "Hesabımla Devam Et",
                  style: TextStyle(
                    fontSize: 15,
                    color: Color(0xFF7B3540).withOpacity(0.7),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 12),

                TextButton(
                  onPressed: () {
                    // Google giriş fonksiyonu
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: Color(0xFFD93025), // biraz koyu kırmızı
                    minimumSize: Size(double.infinity, 44),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 5,
                    shadowColor: Colors.redAccent.withOpacity(0.6),
                  ),
                  child: Text(
                    "GOOGLE",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Color(0xFF7B3540)),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
    );
  }
}
