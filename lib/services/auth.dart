import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> createAccount(String email, String password, String name, String school,String branch,String studentNumber,String telNumber, String kullaniciTuru) async {
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