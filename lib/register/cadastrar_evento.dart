// ignore_for_file: use_build_context_synchronously, deprecated_member_use, depend_on_referenced_packages

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:register_student/pages/faixas.dart';
import 'package:register_student/pages/home_page.dart';
import 'package:register_student/services/db_helper.dart';
import 'package:register_student/util/form.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:register_student/util/view_pdf.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class CadastrarEvento extends StatefulWidget {
  final int? alunoId;
  final bool showButton;

  const CadastrarEvento({
    Key? key,
    this.alunoId,
    this.showButton = true,
  }) : super(key: key);

  @override
  State<CadastrarEvento> createState() => _CadastrarEventoState();
}

class _CadastrarEventoState extends State<CadastrarEvento> {
  final DBHelper dbHelper = DBHelper();
  final TextEditingController _tituloController = TextEditingController();
  final TextEditingController _escrtiaController = TextEditingController();
  final TextEditingController _assinatura1Controller = TextEditingController();
  final TextEditingController _assinatura2Controller = TextEditingController();
  final TextEditingController _assUnicaController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool isDuplaAss = false;
  bool isAssUnica = false;

  @override
  void initState() {
    super.initState();
    if (widget.alunoId != null) {
      _loadAluno(widget.alunoId!);
    }
    _loadDuplaAss();
    _loadAssUnica();
  }

  void _populateFields(Map<String, dynamic> faixa) {
    _tituloController.text = faixa['descricao'];
    setState(() {});
  }

  void _loadAluno(int id) async {
    final faixa = await dbHelper.getFaixasById(id);
    if (faixa != null) {
      _populateFields(faixa);
    }
  }

