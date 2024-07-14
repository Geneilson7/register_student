// ignore_for_file: constant_identifier_names

import 'dart:async';

import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path/path.dart';

class ConnectionSQLiteService {
  ConnectionSQLiteService._();

  static ConnectionSQLiteService? _instance;

  static ConnectionSQLiteService get instance {
    _instance ??= ConnectionSQLiteService._();
    return _instance!;
  }

  /*==========================================*/

  static const DATABASE_NAME = 'student.db';
  static const DATABASE_VERSION = 1;
  Database? _db;

  Future<Database> get db => openDatabase();

  Future<Database> openDatabase() async {
    sqfliteFfiInit();
    String databasePath = await databaseFactoryFfi.getDatabasesPath();
    String path = join(databasePath, DATABASE_NAME);
    DatabaseFactory databaseFactory = databaseFactoryFfi;

    _db ??= await databaseFactory.openDatabase(path, options: OpenDatabaseOptions(
      onCreate: _onCreate,
      version: DATABASE_VERSION,
    ));
    return _db!;
  }

  Future<void> _onCreate(Database db, int version) async {
    db.transaction((reference) async {
      reference.execute(ConnectionSQL.CREATE_DATABASE);
    });
  }
}