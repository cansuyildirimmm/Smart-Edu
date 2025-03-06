import 'package:flutter/material.dart';
import 'package:smartedu/TLoginScreen.dart';

void main() {
  runApp(const MaterialApp(
    home: TCreateAccountScreen(),
  ));
}

class TCreateAccountScreen extends StatelessWidget {
  const TCreateAccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFD93D), // Arka plan rengi (sarı)
      body: SafeArea(
        child: SingleChildScrollView( // ✨ Kaydırılabilir hale getirildi
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Geri butonu
                IconButton(
                  icon: Icon(Icons.arrow_back, size: 28),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),

                SizedBox(height: 10),

                // Başlık
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

                // Form Alanları
                _buildTextField(Icons.person, "AD-SOYAD"),
                _buildTextField(Icons.work, "BRANŞ UZMANLIK ALANI"),
                _buildTextField(Icons.school, "ÇALIŞTIĞINIZ OKUL"),
                _buildTextField(Icons.badge, "TC KİMLİK"),
                _buildTextField(Icons.email, "E-POSTA ADRESİ"),
                _buildTextField(Icons.phone, "TELEFON NUMARASI"),
                _buildTextField(Icons.lock, "ŞİFRE", isPassword: true),

                SizedBox(height: 20),

                // Kayıt Ol Butonu
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
                    onPressed: () {
                      // Kayıt işlemi yapılacak
                    },
                    child: Text(
                      "KAYIT OL",
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),

                SizedBox(height: 15),

                // Giriş yapma bağlantısı
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

                // Google ile devam etme başlığı
                Center(
                  child: Text(
                    "Hesabınızla Devam Edin",
                    style: TextStyle(fontSize: 14, color: Colors.black),
                  ),
                ),

                SizedBox(height: 10),

                // Google Butonu
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

  // Tek bir metot ile tüm textfield'ları oluşturuyoruz
  Widget _buildTextField(IconData icon, String hint, {bool isPassword = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: TextField(
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

// kayıt ekranı