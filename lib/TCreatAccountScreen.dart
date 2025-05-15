import 'package:flutter/material.dart';

import 'package:smartedu/TLoginScreen.dart';
import 'package:smartedu/services/auth.dart';

void main() {
  runApp(MaterialApp(

    home: TCreateAccountScreen(),
  ));
}


class TCreateAccountScreen extends StatefulWidget {
  TCreateAccountScreen({super.key});

  @override
  _TCreateAccountScreenState createState() => _TCreateAccountScreenState();
}

class _TCreateAccountScreenState extends State<TCreateAccountScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  final _schoolController = TextEditingController();
  final _branchController = TextEditingController();
  final _telNumberController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(

      backgroundColor: Color(0xFFFFD93D),
      body: SafeArea(
        child: SingleChildScrollView(

          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [


                IconButton(
                  icon: Icon(Icons.arrow_back, size: 28),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),

                SizedBox(height: 10),

                Center(
                  child: Text(
                    "HESAP OLUŞTURUN",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),

                SizedBox(height: 20),
                _buildTextField(Icons.person, "AD-SOYAD", _nameController),
                _buildTextField(Icons.work, "BRANŞ UZMANLIK ALANI", _branchController),
                _buildTextField(Icons.school, "ÇALIŞTIĞINIZ OKUL", _schoolController),
                _buildTextField(Icons.email, "E-POSTA ADRESİ", _emailController),
                _buildTextField(Icons.phone, "TELEFON NUMARASI", _telNumberController),
                _buildTextField(Icons.lock, "ŞİFRE", _passwordController, isPassword: true),
                SizedBox(height: 20),

                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),

                    onPressed: () async {
                      await createAccount(
                        _emailController.text,
                        _passwordController.text,
                        _nameController.text,
                        _schoolController.text,
                        _branchController.text,
                        "",
                        _telNumberController.text,
                        "teachers",
                      );

                    },
                    child: Text(
                      "KAYIT OL",
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),

                SizedBox(height: 15),
                Center(
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => TLoginScreen()),
                      );

                    },
                    child: Text(
                      "Zaten bir hesabınız var mı? Giriş Yap",
                      style: TextStyle(color: Colors.black, fontSize: 14),
                    ),
                  ),
                ),

                SizedBox(height: 15),

                Center(
                  child: Text(
                    "Hesabınızla Devam Edin",
                    style: TextStyle(fontSize: 14, color: Colors.black),
                  ),
                ),

                SizedBox(height: 10),

                Center(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      backgroundColor: Color(0xFFFFA447),
                      side: BorderSide(color: Color(0xFFFFA447)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      minimumSize: Size(165, 50),
                    ),
                    onPressed: () {
                      // Google ile giriş yapılacak
                    },
                    child: Text(
                      "GOOGLE",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }


  Widget _buildTextField(IconData icon, String hint, TextEditingController controller, {bool isPassword = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: TextField(
        controller: controller,

        obscureText: isPassword,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.black),
          hintText: hint,
          hintStyle: TextStyle(color: Colors.black54),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          suffixIcon: isPassword ? Icon(Icons.visibility_off, color: Colors.black54) : null,
        ),
      ),
    );
  }
}