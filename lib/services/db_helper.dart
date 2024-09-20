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
      onUpgrade: _onUpgrade,
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
        faixa_id INTEGER, 
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
        professor_id INTEGER,
        data_cadastro TEXT DEFAULT (datetime('now')),
        data_inativo TEXT,
        FOREIGN KEY (faixa_id) REFERENCES faixas(id),
        FOREIGN KEY (professor_id) REFERENCES professores(id)
      )
    ''');

    await db.execute('''
    CREATE TABLE frequencia (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      aluno_id INTEGER,
      data TEXT,
      presente INTEGER,
      data_cadastro TEXT DEFAULT (datetime('now')),
      FOREIGN KEY (aluno_id) REFERENCES alunos(id)
    )
  ''');

    await db.execute('''
      CREATE TABLE faixas (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        descricao TEXT,
        data_cadastro TEXT DEFAULT (datetime('now'))
      )
    ''');

    await db.execute('''
      CREATE TABLE professores (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nome TEXT,
        cpf TEXT,
        rg TEXT,
        dtnascimento TEXT,
        pcd TEXT,
        sexo TEXT,
        status TEXT,
        faixa_id INTEGER, 
        cep TEXT,
        municipio TEXT,
        bairro TEXT,
        endereco TEXT,
        telefone TEXT,
        data_cadastro TEXT DEFAULT (datetime('now')),
        data_inativo TEXT,
        FOREIGN KEY (faixa_id) REFERENCES faixas(id)
      )
    ''');

    await db.execute('''
      CREATE TABLE eventos (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        titulo TEXT,
        escrita TEXT,
        assinatura_1 TEXT,
        assinatura_2 TEXT,
        ass_unica TEXT,
        data_cadastro TEXT DEFAULT (datetime('now'))
      )
    ''');

    await db.execute('''
      CREATE TABLE formacao_aluno (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        aluno_id INTEGER NOT NULL,
        faixa_id INTEGER NOT NULL,
        data_mudanca TEXT NOT NULL,
        FOREIGN KEY (aluno_id) REFERENCES alunos(id),
        FOREIGN KEY (faixa_id) REFERENCES faixas(id)
      )
  ''');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('''
        CREATE TABLE faixas (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          descricao TEXT,
          data_cadastro TEXT DEFAULT (datetime('now'))
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

  Future<void> updateAluno(int id, Map<String, dynamic> aluno) async {
    final db = await database;
    await db.update('alunos', aluno, where: 'id = ?', whereArgs: [id]);
  }

  Future<void> insertFaixa(Map<String, dynamic> faixa) async {
    final db = await database;
    await db.insert('faixas', faixa);
  }

  Future<void> updateFaixa(int id, Map<String, dynamic> aluno) async {
    final db = await database;
    await db.update('faixas', aluno, where: 'id = ?', whereArgs: [id]);
  }

  Future<void> deleteFaixa(int id) async {
    final db = await database;
    await db.transaction((txn) async {
      await txn.delete('alunos', where: 'id = ?', whereArgs: [id]);
    });
  }

  Future<List<Map<String, dynamic>>> getFaixas() async {
    final db = await database;
    return await db.query('faixas');
  }

  Future<Map<String, dynamic>?> getFaixasById(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> result = await db.query(
      'faixas',
      where: 'id = ?',
      whereArgs: [id],
    );
    return result.isNotEmpty ? result.first : null;
  }

  Future<List<Map<String, dynamic>>> searchFaixas(String query) async {
    final db = await database;
    final result = await db.rawQuery(
        'SELECT * FROM faixas WHERE id LIKE ? OR descricao LIKE ?',
        ['%$query%', '%$query%']);
    return result;
  }

  Future<List<Map<String, dynamic>>> fetchFaixas() async {
    final db = await database; // função que obtém o database
    return await db.query('faixas', columns: ['id', 'descricao']);
  }

  Future<void> insertProfessores(Map<String, dynamic> faixa) async {
    final db = await database;
    await db.insert('professores', faixa);
  }

  Future<void> updateProfessores(int id, Map<String, dynamic> aluno) async {
    final db = await database;
    await db.update('professores', aluno, where: 'id = ?', whereArgs: [id]);
  }

  Future<void> deleteProfessor(int id) async {
    final db = await database;
    await db.transaction((txn) async {
      await txn.delete('alunos', where: 'id = ?', whereArgs: [id]);
    });
  }

  Future<List<Map<String, dynamic>>> getProfessores() async {
    final db = await database;
    return await db.query('professores');
  }

  Future<Map<String, dynamic>?> getProfessoresId(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> result = await db.query(
      'professores',
      where: 'id = ?',
      whereArgs: [id],
    );
    return result.isNotEmpty ? result.first : null;
  }

  Future<List<Map<String, dynamic>>> searchProfessores(String query) async {
    final db = await database;
    final result = await db.rawQuery(
        'SELECT * FROM professores WHERE id LIKE ? OR nome LIKE ?',
        ['%$query%', '%$query%']);
    return result;
  }

  Future<int> countProfessores() async {
    final db = await database;
    final result =
        await db.rawQuery('SELECT COUNT(*) as count FROM professores');
    return Sqflite.firstIntValue(result) ?? 0;
  }

  Future<int> countProfessoresAtivos() async {
    final db = await database;
    final result = await db.rawQuery(
        'SELECT COUNT(*) as count FROM professores WHERE status = ?',
        ['Ativo']);
    return Sqflite.firstIntValue(result) ?? 0;
  }

  Future<int> countProfessoresInativos() async {
    final db = await database;
    final result = await db.rawQuery(
        'SELECT COUNT(*) as count FROM professores WHERE status = ?',
        ['Inativo']);
    return Sqflite.firstIntValue(result) ?? 0;
  }

  // registrar frequência
  Future<void> registrarFrequencia(int alunoId, bool presente) async {
    final db = await database;
    await db.insert('frequencia', {
      'aluno_id': alunoId,
      'data': DateTime.now().toIso8601String(),
      'presente': presente ? 1 : 0,
    });
  }

  // listar a frequência de um determinado dia
  Future<List<Map<String, dynamic>>> obterFrequenciaPorDia(String data) async {
    final db = await database;
    return await db.query('frequencia', where: 'data = ?', whereArgs: [data]);
  }

// buscar a frequência de um aluno específico
  Future<Map<String, dynamic>?> obterFrequenciaPorAluno(
      int alunoId, String data) async {
    final db = await database;
    final List<Map<String, dynamic>> result = await db.query(
      'frequencia',
      where: 'aluno_id = ? AND data = ?',
      whereArgs: [alunoId, data],
    );
    return result.isNotEmpty ? result.first : null;
  }

  // Atualização de presença
  Future<void> atualizarFrequencia(
      int alunoId, String data, bool presente) async {
    final db = await database;
    await db.update(
      'frequencia',
      {'presente': presente ? 1 : 0},
      where: 'aluno_id = ? AND data = ?',
      whereArgs: [alunoId, data],
    );
  }

  // frequencia por data
  Future<List<Map<String, dynamic>>> getFrequenciaPorData(String data) async {
    final db = await database;
    final result = await db.rawQuery('''
    SELECT frequencia.aluno_id, alunos.nome, frequencia.presente
    FROM frequencia
    JOIN alunos ON frequencia.aluno_id = alunos.id 
    WHERE DATE(frequencia.data) = ?
  ''', [data]);
    return result;
  }

  Future<void> deleteFrequencia(int alunoId) async {
    final db = await database;
    await db.delete(
      'frequencia',
      where: 'aluno_id = ?',
      whereArgs: [alunoId],
    );
  }

  // Eventos
  Future<void> insertEventos(Map<String, dynamic> faixa) async {
    final db = await database;
    await db.insert('eventos', faixa);
  }

  Future<void> updateEventos(int id, Map<String, dynamic> aluno) async {
    final db = await database;
    await db.update('eventos', aluno, where: 'id = ?', whereArgs: [id]);
  }

  Future<void> deleteEventos(int id) async {
    final db = await database;
    await db.transaction((txn) async {
      await txn.delete('eventos', where: 'id = ?', whereArgs: [id]);
    });
  }

  Future<List<Map<String, dynamic>>> getEventos() async {
    final db = await database;
    return await db.query('eventos');
  }

  Future<Map<String, dynamic>?> getEventosById(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> result = await db.query(
      'eventos',
      where: 'id = ?',
      whereArgs: [id],
    );
    return result.isNotEmpty ? result.first : null;
  }

  Future<List<Map<String, dynamic>>> searchEventos(String query) async {
    final db = await database;
    final result = await db.rawQuery(
        'SELECT * FROM faixas WHERE id LIKE ? OR descricao LIKE ?',
        ['%$query%', '%$query%']);
    return result;
  }

  Future<List<Map<String, dynamic>>> getHistoricoFormacaoFiltrado(
      int alunoId, DateTime startDate, DateTime endDate) async {
    final db = await database;
    String start = startDate.toIso8601String();
    String end = endDate.toIso8601String();

    return await db.rawQuery('''
    SELECT faixas.descricao AS faixa, formacao_aluno.data_mudanca
    FROM formacao_aluno
    JOIN faixas ON formacao_aluno.faixa_id = faixas.id
    WHERE formacao_aluno.aluno_id = ? AND formacao_aluno.data_mudanca BETWEEN ? AND ?
    ORDER BY formacao_aluno.data_mudanca DESC
  ''', [alunoId, start, end]);
  }

  Future<List<Map<String, dynamic>>> getFormacaoByAlunoId(int alunoId) async {
    final db = await database;
    return await db
        .query('formacao_aluno', where: 'aluno_id = ?', whereArgs: [alunoId]);
  }

  Future<void> addFormacao(int alunoId, int faixaId) async {
    final db = await database;
    await db.insert('formacao_aluno', {
      'aluno_id': alunoId,
      'faixa_id': faixaId,
      'data_mudanca': DateTime.now().toIso8601String(),
    });
  }
}
