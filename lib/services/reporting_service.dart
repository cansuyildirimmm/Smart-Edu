import 'package:cloud_firestore/cloud_firestore.dart';
import 'activity_tracking_service.dart';

class ReportingService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Öğrencinin test sonuçlarını getir
  Future<List<Map<String, dynamic>>> getStudentTestScores(String studentUid) async {
    try {
      final snapshot = await _firestore
          .collection('students')
          .doc(studentUid)
          .collection('testScores')
          .orderBy('completedAt', descending: true)
          .limit(20)
          .get();

      return snapshot.docs.map((doc) {
        final data = doc.data();
        return {
          'id': doc.id,
          'subject': data['subject'],
          'grade': data['grade'],
          'topic': data['topic'],
          'testTitle': data['testTitle'],
          'completedAt': data['completedAt'],
          'score': data['score'],
          'totalQuestions': data['totalQuestions'],
          'correctAnswers': data['correctAnswers'],
          'wrongAnswers': data['wrongAnswers'],
          'isBanaOzel': data['isBanaOzel'],
        };
      }).toList();
    } catch (e) {
      print('Test sonuçları getirme hatası: $e');
      return [];
    }
  }

  /// Öğrencinin öğrenme profilini getir
  Future<Map<String, dynamic>?> getStudentLearningProfile(String studentUid) async {
    try {
      final studentDoc = await _firestore.collection('students').doc(studentUid).get();
      if (!studentDoc.exists) return null;

      final studentData = studentDoc.data()!;

      final testResultsSnapshot = await _firestore
          .collection('students')
          .doc(studentUid)
          .collection('testResults')
          .orderBy(FieldPath.documentId, descending: true)
          .limit(1)
          .get();

      Map<String, dynamic> profile = {
        'name': studentData['name'] ?? '',
        'school': studentData['school'] ?? '',
        'branch': studentData['branch'] ?? '',
        'studentNumber': studentData['studentNumber'] ?? '',
        'email': studentData['email'] ?? '',
      };

      if (testResultsSnapshot.docs.isNotEmpty) {
        final testResult = testResultsSnapshot.docs.first.data();
        profile['learningStyle'] = testResult['learningStyle'] ?? 'Belirlenmedi';
        profile['disabilityStatus'] = testResult['disabilityStatus'] ?? 'Yok';
      } else {
        profile['learningStyle'] = 'Belirlenmedi';
        profile['disabilityStatus'] = 'Yok';
      }

      return profile;
    } catch (e) {
      print('Öğrenme profili getirme hatası: $e');
      return null;
    }
  }

  /// Öğrencinin özet raporunu getir
  Future<Map<String, dynamic>> getStudentSummaryReport(String studentUid) async {
    try {
      // Bugünlük çalışma süresi
      final activityService = ActivityTrackingService();
      final todayDuration = await activityService.getTodayStudyDuration(studentUid);

      // Son test sonuçları
      final testScores = await getStudentTestScores(studentUid);

      // Ortalama başarı
      double avgScore = 0;
      if (testScores.isNotEmpty) {
        int totalCorrect = 0;
        int totalQuestions = 0;
        for (var score in testScores) {
          totalCorrect += (score['correctAnswers'] as int? ?? 0);
          totalQuestions += (score['totalQuestions'] as int? ?? 0);
        }
        avgScore = totalQuestions > 0 ? (totalCorrect / totalQuestions) * 100 : 0;
      }

      // Öğrenme profili
      final profile = await getStudentLearningProfile(studentUid);

      // Son aktiviteler
      final recentActivities = await activityService.getRecentActivities(studentUid, limit: 10);

      // Devam eden ve tamamlanan aktiviteleri ayır
      List<Map<String, dynamic>> ongoingActivities = [];
      List<Map<String, dynamic>> completedActivities = [];

      for (var activity in recentActivities) {
        if (activity['completedAt'] == null) {
          ongoingActivities.add(activity);
        } else {
          completedActivities.add(activity);
        }
      }

      return {
        'todayStudyDuration': todayDuration,
        'todayStudyDurationMinutes': (todayDuration / 60).floor(),
        'todayStudyDurationFormatted': '${(todayDuration / 60).floor()}dk',
        'totalTestsCompleted': testScores.length,
        'averageScore': avgScore,
        'averageScoreFormatted': '${avgScore.toStringAsFixed(1)}%',
        'recentTests': testScores.take(5).toList(),
        'learningStyle': profile?['learningStyle'] ?? 'Belirlenmedi',
        'disabilityStatus': profile?['disabilityStatus'] ?? 'Yok',
        'studentName': profile?['name'] ?? '',
        'studentNumber': profile?['studentNumber'] ?? '',
        'ongoingActivities': ongoingActivities,
        'completedActivities': completedActivities.take(5).toList(),
      };
    } catch (e) {
      print('Özet rapor hatası: $e');
      return {
        'todayStudyDuration': 0,
        'todayStudyDurationMinutes': 0,
        'todayStudyDurationFormatted': '0dk',
        'totalTestsCompleted': 0,
        'averageScore': 0.0,
        'averageScoreFormatted': '0%',
        'recentTests': [],
        'learningStyle': 'Belirlenmedi',
        'disabilityStatus': 'Yok',
        'studentName': '',
        'studentNumber': '',
        'ongoingActivities': [],
        'completedActivities': [],
      };
    }
  }

  /// Öğrencinin materyal kullanım raporunu getir (tüm zamanlar)
  Future<Map<String, dynamic>> getMaterialUsageReport(String studentUid) async {
    try {
      // Tüm aktiviteleri getir (composite index sorunu önlemek için basit query)
      final snapshot = await _firestore
          .collection('students')
          .doc(studentUid)
          .collection('activityLog')
          .get();

      List<Map<String, dynamic>> pdfActivities = [];
      List<Map<String, dynamic>> videoActivities = [];
      List<Map<String, dynamic>> podcastActivities = [];
      int pdfTotalSeconds = 0;
      int videoTotalSeconds = 0;
      int podcastTotalSeconds = 0;

      for (var doc in snapshot.docs) {
        final data = doc.data();

        // Sadece material_view tipindeki aktiviteleri al
        if (data['type'] != 'material_view') continue;

        final materialType = data['materialType'] ?? '';
        final duration = (data['duration'] ?? 0) as int;

        final activityData = {
          'id': doc.id,
          'subject': data['subject'] ?? '',
          'topic': data['topic'] ?? '',
          'title': data['title'] ?? '',
          'duration': duration,
          'durationMinutes': (duration / 60).floor(),
          'completedAt': data['completedAt'],
          'startedAt': data['startedAt'],
          'progress': data['progress'] ?? 0,
          'materialType': materialType,
        };

        switch (materialType) {
          case 'pdf':
            pdfActivities.add(activityData);
            pdfTotalSeconds += duration;
            break;
          case 'video':
            videoActivities.add(activityData);
            videoTotalSeconds += duration;
            break;
          case 'podcast':
            podcastActivities.add(activityData);
            podcastTotalSeconds += duration;
            break;
        }
      }

      // Tüm materyal aktivitelerini birleştir ve tarihe göre sırala
      List<Map<String, dynamic>> allMaterials = [
        ...pdfActivities,
        ...videoActivities,
        ...podcastActivities,
      ];

      // startedAt'e göre sırala (en yeniden eskiye)
      allMaterials.sort((a, b) {
        final aTime = a['startedAt'];
        final bTime = b['startedAt'];
        if (aTime == null && bTime == null) return 0;
        if (aTime == null) return 1;
        if (bTime == null) return -1;
        return (bTime as Timestamp).compareTo(aTime as Timestamp);
      });

      // Son 10 materyal
      List<Map<String, dynamic>> recentMaterials = allMaterials.take(10).map((m) {
        return <String, dynamic>{
          'id': m['id'],
          'materialType': m['materialType'] ?? '',
          'subject': m['subject'] ?? '',
          'topic': m['topic'] ?? '',
          'title': m['title'] ?? '',
          'duration': m['duration'] ?? 0,
          'durationMinutes': m['durationMinutes'] ?? 0,
          'completedAt': m['completedAt'],
        };
      }).toList();

      return {
        'pdfActivities': pdfActivities,
        'videoActivities': videoActivities,
        'podcastActivities': podcastActivities,
        'pdfTotalMinutes': (pdfTotalSeconds / 60).floor(),
        'videoTotalMinutes': (videoTotalSeconds / 60).floor(),
        'podcastTotalMinutes': (podcastTotalSeconds / 60).floor(),
        'totalMinutes': ((pdfTotalSeconds + videoTotalSeconds + podcastTotalSeconds) / 60).floor(),
        'recentMaterials': recentMaterials,
        'pdfCount': pdfActivities.length,
        'videoCount': videoActivities.length,
        'podcastCount': podcastActivities.length,
      };
    } catch (e) {
      print('Materyal kullanım raporu hatası: $e');
      return {
        'pdfActivities': [],
        'videoActivities': [],
        'podcastActivities': [],
        'pdfTotalMinutes': 0,
        'videoTotalMinutes': 0,
        'podcastTotalMinutes': 0,
        'totalMinutes': 0,
        'recentMaterials': [],
        'pdfCount': 0,
        'videoCount': 0,
        'podcastCount': 0,
      };
    }
  }
}
