import 'package:flutter/material.dart';
import '/SCreatAccountScreen.dart';
import '/SForgotPasswordScreen.dart';
import 'package:smartedu/StudentTestApp.dart';
import '/services/auth.dart';
class SLoginScreen extends StatelessWidget {
  final _eMailController = TextEditingController();
  final _passwordController = TextEditingController();

  SLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF9DAE0),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: IconButton(
                  icon: Icon(Icons.arrow_back_ios),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Hesabınıza\nGiriş Yapın',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF323142),
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 40),
              TextField(

                controller: _eMailController,

                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.email_outlined),
                  hintText: 'E-postanızı girin',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              SizedBox(height: 20),
              TextField(

                controller: _passwordController,

                obscureText: true,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.lock_outline),
                  hintText: 'Şifre',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  suffixIcon: Icon(Icons.visibility_off_outlined),
                ),
              ),
              SizedBox(height: 10),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,

                      MaterialPageRoute(builder: (context) => SForgotPasswordScreen()),

                    );
                  },
                  child: Text(
                    'Şifrenizi Mi Unuttunuz?',
                    style: TextStyle(
                      color: Color(0xFF323142),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),

              SizedBox(height: 30),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFE16053),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  minimumSize: Size(double.infinity, 60),
                ),
                onPressed: () async {
                  bool success = await signIn(context, _eMailController.text, _passwordController.text, "students");
                  if (success) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => StudentTestApp()), // Bu kısmı kendi sayfanla değiştir
                    );
                  }
                },
                child: Text(
                  'Giriş Yap',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Hesabınız Yok Mu ?',
                    style: TextStyle(
                      color: Color(0xFF2A195C),
                      fontSize: 16,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SCreatAccountScreen()),
                      );
                    },
                    child: Text(
                      'Kayıt Olun',
                      style: TextStyle(
                        color: Color(0xFF323142),
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Text(
                'Hesabınızla Devam Edin',
                style: TextStyle(
                  color: Color(0xFF1F1F39),
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 10),
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: Color(0xFFD44638)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  minimumSize: Size(165, 57),
                ),
                onPressed: () {
                  // Google ile giriş işlemleri
                },
                child: Text(
                  'GOOGLE',
                  style: TextStyle(
                    color: Color(0xFFD44638),
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
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