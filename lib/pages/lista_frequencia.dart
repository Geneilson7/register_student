// ignore_for_file: library_private_types_in_public_api, depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:register_student/services/db_helper.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:register_student/util/error_code.dart';
import 'package:register_student/util/view_pdf.dart';

class ListagemFrequenciaScreen extends StatefulWidget {
  const ListagemFrequenciaScreen({super.key});

  @override
  _ListagemFrequenciaScreenState createState() =>
      _ListagemFrequenciaScreenState();
}

class _ListagemFrequenciaScreenState extends State<ListagemFrequenciaScreen> {
  DateTime? dataSelecionada;
  List<Map<String, dynamic>> alunos = [];
  List<Map<String, dynamic>> turmas = [];
  List<Map<String, dynamic>> frequencias = [];
  bool isLoading = false;
  int? selectedTurmaId;

  @override
  void initState() {
    super.initState();
    dataSelecionada = DateTime.now();
    buscarTurmas();
    buscarFrequencia();
  }

  // Método para buscar turmas
  Future<void> buscarTurmas() async {
    final db = DBHelper();
    try {
      final result = await db.getTurmas();
      setState(() {
        turmas = result;
      });
    } catch (e) {
      print('Erro ao buscar turmas: $e');
    }
  }

  Future<void> buscarFrequencia() async {
    setState(() {
      isLoading = true;
    });

    final db = DBHelper();
    String data = DateFormat('yyyy-MM-dd').format(dataSelecionada!);
    try {
      final result = await db.getFrequenciaPorData(data);
      setState(() {
        frequencias = result;
      });
    } catch (e) {
      // Tratamento de erro
      print('Erro ao buscar frequência: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> carregarAlunosPorTurma(int turmaId) async {
    final db = DBHelper();
    try {
      // Consultar dados do backend
      final result = await db.getAlunosComFrequenciaPorTurma(
        turmaId,
        DateFormat('yyyy-MM-dd').format(dataSelecionada!),
      );

      // Verifica se encontrou alunos
      if (result.isEmpty) {
        print(
            'Nenhum aluno encontrado para a turma $turmaId na data $dataSelecionada');
      }

      // Atualiza a lista de alunos com ou sem resultados
      setState(() {
        alunos = result;
        buscarFrequencia();
      });

      print('Turma ID: $turmaId, Data: $dataSelecionada, Resultados: $result');
    } catch (e) {
      print('Erro ao carregar alunos: $e');
    }
  }

  Future<void> _selecionarData(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      locale: const Locale('pt', 'BR'),
      initialDate: dataSelecionada,
      firstDate: DateTime(2020),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != dataSelecionada) {
      setState(() {
        dataSelecionada = picked;
      });

      // Recarregar os alunos conforme a data e turma selecionada
      if (selectedTurmaId != null) {
        carregarAlunosPorTurma(selectedTurmaId!);
      }
    }
  }

  Future<void> _deletarFrequencia(int alunoId) async {
    final db = DBHelper();
    await db.deleteFrequencia(alunoId);
    buscarFrequencia();
  }

  Future<void> _gerarPdf() async {
    final pdf = pw.Document();
    final String dataFormatada =
        DateFormat('dd/MM/yyyy').format(dataSelecionada!);

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
            children: [
              pw.Text(
                'Relatório de Presença - $dataFormatada',
                style:
                    pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold),
                textAlign: pw.TextAlign.center,
              ),
              pw.SizedBox(height: 20),
              pw.Table(
                border: pw.TableBorder.all(color: PdfColors.black, width: 1),
                children: [
                  pw.TableRow(
                    children: [
                      pw.Padding(
                        padding: const pw.EdgeInsets.symmetric(
                            horizontal: 35, vertical: 8),
                        child: pw.Text('Nome do Aluno',
                            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                            textAlign: pw.TextAlign.center),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8.0),
                        child: pw.Text('Status',
                            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                            textAlign: pw.TextAlign.center),
                      ),
                    ],
                  ),
                  ...frequencias.map((freq) {
                    final nome = freq['nome'] ?? 'Desconhecido';
                    final presente = freq['presente'] ?? 0;
                    return pw.TableRow(
                      children: [
                        pw.Padding(
                            padding: const pw.EdgeInsets.all(8.0),
                            child: pw.Text(nome)),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8.0),
                          child: pw.Text(
                            presente == 1 ? 'Presente' : 'Faltou',
                            style: pw.TextStyle(
                                color: presente == 1
                                    ? PdfColors.green
                                    : PdfColors.red),
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ],
              ),
            ],
          );
        },
      ),
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PreviewScreen(
          doc: pdf,
          pdfFileName: 'Relatório de Presença - $dataFormatada.pdf',
          titulo: "Visualizar Lista de Presença",
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Listagem de Frequência",
                        style: GoogleFonts.poppins(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF000000)),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Frequência do dia: ${DateFormat('dd/MM/yyyy').format(dataSelecionada!)}',
                        style: GoogleFonts.poppins(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                        icon: const Icon(Icons.calendar_today),
                        onPressed: () => _selecionarData(context),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 250,
                  child: DropdownButtonFormField<int>(
                    hint: const Text("Selecione uma turma"),
                    value: selectedTurmaId,
                    items: turmas.map((turma) {
                      return DropdownMenuItem<int>(
                        value: turma[
                            'id'], // 'id' é o campo de identificação da turma
                        child: Text(turma['descricao']),
                      );
                    }).toList(),
                    onChanged: (turmaId) {
                      setState(() {
                        selectedTurmaId = turmaId;
                      });
                      if (selectedTurmaId != null && dataSelecionada != null) {
                        // Ao selecionar a turma, buscar alunos conforme a turma e data selecionada
                        carregarAlunosPorTurma(selectedTurmaId!);
                      }
                    },
                    decoration: InputDecoration(
                      label: const Text("Turma"),
                      fillColor: const Color(0xFFF1F4FF).withOpacity(0.9),
                      filled: true,
                      labelStyle: GoogleFonts.poppins(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                          color: const Color(0xFF626262)),
                      isDense: true,
                      border: OutlineInputBorder(
                        borderSide: const BorderSide(
                            color: Color(0xFF262c40), width: 2.0),
                        borderRadius: BorderRadius.circular(11),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                            color: Color(0xFF262c40), width: 2.0),
                        borderRadius: BorderRadius.circular(11),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                            color: Color(0xFF262c40), width: 2.0),
                        borderRadius: BorderRadius.circular(11),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: alunos.isEmpty
                        ? const ErrorPage(
                            label:
                                "Selecione uma turma ou verifique se há aluno cadastrado na turma.",
                          )
                        : ListView.builder(
                            itemCount: frequencias.length,
                            itemBuilder: (context, index) {
                              final freq = frequencias[index];
                              final alunoId = freq['id'] ?? '';
                              final nome = freq['nome'] ?? 'Desconhecido';
                              final presente = freq['presente'] ?? 0;

                              return Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(25),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 0,
                                      blurRadius: 5,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: Card(
                                  color: const Color(0xFFFFFFFF),
                                  elevation: 0,
                                  child: ListTile(
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 20),
                                    leading: Text(
                                      alunoId.toString(),
                                      style: GoogleFonts.poppins(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: const Color(0xff000000),
                                      ),
                                    ),
                                    title: Text(
                                      nome,
                                      style: GoogleFonts.poppins(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    trailing: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          presente == 1
                                              ? Icons.check_circle
                                              : Icons.cancel,
                                          color: presente == 1
                                              ? Colors.green
                                              : Colors.red,
                                          size: 30,
                                        ),
                                        const SizedBox(width: 10),
                                        IconButton(
                                            icon: const Icon(Icons.delete,
                                                color: Colors.red, size: 30),
                                            onPressed: () {
                                              showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return AlertDialog(
                                                    title: Text(
                                                      'Confirmação',
                                                      style:
                                                          GoogleFonts.poppins(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: const Color(
                                                            0xFF000000),
                                                      ),
                                                    ),
                                                    content: const Text(
                                                        'Deseja realmente cancelar?'),
                                                    actions: [
                                                      ElevatedButton(
                                                        onPressed: () {
                                                          _deletarFrequencia(
                                                              alunoId);
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                        style: ElevatedButton
                                                            .styleFrom(
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        13),
                                                          ),
                                                          elevation: 3,
                                                          backgroundColor:
                                                              const Color(
                                                                  0xFFda2828),
                                                        ),
                                                        child: Text(
                                                          'Sim',
                                                          style: GoogleFonts.poppins(
                                                              color: const Color(
                                                                  0xFFFFFFFF)),
                                                        ),
                                                      ),
                                                      ElevatedButton(
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                        style: ElevatedButton
                                                            .styleFrom(
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        13),
                                                          ),
                                                          elevation: 3,
                                                          backgroundColor:
                                                              const Color(
                                                                  0xFF008000),
                                                        ),
                                                        child: Text(
                                                          'Não',
                                                          style: GoogleFonts.poppins(
                                                              color: const Color(
                                                                  0xFFFFFFFF)),
                                                        ),
                                                      ),
                                                    ],
                                                  );
                                                },
                                              );
                                            }),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF1d1e2b),
        foregroundColor: const Color(0xFFFFFFFF),
        onPressed: _gerarPdf,
        child: const Icon(Icons.picture_as_pdf),
      ),
    );
  }
}
