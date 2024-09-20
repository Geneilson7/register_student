// ignore_for_file: library_private_types_in_public_api, depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:register_student/services/db_helper.dart';
import 'package:intl/intl.dart'; // Para formatar a data
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'dart:io';

import 'package:register_student/util/view_pdf.dart';

class ListagemFrequenciaScreen extends StatefulWidget {
  const ListagemFrequenciaScreen({super.key});

  @override
  _ListagemFrequenciaScreenState createState() =>
      _ListagemFrequenciaScreenState();
}

class _ListagemFrequenciaScreenState extends State<ListagemFrequenciaScreen> {
  DateTime? dataSelecionada;
  List<Map<String, dynamic>> frequencias = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    dataSelecionada = DateTime.now();
    buscarFrequencia();
  }

  Future<void> buscarFrequencia() async {
    setState(() {
      isLoading = true;
    });

    final db = DBHelper();
    String data = DateFormat('yyyy-MM-dd').format(dataSelecionada!);
    final result = await db.getFrequenciaPorData(data);

    setState(() {
      frequencias = result;
      isLoading = false;
    });
  }

  Future<void> _selecionarData(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      locale: const Locale('pt', 'BR'),
      initialDate: dataSelecionada ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != dataSelecionada) {
      setState(() {
        dataSelecionada = picked;
      });
      buscarFrequencia();
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
                border: pw.TableBorder.all(
                  color: PdfColors.black,
                  width: 1,
                ),
                children: [
                  pw.TableRow(
                    children: [
                      pw.Padding(
                        padding: const pw.EdgeInsets.symmetric(
                          horizontal: 35,
                          vertical: 8,
                        ),
                        child: pw.Text(
                          'Nome do Aluno',
                          style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold,
                          ),
                          textAlign: pw.TextAlign.center,
                        ),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(8.0),
                        child: pw.Text(
                          'Status',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                          textAlign: pw.TextAlign.center,
                        ),
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
                          child: pw.Text(nome),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8.0),
                          child: pw.Text(
                            presente == 1 ? 'Presente' : 'Faltou',
                            style: pw.TextStyle(
                              color: presente == 1
                                  ? PdfColors.green
                                  : PdfColors.red,
                            ),
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
                          color: const Color(0xFF000000),
                        ),
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
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.calendar_today),
                        onPressed: () => _selecionarData(context),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: ListView.builder(
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
                              contentPadding:
                                  const EdgeInsets.symmetric(horizontal: 20),
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
                                    fontSize: 15, fontWeight: FontWeight.bold),
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
                                    onPressed: () =>
                                        _showConfirmDialog(alunoId),
                                  ),
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

  Future<void> _showConfirmDialog(int alunoId) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
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
          content: const Text(
              'Você tem certeza que deseja excluir esta frequência?'),
          actions: [
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
                'Cancelar',
                style: GoogleFonts.poppins(color: const Color(0xFFFFFFFF)),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _deletarFrequencia(alunoId);
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(13),
                ),
                elevation: 3,
                backgroundColor: const Color(0xFFda2828),
              ),
              child: Text(
                'Excluir',
                style: GoogleFonts.poppins(color: const Color(0xFFFFFFFF)),
              ),
            ),
          ],
        );
      },
    );
  }
}
