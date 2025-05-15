import 'package:flutter/material.dart';

import 'package:smartedu/StudentTestApp.dart';


import 'package:smartedu/SLoginScreen.dart';
import 'package:smartedu/services/auth.dart';

class SCreatAccountScreen extends StatefulWidget {
  @override
   SCreateAccountScreen createState() =>  SCreateAccountScreen();
}

class  SCreateAccountScreen extends State< SCreatAccountScreen> {
  bool isPasswordVisible = false;


  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  final _schoolController = TextEditingController();
  final _studentNumberController = TextEditingController();
  final _telNumberController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFD8F3DC), // Açık yeşil arka plan
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'HESAP OLUŞTURUN',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1F1F1F),
                ),
              ),
              SizedBox(height: 20),


              _buildTextField(Icons.person_outline, 'AD-SOYAD',_nameController),
              _buildTextField(Icons.school_outlined, 'OKUL',_schoolController),
              _buildTextField(Icons.email_outlined, 'E-POSTA ADRESİ',_emailController),
              _buildTextField(Icons.phone_outlined, 'TELEFON NUMARASI',_telNumberController),
              _buildTextField(Icons.badge_outlined, 'ÖĞRENCİ NUMARASI',_studentNumberController),
              //_buildTextField(Icons.credit_card_outlined, 'TC KİMLİK NO'),

              _buildPasswordField(),
              SizedBox(height: 20),
              _buildRegisterButton(),
              SizedBox(height: 10),
              TextButton(
                onPressed: () {

                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SLoginScreen()),
                  );

                },
                child: Text(
                  'Zaten bir hesabınız var mı? Giriş Yapın',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1F1F39),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Hesabınızla Devam Edin',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF1F1F1F),
                ),
              ),
              SizedBox(height: 10),
              _buildGoogleButton(),
            ],
          ),
        ),
      ),
    );
  }


  Widget _buildTextField(IconData icon, String hintText, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,

        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.grey),
          hintText: hintText,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordField() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(

        controller: _passwordController,

        obscureText: !isPasswordVisible,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.lock_outline, color: Colors.grey),
          hintText: 'ŞİFRE',
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          suffixIcon: IconButton(
            icon: Icon(
              isPasswordVisible ? Icons.visibility : Icons.visibility_off,
              color: Colors.grey,
            ),
            onPressed: () {
              setState(() {
                isPasswordVisible = !isPasswordVisible;
              });
            },
          ),
        ),
      ),
    );
  }

  Widget _buildRegisterButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFFD16B6B),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        minimumSize: Size(double.infinity, 55),
      ),

  onPressed: () async {
  bool success = await createAccount(
    _emailController.text,
    _passwordController.text,
    _nameController.text,
    _schoolController.text,
    "",
    _studentNumberController.text,
    _telNumberController.text,
    "students",
  );

  // Eğer kayıt başarılıysa StudentTestApp ekranına yönlendir
  if (success) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => StudentTestApp()),
    );
  } else {
    // Hata durumunda kullanıcıyı bilgilendir (opsiyonel)
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Kayıt başarısız. Lütfen tekrar deneyin.'),
        backgroundColor: Colors.red,
      ),
    );
  }
},

      child: Text(
        'KAYIT OL',
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildGoogleButton() {
    return OutlinedButton.icon(
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: Color(0xFFD44638)),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        minimumSize: Size(160, 50),
      ),
      onPressed: () {
        // Google ile giriş işlemleri
      },
// icon: Icon(Icons.login, color: Color(0xFFD44638)),
      label: Text(
        'GOOGLE',
        style: TextStyle(
          color: Color(0xFFD44638),
          fontWeight: FontWeight.bold,
          letterSpacing: 2,
        ),
      ),
    );
  }
}
