// ignore_for_file: use_build_context_synchronously, deprecated_member_use, depend_on_referenced_packages

import 'dart:io';

import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:register_student/pages/alunos.dart';
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
import 'package:register_student/util/view_pdf.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class CadastrarAluno extends StatefulWidget {
  final int? alunoId;
  final bool showButton;

  const CadastrarAluno({
    Key? key,
    this.alunoId,
    this.showButton = true,
  }) : super(key: key);

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
  final TextEditingController _dataInscricaoController =
      TextEditingController();
  final TextEditingController _dataInativoController = TextEditingController();
  String? tipoTurno = '';
  String? tipoTurnoTreino = '';
  int? tipoFaixa;
  String? tipoParentesco = '';
  String? tipoParentesco2 = '';

  final _formKey = GlobalKey<FormState>();

  List<Map<String, dynamic>> faixas = [];
  bool isMaiorDeIdade = false;
  bool isConcluido = false;

  @override
  void initState() {
    super.initState();
    if (widget.alunoId != null) {
      _loadAluno(widget.alunoId!);
    }
    dbHelper.fetchFaixas().then(
      (data) {
        setState(
          () {
            faixas = data;
          },
        );
      },
    );
    _loadSwitchState();
    _loadConcluido();
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
    tipoFaixa = aluno['faixa_id'];
    tipoParentesco = aluno['grau'];
    tipoParentesco2 = aluno['grau2'];

    // Data cadastro
    String dataIso = aluno['data_cadastro'];
    if (dataIso.isNotEmpty) {
      DateTime dataCadastro = DateTime.parse(dataIso);
      String dataFormatada = DateFormat('dd/MM/yyyy').format(dataCadastro);
      _dataInscricaoController.text = dataFormatada;
    } else {
      _dataInscricaoController.text = '';
    }

    // Data
    String dataInativoIso = aluno['data_inativo'];
    if (dataInativoIso.isNotEmpty) {
      DateTime dataInativo = DateTime.parse(dataInativoIso);
      String dataInativoFormatada =
          DateFormat('dd/MM/yyyy').format(dataInativo);
      _dataInativoController.text = dataInativoFormatada;
    } else {
      _dataInativoController.text = ''; // Limpa caso o aluno esteja ativo
    }

    setState(() {});
    print(_populateFields);
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
          'faixa_id': tipoFaixa,
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
            builder: (context) => WillPopScope(
              onWillPop: () async {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const HomePage(),
                  ),
                );
                return false;
              },
              child: const AlunosScreen(),
            ),
          ),
        );
      }
    } catch (error) {
      ScaffoldMessenger(
        child: Text("$error"),
      );
    }
  }

  void _onStatusChanged(String? newValue) {
    setState(() {
      tipoStatus = newValue;

      if (tipoStatus == 'Inativo') {
        // Salva a data atual como data de inatividade
        String dataAtual = DateFormat('yyyy-MM-dd').format(DateTime.now());
        _dataInativoController.text =
            DateFormat('dd/MM/yyyy').format(DateTime.now());

        // Atualiza no banco de dados passando um Map
        dbHelper.updateAluno(
            widget.alunoId!, {'status': tipoStatus, 'data_inativo': dataAtual});
      } else if (tipoStatus == 'Ativo') {
        // Limpa a data de inatividade
        _dataInativoController.clear();

        // Atualiza no banco de dados com a data de inatividade como null
        dbHelper.updateAluno(
            widget.alunoId!, {'status': tipoStatus, 'data_inativo': null});
      }
    });
  }

  String? getFaixaDescricao(int? faixaId, List<Map<String, dynamic>> faixas) {
    if (faixaId == null) return null;

    for (var faixa in faixas) {
      if (faixa['id'] == faixaId) {
        String descricao = faixa['descricao'];
        return descricao[0].toUpperCase() + descricao.substring(1);
      }
    }

    return null;
  }

  Future<void> _loadSwitchState() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      isMaiorDeIdade = prefs.getBool('isMaiorDeIdade') ?? false;
    });
  }

  Future<void> _saveSwitchState() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('isMaiorDeIdade', isMaiorDeIdade);
  }

  Future<void> _loadConcluido() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      isConcluido = prefs.getBool('isConcluido') ?? false;
    });
  }

  Future<void> _saveConcluido() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('isConcluido', isConcluido);
  }

  void _displayPdf() async {
    await initializeDateFormatting('pt_BR', null);
    final doc = pw.Document();
    final imageBytes = File('assets/image/logoacademia.jpg').readAsBytesSync();
    final image = pw.MemoryImage(imageBytes);
    final String dataAtual =
        DateFormat("d 'de' MMMM 'de' y", 'pt_BR').format(DateTime.now());

    doc.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
            children: [
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text(
                    dataAtual,
                    style: pw.TextStyle(
                      fontSize: 9,
                      fontWeight: pw.FontWeight.normal,
                    ),
                  ),
                  pw.Text(
                    'FICHA CADASTRAL',
                    textAlign: pw.TextAlign.center,
                    style: pw.TextStyle(
                      fontSize: 20,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.SizedBox(
                    width: 100,
                    child: pw.Container(
                      width: 80,
                      height: 80,
                      child: pw.Image(image),
                    ),
                  ),
                ],
              ),
              pw.SizedBox(height: 20),
              _buildSectionTitle('DADOS DO PROFESSOR'),
              _buildLabeledField('Nome do Aluno: ', _nomeController.text),
              _buildLabeledField('CPF: ', _cpfController.text),
              _buildLabeledField('RG: ', _rgController.text),
              _buildLabeledField(
                  'Data Nascimento: ', _dtnascimentoController.text),
              _buildLabeledField('Sexo: ', _sexoController.text),
              _buildLabeledField('PDC: ', tipoValue!),
              pw.SizedBox(height: 10),
              _buildSectionTitle('ENDEREÇO'),
              _buildLabeledField('CEP: ', _cepController.text),
              _buildLabeledField('Município: ', _municipioController.text),
              _buildLabeledField('Bairro: ', _bairroController.text),
              _buildLabeledField('Endereço: ', _enderecoController.text),
              pw.SizedBox(height: 10),
              _buildSectionTitle('STATUS TREINO'),
              _buildLabeledField(
                  'Faixa: ', getFaixaDescricao(tipoFaixa, faixas) ?? 'vazio'),
              _buildLabeledField('Situação: ', tipoStatus!),
              _buildLabeledField('Turno Treino: ', tipoTurnoTreino!),
              pw.SizedBox(height: 10),
              if (!isMaiorDeIdade) ...[
                _buildSectionTitle('RESPONSÁVEL'),
                _buildLabeledField('Responsável 1: ', tipoParentesco!),
                _buildLabeledField(
                    'Telefone Responsável: ', _telresponsavelController.text),
                _buildLabeledField('Grau Parentesco: ', tipoParentesco!),
                pw.SizedBox(height: 5),
                _buildLabeledField('Responsável 2: ', tipoParentesco2!),
                _buildLabeledField(
                    'Telefone Responsável: ', _telresponsavel2Controller.text),
                _buildLabeledField('Grau Parentesco: ', tipoParentesco2!),
              ],
              pw.SizedBox(height: 10),
              if (!isConcluido) ...[
                _buildSectionTitle('DADOS ESCOLAR'),
                _buildLabeledField('Escola: ', _escolaController.text),
                _buildLabeledField('Endereço: ', _endescolaController.text),
                _buildLabeledField('Turno: ', tipoTurno!),
              ]
            ],
          );
        },
      ),
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PreviewScreen(
          doc: doc,
          pdfFileName: "${_nomeController.text}.pdf",
          titulo: "Visualizar Ficha Cadastral",
        ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Confirmação',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF000000),
            ),
          ),
          content: const Text('Deseja realmente cancelar?'),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (context) => const HomePage(),
                  ),
                  (route) => false,
                );
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(13),
                ),
                elevation: 3,
                backgroundColor: const Color(0xFFda2828),
              ),
              child: Text(
                'Sim',
                style: GoogleFonts.poppins(color: const Color(0xFFFFFFFF)),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(13),
                ),
                elevation: 3,
                backgroundColor: const Color(0xFF008000),
              ),
              child: Text(
                'Não',
                style: GoogleFonts.poppins(color: const Color(0xFFFFFFFF)),
              ),
            ),
          ],
        );
      },
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
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF000000),
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
                        selectedFaixaId: tipoFaixa,
                        faixas: faixas,
                        onChanged: (newFaixaId) async {
                          setState(() {
                            tipoFaixa = newFaixaId;
                          });
                          if (widget.alunoId != null) {
                            await dbHelper.addFormacao(
                                widget.alunoId!, newFaixaId!);
                          }
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
                            onChanged: _onStatusChanged,
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 200,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 15),
                        child: TextFormField(
                          decoration: textFormField("Data Inscrição"),
                          keyboardType: TextInputType.number,
                          controller: _dataInscricaoController,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            TelefoneInputFormatter(),
                          ],
                          readOnly: true,
                        ),
                      ),
                    ),
                    if (tipoStatus == 'Inativo')
                      SizedBox(
                        width: 200,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 15),
                          child: TextFormField(
                            decoration: textFormField("Data Inativo"),
                            keyboardType: TextInputType.number,
                            controller: _dataInativoController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Campo obrigatório.";
                              }
                              return null;
                            },
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              TelefoneInputFormatter(),
                            ],
                            readOnly: true,
                          ),
                        ),
                      ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Maior de idade?",
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Switch(
                      value: isMaiorDeIdade,
                      activeColor: const Color(0xFF1d1e2b),
                      onChanged: (value) {
                        setState(() {
                          isMaiorDeIdade = value;
                          _saveSwitchState();
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                if (!isMaiorDeIdade)
                  Row(
                    children: [
                      Text(
                        "Responsável",
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                const SizedBox(height: 10),
                if (!isMaiorDeIdade)
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
                              if (!isMaiorDeIdade) {
                                if (value == null || value.isEmpty) {
                                  return "Campo obrigatório.";
                                }
                                return null;
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
                            decoration:
                                textFormField("Telefone do Responsável"),
                            keyboardType: TextInputType.number,
                            controller: _telresponsavelController,
                            validator: (value) {
                              if (!isMaiorDeIdade) {
                                if (value == null || value.isEmpty) {
                                  return "Campo obrigatório.";
                                }
                                return null;
                              }
                              return null;
                            },
                            inputFormatters: [
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
                if (!isMaiorDeIdade)
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
                              if (!isMaiorDeIdade) {
                                if (value == null || value.isEmpty) {
                                  return "Campo obrigatório.";
                                }
                                return null;
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
                            decoration:
                                textFormField("Telefone do Responsável"),
                            keyboardType: TextInputType.number,
                            controller: _telresponsavel2Controller,
                            validator: (value) {
                              if (!isMaiorDeIdade) {
                                if (value == null || value.isEmpty) {
                                  return "Campo obrigatório.";
                                }
                                return null;
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Concluído?",
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Switch(
                      value: isConcluido,
                      activeColor: const Color(0xFF1d1e2b),
                      onChanged: (value) {
                        setState(
                          () {
                            isConcluido = value;
                            _saveConcluido();
                          },
                        );
                      },
                    ),
                  ],
                ),
                if (!isConcluido)
                  Row(
                    children: [
                      Text(
                        "Dados Escolar",
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                const SizedBox(height: 10),
                if (!isConcluido)
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
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    if (widget.showButton)
                      SizedBox(
                        height: 50,
                        width: 205,
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
                                _displayPdf();
                              }
                            },
                            child: Center(
                              child: Text(
                                'Ficha Cadastral',
                                style: GoogleFonts.poppins(
                                  fontSize: 19,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    const Spacer(),
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
                          child: Center(
                            child: Text(
                              'Salvar',
                              style: GoogleFonts.poppins(
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
                            if (widget.alunoId == null) {
                              _showDeleteDialog(context);
                            } else {
                              Navigator.of(context).pop();
                            }
                          },
                          child: Center(
                            child: Text(
                              'Cancelar',
                              style: GoogleFonts.poppins(
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

pw.Widget _buildSectionTitle(String title) {
  return pw.Padding(
    padding: const pw.EdgeInsets.symmetric(vertical: 5),
    child: pw.Container(
      color: PdfColor.fromHex('eaf1f8'),
      width: double.infinity,
      child: pw.Center(
        child: pw.Text(
          title,
          textAlign: pw.TextAlign.center,
          style: pw.TextStyle(
            fontWeight: pw.FontWeight.bold,
            fontSize: 14,
          ),
        ),
      ),
    ),
  );
}

pw.Widget _buildLabeledField(String label, String value) {
  return pw.Row(
    children: [
      pw.Text(
        label,
        style: pw.TextStyle(
          fontWeight: pw.FontWeight.bold,
        ),
      ),
      pw.Text(
        value.isNotEmpty ? value : '',
      ),
    ],
  );
}
