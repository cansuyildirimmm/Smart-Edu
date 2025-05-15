import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: SForgotPasswordScreen(),
    debugShowCheckedModeBanner: false,
  ));
}

class SForgotPasswordScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue[50],
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              const SizedBox(height: 20),
             Text(
  "Şifrenizi mi Unuttunuz?",
  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
),

              const SizedBox(height: 10),
              Text(
                "Şifrenizi sıfırlamak için hangi iletişim bilgilerinizi kullanmamızı istersiniz?",
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
              const SizedBox(height: 20),
              
              // E-Posta Butonu
              OptionButton(
                icon: Icons.email,
                title: "E-POSTA",
                subtitle: "Kod e-posta adresinize gönderilecek",
                onTap: () {},
              ),

              const SizedBox(height: 10),

              // Telefon Butonu
              OptionButton(
                icon: Icons.phone,
                title: "TELEFON",
                subtitle: "Kod telefon numaranıza gönderilecek",
                onTap: () {},
              ),

              const SizedBox(height: 30),

              // Devam Et Butonu
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[600],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {},
                  child: Text(
                    "Devam Et",
                    style: TextStyle(fontSize: 18, color: Colors.white),
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

// Seçenek Butonu
class OptionButton extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const OptionButton({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 5,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, size: 30, color: Colors.black54),
            const SizedBox(width: 15),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
            Text(title, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),

                Text(subtitle, style: TextStyle(color: Colors.black54)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
