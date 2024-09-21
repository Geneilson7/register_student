// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:register_student/services/db_helper.dart';
import 'package:intl/intl.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:register_student/util/error_code.dart';
import 'package:register_student/util/view_pdf.dart';

class FormacaoAlunoScreen extends StatefulWidget {
  final int alunoId;
  final String nomeId;

  const FormacaoAlunoScreen(
      {super.key, required this.alunoId, required this.nomeId});

  @override
  _FormacaoAlunoScreenState createState() => _FormacaoAlunoScreenState();
}

class _FormacaoAlunoScreenState extends State<FormacaoAlunoScreen> {
  final DBHelper dbHelper = DBHelper();
  List<Map<String, dynamic>> _formacaoItems = [];
  DateTime startDate = DateTime(DateTime.now().year, DateTime.now().month, 1);
  DateTime endDate = DateTime.now();
  late String selectedDateRangeText;

  @override
  void initState() {
    super.initState();
    _loadFormacao();
    selectedDateRangeText = _formatDateRange(startDate, endDate);
  }

  Future<void> _loadFormacao() async {
    final data = await dbHelper.getHistoricoFormacaoFiltrado(
        widget.alunoId, startDate, endDate);
    setState(() {
      _formacaoItems = data;
    });
  }

  Future<void> _deletarFormacao(int formacaoId) async {
    await dbHelper.deleteFormacao(formacaoId);
    _loadFormacao();
  }

  String _formatDateRange(DateTime start, DateTime end) {
    final formatter = DateFormat('dd/MM/yyyy');
    return '${formatter.format(start)} à ${formatter.format(end)}';
  }

  Future<void> _selectDateRange(BuildContext context) async {
    final DateTimeRange? selectedDateRange = await showDateRangePicker(
      context: context,
      initialDateRange: DateTimeRange(start: startDate, end: endDate),
      locale: const Locale('pt', 'BR'),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      helpText: 'Selecione um período',
      cancelText: 'Cancelar',
      confirmText: 'Filtrar',
    );

    if (selectedDateRange != null) {
      setState(() {
        // Ajuste as datas para incluir todo o dia
        startDate = DateTime(
          selectedDateRange.start.year,
          selectedDateRange.start.month,
          selectedDateRange.start.day,
          0,
          0,
          0,
        );
        endDate = DateTime(
          selectedDateRange.end.year,
          selectedDateRange.end.month,
          selectedDateRange.end.day,
          23,
          59,
          59,
          999,
        );

        selectedDateRangeText = _formatDateRange(startDate, endDate);
        _loadFormacao();
      });
    }
  }

  Future<void> _gerarPdf() async {
    final doc = pw.Document();

    doc.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            children: [
              pw.Text(
                'Histórico de Formação: ${widget.nomeId}',
                style:
                    pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
                textAlign: pw.TextAlign.center,
              ),
              pw.SizedBox(height: 20),
              pw.Text('Período: $selectedDateRangeText',
                  style: const pw.TextStyle(fontSize: 16)),
              pw.SizedBox(height: 10),
              pw.ListView.builder(
                itemCount: _formacaoItems.length,
                itemBuilder: (context, index) {
                  final formacao = _formacaoItems[index];
                  return pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text('Faixa: ${formacao['faixa']}'),
                      pw.Text(
                          'Data de Mudança: ${DateFormat('dd/MM/yyyy').format(DateTime.parse(formacao['data_mudanca']))}'),
                      pw.SizedBox(height: 10),
                    ],
                  );
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
          doc: doc,
          pdfFileName: "${widget.nomeId}.pdf",
          titulo: "Histórico de Formação",
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Histórico de Formação",
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF000000),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: Text(
                    selectedDateRangeText,
                    style: GoogleFonts.poppins(
                      color: const Color(0xFF8A8A8A),
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => _selectDateRange(context),
                  icon: const Icon(Icons.calendar_today, size: 30),
                ),
              ],
            ),
            _formacaoItems.isEmpty
                ? const ErrorPage()
                : Expanded(
                    child: ListView.builder(
                      itemCount: _formacaoItems.length,
                      itemBuilder: (context, index) {
                        final formacao = _formacaoItems[index];
                        final formacaoId = formacao['id'] as int? ?? 0;

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
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: ListTile(
                                leading: Text(
                                  formacao['id'].toString(),
                                  style: GoogleFonts.poppins(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                title: Text(
                                  'Faixa: ${formacao['faixa']}',
                                  style: GoogleFonts.poppins(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                                subtitle: Text(
                                  'Data de Mudança: ${DateFormat('dd/MM/yyyy').format(DateTime.parse(formacao['data_mudanca']))}',
                                  style: GoogleFonts.poppins(fontSize: 14),
                                ),
                                trailing: IconButton(
                                  icon: const Icon(Icons.delete,
                                      color: Colors.red, size: 30),
                                  onPressed: () =>
                                      _showConfirmDialog(formacaoId),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
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
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(11),
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Center(
                        child: Text(
                          'Voltar',
                          style: GoogleFonts.poppins(
                            fontSize: 19,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                SizedBox(
                  height: 50,
                  width: 150,
                  child: ElevatedButton(
                    onPressed: _gerarPdf,
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
          ],
        ),
      ),
    );
  }

  Future<void> _showConfirmDialog(int formacaoId) async {
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
                color: const Color(0xFF000000)),
          ),
          content:
              const Text('Você tem certeza que deseja excluir esta formação?'),
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
              child: Text('Cancelar',
                  style: GoogleFonts.poppins(color: const Color(0xFFFFFFFF))),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _deletarFormacao(formacaoId);
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(13),
                ),
                elevation: 3,
                backgroundColor: const Color(0xFFda2828),
              ),
              child: Text('Excluir',
                  style: GoogleFonts.poppins(color: const Color(0xFFFFFFFF))),
            ),
          ],
        );
      },
    );
  }
}
