import 'package:flutter/material.dart';

class SAddNote extends StatefulWidget {
  final Function(String, String) onNoteAdded;

  const SAddNote({Key? key, required this.onNoteAdded}) : super(key: key);

  @override
  _SAddNoteState createState() => _SAddNoteState();
}

class _SAddNoteState extends State<SAddNote> {
  final TextEditingController _contentController = TextEditingController();

  void _saveNote() {
    String content = _contentController.text.trim();

    if (content.isNotEmpty) {
      widget.onNoteAdded("", content); // boş başlık gönderiyoruz
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFF1FF),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Geri ve görsel ikonları
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.lightBlue.shade100,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.black),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.blueGrey.shade400,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.all(8),
                    child: const Icon(Icons.image, color: Colors.white),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // Sadece içerik
              TextField(
                controller: _contentController,
                decoration: InputDecoration(
                  hintText: "Bir şey yaz...",
                  hintStyle: TextStyle(color: Colors.grey.shade600),
                  border: InputBorder.none,
                ),
                style: const TextStyle(fontSize: 20),
                maxLines: null,
              ),

              const Spacer(),

              Align(
                alignment: Alignment.bottomRight,
                child: FloatingActionButton(
                  onPressed: _saveNote,
                  child: const Icon(Icons.check),
                  backgroundColor: Colors.blueGrey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
