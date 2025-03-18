import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

Future<void> createAccount(String email, String password, String name, String school, String branch, String studentNumber, String telNumber, String kullaniciTuru) async {
  try {
    UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    await FirebaseFirestore.instance.collection(kullaniciTuru).doc(userCredential.user!.uid).set({
      'email' : email,
      'password' : password,
      'name ' : name,
      'school' : school,
      'branch' : branch,//for teacher
      'studentNumber' : studentNumber,//for student
      'telNumber' : telNumber,
    });

    print('Kayıt başarılı!');
  } on FirebaseAuthException catch (e) {
    print('Firebase Authentication hatası: ${e.code}');
  } catch (e) {
    print('Hata: $e');
  }
}

Future<void> signIn(BuildContext context, String email, String password, String userType) async {
  try {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    // Giriş başarılı, kullanıcıyı ilgili ana ekrana yönlendir
    if (userType == "students") {
      // Öğrenci ana ekranına yönlendirme
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ogrenci girsii basarili')),
      );
    } else if (userType == "teachers") {
      // Öğretmen ana ekranına yönlendirme
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('ogretnmen girsii basarili')),
      );
    } else {

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Geçersiz kullanıcı tipi.')),
      );
    }
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
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Giriş sırasında bir hata oluştu: $e')),
    );
    print('Genel Hata: $e');
  }
}