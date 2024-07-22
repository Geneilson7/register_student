import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  static final DBHelper _instance = DBHelper._();
  static Database? _database;

  DBHelper._();

  factory DBHelper() {
    return _instance;
  }

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'aluno.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE alunos (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nome TEXT,
        cpf TEXT,
        rg TEXT,
        dtnascimento TEXT,
        pcd TEXT,
        sexo TEXT,
        status TEXT,
        bairro TEXT,
        endereco TEXT,
        municipio TEXT,
        responsavel TEXT,
        telefone TEXT,
        telresponsavel TEXT,
        cep TEXT,
        escola TEXT,
        endescola TEXT,
        turnoescolar TEXT
      )
    ''');
  }

  Future<void> insertAluno(Map<String, dynamic> aluno) async {
    final db = await database;
    await db.insert('alunos', aluno);
  }

  Future<List<Map<String, dynamic>>> getAlunos() async {
    final db = await database;
    return await db.query('alunos');
  }

  Future<void> updateAluno(int id, Map<String, dynamic> aluno) async {
    final db = await database;
    await db.update('alunos', aluno, where: 'id = ?', whereArgs: [id]);
  }

  Future<void> deleteAluno(int id) async {
    final db = await database;
    await db.delete('alunos', where: 'id = ?', whereArgs: [id]);
  }

  Future<Map<String, dynamic>?> getAlunoById(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> result = await db.query(
      'alunos',
      where: 'id = ?',
      whereArgs: [id],
    );
    return result.isNotEmpty ? result.first : null;
  }
}