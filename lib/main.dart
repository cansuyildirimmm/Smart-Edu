import 'package:flutter/material.dart';
import 'package:smartedu/OnboardingScreen.dart';
import 'package:smartedu/SWelcomeScreen.dart';
import 'package:smartedu/TWelcomeScreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: OnboardingScreen()
    );
  }
}

