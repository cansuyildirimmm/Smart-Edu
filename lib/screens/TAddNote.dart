import 'package:flutter/material.dart';

class TAddNote extends StatefulWidget {
  final Function(String, String) onNoteAdded;

  const TAddNote({super.key, required this.onNoteAdded});

  @override
  _TAddNoteState createState() => _TAddNoteState();
}

class _TAddNoteState extends State<TAddNote> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  void _saveNote() {
    String title = _titleController.text.trim();
    String content = _contentController.text.trim();

    if (title.isNotEmpty || content.isNotEmpty) {
      widget.onNoteAdded(title, content);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFCFEFF2),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.lightBlue.shade100,
                    child: IconButton(
                      icon: Icon(Icons.arrow_back, color: Colors.black),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.blueGrey.shade400,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: EdgeInsets.all(8),
                    child: Icon(Icons.image, color: Colors.white),
                  ),
                ],
              ),
              SizedBox(height: 32),
              TextField(
                controller: _titleController,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey.shade700,
                ),
                decoration: InputDecoration(
                  hintText: "Başlık",
                  border: InputBorder.none,
                ),
              ),
              TextField(
                controller: _contentController,
                decoration: InputDecoration(
                  hintText: "Bir şey yaz...",
                  hintStyle: TextStyle(color: Colors.grey.shade600),
                  border: InputBorder.none,
                ),
                maxLines: null,
              ),
              Spacer(),
              Align(
                alignment: Alignment.bottomRight,
                child: FloatingActionButton(
                  onPressed: _saveNote,
                  backgroundColor: Colors.blueGrey,
                  child: Icon(Icons.check),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
