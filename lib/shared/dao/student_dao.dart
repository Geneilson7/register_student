import 'package:register_student/shared/dao/sql.dart';
import 'package:register_student/shared/models/student_model.dart';
import 'package:register_student/shared/services/connection_sqlite_service.dart';
import 'package:sqflite/sqflite.dart';

class StudentDao{
  ConnectionSQLiteService _connection = ConnectionSQLiteService.instance;

  Future<Database>_getDatabase () async {
    return await _connection.db;
  }

  Future<Student> adicionar(Student student) async {
    try {
      Database db = await _getDatabase();
      db.rawInsert(ConnectionSQL.adicionarStudent());
    } catch (error) {
      throw Exception();
    }
  }  

  Future atualizar() async {
    try {
      
    } catch (error) {
      throw Exception();
    }
  }

  Future selecionarTodos() async {
    try {
      
    } catch (error) {
      throw Exception();
    }
  }

  Future deletar() async {
    try {
      
    } catch (error) {
      throw Exception();
    }
  }
}