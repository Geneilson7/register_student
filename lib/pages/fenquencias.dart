// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api, deprecated_member_use, depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:register_student/services/db_helper.dart';
import 'package:register_student/util/error_code.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:register_student/util/view_pdf.dart';
import 'package:intl/intl.dart';

class FrequenciaScreen extends StatefulWidget {
  const FrequenciaScreen({super.key});

  @override
  _FrequenciaScreenState createState() => _FrequenciaScreenState();
}

class _FrequenciaScreenState extends State<FrequenciaScreen> {
  List<Map<String, dynamic>> alunos = [];
  List<Map<String, dynamic>> turmas = [];
  Map<int, bool> frequencia = {};
  bool marcarTodos = false;
  int? selectedTurmaId;

  @override
  void initState() {
    super.initState();
    carregarTurmas(); // Carregar turmas ao iniciar a tela
  }

  Future<void> carregarTurmas() async {
    final db = DBHelper();
    final result = await db.fetchTurmas();
    setState(() {
      turmas = result;
    });
  }

  Future<void> carregarAlunosPorTurma(int turmaId) async {
    final db = DBHelper();
    final result = await db.getAlunosByTurma(turmaId);
    setState(() {
      alunos = result;
      frequencia.clear(); // Limpa a frequência anterior
    });
  }

  Future<void> registrarFrequencia() async {
    final db = DBHelper();
    for (var aluno in alunos) {
      final presente = frequencia[aluno['id']] ?? false;
      await db.registrarFrequencia(aluno['id'], presente);
    }
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Frequência registrada com sucesso!')));
  }

  void _toggleMarcarTodos(bool? value) {
    setState(() {
      marcarTodos = value ?? false;
      for (var aluno in alunos) {
        frequencia[aluno['id']] = marcarTodos;
      }
    });
  }

  Future<void> gerarPDF() async {
    final pdf = pw.Document();
    final dataFrequencia =
        DateTime.now(); // Aqui você pode definir a data da frequência.
    final String dataFrequenciaFormatada =
        DateFormat('dd/MM/yyyy').format(dataFrequencia);

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Column(
            children: [
              pw.Text(
                'Lista de Frequência',
                style:
                    pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
              ),
              pw.SizedBox(height: 20),
              pw.Text('Data da Frequência: $dataFrequenciaFormatada.'),
              pw.SizedBox(height: 20),
              pw.Table.fromTextArray(
                headers: ['Nome', 'Assinatura'],
                data: alunos.map((aluno) {
                  return [
                    aluno['nome'],
                  ];
                }).toList(),
                columnWidths: {
                  0: const pw.FixedColumnWidth(
                      200), // Ajuste a largura da coluna do nome conforme necessário
                  1: const pw.FixedColumnWidth(
                      150), // Ajuste a largura da coluna da assinatura conforme necessário
                },
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
          pdfFileName: 'Relatório de Presença - $dataFrequencia.pdf',
          titulo: "Visualizar Lista de Presença",
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Text(
              "Lista de Frequência",
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF000000),
              ),
            ),
            const SizedBox(height: 10),

            SizedBox(
              width: 250,
              child: DropdownButtonFormField<int>(
                hint: const Text("Selecione uma turma"),
                value: selectedTurmaId,
                items: turmas.map((turma) {
                  return DropdownMenuItem<int>(
                    value: turma['id'],
                    child: Text(turma['descricao']),
                  );
                }).toList(),
                onChanged: (turmaId) {
                  setState(() {
                    selectedTurmaId = turmaId!;
                    carregarAlunosPorTurma(turmaId);
                  });
                },
                decoration: InputDecoration(
                  label: const Text("Turma"),
                  fillColor: const Color(0xFFF1F4FF).withOpacity(0.9),
                  filled: true,
                  labelStyle: GoogleFonts.poppins(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                    color: const Color(0xFF626262),
                  ),
                  isDense: true,
                  border: OutlineInputBorder(
                    borderSide:
                        const BorderSide(color: Color(0xFF262c40), width: 2.0),
                    borderRadius: BorderRadius.circular(11),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide:
                        const BorderSide(color: Color(0xFF262c40), width: 2.0),
                    borderRadius: BorderRadius.circular(11),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        const BorderSide(color: Color(0xFF262c40), width: 2.0),
                    borderRadius: BorderRadius.circular(11),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderSide:
                        const BorderSide(color: Color(0xFF262c40), width: 2.0),
                    borderRadius: BorderRadius.circular(11),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide:
                        const BorderSide(color: Color(0xFF262c40), width: 2.0),
                    borderRadius: BorderRadius.circular(11),
                  ),
                ),
              ),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Marcar Todos",
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xff000000),
                  ),
                ),
                Switch(
                  value: marcarTodos,
                  activeColor: const Color(0xFF1d1e2b),
                  onChanged: _toggleMarcarTodos,
                ),
              ],
            ),

            // Lista de alunos filtrados pela turma
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 20),
                child: alunos.isEmpty
                    ? const ErrorPage(
                        label:
                            "Selecione uma turma ou verifique se há aluno cadastrado na turma.",
                      )
                    : ListView.builder(
                        itemCount: alunos.length,
                        itemBuilder: (context, index) {
                          final aluno = alunos[index];
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
                                leading: Text(
                                  aluno['id'].toString(),
                                  style: GoogleFonts.poppins(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xff000000),
                                  ),
                                ),
                                title: Text(
                                  aluno['nome'],
                                  style: GoogleFonts.poppins(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xff000000),
                                  ),
                                ),
                                trailing: Switch(
                                  value: frequencia[aluno['id']] ?? false,
                                  activeColor: const Color(0xFF1d1e2b),
                                  onChanged: (valor) {
                                    setState(() {
                                      frequencia[aluno['id']] = valor;
                                    });
                                  },
                                ),
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ),
            if (selectedTurmaId != null) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 50,
                    width: 150,
                    child: ElevatedButton(
                      onPressed: () {
                        gerarPDF();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(11),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          'Gerar PDF',
                          style: GoogleFonts.poppins(
                            fontSize: 19,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ] else ...[
              const SizedBox(height: 20),
              Text(
                "Selecione uma turma para gerar o PDF.",
                style: GoogleFonts.poppins(fontSize: 16, color: Colors.grey),
              ),
            ],
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF1d1e2b),
        foregroundColor: const Color(0xFFFFFFFF),
        onPressed: registrarFrequencia,
        child: const Icon(Icons.save),
      ),
    );
  }
}
