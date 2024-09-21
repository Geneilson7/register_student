// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:register_student/services/db_helper.dart';
import 'package:register_student/util/error_code.dart';

class FrequenciaScreen extends StatefulWidget {
  const FrequenciaScreen({super.key});

  @override
  _FrequenciaScreenState createState() => _FrequenciaScreenState();
}

class _FrequenciaScreenState extends State<FrequenciaScreen> {
  List<Map<String, dynamic>> alunos = [];
  List<Map<String, dynamic>> turmas = [];
  Map<int, bool> frequencia = {};
  bool isLoading = true;
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
      isLoading = false;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
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
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: Color(0xFF262c40), width: 2.0),
                          borderRadius: BorderRadius.circular(11),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: Color(0xFF262c40), width: 2.0),
                          borderRadius: BorderRadius.circular(11),
                        ),
                      ),
                    ),
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Marcar Todos"),
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
                          ? const ErrorPage()
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
