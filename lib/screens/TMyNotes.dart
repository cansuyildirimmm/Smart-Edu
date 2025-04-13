import 'package:flutter/material.dart';
import 'TAddNote.dart';

class TMyNotes extends StatefulWidget {
  @override
  _TMyNotesState createState() => _TMyNotesState();
}

class _TMyNotesState extends State<TMyNotes> {
  List<String> _notes = [];

  void _addNote() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TAddNote(
          onNoteAdded: (newNote) {
            setState(() {
              _notes.add(newNote);
            });
          },
        ),
      ),
    );
  }

  Widget _buildNoteCard(String noteText) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFFA8D8C9),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        noteText,
        style: TextStyle(fontSize: 16),
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
                  return _buildNoteCard(_notes[index]);
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
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 4,
                    ),
                  ],
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
          onPressed: _addNote,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
