import 'package:flutter/material.dart';
import 'TDetailedResults.dart';
import '../services/teacher_student_service.dart';

class TStudentResults extends StatefulWidget {
  const TStudentResults({super.key});

  @override
  State<TStudentResults> createState() => _TStudentResultsState();
}

class _TStudentResultsState extends State<TStudentResults> {
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
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(left: 20.0, top: 20.0),
            child: Align(
              alignment: Alignment.topLeft,
              child: Container(
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFFF8F2FF),
                ),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Color(0xFF272788)),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          children: [
            const SizedBox(height: 40),
            const Center(
              child: Text(
                'Öğrenci Sonuçları',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2C2C7E),
                ),
              ),
            ),
            const SizedBox(height: 30),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Öğrenci adı',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      _searchController.clear();
                      setState(() {
                        _searchQuery = '';
                      });
                    },
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 15),
                ),
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value.toLowerCase();
                  });
                },
              ),
            ),
            const SizedBox(height: 30),
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
                        'Henüz öğrenci eklemediniz.\nÖnce "Öğrencilerim" sayfasından öğrenci ekleyin.',
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
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TDetailedResults(
                                studentUid: student['uid'],
                                studentName: student['name'] ?? 'İsimsiz',
                                studentNumber: student['studentNumber'] ?? '',
                              ),
                            ),
                          );
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    student['name'] ?? 'İsimsiz',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    student['school'] ?? 'Okul bilgisi yok',
                                    style: const TextStyle(
                                      color: Colors.grey,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: const BoxDecoration(
                                  color: Color(0xFFF8F2FF),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.person,
                                  color: Color(0xFF272788),
                                ),
                              ),
                            ],
                          ),
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
    );
  }
}
