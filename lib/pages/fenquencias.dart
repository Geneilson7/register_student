// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:register_student/services/db_helper.dart';
// import 'db_helper.dart'; // Assumindo que o arquivo DBHelper está nesse caminho

class FrequenciaScreen extends StatefulWidget {
  const FrequenciaScreen({super.key});

  @override
  _FrequenciaScreenState createState() => _FrequenciaScreenState();
}

class _FrequenciaScreenState extends State<FrequenciaScreen> {
  List<Map<String, dynamic>> alunos = [];
  Map<int, bool> frequencia = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    carregarAlunos();
  }

  Future<void> carregarAlunos() async {
    final db = DBHelper();
    final result = await db.getAlunos();
    setState(() {
      alunos = result;
      isLoading = false;
    });
  }

  Future<void> registrarFrequencia() async {
    final db = DBHelper();
    String dataAtual = DateTime.now().toIso8601String();
    for (var aluno in alunos) {
      final presente = frequencia[aluno['id']] ?? false;
      await db.registrarFrequencia(aluno['id'], presente);
    }
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Frequência registrada com sucesso!')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 15,
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Lista de Frequência",
                          style: GoogleFonts.poppins(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF000000),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(
                        top: 20,
                      ),
                      child: ListView.builder(
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
