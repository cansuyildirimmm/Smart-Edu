import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ActivityTrackingService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> logTestActivity({
    required String subject,
    required String topic,
    required String testTitle,
    required int score,
    required int totalQuestions,
    required int duration,
    bool isBanaOzel = false,
  }) async {
    final user = _auth.currentUser;
    if (user == null) return;

    try {
      await _firestore
          .collection('students')
          .doc(user.uid)
          .collection('activities')
          .add({
        'type': 'test_solve',
        'subject': subject,
        'topic': topic,
        'testTitle': testTitle,
        'score': score,
        'totalQuestions': totalQuestions,
        'duration': duration, // saniye cinsinden
        'timestamp': FieldValue.serverTimestamp(),
        'isBanaOzel': isBanaOzel,
      });
      print('Aktivite başarıyla kaydedildi.');
    } catch (e) {
      print('Aktivite kaydetme hatası: $e');
    }
  }

  // İleride eklenebilecek diğer aktiviteler için metodlar buraya gelebilir
  // Örneğin: logVideoWatch, logDocumentRead vb.
  // Material aktivitelerini başlatma ve tamamlama metodları
  Future<String?> startMaterialActivity({
    required String materialType,
    required String subject,
    required String topic,
    required String title,
  }) async {
    final user = _auth.currentUser;
    if (user == null) return null;

    try {
      final docRef = await _firestore
          .collection('students')
          .doc(user.uid)
          .collection('activities')
          .add({
        'type': 'material_view',
        'materialType': materialType,
        'subject': subject,
        'topic': topic,
        'title': title,
        'startTime': FieldValue.serverTimestamp(),
        'status': 'started',
      });
      return docRef.id;
    } catch (e) {
      print('Aktivite başlatma hatası: $e');
      return null;
    }
  }

  Future<void> completeMaterialActivity({
    required String activityId,
  }) async {
    final user = _auth.currentUser;
    if (user == null) return;

    try {
      await _firestore
          .collection('students')
          .doc(user.uid)
          .collection('activities')
          .doc(activityId)
          .update({
        'endTime': FieldValue.serverTimestamp(),
        'status': 'completed',
      });
      print('Aktivite tamamlandı.');
    } catch (e) {
      print('Aktivite tamamlama hatası: $e');
    }
  }
}
