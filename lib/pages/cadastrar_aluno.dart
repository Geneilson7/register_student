// ignore_for_file: use_build_context_synchronously, deprecated_member_use

import 'dart:io';

import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:register_student/pages/home_page.dart';
import 'package:register_student/services/db_helper.dart';
import 'package:register_student/src/dropdown_faixa.dart';
import 'package:register_student/src/dropdown_pcd.dart';
import 'package:register_student/src/dropdown_status.dart';
import 'package:register_student/src/dropdown_turno_escolar.dart';
import 'package:register_student/src/dropdown_turno_treino.dart';
import 'package:register_student/util/form.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:register_student/util/view_pdf.dart';

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
  String? tipoValue = '';
  final TextEditingController _sexoController = TextEditingController();
  String? tipoStatus = '';
  final TextEditingController _bairroController = TextEditingController();
  final TextEditingController _enderecoController = TextEditingController();
  final TextEditingController _municipioController = TextEditingController();
  final TextEditingController _responsavelController = TextEditingController();
  final TextEditingController _responsavel2Controller = TextEditingController();
  final TextEditingController _telefoneController = TextEditingController();
  final TextEditingController _telresponsavelController =
      TextEditingController();
  final TextEditingController _telresponsavel2Controller =
      TextEditingController();
  final TextEditingController _cepController = TextEditingController();
  final TextEditingController _escolaController = TextEditingController();
  final TextEditingController _endescolaController = TextEditingController();
  String? tipoTurno = '';
  String? tipoTurnoTreino = '';
  String? tipoFaixa = '';
  String? tipoParentesco = '';
  String? tipoParentesco2 = '';

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
    tipoStatus = aluno['status'];
    _bairroController.text = aluno['bairro'];
    _enderecoController.text = aluno['endereco'];
    _municipioController.text = aluno['municipio'];
    _responsavelController.text = aluno['responsavel'];
    _responsavel2Controller.text = aluno['responsavel2'];
    _telefoneController.text = aluno['telefone'];
    _telresponsavelController.text = aluno['telresponsavel'];
    _telresponsavel2Controller.text = aluno['telresponsavel2'];
    _cepController.text = aluno['cep'];
    _escolaController.text = aluno['escola'];
    _endescolaController.text = aluno['endescola'];
    tipoTurno = aluno['turnoescolar'];
    tipoTurnoTreino = aluno['turnotreino'];
    tipoFaixa = aluno['faixa'];
    tipoParentesco = aluno['grau'];
    tipoParentesco2 = aluno['grau2'];
    setState(() {});
  }

  void _loadAluno(int id) async {
    final aluno = await dbHelper.getAlunoById(id);
    if (aluno != null) {
      _populateFields(aluno);
    }
  }

  void _saveItem() async {
    try {
      if (_formKey.currentState!.validate()) {
        final aluno = {
          'nome': _nomeController.text,
          'cpf': _cpfController.text,
          'rg': _rgController.text,
          'dtnascimento': _dtnascimentoController.text,
          'pcd': tipoValue,
          'sexo': _sexoController.text,
          'status': tipoStatus,
          'bairro': _bairroController.text,
          'endereco': _enderecoController.text,
          'municipio': _municipioController.text,
          'responsavel': _responsavelController.text,
          'responsavel2': _responsavel2Controller.text,
          'telefone': _telefoneController.text,
          'telresponsavel': _telresponsavelController.text,
          'telresponsavel2': _telresponsavel2Controller.text,
          'cep': _cepController.text,
          'escola': _escolaController.text,
          'endescola': _endescolaController.text,
          'turnoescolar': tipoTurno,
          'turnotreino': tipoTurnoTreino,
          'faixa': tipoFaixa,
          'grau': tipoParentesco,
          'grau2': tipoParentesco2,
        };

        if (widget.alunoId != null) {
          await dbHelper.updateAluno(widget.alunoId!, aluno);
        } else {
          await dbHelper.insertAluno(aluno);
        }

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const HomePage(),
          ),
        );
      }
    } catch (error) {
      ScaffoldMessenger(
        child: Text("$error"),
      );
    }
  }

  Future<void> _generateAndPreviewPDF() async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Título Principal
              pw.Center(
                child: pw.Text(
                  'FICHA CADASTRAL',
                  style: pw.TextStyle(
                      fontSize: 18, fontWeight: pw.FontWeight.bold),
                ),
              ),
              pw.SizedBox(height: 20),

              // Seção: Dados do Proprietário
              pw.Text(
                'DADOS DO ALUNO:',
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              ),
              pw.SizedBox(height: 5),
              pw.Text('Aluno: ${_nomeController.text}'),
              pw.Text('CPF: ${_cpfController.text}'),
              pw.Text('RG: ${_sexoController.text}'),
              pw.Text('Data nascimento: ${_dtnascimentoController.text}'),
              pw.Text('PDC: $tipoValue'),

              pw.SizedBox(height: 15),

              pw.Text(
                'ENDEREÇO:',
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              ),
              pw.SizedBox(height: 5),
              pw.Text('Município: ${_municipioController.text}'),
              pw.Text('CEP: ${_cepController.text}'),
              pw.Text('Bairro: ${_enderecoController.text}'),
              pw.Text('Endereço: ${_enderecoController.text}}'),

              pw.SizedBox(height: 15),

              pw.Text(
                'STATUS TREINO:',
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              ),
              pw.SizedBox(height: 5),
              pw.Text('Faixa: $tipoFaixa'),
              pw.Text('Status: $tipoStatus'),
              pw.Text('Turno Treino: $tipoTurnoTreino'),
              pw.SizedBox(height: 15),

              pw.Text(
                'RESPONSÁVEL:',
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              ),
              pw.SizedBox(height: 5),
              pw.Text('Responsável 1: $tipoParentesco'),
              pw.Text(
                  'Telefone Responsável: ${_telresponsavelController.text}'),
              pw.Text('Grau Parentesco: $tipoParentesco'),
              pw.SizedBox(height: 5),
              pw.Text('Responsável 2: $tipoParentesco2'),
              pw.Text(
                  'Telefone Responsável: ${_telresponsavel2Controller.text}'),
              pw.Text('Grau Parentesco: $tipoParentesco2'),

              pw.SizedBox(height: 15),

              pw.Text(
                'DADOS ESCOLAR:',
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              ),
              pw.SizedBox(height: 5),
              pw.Text('Escola: ${_escolaController.text}'),
              pw.Text('Endereço: ${_endescolaController.text}'),
              pw.Text('Turno: $tipoTurno'),
            ],
          );
        },
      ),
    );

    // final dir = await getApplicationDocumentsDirectory();
    // final String path =
    //     '${dir.path}/$_nomeController.pdf'; // Nome do arquivo PDF
    // final File file = File(path);

    // // Salvar o PDF localmente
    // await file.writeAsBytes(await pdf.save());

    // Sanitizar o nome do arquivo para evitar erros no sistema de arquivos
    // Salvando o PDF em um arquivo temporário
    String sanitizedFileName = _nomeController.text
        .replaceAll(RegExp(r'[^\w\s]+'), ''); // Remove caracteres especiais
    final dir = await getApplicationDocumentsDirectory();
    final String path = '${dir.path}/$sanitizedFileName.pdf';
    final File file = File(path);
    await file.writeAsBytes(await pdf.save());

    // Navegar para a tela de visualização do PDF
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => PDFViewerScreen(path),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFFFFF),
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text(
          widget.alunoId != null ? 'Atualizar Aluno' : 'Cadastrar Aluno',
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Color(0xFF000000),
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
                        selectedValue: tipoValue,
                        items: const ['Sim', 'Não'],
                        onChanged: (newValue) {
                          setState(() {
                            tipoValue = newValue!;
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
                    const SizedBox(width: 25),
                    Expanded(
                      flex: 1,
                      child: Faixa(
                        label: "Faixa",
                        selectedValue: tipoFaixa,
                        items: const [
                          'Branca',
                          'Amarela',
                          'Laraja',
                          'Verde',
                          'Azul',
                          'Roxa',
                          'Marrom',
                          'Preta',
                          'Coral',
                          'Vermelha',
                        ],
                        onChanged: (newValue) {
                          setState(() {
                            tipoFaixa = newValue!;
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 25),
                    Row(
                      children: [
                        SizedBox(
                          width: 200,
                          child: Status(
                            label: "Status",
                            selectedValue: tipoStatus,
                            items: const ['Ativo', 'Inativo', 'Concluído'],
                            onChanged: (newValue) {
                              setState(() {
                                tipoStatus = newValue!;
                              });
                            },
                          ),
                        ),
                        const SizedBox(width: 25),
                        SizedBox(
                          width: 200,
                          child: TurnoTreino(
                            label: "Turno Treino",
                            selectedValue: tipoTurnoTreino,
                            items: const ['Manhã', 'Tarde', 'Noite'],
                            onChanged: (newValue) {
                              setState(() {
                                tipoTurnoTreino = newValue!;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const Row(
                  children: [
                    Text(
                      "Responsável",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
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
                    const SizedBox(
                      width: 25,
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: 200,
                          child: Status(
                            label: "Grau Parentesco",
                            selectedValue: tipoParentesco,
                            items: const [
                              'Pai',
                              'Mãe',
                              'Tio (a)',
                              'Maior 18',
                            ],
                            onChanged: (newValue) {
                              setState(() {
                                tipoParentesco = newValue!;
                              });
                            },
                          ),
                        ),
                      ],
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
                          controller: _responsavel2Controller,
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
                          controller: _telresponsavel2Controller,
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
                    const SizedBox(
                      width: 25,
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: 200,
                          child: Status(
                            label: "Grau Parentesco",
                            selectedValue: tipoParentesco2,
                            items: const [
                              'Pai',
                              'Mãe',
                              'Tio (a)',
                              'Maior 18',
                            ],
                            onChanged: (newValue) {
                              setState(() {
                                tipoParentesco2 = newValue!;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const Row(
                  children: [
                    Text(
                      "Dados Escolar",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
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
                      child: Turno(
                        label: "Turno Escolar",
                        selectedValue: tipoTurno,
                        items: const ['Manhã', 'Tarde', 'Noite'],
                        onChanged: (newValue) {
                          setState(() {
                            tipoTurno = newValue!;
                          });
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
                            backgroundColor: const Color(0xFF1F41BB),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(11),
                            ),
                          ),
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              _generateAndPreviewPDF();
                            }
                          },
                          child: const Center(
                            child: Text(
                              'Imprimir',
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
                                        Navigator.of(context)
                                            .pushAndRemoveUntil(
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const HomePage(),
                                          ),
                                          (route) => false,
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
