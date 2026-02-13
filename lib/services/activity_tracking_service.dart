import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ActivityTrackingService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Materyal görüntüleme aktivitesi başlat
  Future<String?> startMaterialActivity({
    required String materialType,
    required String subject,
    required String topic,
    required String title,
  }) async {
    try {
      final uid = _auth.currentUser?.uid;
      if (uid == null) {
        print('DEBUG: Kullanıcı oturumu yok - aktivite kaydedilemedi');
        return null;
      }

      print('DEBUG: Aktivite başlatılıyor - UID: $uid, Type: $materialType, Title: $title');

      final docRef = await _firestore
          .collection('students')
          .doc(uid)
          .collection('activityLog')
          .add({
        'type': 'material_view',
        'materialType': materialType,
        'subject': subject,
        'topic': topic,
        'title': title,
        'startedAt': FieldValue.serverTimestamp(),
        'completedAt': null,
        'duration': 0,
      });

      print('DEBUG: Aktivite başlatıldı - ID: ${docRef.id}');
      return docRef.id;
    } catch (e) {
      print('Aktivite başlama hatası: $e');
      return null;
    }
  }

  /// Aktiviteyi tamamla
  Future<bool> completeMaterialActivity({
    required String activityId,
    double? progress,
  }) async {
    try {
      final uid = _auth.currentUser?.uid;
      if (uid == null) {
        print('DEBUG: Kullanıcı oturumu yok - aktivite tamamlanamadı');
        return false;
      }

      print('DEBUG: Aktivite tamamlanıyor - ID: $activityId');

      final docRef = _firestore
          .collection('students')
          .doc(uid)
          .collection('activityLog')
          .doc(activityId);

      final doc = await docRef.get();
      if (!doc.exists) {
        print('DEBUG: Aktivite bulunamadı - ID: $activityId');
        return false;
      }

      final data = doc.data();
      if (data == null || data['startedAt'] == null) {
        print('DEBUG: Aktivite verisi eksik');
        return false;
      }

      final startedAt = (data['startedAt'] as Timestamp).toDate();
      final duration = DateTime.now().difference(startedAt).inSeconds;

      print('DEBUG: Aktivite süresi: $duration saniye');

      Map<String, dynamic> updateData = {
        'completedAt': FieldValue.serverTimestamp(),
        'duration': duration,
      };

      if (progress != null) {
        updateData['progress'] = progress;
      }

      await docRef.update(updateData);

      print('DEBUG: Aktivite tamamlandı - Süre: $duration saniye');
      return true;
    } catch (e) {
      print('Aktivite tamamlama hatası: $e');
      return false;
    }
  }

  /// Test aktivitesi kaydet (tek seferde)
  Future<bool> logTestActivity({
    required String subject,
    required String topic,
    required String testTitle,
    required int score,
    required int totalQuestions,
    required int duration,
    required bool isBanaOzel,
  }) async {
    try {
      final uid = _auth.currentUser?.uid;
      if (uid == null) return false;

      await _firestore
          .collection('students')
          .doc(uid)
          .collection('activityLog')
          .add({
        'type': 'test_complete',
        'materialType': null,
        'subject': subject,
        'topic': topic,
        'title': testTitle,
        'startedAt': FieldValue.serverTimestamp(),
        'completedAt': FieldValue.serverTimestamp(),
        'duration': duration,
        'score': score,
        'totalQuestions': totalQuestions,
        'correctAnswers': score,
        'wrongAnswers': totalQuestions - score,
        'isBanaOzel': isBanaOzel,
      });

      return true;
    } catch (e) {
      print('Test aktivite kaydı hatası: $e');
      return false;
    }
  }

  /// Öğrencinin bugünlük çalışma süresini getir (saniye cinsinden)
  Future<int> getTodayStudyDuration(String studentUid) async {
    try {
      final now = DateTime.now();
      final todayStart = DateTime(now.year, now.month, now.day);

      final snapshot = await _firestore
          .collection('students')
          .doc(studentUid)
          .collection('activityLog')
          .where('startedAt', isGreaterThanOrEqualTo: Timestamp.fromDate(todayStart))
          .get();

      int totalDuration = 0;
      for (var doc in snapshot.docs) {
        final data = doc.data();
        totalDuration += (data['duration'] as int? ?? 0);
      }

      return totalDuration;
    } catch (e) {
      print('Çalışma süresi hesaplama hatası: $e');
      return 0;
    }
  }

  /// Öğrencinin son aktivitelerini getir
  Future<List<Map<String, dynamic>>> getRecentActivities(String studentUid, {int limit = 10}) async {
    try {
      final snapshot = await _firestore
          .collection('students')
          .doc(studentUid)
          .collection('activityLog')
          .orderBy('startedAt', descending: true)
          .limit(limit)
          .get();

      return snapshot.docs.map((doc) {
        final data = doc.data();
        return {
          'id': doc.id,
          'type': data['type'],
          'materialType': data['materialType'],
          'subject': data['subject'],
          'topic': data['topic'],
          'title': data['title'],
          'startedAt': data['startedAt'],
          'completedAt': data['completedAt'],
          'duration': data['duration'],
          'score': data['score'],
          'totalQuestions': data['totalQuestions'],
          'progress': data['progress'],
        };
      }).toList();
    } catch (e) {
      print('Aktivite geçmişi hatası: $e');
      return [];
    }
  }
}
