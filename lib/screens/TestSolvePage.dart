import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/activity_tracking_service.dart';
import '../services/tts_service.dart';

class TestSolvePage extends StatefulWidget {
  final String subject;
  final int grade;
  final String topic;
  final String testTitle;
  final bool isBanaOzel; // 🔹 Bana özel modu eklendi

  const TestSolvePage({
    super.key,
    required this.subject,
    required this.grade,
    required this.topic,
    required this.testTitle,
    this.isBanaOzel = false, // 🔹 Varsayılan olarak false
  });

  @override
  _TestSolvePageState createState() => _TestSolvePageState();
}

class _TestSolvePageState extends State<TestSolvePage> {
  List<Map<String, dynamic>> questions = [];
  int currentIndex = 0;
  Map<int, String> userAnswers = {};
  bool isLoading = true;
  DateTime? _testStartTime;
  final TtsService _ttsService = TtsService();

  @override
  void initState() {
    super.initState();
    _testStartTime = DateTime.now();
    _fetchQuestions();
    _announceStart();
  }

  void _announceStart() async {
    if (_ttsService.isEnabled) {
      await Future.delayed(Duration(milliseconds: 1000));
      _ttsService.speak("${widget.testTitle} testi başlıyor.");
    }
  }

  void _announceQuestion(int index) async {
    if (_ttsService.isEnabled) {
      await Future.delayed(Duration(milliseconds: 500));
      _ttsService.speak("Soru ${index + 1}. Seçenekler: A, B, C.");
    }
  }

  void _fetchQuestions() async {
    try {
      final testSnapshot = await FirebaseFirestore.instance
          .collection('tests')
          .where('subject', isEqualTo: widget.subject)
          .where('grade', isEqualTo: widget.grade)
          .where('topic', isEqualTo: widget.topic)
          .where('testTitle', isEqualTo: widget.testTitle)
          .limit(1)
          .get();

      if (testSnapshot.docs.isEmpty) {
        if (mounted) setState(() => isLoading = false);
        return;
      }

      final testDoc = testSnapshot.docs.first;

      final questionsSnapshot = await testDoc.reference
          .collection('questions')
          .orderBy('order')
          .get();

      final List<Map<String, dynamic>> fetchedQuestions = [];
      for (var doc in questionsSnapshot.docs) {
        final data = doc.data();
        try {
          final downloadUrl = await FirebaseStorage.instance
              .ref(data['storageUrl'])
              .getDownloadURL();
          data['downloadUrl'] = downloadUrl;
          fetchedQuestions.add(data);
        } catch (e) {
          print("Resim yükleme hatası (${data['storageUrl']}): $e");
          data['downloadUrl'] = ""; 
          fetchedQuestions.add(data);
        }
      }

      if (mounted) {
        setState(() {
          questions = fetchedQuestions;
          isLoading = false;
        });
        _announceQuestion(0);
      }
    } catch (e) {
      print("Firestore Hatası: $e");
      if (mounted) setState(() => isLoading = false);
    }
  }

  void _selectOption(String option) {
    setState(() {
      userAnswers[currentIndex] = option;
    });
  }

  void _nextQuestion() {
    if (currentIndex < questions.length - 1) {
      setState(() {
        currentIndex++;
      });
      _announceQuestion(currentIndex);
    } else {
      _showResult();
    }
  }

  void _previousQuestion() {
    if (currentIndex > 0) {
      setState(() {
        currentIndex--;
      });
      _announceQuestion(currentIndex);
    }
  }

  Future<void> _saveTestResult(int correctAnswers, int wrongAnswers) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      final duration = _testStartTime != null
          ? DateTime.now().difference(_testStartTime!).inSeconds
          : 0;

      // Test sonucunu testScores koleksiyonuna kaydet
      await FirebaseFirestore.instance
          .collection('students')
          .doc(user.uid)
          .collection('testScores')
          .add({
        'subject': widget.subject,
        'grade': widget.grade,
        'topic': widget.topic,
        'testTitle': widget.testTitle,
        'completedAt': FieldValue.serverTimestamp(),
        'score': correctAnswers,
        'totalQuestions': questions.length,
        'correctAnswers': correctAnswers,
        'wrongAnswers': wrongAnswers,
        'duration': duration,
        'isBanaOzel': widget.isBanaOzel,
      });

      // Aktivite logla
      await ActivityTrackingService().logTestActivity(
        subject: widget.subject,
        topic: widget.topic,
        testTitle: widget.testTitle,
        score: correctAnswers,
        totalQuestions: questions.length,
        duration: duration,
        isBanaOzel: widget.isBanaOzel,
      );

