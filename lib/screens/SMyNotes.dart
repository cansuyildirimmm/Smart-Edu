import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'SAddNote.dart';
import '../services/teacher_notes_service.dart';

class SMyNotes extends StatefulWidget {
  const SMyNotes({super.key});

  @override
  State<SMyNotes> createState() => _SMyNotesState();
}

class _SMyNotesState extends State<SMyNotes> {
  List<String> studentNotes = [];
  final TeacherNotesService _notesService = TeacherNotesService();

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

  void _viewTeacherNoteDetail({
    required String noteId,
    required String teacherName,
    required String date,
    required String content,
    required bool isRead,
  }) {
    // Notu okundu olarak işaretle
    if (!isRead) {
      _notesService.markNoteAsRead(noteId);
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TeacherNoteDetailPage(
          teacherName: teacherName,
          date: date,
          content: content,
        ),
      ),
    );
  }

  String _formatDate(Timestamp? timestamp) {
    if (timestamp == null) return '';
    final date = timestamp.toDate();
    final months = [
      'Ocak', 'Şubat', 'Mart', 'Nisan', 'Mayıs', 'Haziran',
      'Temmuz', 'Ağustos', 'Eylül', 'Ekim', 'Kasım', 'Aralık'
    ];
    return '${date.day} ${months[date.month - 1]}';
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
                child: StreamBuilder<List<Map<String, dynamic>>>(
                  stream: _notesService.getMyTeacherNotes(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    final notes = snapshot.data ?? [];

                    if (notes.isEmpty) {
                      return const Center(
                        child: Text(
                          "Henüz öğretmen notu yok.",
                          style: TextStyle(color: Colors.grey, fontSize: 16),
                        ),
                      );
                    }

                    return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: notes.length,
                      itemBuilder: (context, index) {
                        final note = notes[index];
                        final date = _formatDate(note['createdAt'] as Timestamp?);
                        return _buildTeacherNote(
                          noteId: note['id'] ?? '',
                          title: note['teacherName'] ?? 'Öğretmen',
                          date: date,
                          content: note['content'] ?? '',
                          isRead: note['isRead'] ?? false,
                        );
                      },
                    );
                  },
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
    required String noteId,
    required String title,
    required String date,
    required String content,
    required bool isRead,
  }) {
    return GestureDetector(
      onTap: () => _viewTeacherNoteDetail(
        noteId: noteId,
        teacherName: title,
        date: date,
        content: content,
        isRead: isRead,
      ),
      child: Container(
        height: 200,
        width: 200,
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFFFFE18D),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Stack(
          children: [
            Column(
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
                Expanded(
                  child: Text(
                    content,
                    style: const TextStyle(fontSize: 15),
                    maxLines: 5,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            // Okunmamış not göstergesi
            if (!isRead)
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                  width: 12,
                  height: 12,
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
          ],
        ),
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
          color: const Color(0xFFCFEFF2),
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
        backgroundColor: const Color(0xFFEFF1FF),
        title: const Text('Not Detayı'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Text(
            content,
            style: const TextStyle(fontSize: 20),
          ),
        ),
      ),
      backgroundColor: const Color(0xFFEFF1FF),
    );
  }
}

class TeacherNoteDetailPage extends StatelessWidget {
  final String teacherName;
  final String date;
  final String content;

  const TeacherNoteDetailPage({
    super.key,
    required this.teacherName,
    required this.date,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFF1FF),
      appBar: AppBar(
        backgroundColor: const Color(0xFFEFF1FF),
        title: const Text('Öğretmen Notu'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFFFE18D),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.person, color: Colors.black54),
                      const SizedBox(width: 8),
                      Text(
                        teacherName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.calendar_today, size: 16, color: Colors.black54),
                      const SizedBox(width: 8),
                      Text(
                        date,
                        style: const TextStyle(fontSize: 14, color: Colors.black54),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    content,
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
