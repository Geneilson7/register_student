// ignore_for_file: use_build_context_synchronously, deprecated_member_use

import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:register_student/pages/home_page.dart';
import 'package:register_student/services/db_helper.dart';
import 'package:register_student/src/dropdown_pcd.dart';
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
  // final TextEditingController _pcdController = TextEditingController();
  String? tipoValue = '';
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
    tipoValue = aluno['pcd'];
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
        'pcd': tipoValue,
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
                Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Padding(
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
                    ),
                    const SizedBox(width: 25),
                    Expanded(
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 15),
                        child: TextFormField(
                          decoration: textFormField("CPF"),
                          keyboardType: TextInputType.number,
                          controller: _cpfController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Campo obrigatório.";
                            }
                            return null;
                          },
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            CpfInputFormatter(),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 15),
                        child: TextFormField(
                          decoration: textFormField("RG"),
                          keyboardType: TextInputType.number,
                          controller: _rgController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Campo obrigatório.";
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                    const SizedBox(width: 25),
                    Expanded(
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 15),
                        child: TextFormField(
                          decoration: textFormField("Data de Nascimento"),
                          keyboardType: TextInputType.number,
                          controller: _dtnascimentoController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Campo obrigatório.";
                            }
                            return null;
                          },
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            DataInputFormatter(),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 25),
                    Expanded(
                      flex: 1,
                      child: Padding(
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
                    ),
                    const SizedBox(width: 25),
                    Expanded(
                      flex: 1,
                      child: Pcd(
                        label: "PCD",
                        selectedValue: tipoValue ?? '',
                        items: const ['Sim', 'Não'],
                        onChanged: (newValue) {
                          setState(() {
                            tipoValue = newValue;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 15),
                        child: TextFormField(
                          decoration: textFormField("CEP"),
                          controller: _cepController,
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Campo obrigatório.";
                            }
                            return null;
                          },
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            CepInputFormatter(),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 25),
                    Expanded(
                      flex: 1,
                      child: Padding(
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
                    ),
                    const SizedBox(width: 25),
                    Expanded(
                      flex: 1,
                      child: Padding(
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
                    ),
                    const SizedBox(width: 25),
                    Expanded(
                      flex: 1,
                      child: Padding(
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
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Padding(
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
                    ),
                    const SizedBox(width: 25),
                    Expanded(
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 15),
                        child: TextFormField(
                          decoration: textFormField("Telefone do Responsável"),
                          keyboardType: TextInputType.number,
                          controller: _telresponsavelController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Campo obrigatório.";
                            }
                            return null;
                          },
                          inputFormatters: [
                            // obrigatório
                            FilteringTextInputFormatter.digitsOnly,
                            TelefoneInputFormatter(),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 25),
                    Expanded(
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 15),
                        child: TextFormField(
                          decoration: textFormField("Telefone"),
                          keyboardType: TextInputType.number,
                          controller: _telefoneController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Campo obrigatório.";
                            }
                            return null;
                          },
                          inputFormatters: [
                            // obrigatório
                            FilteringTextInputFormatter.digitsOnly,
                            TelefoneInputFormatter(),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: Padding(
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
                    ),
                    const SizedBox(width: 25),
                    Expanded(
                      flex: 1,
                      child: Padding(
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
                    ),
                    const SizedBox(width: 25),
                    Expanded(
                      flex: 1,
                      child: Padding(
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
                    ),
                  ],
                ),
                Row(
                  children: [
                    SizedBox(
                      width: 150,
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
                  ],
                ),
                const SizedBox(height: 50),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SizedBox(
                      height: 50,
                      width: 150,
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
                    const SizedBox(width: 25),
                    SizedBox(
                      height: 50,
                      width: 150,
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
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(11),
                            ),
                          ),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (_) {
                                return AlertDialog(
                                  title: const Text(
                                    'Confirmação',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xFF000000),
                                    ),
                                  ),
                                  content: const Text(
                                      'Deseja realmente sair da página?'),
                                  actions: <Widget>[
                                    ElevatedButton(
                                      onPressed: () async {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => WillPopScope(
                                              onWillPop: () async {
                                                Navigator.pushReplacement(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        const HomePage(),
                                                  ),
                                                );
                                                return false;
                                              },
                                              child: const HomePage(),
                                            ),
                                          ),
                                        );
                                      },
                                      style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(13),
                                        ),
                                        elevation: 3,
                                        backgroundColor:
                                            const Color(0xFFda2828),
                                      ),
                                      child: const Text(
                                        'Sim',
                                        style: TextStyle(
                                          color: Color(0xFFFFFFFF),
                                        ),
                                      ),
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(13),
                                        ),
                                        elevation: 3,
                                        backgroundColor:
                                            const Color(0xFF008000),
                                      ),
                                      child: const Text(
                                        'Não',
                                        style: TextStyle(
                                          color: Color(0xFFFFFFFF),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          child: const Center(
                            child: Text(
                              'Cancelar',
                              style: TextStyle(
                                fontSize: 19,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
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