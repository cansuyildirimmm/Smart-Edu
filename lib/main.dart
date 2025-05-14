import 'package:flutter/material.dart';
//import 'package:smartedu/screens/SHome.dart';
//import 'screens/TMainMenuScreen.dart';
import 'screens/SMainMenuScreen.dart'; 
//import 'screens/SMyLessons.dart'; 

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      //home: TeacherMenuScreen(), 
      home: SMainMenuScreen(),
      //home: SHome(),
    );
  }
}
