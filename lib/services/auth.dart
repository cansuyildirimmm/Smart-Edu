import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

Future<bool> createAccount(
    String email,
    String password,
    String name,
    String school,
    String branch,
    String studentNumber,
    String telNumber,
    String kullaniciTuru,
    ) async {
  try {
    UserCredential userCredential =
    await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    await FirebaseFirestore.instance
        .collection(kullaniciTuru)
        .doc(userCredential.user!.uid)
        .set({
      'email': email,
      'password': password,
      'name': name,
      'school': school,
      'branch': branch, // for teacher
      'studentNumber': studentNumber, // for student
      'telNumber': telNumber,
    });

    print('Kayıt başarılı!');
    return true;
  } on FirebaseAuthException catch (e) {
    print('Firebase Authentication hatası: ${e.code}');
    return false;
  } catch (e) {
    print('Hata: $e');
    return false;
  }
}


Future<bool> signIn(BuildContext context, String email, String password, String userType) async {
  try {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    if (userType == "students") {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Öğrenci girişi başarılı')),
      );
    } else if (userType == "teachers") {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Öğretmen girişi başarılı')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Geçersiz kullanıcı tipi.')),
      );
      return false; // Geçersiz kullanıcı tipi
    }

    return true; // Başarılı giriş
  } on FirebaseAuthException catch (e) {
    String errorMessage = 'Giriş yapılamadı. Lütfen bilgilerinizi kontrol edin.';
    if (e.code == 'user-not-found') {
      errorMessage = 'Bu e-posta adresiyle kayıtlı bir kullanıcı bulunamadı.';
    } else if (e.code == 'wrong-password') {
      errorMessage = 'Yanlış şifre girdiniz.';
    } else if (e.code == 'network-request-failed') {
      errorMessage = 'İnternet bağlantınızı kontrol edin.';
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(errorMessage)),
    );
    print('Firebase Auth Hatası: ${e.code}');
    return false;
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Giriş sırasında bir hata oluştu: $e')),
    );
    print('Genel Hata: $e');
    return false;
  }
}
Future<bool> saveTestResult({
  required String kullaniciTuru,
  required String learningStyle,
  required String disabilityStatus,
}) async {
  try {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return false;

    await FirebaseFirestore.instance
        .collection(kullaniciTuru)
        .doc(user.uid)
        .collection('testResults')
        .add({
      'learningStyle': learningStyle,
      'disabilityStatus': disabilityStatus,
      'date': DateTime.now(),
    });

    print('Test sonucu başarıyla kaydedildi.');
    return true;

  } catch (e) {
    print('Test sonucu kaydedilirken hata: $e');
    return false;
  }
}
void kaydetTestSonucu(String secilenOgrenmeBicimi, String secilenEngelDurumu) async {
  bool sonuc = await saveTestResult(
    kullaniciTuru: 'students',  // ya da 'teachers'
    learningStyle: secilenOgrenmeBicimi,
    disabilityStatus: secilenEngelDurumu,
  );

  if (sonuc) {
    print('Test sonucu kaydedildi, devam edebilirsiniz.');
  } else {
    print('Test sonucu kaydedilirken hata oluştu.');
  }
}

Future<Map<String, dynamic>?> getLatestTestResult(String kullaniciTuru) async {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) return null;

  final snapshot = await FirebaseFirestore.instance
      .collection(kullaniciTuru)
      .doc(user.uid)
      .collection('testResults')
      .orderBy('date', descending: true)
      .limit(1)
      .get();

  if (snapshot.docs.isNotEmpty) {
    return snapshot.docs.first.data();
  } else {
    return null;
  }
}