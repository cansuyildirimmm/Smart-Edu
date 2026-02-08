import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TeacherStudentService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Öğrenci ara (Numara ile)
  Future<Map<String, dynamic>?> searchStudentByNumber(String studentNumber) async {
    try {
      final querySnapshot = await _firestore
          .collection('students')
          .where('studentNumber', isEqualTo: studentNumber)
          .limit(1)
          .get();

      if (querySnapshot.docs.isEmpty) return null;

      final doc = querySnapshot.docs.first;
      final data = doc.data();
      data['uid'] = doc.id;
      return data;
    } catch (e) {
      print('Öğrenci arama hatası: $e');
      return null;
    }
  }

  // Öğrenci zaten ekli mi kontrol et
  Future<bool> isStudentAlreadyAdded(String studentUid) async {
    final teacher = _auth.currentUser;
    if (teacher == null) return false;

    try {
      final doc = await _firestore
          .collection('teachers')
          .doc(teacher.uid)
          .collection('students')
          .doc(studentUid)
          .get();

      return doc.exists;
    } catch (e) {
      print('Öğrenci kontrol hatası: $e');
      return false;
    }
  }

  // Öğrenciyi öğretmene ekle
  Future<bool> addStudentToTeacher(String studentUid) async {
    final teacher = _auth.currentUser;
    if (teacher == null) return false;

    try {
      // Öğrenci bilgilerini al
      final studentDoc = await _firestore.collection('students').doc(studentUid).get();
      if (!studentDoc.exists) return false;

      final studentData = studentDoc.data()!;

      // Öğretmenin listesine ekle
      await _firestore
          .collection('teachers')
          .doc(teacher.uid)
          .collection('students')
          .doc(studentUid)
          .set({
        'name': studentData['name'],
        'studentNumber': studentData['studentNumber'],
        'school': studentData['school'],
        'addedAt': FieldValue.serverTimestamp(),
      });

      return true;
    } catch (e) {
      print('Öğrenci ekleme hatası: $e');
      return false;
    }
  }

  // Öğretmenin öğrencilerini listele
  Stream<List<Map<String, dynamic>>> getMyStudents() {
    final teacher = _auth.currentUser;
    if (teacher == null) {
      return Stream.value([]);
    }

    return _firestore
        .collection('teachers')
        .doc(teacher.uid)
        .collection('students')
        .orderBy('name')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
              final data = doc.data();
              data['uid'] = doc.id;
              return data;
            }).toList());
  }

  // getMyStudents alias
  Stream<List<Map<String, dynamic>>> getTeacherStudents() => getMyStudents();

  // Öğrenci sil
  Future<void> removeStudent(String studentUid) async {
    final teacher = _auth.currentUser;
    if (teacher == null) return;

    try {
      await _firestore
          .collection('teachers')
          .doc(teacher.uid)
          .collection('students')
          .doc(studentUid)
          .delete();
    } catch (e) {
      print('Öğrenci silme hatası: $e');
    }
  }
}
