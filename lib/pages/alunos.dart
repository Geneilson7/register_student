// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:register_student/pages/formacao.dart';
import 'package:register_student/register/cadastrar_aluno.dart';
import 'package:register_student/pages/home_page.dart';
import 'package:register_student/services/db_helper.dart';

class AlunosScreen extends StatefulWidget {
  const AlunosScreen({super.key});

  @override
  State<AlunosScreen> createState() => _AlunosScreenState();
}

class _AlunosScreenState extends State<AlunosScreen> {
  final DBHelper dbHelper = DBHelper();

  List<Map<String, dynamic>> _items = [];

  final TextEditingController _searchController = TextEditingController();

  int? _alunoCount = 0;
  int? _ativoCount = 0;
  int? _inativoCount = 0;

  @override
  void initState() {
    super.initState();
    _refreshItems();
    _countAlunos();
    _countAtivo();
    _countInativo();
  }

  Future<void> _performSearch(String query) async {
    final dbHelper = DBHelper();
    final searchResults = await dbHelper.searchAlunos(query);
    setState(() {
      _items = searchResults;
    });
  }

  void _refreshItems() async {
    final data = await dbHelper.getAlunos();
    setState(() {
      _items = data;
    });
  }

  void _deleteItem(int id) async {
    try {
      await dbHelper.deleteAluno(id);
      _refreshItems();
    } catch (e) {
      print('Erro ao deletar aluno: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao deletar aluno: $e')),
      );
    }
  }

  Future<void> _countAlunos() async {
    try {
      final count = await dbHelper.countAlunos();
      setState(() {
        _alunoCount = count;
      });
    } catch (error) {
      print(error);
    }
  }

  Future<void> _countAtivo() async {
    try {
      final count = await dbHelper.countAlunosAtivos();
      setState(() {
        _ativoCount = count;
      });
    } catch (error) {
      print(error);
    }
  }

  Future<void> _countInativo() async {
    try {
      final count = await dbHelper.countAlunosInativos();
      setState(() {
        _inativoCount = count;
      });
    } catch (error) {
      print(error);
    }
  }

  Color _getStatusColor(String status) {
    if (status == "Ativo") {
      return const Color(0xFFFFFFFF);
    } else {
      return const Color(0xFF8A8A8A);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: const Color(0xffecf0f4),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Alunos",
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF000000),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: CustomButton(
                      text: 'Matriculados',
                      icon: Icons.group,
                      iconColor: Colors.blueAccent,
                      backgroundColor: const Color(0xFF2E374B),
                      value: '$_alunoCount',
                    ),
                  ),
                  Expanded(
                    child: CustomButton(
                      text: 'Ativos',
                      icon: Icons.check_circle,
                      iconColor: Colors.green,
                      backgroundColor: const Color(0xFF2E374B),
                      value: '$_ativoCount',
                    ),
                  ),
                  Expanded(
                    child: CustomButton(
                      text: 'Inativos',
                      icon: Icons.cancel,
                      iconColor: Colors.red,
                      backgroundColor: const Color(0xFF2E374B),
                      value: '$_inativoCount',
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 0,
                      blurRadius: 7,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: TextFormField(
                  controller: _searchController,
                  onChanged: (value) {
                    _performSearch(value);
                  },
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.transparent,
                    isDense: true,
                    hintText: 'Pesquisar',
                    hintStyle: GoogleFonts.poppins(
                      color: const Color(0xFF15133D),
                      fontSize: 14,
                      fontStyle: FontStyle.italic,
                    ),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            onPressed: () {
                              _searchController.clear();
                              _performSearch('');
                            },
                            icon: const Icon(
                              Icons.clear,
                              color: Colors.black,
                              size: 21,
                            ),
                          )
                        : const Icon(
                            Icons.search,
                            color: Colors.black,
                            size: 21,
                          ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                        width: 0,
                        style: BorderStyle.none,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 7,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SingleChildScrollView(
                      child: DataTable(
                        columns: [
                          DataColumn(
                            label: Text(
                              'Código',
                              style: GoogleFonts.poppins(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'Nome',
                              style: GoogleFonts.poppins(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'Turno',
                              style: GoogleFonts.poppins(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'Status',
                              style: GoogleFonts.poppins(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'Formação',
                              style: GoogleFonts.poppins(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'Ações',
                              style: GoogleFonts.poppins(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                        rows: _items.asMap().entries.map((entry) {
                          final index = entry.key;
                          final item = entry.value;

                          return DataRow(
                            color: MaterialStateProperty.resolveWith<Color?>(
                              (Set<MaterialState> states) {
                                Color? statusColor =
                                    _getStatusColor(item['status']);
                                if (statusColor != const Color(0xFFFFFFFF)) {
                                  return statusColor;
                                }
                                return index.isEven
                                    ? Colors.grey[200]
                                    : Colors.white;
                              },
                            ),
                            cells: [
                              DataCell(
                                Text(
                                  item['id'].toString().toUpperCase(),
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                    fontSize: 16,
                                  ),
                                ),
                                onTap: () async {
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          CadastrarAluno(alunoId: item['id']),
                                    ),
                                  ).then((value) => _refreshItems());
                                },
                              ),
                              DataCell(
                                Text(
                                  item['nome'].toString().toUpperCase(),
                                  style: GoogleFonts.poppins(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xFF1C1C1C),
                                  ),
                                ),
                                onTap: () async {
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          CadastrarAluno(alunoId: item['id']),
                                    ),
                                  ).then((value) => _refreshItems());
                                },
                              ),
                              DataCell(
                                Text(
                                  item['turnotreino'].toString().toUpperCase(),
                                  style: GoogleFonts.poppins(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xFF1C1C1C),
                                  ),
                                ),
                                onTap: () async {
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          CadastrarAluno(alunoId: item['id']),
                                    ),
                                  ).then((value) => _refreshItems());
                                },
                              ),
                              DataCell(
                                Text(
                                  item['status'].toString().toUpperCase(),
                                  style: GoogleFonts.poppins(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xFF1C1C1C),
                                  ),
                                ),
                                onTap: () async {
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          CadastrarAluno(alunoId: item['id']),
                                    ),
                                  ).then((value) => _refreshItems());
                                },
                              ),
                              DataCell(
                                IconButton(
                                  icon: const Icon(Icons.school,
                                      color: Colors.blue),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            FormacaoAlunoScreen(
                                                alunoId: item['id'],
                                                nomeId: item['nome']),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              DataCell(
                                IconButton(
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                  onPressed: () {
                                    _showDeleteDialog(context);
                                  },
                                ),
                              ),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
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
}
