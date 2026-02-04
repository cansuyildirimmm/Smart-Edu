import 'package:flutter/material.dart';
import '../services/teacher_student_service.dart';

class TAddStudent extends StatefulWidget {
  const TAddStudent({super.key});

  @override
  State<TAddStudent> createState() => _TAddStudentState();
}

class _TAddStudentState extends State<TAddStudent> {
  final _studentNumberController = TextEditingController();
  final _service = TeacherStudentService();

  Map<String, dynamic>? _foundStudent;
  bool _isSearching = false;
  bool _isAdding = false;
  String? _errorMessage;

  @override
  void dispose() {
    _studentNumberController.dispose();
    super.dispose();
  }

  Future<void> _searchStudent() async {
    final studentNumber = _studentNumberController.text.trim();
    if (studentNumber.isEmpty) {
      setState(() {
        _errorMessage = 'Lütfen öğrenci numarası girin.';
        _foundStudent = null;
      });
      return;
    }

    setState(() {
      _isSearching = true;
      _errorMessage = null;
      _foundStudent = null;
    });

    final student = await _service.searchStudentByNumber(studentNumber);

    setState(() {
      _isSearching = false;
      if (student != null) {
        _foundStudent = student;
        _errorMessage = null;
      } else {
        _foundStudent = null;
        _errorMessage = 'Bu numaraya sahip öğrenci bulunamadı.';
      }
    });
  }

  Future<void> _addStudent() async {
    if (_foundStudent == null) return;

    setState(() => _isAdding = true);

    final isAlreadyAdded = await _service.isStudentAlreadyAdded(_foundStudent!['uid']);
    if (isAlreadyAdded) {
      setState(() => _isAdding = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Bu öğrenci zaten listenizde.')),
        );
      }
      return;
    }

    final success = await _service.addStudentToTeacher(_foundStudent!['uid']);

    setState(() => _isAdding = false);

    if (mounted) {
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Öğrenci başarıyla eklendi.')),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Öğrenci eklenirken bir hata oluştu.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFCFEFF2),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10),
          child: Column(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Color(0xFFF8F2FF),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new),
                      color: const Color(0xFF4A08B5),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 40),

              const Center(
                child: Text(
                  "Öğrenci Ekle",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4A08B5),
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // Öğrenci Numarası - Arama alanı
              Container(
                height: 70,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFF4A08B5), width: 2),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.account_circle, color: Color(0xFF4A08B5)),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        controller: _studentNumberController,
                        decoration: const InputDecoration(
                          hintText: "Okul Numarası ile Ara",
                          border: InputBorder.none,
                        ),
                        onSubmitted: (_) => _searchStudent(),
                      ),
                    ),
                    if (_isSearching)
                      const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    else
                      IconButton(
                        icon: const Icon(Icons.search, color: Color(0xFF4A08B5)),
                        onPressed: _searchStudent,
                      ),
                  ],
                ),
              ),

              if (_errorMessage != null) ...[
                const SizedBox(height: 10),
                Text(
                  _errorMessage!,
                  style: const TextStyle(color: Colors.red, fontSize: 14),
                ),
              ],

              const SizedBox(height: 20),

              // Bulunan öğrenci bilgileri (readonly)
              _buildReadOnlyField(
                "Öğrenci Adı",
                Icons.person,
                _foundStudent?['name'] ?? '',
              ),

              const SizedBox(height: 20),

              _buildReadOnlyField(
                "Okulu",
                Icons.school,
                _foundStudent?['school'] ?? '',
              ),

              const SizedBox(height: 20),

              _buildReadOnlyField(
                "Sınıfı",
                Icons.notifications,
                _foundStudent?['branch'] ?? '',
              ),

              const SizedBox(height: 20),

              _buildReadOnlyField(
                "Sağlık/Engel Durumu",
                Icons.accessibility,
                _foundStudent != null ? 'Bilgi mevcut' : '',
              ),

              const SizedBox(height: 40),

              // EKLE butonu
              GestureDetector(
                onTap: (_foundStudent != null && !_isAdding) ? _addStudent : null,
                child: Container(
                  height: 70,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: _foundStudent != null
                        ? const Color(0xFF4A08B5)
                        : Colors.grey,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Center(
                    child: _isAdding
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            "EKLE",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReadOnlyField(String label, IconData icon, String value) {
    return Container(
      height: 70,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF4A08B5), width: 2),
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF4A08B5)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value.isNotEmpty ? value : label,
              style: TextStyle(
                fontSize: 16,
                color: value.isNotEmpty ? Colors.black : Colors.grey,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
