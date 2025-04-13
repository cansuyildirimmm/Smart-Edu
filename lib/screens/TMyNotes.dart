import 'package:flutter/material.dart';
import 'TAddNote.dart';


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
  List<Note> _notes = [];  

  
  void _addNote() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TAddNote(
          onNoteAdded: (newNoteTitle, newNoteContent) {
            setState(() {
              _notes.add(Note(title: newNoteTitle, content: newNoteContent));  
            });
          },
        ),
      ),
    );
  }

  
  Widget _buildNoteCard(Note note) {
    return GestureDetector(
      onTap: () => _viewNoteDetails(note), 
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Color(0xFFA8D8C9),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          note.title,  
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }


  void _viewNoteDetails(Note note) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NoteDetailPage(note: note), 
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
            Padding(
              padding: const EdgeInsets.only(top: 150),
              child: ListView.builder(
                itemCount: _notes.length,
                itemBuilder: (context, index) {
                  return _buildNoteCard(_notes[index]);  
                },
              ),
            ),

            
            Positioned(
              top: 24,
              left: 16,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.lightBlue.shade100,
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

// Not Detay Sayfası
class NoteDetailPage extends StatelessWidget {
  final Note note;

  NoteDetailPage({required this.note});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(note.title),  
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);  
          },
        ),
         backgroundColor: Color(0xFFCFEFF2),
      ),
      backgroundColor: Color(0xFFCFEFF2), 
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16),
            Text(
              note.content,  
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}



