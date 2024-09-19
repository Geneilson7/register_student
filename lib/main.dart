// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:register_student/pages/home_page.dart';
import 'package:register_student/services/db_helper.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:window_manager/window_manager.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();

  WindowOptions windowOptions = const WindowOptions(
    center: true,
    title: "GenTech Jiu-Jitsu",
    backgroundColor: Colors.transparent,
    size: Size(1366, 768),
  );

  await windowManager.waitUntilReadyToShow(windowOptions, () async {
    // await windowManager.maximize();
    // await windowManager.show();
  });

  // Inicializar o banco de dados
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;
  await DBHelper().database;

  runApp(const MyApp());
}

void onWindowEvent(String eventName) {
  print('[WindowManager] onWindowEvent: $eventName');
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xffFFFFFF),
      ),
      debugShowCheckedModeBanner: false,
      locale: const Locale('pt', 'BR'),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      home: const HomePage(),
    );
  }
}