  void _saveItem() async {
    try {
      if (_formKey.currentState!.validate()) {
        final faixa = {
          'descricao': _tituloController.text,
        };

        if (widget.alunoId != null) {
          await dbHelper.updateFaixa(widget.alunoId!, faixa);
        } else {
          await dbHelper.insertFaixa(faixa);
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
              child: const FaixaScreen(),
            ),
          ),
        );
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("$error")),
      );
    }
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

  Future<void> _loadDuplaAss() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      isDuplaAss = prefs.getBool('isDuplaAss') ?? false;
    });
  }

  Future<void> _saveDuplaAss() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('isDuplaAss', isDuplaAss);
  }

  Future<void> _loadAssUnica() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      isAssUnica = prefs.getBool('isAssUnica') ?? false;
    });
  }

  Future<void> _saveAssUnica() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('isAssUnica', isAssUnica);
  }

  Future<void> _displayPdf() async {
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
                  pw.SizedBox(
                    width: 100,
                    child: pw.Container(
                      width: 70,
                      height: 70,
                      child: pw.Image(image),
                      // color: PdfColor.fromHex('eaf1f8'),
                    ),
                  ),
                  pw.Text(
                    dataAtual,
                    style: pw.TextStyle(
                      fontSize: 9,
                      fontWeight: pw.FontWeight.normal,
                    ),
                  ),
                ],
              ),
              pw.SizedBox(
                height: 10,
              ),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.center,
                children: [
                  pw.Text(
                    _tituloController.text,
                    textAlign: pw.TextAlign.center,
                    style: pw.TextStyle(
                      fontSize: 25,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                ],
              ),
              pw.SizedBox(height: 20),
              pw.Text(
                _escrtiaController.text,
                style: const pw.TextStyle(
                  fontSize: 12,
                ),
                textAlign: pw.TextAlign.justify,
                softWrap: true, // Ativa a quebra de linha automática
              ),
              pw.Spacer(),
              if (!isDuplaAss) ...[
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
                  children: [
                    pw.Column(
                      children: [
                        pw.Text('________________________________'),
                        pw.SizedBox(
                          height: 5,
                        ),
                        _buildLabeledField(_assinatura1Controller.text),
                      ],
                    ),
                    pw.SizedBox(
                      width: 10,
                    ),
                    pw.Column(
                      children: [
                        pw.Text('________________________________'),
                        pw.SizedBox(
                          height: 5,
                        ),
                        _buildLabeledField(_assinatura2Controller.text),
                      ],
                    ),
                  ],
                ),
              ],
              if (!isAssUnica) ...[
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.center,
                  children: [
                    pw.Column(
                      children: [
                        pw.Text('________________________________'),
                        pw.SizedBox(
                          height: 5,
                        ),
                        _buildLabeledField(_assUnicaController.text),
                      ],
                    ),
                  ],
                ),
              ],
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
          pdfFileName: "${_tituloController.text}.pdf",
          titulo: "Visualizar Evento",
        ),
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
          widget.alunoId != null ? 'Atualizar Evento' : 'Cadastrar Evento',
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
                Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: TextFormField(
                    decoration: textFormField("Título"),
                    controller: _tituloController,
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
                    decoration: textFormField("Escrita").copyWith(
                      alignLabelWithHint: true,
                    ),
                    controller: _escrtiaController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Campo obrigatório.";
                      }
                      return null;
                    },
                    minLines: 5,
                    maxLines: null,
                    keyboardType: TextInputType.multiline,
                  ),
                ),
                const SizedBox(
                  height: 180,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Dupla Ass?",
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Switch(
                      value: isDuplaAss,
                      activeColor: const Color(0xFF1d1e2b),
                      onChanged: (value) {
                        setState(
                          () {
                            isDuplaAss = value;
                            _saveDuplaAss();
                          },
                        );
                      },
                    ),
                  ],
                ),
                if (!isDuplaAss)
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Dupla Assinatura",
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                if (!isDuplaAss)
                  Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 15),
                          child: TextFormField(
                            decoration: textFormField("Assinatura 1"),
                            controller: _assinatura1Controller,
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
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 15),
                          child: TextFormField(
                            decoration: textFormField("Assinatura 2"),
                            controller: _assinatura2Controller,
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
                const SizedBox(
                  height: 5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Ass Única?",
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Switch(
                      value: isAssUnica,
                      activeColor: const Color(0xFF1d1e2b),
                      onChanged: (value) {
                        setState(
                          () {
                            isAssUnica = value;
                            _saveAssUnica();
                          },
                        );
                      },
                    ),
                  ],
                ),
                if (!isAssUnica)
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      "Assinatura Única",
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                if (!isAssUnica)
                  Row(
                    children: [
                      const Spacer(),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 15),
                          child: TextFormField(
                            decoration: textFormField("Assinatura"),
                            controller: _assUnicaController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Campo obrigatório.";
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                      const Spacer(),
                    ],
                  ),
                const SizedBox(height: 50),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SizedBox(
                      height: 50,
                      width: 180,
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
                              'Gerar Evento',
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
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //     builder: (context) => WillPopScope(
                            //       onWillPop: () async {
                            //         Navigator.pushReplacement(
                            //           context,
                            //           MaterialPageRoute(
                            //             builder: (context) => const HomePage(),
                            //           ),
                            //         );
                            //         return false;
                            //       },
                            //       child: const FaixaScreen(),
                            //     ),
                            //   ),
                            // );
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

// Função para criar título de seção com estilo
pw.Widget _buildSectionTitle(String value) {
  return pw.Padding(
    padding: const pw.EdgeInsets.symmetric(vertical: 5),
    child: pw.Container(
      color: PdfColor.fromHex('eaf1f8'),
      width: double.infinity,
      // child: pw.Center(
      //   child: pw.Text(
      //     title,
      //     textAlign: pw.TextAlign.center,
      //     style: pw.TextStyle(
      //       fontWeight: pw.FontWeight.bold,
      //       fontSize: 14,
      //     ),
      //   ),
      // ),
    ),
  );
}

// Função para criar campos com rótulos e valores
pw.Widget _buildLabeledField(String value) {
  return pw.Row(
    children: [
      // pw.Text(
      //   label,
      //   style: pw.TextStyle(
      //     fontWeight: pw.FontWeight.bold,
      //   ),
      // ),
      pw.Text(
        value.isNotEmpty ? value : '',
      ),
    ],
  );
}
