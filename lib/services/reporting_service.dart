import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class ReportingService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Map<String, dynamic>> getStudentSummaryReport(String studentUid) async {
    try {
      final now = DateTime.now();
      final startOfDay = DateTime(now.year, now.month, now.day);
      
      // Bugün çalışılan süreyi hesapla
      final activitiesSnapshot = await _firestore
          .collection('students')
          .doc(studentUid)
          .collection('activities')
          .where('timestamp', isGreaterThanOrEqualTo: startOfDay)
          .get();

      int todayMinutes = 0;
      for (var doc in activitiesSnapshot.docs) {
        final data = doc.data();
        if (data['duration'] != null) {
          todayMinutes += (data['duration'] as int) ~/ 60;
        }
      }

      // Son testleri getir
      final testsSnapshot = await _firestore
          .collection('students')
          .doc(studentUid)
          .collection('testScores')
          .orderBy('completedAt', descending: true)
          .limit(5)
          .get();

      final recentTests = testsSnapshot.docs.map((doc) => doc.data()).toList();

      // Tamamlanan aktiviteleri getir
      final completedActivitiesSnapshot = await _firestore
           .collection('students')
          .doc(studentUid)
          .collection('activities')
          .where('status', isEqualTo: 'completed')
          .orderBy('endTime', descending: true)
          .limit(5)
          .get();

      final completedActivities = completedActivitiesSnapshot.docs.map((doc) => doc.data()).toList();


      return {
        'todayStudyDurationMinutes': todayMinutes,
        'todayStudyDurationFormatted': '${todayMinutes}dk',
        'recentTests': recentTests,
        'completedActivities': completedActivities,
      };
    } catch (e) {
      print('Rapor oluşturma hatası: $e');
      return {};
    }
  }

  Future<Map<String, dynamic>> getMaterialUsageReport(String studentUid) async {
    try {
      final snapshot = await _firestore
          .collection('students')
          .doc(studentUid)
          .collection('activities')
          .where('type', isEqualTo: 'material_view')
          .get();

      int pdfCount = 0;
      int videoMinutes = 0;
      int podcastMinutes = 0;
      List<Map<String, dynamic>> recentMaterials = [];

      for (var doc in snapshot.docs) {
        final data = doc.data();
        final duration = (data['endTime'] != null && data['startTime'] != null)
            ? (data['endTime'] as Timestamp)
                .toDate()
                .difference((data['startTime'] as Timestamp).toDate())
                .inMinutes
            : 0;

        if (data['materialType'] == 'pdf') {
          pdfCount++;
        } else if (data['materialType'] == 'video') {
          videoMinutes += duration;
        } else if (data['materialType'] == 'podcast') {
          podcastMinutes += duration;
        }
        
        // Son materyalleri listeye ekle
        data['durationMinutes'] = duration;
        recentMaterials.add(data);
      }

      // En son kullanılanlara göre sırala
      recentMaterials.sort((a, b) {
        final aTime = (a['startTime'] as Timestamp?)?.toDate() ?? DateTime(2000);
        final bTime = (b['startTime'] as Timestamp?)?.toDate() ?? DateTime(2000);
        return bTime.compareTo(aTime);
      });

      return {
        'pdfCount': pdfCount,
        'videoTotalMinutes': videoMinutes,
        'podcastTotalMinutes': podcastMinutes,
        'recentMaterials': recentMaterials.take(5).toList(),
      };
    } catch (e) {
      print('Materyal raporu oluşturma hatası: $e');
      return {};
    }
  }
}
