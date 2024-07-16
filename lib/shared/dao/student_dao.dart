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
      int idRetornado = await db.rawInsert(ConnectionSQL.adicionarStudent(student));
      student.id = idRetornado;
      return student;
    } catch (error) {
      throw Exception();
    }
  }  

  Future<bool> atualizar(Student student) async {
    try {
      Database db = await _getDatabase();
      int linhasAfetadas = await db.rawUpdate(ConnectionSQL.atulizarStudent(student));
      if (linhasAfetadas > 0) {
        return true;
      }
      return false;
    } catch (error) {
      throw Exception();
    }
  }

  Future selecionarTodos() async {
    try {
      Database db = await _getDatabase();
      List<Map> linhas = await db.rawQuery(ConnectionSQL.selecionarTodosOsStudents());
      List<Student> student = Student.fromSQLiteList(linhas);
      return student;
    } catch (error) {
      throw Exception();
    }
  }

  Future<bool> deletar(Student student) async {
    try {
      Database db = await _getDatabase();
      int linhasAfetadas = await db.rawDelete(ConnectionSQL.deleteStudent(student));
      if (linhasAfetadas > 0) {
        return true;        
      }
      return false;
    } catch (error) {
      throw Exception();
    }
  }
}