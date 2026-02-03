import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'SMainMenuScreen.dart';

class SMyProfile extends StatefulWidget {
  const SMyProfile({super.key});

  @override
  State<SMyProfile> createState() => _SMyProfileState();
}

class _SMyProfileState extends State<SMyProfile> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Map<String, dynamic>?> _getUserData() async {
    User? user = _auth.currentUser;
    if (user == null) return null;

    DocumentSnapshot doc =
        await _firestore.collection('students').doc(user.uid).get();
    if (doc.exists) {
      return doc.data() as Map<String, dynamic>;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFF1FF),
      body: SafeArea(
        child: FutureBuilder<Map<String, dynamic>?>(
          future: _getUserData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData || snapshot.data == null) {
              return const Center(child: Text("Kullanıcı bilgisi bulunamadı"));
            }

            final userData = snapshot.data!;
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 40),
                  const Text(
                    "Profilim",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF223344),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.grey[300],
                        child: const Icon(Icons.person,
                            size: 70, color: Colors.white),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 4,
                        child: CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: 16,
                          child: const Icon(Icons.camera_alt,
                              size: 16, color: Color(0xFF50D4DB)),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(userData['name'] ?? "Öğrenci İsmi",
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.bold)),
                  Text(userData['email'] ?? "Deneme@mail.com",
                      style: TextStyle(color: Colors.grey[600])),
                  const SizedBox(height: 30),
                  _buildInfoCard(
                      "Okul", userData['school'] ?? "Öğrencinin Okulu",
                      cardColor: const Color(0xFFA2FF3F).withOpacity(0.7),
                      textColor: Colors.black),
                  _buildInfoCard("Sınıf Seviyesi",
                      userData['classLevel'] ?? "Öğrencinin Sınıf Seviyesi",
                      cardColor: const Color(0xFFA2FF3F).withOpacity(0.7),
                      textColor: Colors.black),
                  _buildInfoCard("Okul Numarası",
                      userData['studentNumber'] ?? "Okul Numarası",
                      cardColor: const Color(0xFFA2FF3F).withOpacity(0.7),
                      textColor: Colors.black),
                  _buildInfoCard("Telefon Numarası",
                      userData['phone'] ?? "Telefon Numarası",
                      cardColor: const Color(0xFFA2FF3F).withOpacity(0.7),
                      textColor: Colors.black),
                  _buildInfoCard("Şifre", "****************",
                      cardColor: const Color(0xFFA2FF3F).withOpacity(0.7),
                      textColor: Colors.black,
                      isPassword: true),
                ],
              ),
            );
          },
        ),
      ),
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
            if (index == 0) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => const SMainMenuScreen()),
              );
            } else if (index == 3) {
              // Profil ekranında zaten olduğumuz için bir şey yapma
            }
          },
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: ""),
            BottomNavigationBarItem(icon: Icon(Icons.library_books), label: ""),
            BottomNavigationBarItem(icon: Icon(Icons.description), label: ""),
            BottomNavigationBarItem(
                icon: Icon(Icons.person_outline), label: ""),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(String title, String value,
      {bool isPassword = false,
      required Color cardColor,
      required Color textColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20.0),
      child: Card(
        color: cardColor,
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: ListTile(
          title: Text(title,
              style: TextStyle(fontWeight: FontWeight.bold, color: textColor)),
          subtitle: Text(isPassword ? "********" : value,
              style: TextStyle(color: textColor)),
        ),
      ),
    );
  }
}
