import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TeacherNotesService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Öğretmen öğrenciye not gönderir
  Future<bool> sendNoteToStudent({
    required String studentUid,
    required String content,
  }) async {
    try {
      final currentUser = _auth.currentUser;
      if (currentUser == null) return false;

      // Öğretmen bilgilerini al
      final teacherDoc = await _firestore
          .collection('teachers')
          .doc(currentUser.uid)
          .get();

      if (!teacherDoc.exists) return false;

      final teacherData = teacherDoc.data()!;
      final teacherName = teacherData['name'] ?? 'Öğretmen';

      // Notu öğrencinin teacherNotes koleksiyonuna ekle
      await _firestore
          .collection('students')
          .doc(studentUid)
          .collection('teacherNotes')
          .add({
        'teacherUid': currentUser.uid,
        'teacherName': teacherName,
        'content': content,
        'createdAt': FieldValue.serverTimestamp(),
        'isRead': false,
      });

      return true;
    } catch (e) {
      print('Not gönderme hatası: $e');
      return false;
    }
  }

  /// Öğretmen gönderdiği notu siler
  Future<bool> deleteNote({
    required String studentUid,
    required String noteId,
  }) async {
    try {
      final currentUser = _auth.currentUser;
      if (currentUser == null) return false;

      // Notun bu öğretmene ait olduğunu kontrol et
      final noteDoc = await _firestore
          .collection('students')
          .doc(studentUid)
          .collection('teacherNotes')
          .doc(noteId)
          .get();

      if (!noteDoc.exists) return false;

      final noteData = noteDoc.data()!;
      if (noteData['teacherUid'] != currentUser.uid) return false;

      // Notu sil
      await _firestore
          .collection('students')
          .doc(studentUid)
          .collection('teacherNotes')
          .doc(noteId)
          .delete();

      return true;
    } catch (e) {
      print('Not silme hatası: $e');
      return false;
    }
  }

  /// Öğrenci kendi öğretmen notlarını görür (Stream)
  Stream<List<Map<String, dynamic>>> getMyTeacherNotes() {
    final currentUser = _auth.currentUser;
    if (currentUser == null) {
      return Stream.value([]);
    }

    return _firestore
        .collection('students')
        .doc(currentUser.uid)
        .collection('teacherNotes')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return {
          'id': doc.id,
          'teacherUid': data['teacherUid'],
          'teacherName': data['teacherName'],
          'content': data['content'],
          'createdAt': data['createdAt'],
          'isRead': data['isRead'] ?? false,
        };
      }).toList();
    });
  }

  /// Belirli bir öğrencinin öğretmen notlarını getir (öğretmen için)
  Stream<List<Map<String, dynamic>>> getStudentTeacherNotes(String studentUid) {
    return _firestore
        .collection('students')
        .doc(studentUid)
        .collection('teacherNotes')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return {
          'id': doc.id,
          'teacherUid': data['teacherUid'],
          'teacherName': data['teacherName'],
          'content': data['content'],
          'createdAt': data['createdAt'],
          'isRead': data['isRead'] ?? false,
        };
      }).toList();
    });
  }

  /// Okunmamış not sayısı (Stream)
  Stream<int> getUnreadNoteCount() {
    final currentUser = _auth.currentUser;
    if (currentUser == null) {
      return Stream.value(0);
    }

    return _firestore
        .collection('students')
        .doc(currentUser.uid)
        .collection('teacherNotes')
        .where('isRead', isEqualTo: false)
        .snapshots()
        .map((snapshot) => snapshot.docs.length);
  }

  /// Notu okundu olarak işaretle
  Future<void> markNoteAsRead(String noteId) async {
    final currentUser = _auth.currentUser;
    if (currentUser == null) return;

    try {
      await _firestore
          .collection('students')
          .doc(currentUser.uid)
          .collection('teacherNotes')
          .doc(noteId)
          .update({'isRead': true});
    } catch (e) {
      print('Not okundu işaretleme hatası: $e');
    }
  }

  /// Son notu getir (ana menü için)
  Stream<Map<String, dynamic>?> getMostRecentNote() {
    final currentUser = _auth.currentUser;
    if (currentUser == null) {
      return Stream.value(null);
    }

    return _firestore
        .collection('students')
        .doc(currentUser.uid)
        .collection('teacherNotes')
        .orderBy('createdAt', descending: true)
        .limit(1)
        .snapshots()
        .map((snapshot) {
      if (snapshot.docs.isEmpty) return null;

      final doc = snapshot.docs.first;
      final data = doc.data();
      return {
        'id': doc.id,
        'teacherUid': data['teacherUid'],
        'teacherName': data['teacherName'],
        'content': data['content'],
        'createdAt': data['createdAt'],
        'isRead': data['isRead'] ?? false,
      };
    });
  }
}
