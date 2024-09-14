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
    print('Database path (inside _initDatabase): $path');
    return await openDatabase(
      path,
      version: 2,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade, // Atualização do banco de dados
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
        faixa_id INTEGER,  -- Relaciona com a tabela de faixas
        turnotreino TEXT,
        bairro TEXT,
        endereco TEXT,
        municipio TEXT,
        responsavel TEXT,
        responsavel2 TEXT,
        telefone TEXT,
        telresponsavel TEXT,
        telresponsavel2 TEXT,
        grau TEXT,
        grau2 TEXT,
        cep TEXT,
        escola TEXT,
        endescola TEXT,
        turnoescolar TEXT,
        FOREIGN KEY (faixa_id) REFERENCES faixas(id)  -- Define chave estrangeira
      )
    ''');

    await db.execute('''
      CREATE TABLE faixas (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        descricao TEXT
      )
    ''');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('''
        CREATE TABLE faixas (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          descricao TEXT
        )
      ''');

      await db.execute('''
        ALTER TABLE alunos ADD COLUMN faixa_id INTEGER;
      ''');

      await db.execute('''
        ALTER TABLE alunos ADD FOREIGN KEY (faixa_id) REFERENCES faixas(id);
      ''');
    }
  }

  Future<void> insertAluno(Map<String, dynamic> aluno) async {
    final db = await database;
    await db.insert('alunos', aluno);
  }

  Future<void> insertFaixa(Map<String, dynamic> faixa) async {
    final db = await database;
    await db.insert('faixas', faixa);
  }

  Future<List<Map<String, dynamic>>> getFaixas() async {
    final db = await database;
    return await db.query('faixas');
  }

  Future<void> updateAluno(int id, Map<String, dynamic> aluno) async {
    final db = await database;
    await db.update('alunos', aluno, where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Map<String, dynamic>>> getAlunos() async {
    final db = await database;
    return await db.query('alunos');
  }

  Future<void> deleteAluno(int id) async {
    final db = await database;
    await db.transaction((txn) async {
      await txn.delete('alunos', where: 'id = ?', whereArgs: [id]);
    });
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

  Future<int> countAlunos() async {
    final db = await database;
    final result = await db.rawQuery('SELECT COUNT(*) as count FROM alunos');
    return Sqflite.firstIntValue(result) ?? 0;
  }

  Future<int> countAlunosAtivos() async {
    final db = await database;
    final result = await db.rawQuery(
        'SELECT COUNT(*) as count FROM alunos WHERE status = ?', ['Ativo']);
    return Sqflite.firstIntValue(result) ?? 0;
  }

  Future<int> countAlunosInativos() async {
    final db = await database;
    final result = await db.rawQuery(
        'SELECT COUNT(*) as count FROM alunos WHERE status = ?', ['Inativo']);
    return Sqflite.firstIntValue(result) ?? 0;
  }

  Future<List<Map<String, dynamic>>> searchAlunos(String query) async {
    final db = await database;
    final result = await db.rawQuery(
        'SELECT * FROM alunos WHERE id LIKE ? OR nome LIKE ?',
        ['%$query%', '%$query%']);
    return result;
  }
}
