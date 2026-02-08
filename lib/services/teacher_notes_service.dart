import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TeacherNotesService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<bool> sendNoteToStudent({
    required String studentUid,
    required String content,
  }) async {
    final teacher = _auth.currentUser;
    if (teacher == null) return false;

    try {
      await _firestore
          .collection('students')
          .doc(studentUid)
          .collection('teacherNotes')
          .add({
        'content': content,
        'senderUid': teacher.uid,
        'senderName': teacher.displayName ?? 'Öğretmen',
        'timestamp': FieldValue.serverTimestamp(),
        'isRead': false,
      });
      return true;
    } catch (e) {
      print('Not gönderme hatası: $e');
      return false;
    }
  }

  Stream<List<Map<String, dynamic>>> getMyTeacherNotes() {
    final user = _auth.currentUser;
    if (user == null) {
      return Stream.value([]);
    }

    return _firestore
        .collection('students')
        .doc(user.uid)
        .collection('teacherNotes')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return data;
      }).toList();
    });
  }

  Future<void> markNoteAsRead(String noteId) async {
    final user = _auth.currentUser;
    if (user == null) return;

    try {
      await _firestore
          .collection('students')
          .doc(user.uid)
          .collection('teacherNotes')
          .doc(noteId)
          .update({'isRead': true});
    } catch (e) {
      print('Not okundu işaretleme hatası: $e');
    }
  }
  Stream<int> getUnreadNoteCount() {
    final user = _auth.currentUser;
    if (user == null) {
      return Stream.value(0);
    }

    return _firestore
        .collection('students')
        .doc(user.uid)
        .collection('teacherNotes')
        .where('isRead', isEqualTo: false)
        .snapshots()
        .map((snapshot) => snapshot.docs.length);
  }

  Stream<Map<String, dynamic>?> getMostRecentNote() {
    final user = _auth.currentUser;
    if (user == null) {
      return Stream.value(null);
    }

    return _firestore
        .collection('students')
        .doc(user.uid)
        .collection('teacherNotes')
        .orderBy('timestamp', descending: true)
        .limit(1)
        .snapshots()
        .map((snapshot) {
      if (snapshot.docs.isEmpty) return null;
      final doc = snapshot.docs.first;
      final data = doc.data();
      data['id'] = doc.id;
      return data;
    });
  }
}
