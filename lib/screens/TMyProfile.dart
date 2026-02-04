import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:smartedu/OnboardingScreen.dart';
import 'package:smartedu/services/auth.dart';

class TMyProfile extends StatefulWidget {
  const TMyProfile({super.key});

  @override
  State<TMyProfile> createState() => _TMyProfileState();
}

class _TMyProfileState extends State<TMyProfile> {
  bool obscurePassword = true;

  Future<Map<String, dynamic>?> _getUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return null;

    final doc = await FirebaseFirestore.instance
        .collection('teachers')
        .doc(user.uid)
        .get();

    return doc.data();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD2F3F4),
      body: SafeArea(
        child: FutureBuilder<Map<String, dynamic>?>(
          future: _getUserData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData || snapshot.data == null) {
              return const Center(
                child: Text("Kullanıcı bilgileri bulunamadı."),
              );
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
                        child: const Icon(Icons.person, size: 70, color: Colors.white),
                      ),
                      const Positioned(
                        bottom: 0,
                        right: 4,
                        child: CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: 16,
                          child: Icon(Icons.camera_alt,
                              size: 16, color: Color(0xFF50D4DB)),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    userData['name'] ?? "İsim Yok",
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    FirebaseAuth.instance.currentUser?.email ?? "Email Yok",
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 30),
                  _buildInfoCard("Okul", userData['school'] ?? "Bilgi Yok"),
                  _buildInfoCard("Branş", userData['branch'] ?? "Bilgi Yok"),
                  _buildInfoCard("Telefon Numarası", userData['telNumber'] ?? "Bilgi Yok"),
                  _buildInfoCard(
                    "Şifre",
                    userData['password'] != null
                        ? (obscurePassword ? "****************" : userData['password'])
                        : "****************",
                    isPassword: true,
                    onTap: () {
                      setState(() {
                        obscurePassword = !obscurePassword;
                      });
                    },
                  ),
                  const SizedBox(height: 30),
                  // Çıkış Yap Butonu
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 40),
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        await signOut();
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const OnboardingScreen(),
                          ),
                          (route) => false,
                        );
                      },
                      icon: const Icon(Icons.logout, color: Colors.white),
                      label: const Text(
                        'Çıkış Yap',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildInfoCard(String title, String content,
      {bool isPassword = false, VoidCallback? onTap}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 40, vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFFB6E2DC),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                    fontWeight: FontWeight.bold, color: Color(0xFF223344)),
              ),
              const SizedBox(height: 4),
              Text(content, style: const TextStyle(color: Color(0xFF223344))),
            ],
          ),
          if (isPassword)
            GestureDetector(
              onTap: onTap,
              child: Icon(
                  obscurePassword ? Icons.visibility_off : Icons.visibility,
                  color: Colors.black54),
            ),
        ],
      ),
    );
  }
}
