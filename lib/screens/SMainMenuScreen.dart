import 'package:flutter/material.dart';
import 'package:smartedu/screens/SMyLessons.dart';
import 'package:smartedu/screens/SMyNotes.dart';
import 'package:smartedu/screens/SMyProfile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'lesson_mode.dart';
import '../services/teacher_notes_service.dart';

class SMainMenuScreen extends StatefulWidget {
  const SMainMenuScreen({super.key});

  @override
  State<SMainMenuScreen> createState() => _SMainMenuScreenState();
}

class _SMainMenuScreenState extends State<SMainMenuScreen> {
  String userName = '';
  final TeacherNotesService _notesService = TeacherNotesService();

  @override
  void initState() {
    super.initState();
    _loadUserName();
  }

  Future<void> _loadUserName() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final doc = await FirebaseFirestore.instance
            .collection('students')
            .doc(user.uid)
            .get();
        if (doc.exists) {
          setState(() {
            userName = doc['name'] ?? '';
          });
        }
      }
    } catch (e) {
      print('Kullanıcı adı alınamadı: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFF1FF),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Container(
                  height: 80,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFDAD7FF),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        userName.isNotEmpty ? "Merhaba $userName" : "Merhaba",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SMyProfile(),
                            ),
                          );
                        },
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.grey.withOpacity(0.5),
                          ),
                          child: const Icon(
                            Icons.person_outline,
                            color: Color(0xFF161C2B),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => SMyLessons(
                                mode: LessonMode.derslerim,
                              ),
                            ),
                          );
                        },
                        child: Container(
                          height: 55,
                          decoration: BoxDecoration(
                            color: const Color(0xFF6C5CE7),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Center(
                            child: Text(
                              "Derslerim",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => SMyLessons(
                                mode: LessonMode.banaOzel,
                              ),
                            ),
                          );
                        },
                        child: Container(
                          height: 55,
                          decoration: BoxDecoration(
                            color: const Color(0xFF90DBF4),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: const Center(
                            child: Text(
                              "Bana Özel",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Son Çalışmalarım
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0x80CACFF5),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    "Son Çalışmalarım",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF6C5CE7),
                    ),
                  ),
                ),
                const SizedBox(height: 8),

                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      Container(
                        width: 220,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFB18CFE),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          children: [
                            const Text(
                              "Over hundred\nnumbers",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    SizedBox(
                                      height: 40,
                                      width: 40,
                                      child: CircularProgressIndicator(
                                        value: 0.7,
                                        strokeWidth: 6,
                                        backgroundColor:
                                            Colors.white.withOpacity(0.2),
                                        valueColor:
                                            const AlwaysStoppedAnimation<Color>(
                                                Colors.blue),
                                      ),
                                    ),
                                    Container(
                                      width: 40,
                                      height: 40,
                                      decoration: const BoxDecoration(
                                        color: Colors.yellow,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    const Icon(Icons.search,
                                        size: 32, color: Colors.white),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: Image.asset("assets/over_hnumbers.png",
                                      height: 80),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        width: 220,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFF46D300).withOpacity(0.6),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          children: [
                            const Text(
                              "Devre\nElemanları",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    SizedBox(
                                      height: 40,
                                      width: 40,
                                      child: CircularProgressIndicator(
                                        value: 1.0,
                                        strokeWidth: 4,
                                        backgroundColor:
                                            Colors.white.withOpacity(0.2),
                                        valueColor:
                                            const AlwaysStoppedAnimation<Color>(
                                                Color(0xFF2C2C2E)),
                                      ),
                                    ),
                                    const Icon(Icons.check_circle,
                                        size: 32, color: Colors.green),
                                  ],
                                ),
                                Image.asset("assets/devre_elemanlari.png",
                                    height: 80),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Derslerim
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SMyLessons()),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0x80CACFF5),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      "Derslerim",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF6C5CE7),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),

                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      dersKarti("Matematik", "assets/mat_icon.png"),
                      const SizedBox(width: 8),
                      dersKarti("Fen Bilimleri", "assets/fen_icon.png"),
                      const SizedBox(width: 8),
                      dersKarti("Türkçe", "assets/turkce_icon.png"),
                      const SizedBox(width: 8),
                      dersKarti("Müzik", "assets/muzik_icon.png"),
                      const SizedBox(width: 8),
                      dersKarti("İngilizce", "assets/notes.png"),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Notlarım (TIKLANABİLİR)
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const SMyNotes()),
                    );
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: const Color(0x80CACFF5),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Text(
                              "Notlarım",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF6C5CE7),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          // Okunmamış not sayısı badge
                          StreamBuilder<int>(
                            stream: _notesService.getUnreadNoteCount(),
                            builder: (context, snapshot) {
                              final count = snapshot.data ?? 0;
                              if (count == 0) return const SizedBox.shrink();
                              return Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  count > 9 ? '9+' : '$count',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      StreamBuilder<Map<String, dynamic>?>(
                        stream: _notesService.getMostRecentNote(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return Container(
                              width: double.infinity,
                              height: 110,
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFE7A0),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Center(
                                child: CircularProgressIndicator(),
                              ),
                            );
                          }

                          final note = snapshot.data;
                          if (note == null) {
                            return Container(
                              width: double.infinity,
                              height: 110,
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFE7A0),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Center(
                                child: Text(
                                  "Henüz öğretmen notu yok",
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            );
                          }

                          return Container(
                            width: double.infinity,
                            height: 110,
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFE7A0),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Stack(
                              children: [
                                Text.rich(
                                  TextSpan(
                                    children: [
                                      TextSpan(
                                        text: "${note['teacherName'] ?? 'Öğretmen'}\n",
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                          color: Colors.black,
                                        ),
                                      ),
                                      TextSpan(
                                        text: note['content'] ?? '',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                  maxLines: 4,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                // Okunmamış göstergesi
                                if (note['isRead'] == false)
                                  Positioned(
                                    top: 0,
                                    right: 0,
                                    child: Container(
                                      width: 10,
                                      height: 10,
                                      decoration: const BoxDecoration(
                                        color: Colors.red,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Asistan kutusu
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF48484A),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  margin: const EdgeInsets.only(top: 30),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          textAlignVertical: TextAlignVertical.center,
                          decoration: InputDecoration(
                            hintText: "Asistan'a Sor..",
                            hintStyle: const TextStyle(color: Colors.white70),
                            border: InputBorder.none,
                            prefixIcon:
                                const Icon(Icons.search, color: Colors.white70),
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 12),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.smart_toy,
                            color: Color(0xFF00A4F0)),
                        onPressed: () {},
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
      // BOTTOM NAVIGATION
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        margin: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 20.0),
        decoration: BoxDecoration(
          color: const Color(0xFFE66A8A),
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
            switch (index) {
              case 0:
                break;
              case 1:
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SMyLessons(
                      mode: LessonMode.derslerim,
                    ),
                  ),
                );

                break;
              case 2:
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SMyLessons(
                      mode: LessonMode.banaOzel,
                    ),
                  ),
                );
                break;

              case 3:
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SMyNotes()),
                );
                break;
              case 4:
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SMyProfile()),
                );
                break;
            }
          },
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: ""),
            BottomNavigationBarItem(icon: Icon(Icons.library_books), label: ""),
            BottomNavigationBarItem(
                icon: Icon(Icons.star), label: ""), // ⭐ Bana Özel
            BottomNavigationBarItem(icon: Icon(Icons.description), label: ""),
            BottomNavigationBarItem(
                icon: Icon(Icons.person_outline), label: ""),
          ],
        ),
      ),
    );
  }

  Widget dersKarti(String dersAdi, String imgUrl) {
    return Container(
      width: 150,
      height: 100,
      decoration: BoxDecoration(
        color: const Color(0xFF3A3A3C),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(imgUrl, height: 50),
          const SizedBox(height: 6),
          Text(
            dersAdi,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
