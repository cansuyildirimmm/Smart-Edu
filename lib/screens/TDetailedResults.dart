import 'package:flutter/material.dart';
import '../services/reporting_service.dart';
import '../services/teacher_notes_service.dart';

class TDetailedResults extends StatefulWidget {
  final String studentUid;
  final String studentName;
  final String studentNumber;

  const TDetailedResults({
    super.key,
    required this.studentUid,
    required this.studentName,
    required this.studentNumber,
  });

  @override
  State<TDetailedResults> createState() => _TDetailedResultsState();
}

class _TDetailedResultsState extends State<TDetailedResults> {
  final TextEditingController _noteController = TextEditingController();
  final TeacherNotesService _notesService = TeacherNotesService();
  final ReportingService _reportingService = ReportingService();
  bool _isSending = false;

  Map<String, dynamic>? _summaryReport;
  Map<String, dynamic>? _materialReport;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadReports();
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _loadReports() async {
    try {
      print('DEBUG: Öğrenci UID: ${widget.studentUid}');

      final summaryFuture = _reportingService.getStudentSummaryReport(widget.studentUid);
      final materialFuture = _reportingService.getMaterialUsageReport(widget.studentUid);

      final results = await Future.wait([summaryFuture, materialFuture]);

      print('DEBUG: Materyal Raporu: ${results[1]}');
      print('DEBUG: PDF Count: ${results[1]['pdfCount']}');
      print('DEBUG: Video Minutes: ${results[1]['videoTotalMinutes']}');
      print('DEBUG: Recent Materials: ${results[1]['recentMaterials']}');

      setState(() {
        _summaryReport = results[0];
        _materialReport = results[1];
        _isLoading = false;
      });
    } catch (e) {
      print('DEBUG: Rapor yükleme hatası: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _sendNote() async {
    if (_noteController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lütfen bir not yazın')),
      );
      return;
    }

    setState(() => _isSending = true);

    final success = await _notesService.sendNoteToStudent(
      studentUid: widget.studentUid,
      content: _noteController.text.trim(),
    );

    setState(() => _isSending = false);

    if (success) {
      _noteController.clear();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Not başarıyla gönderildi!'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Not gönderilemedi. Tekrar deneyin.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: Color(0xFFCFEFF2),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final report = _summaryReport ?? {};
    final materialReport = _materialReport ?? {};
    final todayMinutes = report['todayStudyDurationMinutes'] ?? 0;
    final todayFormatted = report['todayStudyDurationFormatted'] ?? '0dk';
    final recentTests = (report['recentTests'] as List?) ?? [];
    final completedActivities = (report['completedActivities'] as List?) ?? [];

    return Scaffold(
      backgroundColor: const Color(0xFFCFEFF2),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Geri butonu
                    Align(
                      alignment: Alignment.topLeft,
                      child: Container(
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFFB2E4EA),
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Öğrenci bilgi kartı
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.studentName,
                            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          Text(widget.studentNumber.isNotEmpty ? widget.studentNumber : 'Numara yok'),
                          const SizedBox(height: 16),
                          const Text(
                            "Bugün Çalışılan Süre",
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Text(
                                todayFormatted,
                                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              const Text("   / 60dk"),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Container(
                            height: 6,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade300,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: FractionallySizedBox(
                              alignment: Alignment.centerLeft,
                              widthFactor: (todayMinutes / 60).clamp(0.0, 1.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.orange,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Materyal kullanım raporu
                    _buildMaterialUsageSection(materialReport),
                    const SizedBox(height: 16),

                    // Aktivite kartları
                    if (recentTests.isEmpty && completedActivities.isEmpty)
                      const Padding(
                        padding: EdgeInsets.all(20),
                        child: Text(
                          'Henüz aktivite kaydı bulunmuyor.',
                          style: TextStyle(color: Colors.grey, fontSize: 16),
                        ),
                      )
                    else
                      _buildActivityCards(recentTests, completedActivities),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),

            // Not gönderme bölümü
            _buildNoteSenderSheet(),
          ],
        ),
      ),
    );
  }

  Widget _buildMaterialUsageSection(Map<String, dynamic> report) {
    final pdfCount = report['pdfCount'] ?? 0;
    final videoMinutes = report['videoTotalMinutes'] ?? 0;
    final podcastMinutes = report['podcastTotalMinutes'] ?? 0;
    final recentMaterials = (report['recentMaterials'] as List?) ?? [];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Materyal Kullanımı",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildMaterialTypeCard(
                icon: Icons.picture_as_pdf,
                label: "PDF",
                value: "$pdfCount",
                unit: "adet",
                color: const Color(0xFFFFE7EE),
              ),
              _buildMaterialTypeCard(
                icon: Icons.video_library,
                label: "Video",
                value: "$videoMinutes",
                unit: "dk",
                color: const Color(0xFFBAD6FF),
              ),
              _buildMaterialTypeCard(
                icon: Icons.headphones,
                label: "Podcast",
                value: "$podcastMinutes",
                unit: "dk",
                color: const Color(0xFFBAE0DB),
              ),
            ],
          ),
          if (recentMaterials.isNotEmpty) ...[
            const SizedBox(height: 16),
            const Text(
              "Kullanılan Materyaller",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ...recentMaterials.take(5).map((m) => _buildRecentMaterialItem(m)),
          ],
        ],
      ),
    );
  }

  Widget _buildMaterialTypeCard({
    required IconData icon,
    required String label,
    required String value,
    required String unit,
    required Color color,
  }) {
    return Container(
      width: 90,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, size: 28, color: Colors.black54),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
          ),
          const SizedBox(height: 2),
          Text(
            "$value $unit",
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentMaterialItem(Map<String, dynamic> material) {
    IconData icon;
    Color iconColor;

    switch (material['materialType']) {
      case 'pdf':
        icon = Icons.picture_as_pdf;
        iconColor = const Color(0xFFE91E63);
        break;
      case 'video':
        icon = Icons.video_library;
        iconColor = const Color(0xFF2196F3);
        break;
      case 'podcast':
        icon = Icons.headphones;
        iconColor = const Color(0xFF009688);
        break;
      default:
        icon = Icons.insert_drive_file;
        iconColor = Colors.grey;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(icon, size: 20, color: iconColor),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              material['title'] ?? 'Materyal',
              style: const TextStyle(fontSize: 13),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Text(
            "${material['durationMinutes']}dk",
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildNoteSenderSheet() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.note, color: Colors.teal),
              const SizedBox(width: 8),
              const Expanded(
                child: Text(
                  "Öğrenciye Not Gönder",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              _isSending
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : IconButton(
                      icon: const Icon(Icons.send, color: Colors.teal),
                      onPressed: _sendNote,
                    ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            height: 80,
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: TextField(
              controller: _noteController,
              maxLines: 3,
              decoration: const InputDecoration(
                hintText: "Notunuzu yazın...",
                border: InputBorder.none,
                contentPadding: EdgeInsets.all(12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityCards(List recentTests, List completedActivities) {
    List<Widget> cards = [];

    // Test sonuçlarını kartlara dönüştür
    for (int i = 0; i < recentTests.length && i < 4; i++) {
      final test = recentTests[i];
      final correctAnswers = test['correctAnswers'] ?? 0;
      final totalQuestions = test['totalQuestions'] ?? 1;
      final progress = totalQuestions > 0 ? correctAnswers / totalQuestions : 0.0;
      final isCompleted = progress >= 0.5;

      cards.add(
        _buildTaskCard(
          color: isCompleted ? const Color(0xFFBAE0DB) : const Color(0xFFFFE7EE),
          title: '${test['topic'] ?? 'Test'}\n${test['testTitle'] ?? ''}',
          status: 'Tamamlandı',
          icon: isCompleted ? Icons.check : Icons.close,
          iconColor: Colors.white,
          height: 230,
          progressValue: progress,
          progressText: '$correctAnswers/$totalQuestions',
          iconBackgroundColor: isCompleted ? const Color(0xFF4DD42F) : Colors.red,
        ),
      );
    }

    // Aktiviteleri kartlara dönüştür
    for (int i = 0; i < completedActivities.length && cards.length < 4; i++) {
      final activity = completedActivities[i];
      final duration = activity['duration'] ?? 0;
      final durationMinutes = (duration / 60).floor();

      cards.add(
        _buildTaskCard(
          color: const Color(0xFFBAD6FF),
          title: '${activity['topic'] ?? 'Aktivite'}\n${activity['title'] ?? ''}',
          status: 'Tamamlandı',
          icon: Icons.check,
          iconColor: Colors.white,
          height: 230,
          progressValue: 1.0,
          progressText: '${durationMinutes}dk',
          iconBackgroundColor: const Color(0xFF4DD42F),
        ),
      );
    }

    // Kartları satırlara yerleştir
    List<Widget> rows = [];
    for (int i = 0; i < cards.length; i += 2) {
      rows.add(
        Row(
          children: [
            Expanded(child: cards[i]),
            const SizedBox(width: 16),
            if (i + 1 < cards.length)
              Expanded(child: cards[i + 1])
            else
              const Expanded(child: SizedBox()),
          ],
        ),
      );
      if (i + 2 < cards.length) {
        rows.add(const SizedBox(height: 16));
      }
    }

    return Column(children: rows);
  }

  Widget _buildTaskCard({
    required Color color,
    required String title,
    required String status,
    required IconData icon,
    required Color iconColor,
    required double height,
    required double progressValue,
    required String progressText,
    required Color iconBackgroundColor,
  }) {
    return Container(
      height: height,
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              LinearProgressIndicator(
                value: progressValue,
                backgroundColor: Colors.white,
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.orangeAccent),
              ),
              const SizedBox(height: 4),
              Text(status, style: const TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          Positioned(
            bottom: 1,
            left: 6,
            child: Text(
              progressText,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.black,
              ),
            ),
          ),
          Positioned(
            bottom: 10,
            right: 0,
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: iconBackgroundColor,
                border: Border.all(color: Colors.black, width: 2),
              ),
              child: Icon(icon, color: iconColor, size: 20),
            ),
          ),
        ],
      ),
    );
  }
}
