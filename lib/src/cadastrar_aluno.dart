// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:register_student/register/home_page.dart';
import 'package:register_student/services/db_helper.dart';
import 'package:register_student/util/form.dart';

class CadastrarAluno extends StatefulWidget {
  final int? alunoId; // Alterado para int? para aceitar o ID do aluno

  const CadastrarAluno({Key? key, this.alunoId}) : super(key: key);

  @override
  State<CadastrarAluno> createState() => _CadastrarAlunoState();
}

class _CadastrarAlunoState extends State<CadastrarAluno> {
  final DBHelper dbHelper = DBHelper();
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _cpfController = TextEditingController();
  final TextEditingController _rgController = TextEditingController();
  final TextEditingController _dtnascimentoController = TextEditingController();
  final TextEditingController _pcdController = TextEditingController();
  final TextEditingController _sexoController = TextEditingController();
  final TextEditingController _statusController = TextEditingController();
  final TextEditingController _bairroController = TextEditingController();
  final TextEditingController _enderecoController = TextEditingController();
  final TextEditingController _municipioController = TextEditingController();
  final TextEditingController _responsavelController = TextEditingController();
  final TextEditingController _telefoneController = TextEditingController();
  final TextEditingController _telresponsavelController =
      TextEditingController();
  final TextEditingController _cepController = TextEditingController();
  final TextEditingController _escolaController = TextEditingController();
  final TextEditingController _endescolaController = TextEditingController();
  final TextEditingController _turnoescolarController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    if (widget.alunoId != null) {
      _loadAluno(widget.alunoId!);
    }
  }

  void _populateFields(Map<String, dynamic> aluno) {
    _nomeController.text = aluno['nome'];
    _cpfController.text = aluno['cpf'];
    _rgController.text = aluno['rg'];
    _dtnascimentoController.text = aluno['dtnascimento'];
    _pcdController.text = aluno['pcd'];
    _sexoController.text = aluno['sexo'];
    _statusController.text = aluno['status'];
    _bairroController.text = aluno['bairro'];
    _enderecoController.text = aluno['endereco'];
    _municipioController.text = aluno['municipio'];
    _responsavelController.text = aluno['responsavel'];
    _telefoneController.text = aluno['telefone'];
    _telresponsavelController.text = aluno['telresponsavel'];
    _cepController.text = aluno['cep'];
    _escolaController.text = aluno['escola'];
    _endescolaController.text = aluno['endescola'];
    _turnoescolarController.text = aluno['turnoescolar'];
  }

  void _loadAluno(int id) async {
    final aluno = await dbHelper.getAlunoById(id);
    if (aluno != null) {
      _populateFields(aluno);
    }
  }

  void _saveItem() async {
    if (_formKey.currentState!.validate()) {
      final aluno = {
        'nome': _nomeController.text,
        'cpf': _cpfController.text,
        'rg': _rgController.text,
        'dtnascimento': _dtnascimentoController.text,
        'pcd': _pcdController.text,
        'sexo': _sexoController.text,
        'status': _statusController.text,
        'bairro': _bairroController.text,
        'endereco': _enderecoController.text,
        'municipio': _municipioController.text,
        'responsavel': _responsavelController.text,
        'telefone': _telefoneController.text,
        'telresponsavel': _telresponsavelController.text,
        'cep': _cepController.text,
        'escola': _escolaController.text,
        'endescola': _endescolaController.text,
        'turnoescolar': _turnoescolarController.text
      };

      if (widget.alunoId != null) {
        // Atualizar aluno existente
        await dbHelper.updateAluno(widget.alunoId!, aluno);
      } else {
        // Adicionar novo aluno
        await dbHelper.insertAluno(aluno);
      }

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const HomePage(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (context) => const HomePage(),
              ),
              (route) => false,
            );
          },
          iconSize: 20,
          icon: const Icon(Icons.arrow_back_ios),
          color: const Color(0xFF1F41BB),
        ),
        title: Text(
          widget.alunoId != null ? 'Atualizar Aluno' : 'Cadastrar Aluno',
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Color(0xFF404046),
          ),
        ),
        centerTitle: true,
        toolbarHeight: 60,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 5),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: TextFormField(
                    decoration: textFormField("Nome"),
                    controller: _nomeController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Campo obrigatório.";
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: TextFormField(
                    decoration: textFormField("CPF"),
                    controller: _cpfController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Campo obrigatório.";
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: TextFormField(
                    decoration: textFormField("RG"),
                    controller: _rgController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Campo obrigatório.";
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: TextFormField(
                    decoration: textFormField("Data de Nascimento"),
                    controller: _dtnascimentoController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Campo obrigatório.";
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: TextFormField(
                    decoration: textFormField("PCD"),
                    controller: _pcdController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Campo obrigatório.";
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: TextFormField(
                    decoration: textFormField("Sexo"),
                    controller: _sexoController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Campo obrigatório.";
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: TextFormField(
                    decoration: textFormField("Status"),
                    controller: _statusController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Campo obrigatório.";
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: TextFormField(
                    decoration: textFormField("Bairro"),
                    controller: _bairroController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Campo obrigatório.";
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: TextFormField(
                    decoration: textFormField("Endereço"),
                    controller: _enderecoController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Campo obrigatório.";
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: TextFormField(
                    decoration: textFormField("Município"),
                    controller: _municipioController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Campo obrigatório.";
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: TextFormField(
                    decoration: textFormField("Responsável"),
                    controller: _responsavelController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Campo obrigatório.";
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: TextFormField(
                    decoration: textFormField("Telefone"),
                    controller: _telefoneController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Campo obrigatório.";
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: TextFormField(
                    decoration: textFormField("Telefone do Responsável"),
                    controller: _telresponsavelController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Campo obrigatório.";
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: TextFormField(
                    decoration: textFormField("CEP"),
                    controller: _cepController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Campo obrigatório.";
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: TextFormField(
                    decoration: textFormField("Escola"),
                    controller: _escolaController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Campo obrigatório.";
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: TextFormField(
                    decoration: textFormField("Endereço da Escola"),
                    controller: _endescolaController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Campo obrigatório.";
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: TextFormField(
                    decoration: textFormField("Turno Escolar"),
                    controller: _turnoescolarController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Campo obrigatório.";
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: 50,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(11),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF1F41BB).withOpacity(0.2),
                          spreadRadius: 0,
                          blurRadius: 4,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF262c40),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(11),
                        ),
                      ),
                      onPressed: _saveItem,
                      child: const Center(
                        child: Text(
                          'Salvar',
                          style: TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 50),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
