import 'package:flutter/material.dart';
import 'package:register_student/register/home_page.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() async {
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;
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

