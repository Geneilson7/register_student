// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:register_student/services/db_helper.dart';

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

  @override
  void initState() {
    super.initState();
    _loadFormacao();
  }

  DateTime _startDate = DateTime.now().subtract(const Duration(days: 30));
  DateTime _endDate = DateTime.now();

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isStartDate ? _startDate : _endDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != (isStartDate ? _startDate : _endDate)) {
      setState(() {
        if (isStartDate) {
          _startDate = picked;
        } else {
          _endDate = picked;
        }
        _loadFormacao(); // Recarregar a formação com as novas datas
      });
    }
  }

  Future<void> _loadFormacao() async {
    final data = await dbHelper.getHistoricoFormacaoFiltrado(
        widget.alunoId, _startDate, _endDate);
    setState(() {
      _formacaoItems = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text('Formação do Aluno', style: GoogleFonts.poppins(fontSize: 20)),
        backgroundColor: const Color(0xFF2E374B),
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: _formacaoItems.isEmpty
            ? const Center(child: Text('Nenhuma formação encontrada.'))
            : Column(
                children: [
                  Row(
                    children: [
                      TextButton(
                        onPressed: () => _selectDate(context, true),
                        child: Text('Data Início: ${_startDate.toLocal()}'
                            .split(' ')[0]),
                      ),
                      TextButton(
                        onPressed: () => _selectDate(context, false),
                        child: Text(
                            'Data Fim: ${_endDate.toLocal()}'.split(' ')[0]),
                      ),
                    ],
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: _formacaoItems.length,
                      itemBuilder: (context, index) {
                        final formacao = _formacaoItems[index];
                        return Card(
                          child: ListTile(
                            title: Text(
                              'Faixa: ${formacao['faixa']}',
                              style: GoogleFonts.poppins(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(
                              'Data de Mudança: ${formacao['data_mudanca']}',
                              style: GoogleFonts.poppins(fontSize: 14),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
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
      ),
    );
  }
}
