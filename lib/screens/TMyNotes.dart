import 'package:flutter/material.dart';
import 'TAddNote.dart';

// Notu içerecek model sınıfı
class Note {
  String title;
  String content;

  Note({
    required this.title,
    required this.content,
  });
}

class TMyNotes extends StatefulWidget {
  @override
  _TMyNotesState createState() => _TMyNotesState();
}

class _TMyNotesState extends State<TMyNotes> {
  List<Note> _notes = [];  // Burada liste Note türünde olacak

  // Not eklemek için
  void _addNote() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TAddNote(
          onNoteAdded: (newNoteTitle, newNoteContent) {
            setState(() {
              // Yeni notu ekliyoruz
              _notes.add(Note(title: newNoteTitle, content: newNoteContent));  // İçeriği de ekliyoruz
            });
          },
        ),
      ),
    );
  }

  // Not kartı oluşturma (sadece başlık görünür)
  Widget _buildNoteCard(Note note) {
    return GestureDetector(
      onTap: () => _viewNoteDetails(note), // Tıklanınca detaylara git
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Color(0xFFA8D8C9),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          note.title,  // Başlık görünür
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }

  // Detay sayfasına yönlendirme
  void _viewNoteDetails(Note note) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NoteDetailPage(note: note),  // Detay sayfası gösterilecek
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFCFEFF2),
      body: SafeArea(
        child: Stack(
          children: [
            // Notlar listesi
            Padding(
              padding: const EdgeInsets.only(top: 150),
              child: ListView.builder(
                itemCount: _notes.length,
                itemBuilder: (context, index) {
                  return _buildNoteCard(_notes[index]);  // Başlıkları gösteriyoruz
                },
              ),
            ),

            // Geri tuşu
            Positioned(
              top: 24,
              left: 16,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.8),
                  shape: BoxShape.circle,
                  boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
                ),
                child: IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.black87),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
            ),

            // Notlarım başlığı
            Positioned(
              top: 40,
              left: 0,
              right: 0,
              child: Center(
                child: Text(
                  "Notlarım",
                  style: TextStyle(
                    color: Color(0xFF2C3E50),
                    fontWeight: FontWeight.bold,
                    fontSize: 32,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: FloatingActionButton(
          backgroundColor: Color(0xFF2C3E50),
          child: Icon(Icons.add, color: Colors.white),
          onPressed: _addNote,  // Yeni not ekleme
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}

// Not Detay Sayfası
class NoteDetailPage extends StatelessWidget {
  final Note note;

  NoteDetailPage({required this.note});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(note.title),  // Burada "Not Detayı" yerine başlık olacak
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);  // Geri tuşuna basıldığında önceki sayfaya dön
          },
        ),
         backgroundColor: Color(0xFFCFEFF2),
      ),
      backgroundColor: Color(0xFFCFEFF2),  // Sayfa arka plan rengini buraya ekliyoruz
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16),
            // Kullanıcının girdiği içerik
            Text(
              note.content,  // İçerik
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}



