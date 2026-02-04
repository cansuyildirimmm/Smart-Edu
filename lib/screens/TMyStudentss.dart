import 'package:flutter/material.dart';
import 'TAddStudent.dart';
import '../services/teacher_student_service.dart';

class TMyStudentss extends StatefulWidget {
  const TMyStudentss({super.key});

  @override
  State<TMyStudentss> createState() => _TMyStudentssState();
}

class _TMyStudentssState extends State<TMyStudentss> {
  final _searchController = TextEditingController();
  final _service = TeacherStudentService();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFCFEFF2),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20),
          child: Column(
            children: [
              // Geri Butonu
              Align(
                alignment: Alignment.topLeft,
                child: Container(
                  decoration: const BoxDecoration(
                    color: Color(0xFFF8F2FF),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new),
                    color: const Color(0xFF4C00BF),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // Başlık
              const Center(
                child: Text(
                  "Öğrencilerim",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF272788),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Arama Kutusu
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Row(
                  children: [
                    const Icon(Icons.search, color: Colors.grey),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        decoration: const InputDecoration(
                          hintText: 'Öğrenci adı',
                          border: InputBorder.none,
                        ),
                        onChanged: (value) {
                          setState(() {
                            _searchQuery = value.toLowerCase();
                          });
                        },
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        _searchController.clear();
                        setState(() {
                          _searchQuery = '';
                        });
                      },
                      child: const Icon(Icons.clear, color: Colors.grey),
                    ),
                    const SizedBox(width: 8),
                    const Icon(Icons.tune, color: Colors.grey),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Öğrenci Ekle Butonu
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const TAddStudent()),
                  );
                },
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    color: const Color(0xFF272788),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.0),
                        child: Text(
                          'Öğrenci Ekle',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(right: 10),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 4,
                              offset: Offset(2, 2),
                            ),
                          ],
                        ),
                        child: const Padding(
                          padding: EdgeInsets.all(6),
                          child: Icon(Icons.add, color: Color(0xFF272788)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Öğrenci Kartları - StreamBuilder ile
              Expanded(
                child: StreamBuilder<List<Map<String, dynamic>>>(
                  stream: _service.getTeacherStudents(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.hasError) {
                      return const Center(
                        child: Text('Öğrenciler yüklenirken bir hata oluştu.'),
                      );
                    }

                    final students = snapshot.data ?? [];

                    if (students.isEmpty) {
                      return const Center(
                        child: Text(
                          'Henüz öğrenci eklemediniz.\nYukarıdaki butonu kullanarak öğrenci ekleyebilirsiniz.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 16,
                          ),
                        ),
                      );
                    }

                    // Arama filtresi uygula
                    final filteredStudents = _searchQuery.isEmpty
                        ? students
                        : students.where((s) {
                            final name = (s['name'] ?? '').toLowerCase();
                            return name.contains(_searchQuery);
                          }).toList();

                    if (filteredStudents.isEmpty) {
                      return const Center(
                        child: Text(
                          'Aramanızla eşleşen öğrenci bulunamadı.',
                          style: TextStyle(color: Colors.grey, fontSize: 16),
                        ),
                      );
                    }

                    return ListView.builder(
                      itemCount: filteredStudents.length,
                      itemBuilder: (context, index) {
                        final student = filteredStudents[index];
                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            children: [
                              // Öğrenci Bilgileri
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      student['name'] ?? 'İsimsiz',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(student['school'] ?? 'Okul bilgisi yok'),
                                    const SizedBox(height: 8),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 6),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFF3F4F6),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Icon(
                                            Icons.shopping_bag,
                                            color: Colors.grey,
                                            size: 18,
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            student['branch'] ?? 'Sınıf',
                                            style: const TextStyle(fontSize: 13),
                                          ),
                                          const SizedBox(width: 16),
                                          const Icon(
                                            Icons.note,
                                            color: Colors.grey,
                                            size: 18,
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            student['studentNumber'] ?? 'No',
                                            style: const TextStyle(fontSize: 13),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Column(
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(top: 5),
                                    decoration: const BoxDecoration(
                                      color: Color(0xFFF8F2FF),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Padding(
                                      padding: EdgeInsets.all(6),
                                      child: Icon(
                                        Icons.person,
                                        color: Color(0xFF4C00BF),
                                        size: 30,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
