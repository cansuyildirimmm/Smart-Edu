import 'package:flutter/material.dart';
import 'screens/TMainMenuScreen.dart';
 // TMainMenuScreen.dart dosyasını dahil ettik

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: TeacherMenuScreen(), // TeacherMenuScreen burada kullanılacak
    );
  }
}
