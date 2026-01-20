import 'package:flutter/material.dart';
import 'SAddNote.dart';

class SMyNotes extends StatefulWidget {
  const SMyNotes({super.key});

  @override
  State<SMyNotes> createState() => _SMyNotesState();
}

class _SMyNotesState extends State<SMyNotes> {
  List<String> studentNotes = [];

  void _addNote(String title, String content) {
    setState(() {
      studentNotes.add("$title\n$content");
    });
  }

  void _viewNoteDetail(String content) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NoteDetailPage(content: content),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFF1FF),
      appBar: AppBar(
        backgroundColor: const Color(0xFFEFF1FF),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              const Center(
                child: Text(
                  "Öğretmen Notları",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 220,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    _buildTeacherNote(
                      title: "Necip Gözüaçık",
                      date: "3 Nisan",
                      content:
                          "İyi ilerliyorsun Can. İngilizce 4. yazma çalışmanı bu hafta tamamlamaya çalış ayrıca matematikten de konu anlatımı yap.",
                    ),
                    _buildTeacherNote(
                      title: "Necip Gözüaçık",
                      date: "19 Mart",
                      content:
                          "İyi ilerliyorsun Can. İngilizce 4. yazma çalışmanı bu hafta tamamlamaya çalış ayrıca matematikten de konu anlatımı yap.",
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              const Center(
                child: Text(
                  "Notlarım",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: studentNotes.isEmpty
                    ? const Center(
                        child: Text(
                          "Henüz not eklenmedi.",
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      )
                    : ListView.builder(
                        itemCount: studentNotes.length,
                        itemBuilder: (context, index) {
                          return _buildStudentNote(studentNotes[index]);
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FloatingActionButton(
          backgroundColor: const Color(0xFF2C3E50),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SAddNote(
                  onNoteAdded: _addNote,
                ),
              ),
            );
          },
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          child: const Icon(
            Icons.add,
            color: Colors.white,
            size: 35,
          ),
        ),
      ),
    );
  }

  Widget _buildTeacherNote({
    required String title,
    required String date,
    required String content,
  }) {
    return Container(
      height: 400,
      width: 200,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFE18D),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 4),
          Text(
            date,
            style: const TextStyle(fontSize: 14),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: const TextStyle(fontSize: 15),
          ),
        ],
      ),
    );
  }

  Widget _buildStudentNote(String content) {
    return GestureDetector(
      onTap: () => _viewNoteDetail(content),
      child: Container(
        height: 120,
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFCFEFF2), // Rengi düzenledik
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          content,
          style: const TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}

class NoteDetailPage extends StatelessWidget {
  final String content;

  const NoteDetailPage({super.key, required this.content});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFEFF1FF), // Rengini değiştirdim
        title: const Text('Not Detayı'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Text(
            content,
            style:
                const TextStyle(fontSize: 20), // Metin boyutunu da düzenledim
          ),
        ),
      ),
      backgroundColor: const Color(0xFFEFF1FF), // Arka plan rengini düzelttim
    );
  }
}
