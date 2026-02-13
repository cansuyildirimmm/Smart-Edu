import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TeacherStudentService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Öğrenci numarası ile öğrenci arama
  Future<Map<String, dynamic>?> searchStudentByNumber(String studentNumber) async {
    try {
      final querySnapshot = await _firestore
          .collection('students')
          .where('studentNumber', isEqualTo: studentNumber.trim())
          .limit(1)
          .get();

      if (querySnapshot.docs.isEmpty) return null;

      final doc = querySnapshot.docs.first;
      return {
        'uid': doc.id,
        'name': doc.data()['name'],
        'email': doc.data()['email'],
        'school': doc.data()['school'],
        'branch': doc.data()['branch'],
        'studentNumber': doc.data()['studentNumber'],
        'telNumber': doc.data()['telNumber'],
      };
    } catch (e) {
      print('Öğrenci arama hatası: $e');
      return null;
    }
  }

  /// Öğretmene öğrenci ekleme (mevcut öğrenciyi bağlama)
  Future<bool> addStudentToTeacher(String studentUid) async {
    try {
      final teacherUid = _auth.currentUser?.uid;
      if (teacherUid == null) return false;

      // Öğrenci bilgilerini al
      final studentDoc = await _firestore.collection('students').doc(studentUid).get();
      if (!studentDoc.exists) return false;

      final studentData = studentDoc.data()!;

      await _firestore
          .collection('teachers')
          .doc(teacherUid)
          .collection('students')
          .doc(studentUid)
          .set({
        'addedAt': FieldValue.serverTimestamp(),
        'studentEmail': studentData['email'],
        'studentName': studentData['name'],
        'studentNumber': studentData['studentNumber'],
      });

      return true;
    } catch (e) {
      print('Öğrenci ekleme hatası: $e');
      return false;
    }
  }

  /// Öğretmenin öğrenci listesini getirme (Stream)
  Stream<List<Map<String, dynamic>>> getTeacherStudents() {
    final teacherUid = _auth.currentUser?.uid;
    if (teacherUid == null) return Stream.value([]);

    return _firestore
        .collection('teachers')
        .doc(teacherUid)
        .collection('students')
        .orderBy('addedAt', descending: true)
        .snapshots()
        .asyncMap((snapshot) async {
      List<Map<String, dynamic>> students = [];

      for (var doc in snapshot.docs) {
        // Güncel öğrenci bilgilerini students koleksiyonundan al
        final studentDoc = await _firestore.collection('students').doc(doc.id).get();
        if (studentDoc.exists) {
          final studentData = studentDoc.data()!;
          students.add({
            'uid': doc.id,
            'name': studentData['name'] ?? '',
            'email': studentData['email'] ?? '',
            'school': studentData['school'] ?? '',
            'branch': studentData['branch'] ?? '',
            'studentNumber': studentData['studentNumber'] ?? '',
            'telNumber': studentData['telNumber'] ?? '',
            'addedAt': doc.data()['addedAt'],
          });
        }
      }
      return students;
    });
  }

  /// Öğrenci-öğretmen ilişkisini kaldırma
  Future<bool> removeStudentFromTeacher(String studentUid) async {
    try {
      final teacherUid = _auth.currentUser?.uid;
      if (teacherUid == null) return false;

      await _firestore
          .collection('teachers')
          .doc(teacherUid)
          .collection('students')
          .doc(studentUid)
          .delete();

      return true;
    } catch (e) {
      print('Öğrenci silme hatası: $e');
      return false;
    }
  }

  /// Öğrencinin zaten ekli olup olmadığını kontrol
  Future<bool> isStudentAlreadyAdded(String studentUid) async {
    try {
      final teacherUid = _auth.currentUser?.uid;
      if (teacherUid == null) return false;

      final doc = await _firestore
          .collection('teachers')
          .doc(teacherUid)
          .collection('students')
          .doc(studentUid)
          .get();

      return doc.exists;
    } catch (e) {
      print('Öğrenci kontrol hatası: $e');
      return false;
    }
  }
}
