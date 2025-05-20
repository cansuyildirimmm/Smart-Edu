import 'package:flutter/material.dart';
import 'package:smartedu/SCreatAccountScreen.dart';
import 'package:smartedu/SLoginScreen.dart';

class SWelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Renkler - Öğrenci temasına uygun turkuaz/yeşil tonlar
    final backgroundColor = isDark ? Color(0xFF263238) : Color(0xFFE0F7FA);
    final appBarColor = backgroundColor;
    final textColor = isDark ? Colors.white70 : Color(0xFF006064);
    final shadowColor = isDark ? Colors.black54 : Colors.black12;
    final buttonColor = isDark ? Color(0xFF00838F) : Color(0xFF00ACC1);
    final outlinedBorderColor = isDark ? Colors.tealAccent : Color(0xFF00838F);
    final outlinedTextColor = isDark ? Colors.white70 : Color(0xFF00838F);
    final googleButtonColor = isDark ? Color(0xFFD32F2F) : Color(0xFFF44336);
    final googleShadowColor = isDark ? Colors.redAccent.withOpacity(0.8) : Colors.redAccent.withOpacity(0.6);
    final secondaryTextColor = isDark ? Colors.white60 : Color(0xFF00838F).withOpacity(0.7);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: appBarColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: textColor),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
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
                "Öğrenci Platformuna Hoş Geldiniz",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                  shadows: [
                    Shadow(
                      color: shadowColor,
                      offset: Offset(1, 2),
                      blurRadius: 3,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 40),

              // Giriş Yap Butonu
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => SLoginScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: buttonColor,
                  minimumSize: Size(double.infinity, 54),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 6,
                  shadowColor: Colors.cyanAccent.withOpacity(0.5),
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

              // Kayıt Ol Butonu
              OutlinedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SCreatAccountScreen()),
                  );
                },
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: outlinedBorderColor, width: 2),
                  backgroundColor: isDark ? Colors.transparent : Color(0xFFE0F7FF),
                  minimumSize: Size(double.infinity, 54),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  "Kayıt Ol",
                  style: TextStyle(
                    color: outlinedTextColor,
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
                  color: secondaryTextColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 12),

              TextButton(
                onPressed: () {
                  // Google giriş fonksiyonu
                },
                style: TextButton.styleFrom(
                  backgroundColor: googleButtonColor,
                  minimumSize: Size(double.infinity, 44),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 5,
                  shadowColor: googleShadowColor,
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
    );
  }
}