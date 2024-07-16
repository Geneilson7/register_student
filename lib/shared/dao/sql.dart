import 'package:register_student/shared/models/student_model.dart';

class ConnectionSQL {
  static final CREATE_DATABASE = '''
  CREATE TABLE `student` (
    `id` INTEGER PRIMARY KEY AUTOINCREMENT,
    `nome` INTEGER,
    `cpf` INTEGER,
    `rg` INTEGER,
    `dtnascimento` INTEGER,
    `pcd` INTEGER,
    `sexo` INTEGER,
    `status` INTEGER,
    `endereco` INTEGER,
    `municipio` INTEGER,
    `responsavel` INTEGER,
    `telefone` INTEGER,
    `telresponsavel` INTEGER,
    `cep` INTEGER,
    `escola` INTEGER,
    `endescola` INTEGER,
    `turnoescolar` INTEGER,    
  );
  ''';

  static String selecionarTodosOsStudents() {
    return 'select * from student';
  }

  static String adicionarStudent(Student student) {
    return '''
      insert into student (nome, cpf, rg, dtnascimento, pcd, sexo, status, endereco, municipio, responsavel, telefone, telresponsavel, cep, escola, endescola, turnoescolar)
      values ('${student.nome}','${student.cpf}','${student.rg}','${student.dtnascimento}','${student.pcd}','${student.sexo}','${student.status}','${student.endereco}','${student.municipio}','${student.responsavel}','${student.telefone}','${student.telresponsavel}','${student.cep}','${student.escola}','${student.turnoescolar}');
    ''';
  }

  static String atulizarStudent(Student student){
    return '''
      update student
      set nome = '${student.nome}',
      cpf = '${student.cpf}',
      rg = '${student.rg}',
      dtnascimento = '${student.dtnascimento}',
      pcd = '${student.pcd}',
      sexo = '${student.sexo}',
      status = '${student.status}',
      endereco = '${student.endereco}',
      municipio = '${student.municipio}',
      responsavel = '${student.responsavel}',
      telefone = '${student.telefone}',
      telresponsavel = '${student.telresponsavel}',
      cep = '${student.cep}',
      escola = '${student.escola}',
      endescola = '${student.endescola}',
      turnoescolar = '${student.turnoescolar}',
      where id = '${student.id}';
      ''';
  }

  static String deleteStudent (Student student){
    return 'delete from student where id = ${student.id};';
  }
}
