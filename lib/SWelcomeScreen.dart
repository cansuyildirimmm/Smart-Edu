import 'package:flutter/material.dart';
import 'package:smartedu/SCreatAccountScreen.dart';
import 'package:smartedu/SLoginScreen.dart';

class SWelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFC1B6), // Light peach background
      appBar: AppBar(
        backgroundColor: Color(0xFFFFC1B6),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.black87),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/smartedu_logo.png', height: 80),
              SizedBox(height: 20),
              Text(
                "Öğrenci Platformuna Hoş Geldiniz",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SLoginScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  minimumSize: Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text("Giriş Yap", style: TextStyle(color: Colors.white)),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SCreatAccountScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  minimumSize: Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  side: BorderSide(color: Colors.black45),
                ),
                child: Text("Kayıt Ol", style: TextStyle(color: Colors.black87)),
              ),
              SizedBox(height: 20),
              Text(
                "Hesabımla Devam Et",
                style: TextStyle(fontSize: 14, color: Colors.black54),
              ),
              SizedBox(height: 10),
              TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(
                  backgroundColor: Colors.red[300],
                  minimumSize: Size(double.infinity, 35),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text("GOOGLE", style: TextStyle(color: Colors.white, fontSize: 14)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
