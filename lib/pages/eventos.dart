// ignore_for_file: deprecated_member_use, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:register_student/pages/home_page.dart';
import 'package:register_student/register/cadastrar_evento.dart';
import 'package:register_student/register/cadastrar_faixa.dart';
import 'package:register_student/services/db_helper.dart';

class EventosScreen extends StatefulWidget {
  const EventosScreen({super.key});

  @override
  State<EventosScreen> createState() => _EventosScreenState();
}

class _EventosScreenState extends State<EventosScreen> {
  final DBHelper dbHelper = DBHelper();

  List<Map<String, dynamic>> _items = [];

  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _refreshItems();
  }

  Future<void> _performSearch(String query) async {
    final dbHelper = DBHelper();
    final searchResults = await dbHelper.searchEventos(query);
    setState(() {
      _items = searchResults;
    });
  }

  void _refreshItems() async {
    final data = await dbHelper.getEventos();
    setState(() {
      _items = data;
    });
  }

  void _deleteItem(int id) async {
    try {
      await dbHelper.deleteEventos(id);
      _refreshItems();
    } catch (e) {
      print('Erro ao deletar eventos: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao deletar eventos: $e')),
      );
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
                    "Eventos",
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
                              'Descrição',
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
                          final item = entry.value;

                          return DataRow(
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
                                          CadastrarEvento(alunoId: item['id']),
                                    ),
                                  ).then((value) => _refreshItems());
                                },
                              ),
                              DataCell(
                                Text(
                                  item['titulo'].toString().toUpperCase(),
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
                                          CadastrarEvento(alunoId: item['id']),
                                    ),
                                  ).then((value) => _refreshItems());
                                },
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
