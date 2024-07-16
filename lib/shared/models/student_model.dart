class Student {
  int? id;
  String nome;
  String cpf;
  String rg;
  String dtnascimento;
  String pcd;
  String sexo;
  String status;
  String bairro;
  String endereco;
  String municipio;
  String responsavel;
  String telefone;
  String telresponsavel;
  String cep;
  String escola;
  String endescola;
  String turnoescolar;

  Student({
    this.id,
    required this.nome,
    required this.cpf,
    required this.rg,
    required this.dtnascimento,
    required this.pcd,
    required this.sexo,
    required this.status,
    required this.bairro,
    required this.endereco,
    required this.municipio,
    required this.responsavel,
    required this.telefone,
    required this.telresponsavel,
    required this.cep,
    required this.escola,
    required this.endescola,
    required this.turnoescolar,
  });

  factory Student.fromSQLite(Map map) {
    return Student(
      id: map['id'],
      nome: map['nome'],
      cpf: map['cpf'],
      rg: map['rg'],
      dtnascimento: map['dtnascimento'],
      pcd: map['pcd'],
      sexo: map['sexo'],
      status: map['status'],
      bairro: map['bairro'],
      endereco: map['endereco'],
      municipio: map['municipio'],
      responsavel: map['responsavel'],
      telefone: map['telefone'],
      telresponsavel: map['telresponsavel'],
      cep: map['cep'],
      escola: map['escola'],
      endescola: map['endescola'],
      turnoescolar: map['turnoescolar'],
    );
  }

  static List<Student> fromSQLiteList(List<Map> listMap) {
    List<Student> student = [];
    for (Map item in listMap) {
      student.add(Student.fromSQLite(item));
    }
    return student;
  }

  factory Student.empty() {
    return Student(
        nome: '',
        cpf: '',
        rg: '',
        dtnascimento: '',
        pcd: '',
        sexo: '',
        status: '',
        bairro: '',
        endereco: '',
        municipio: '',
        responsavel: '',
        telefone: '',
        telresponsavel: '',
        cep: '',
        escola: '',
        endescola: '',
        turnoescolar: '');
  }
}
