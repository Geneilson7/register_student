import 'package:flutter/material.dart';
import 'package:register_student/src/home_page.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(        
        scaffoldBackgroundColor: const Color(0xffFFFFFF),
      ),
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
    );
  }
}