      print('Test sonucu başarıyla kaydedildi.');
    } catch (e) {
      print('Test sonucu kaydetme hatası: $e');
    }
  }

  void _showResult() async {
    int score = 0;
    for (int i = 0; i < questions.length; i++) {
      if (userAnswers[i] == questions[i]['correctOption']) {
        score++;
      }
    }

    int wrong = questions.length - score;
    final Color mainColor = widget.isBanaOzel ? const Color(0xFF4DB6AC) : Colors.redAccent;

    // Test sonucunu Firestore'a kaydet
    await _saveTestResult(score, wrong);

    if (_ttsService.isEnabled) {
      _ttsService.speak("Test bitti. Doğru sayısı: $score. Yanlış sayısı: $wrong.");
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        title: Text(
          '🎊 TEST BİTTİ! 🎊', 
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 26, color: mainColor),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Müthişsin! Sonuçların burada:',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, color: Colors.black54),
            ),
            const SizedBox(height: 25),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: Colors.green.shade50, borderRadius: BorderRadius.circular(15)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.check_circle, color: Colors.green, size: 30),
                  const SizedBox(width: 10),
                  Text('Doğru: $score', style: const TextStyle(color: Colors.green, fontSize: 28, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            const SizedBox(height: 15),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: Colors.red.shade50, borderRadius: BorderRadius.circular(15)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.cancel, color: Colors.red, size: 30),
                  const SizedBox(width: 10),
                  Text('Yanlış: $wrong', style: const TextStyle(color: Colors.red, fontSize: 28, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Text('Toplam Soru: ${questions.length}', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orangeAccent,
                    minimumSize: const Size.fromHeight(55),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    elevation: 5,
                  ),
                  onPressed: () {
                    Navigator.of(dialogContext).pop();
                    setState(() {
                      currentIndex = 0;
                      userAnswers.clear();
                    });
                  },
                  child: const Text('TEKRAR ÇÖZ', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                ),
                const SizedBox(height: 10),
                TextButton(
                  onPressed: () {
                    Navigator.of(dialogContext).pop();
                    if (mounted) {
                      Navigator.of(context).pop();
                    }
                  },
                  child: const Text('ANA MENÜYE DÖN', style: TextStyle(color: Colors.blueGrey, fontSize: 16)),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // 🎨 Temaya göre ana renk belirleniyor
    final Color mainColor = widget.isBanaOzel ? const Color(0xFF4DB6AC) : Colors.redAccent;

    if (isLoading) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator(color: mainColor)),
      );
    }

    if (questions.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text(widget.testTitle), backgroundColor: mainColor),
        body: const Center(child: Text("Soru bulunamadı. Lütfen internetini kontrol et.")),
      );
    }

    final question = questions[currentIndex];

    return Scaffold(
      backgroundColor: const Color(0xFFF5F3FF),
      appBar: AppBar(
        title: Text(widget.testTitle, style: const TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: mainColor,
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          children: [
            LinearProgressIndicator(
              value: (currentIndex + 1) / questions.length,
              backgroundColor: Colors.grey[300],
              color: mainColor,
              minHeight: 8,
            ),
            const SizedBox(height: 10),
            Text(
              'Soru ${currentIndex + 1} / ${questions.length}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),

            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: mainColor.withOpacity(0.3)),
                  boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 8)],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: question['downloadUrl'].isNotEmpty
                      ? Image.network(
                          question['downloadUrl'],
                          fit: BoxFit.contain,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Center(child: CircularProgressIndicator(color: mainColor));
                          },
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(Icons.broken_image, size: 100, color: Colors.grey),
                        )
                      : const Icon(Icons.image_not_supported, size: 100),
                ),
              ),
            ),
            const SizedBox(height: 25),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: ['A', 'B', 'C'].map((option) {
                bool isSelected = userAnswers[currentIndex] == option;
                return GestureDetector(
                  onTap: () => _selectOption(option),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    width: 75,
                    height: 75,
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.orangeAccent : Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isSelected ? Colors.orange : mainColor,
                        width: 3,
                      ),
                      boxShadow: isSelected ? [const BoxShadow(color: Colors.orange, blurRadius: 12)] : [],
                    ),
                    child: Center(
                      child: Text(
                        option,
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: isSelected ? Colors.white : mainColor,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 30),

            Row(
              children: [
                if (currentIndex > 0)
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey[400],
                          minimumSize: const Size.fromHeight(60),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                        ),
                        onPressed: _previousQuestion,
                        child: const Icon(Icons.arrow_back, color: Colors.white, size: 30),
                      ),
                    ),
                  ),
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: mainColor,
                      minimumSize: const Size.fromHeight(60),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      elevation: 5,
                    ),
                    onPressed: userAnswers.containsKey(currentIndex) ? _nextQuestion : null,
                    child: Text(
                      currentIndex == questions.length - 1 ? 'BİTİR' : 'SONRAKİ',
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}