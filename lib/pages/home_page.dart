// ignore_for_file: use_build_context_synchronously, deprecated_member_use, avoid_print

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:register_student/pages/alunos.dart';
import 'package:register_student/pages/faixa.dart';
import 'package:register_student/pages/sobre.dart';
import 'package:register_student/register/cadastrar_faixa.dart';
import 'package:register_student/services/db_helper.dart';
import 'package:register_student/register/cadastrar_aluno.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final DBHelper dbHelper = DBHelper();

  List<Map<String, dynamic>> _items = [];

  final TextEditingController _searchController = TextEditingController();

  int? _alunoCount = 0;
  int? _ativoCount = 0;
  int? _inativoCount = 0;

  int? _selectedIndex;
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

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

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    // Utilize o Navigator interno para definir a tela inicial
    _navigatorKey.currentState?.pushReplacement(
      MaterialPageRoute(builder: (context) => _getSelectedScreen(index)),
    );
  }

  Widget _getSelectedScreen(int? selectedIndex) {
    switch (selectedIndex) {
      case 0:
        return const AlunosScreen();
      case 1:
        return FaixaScreen();
      case 2:
        return CadastrarAluno(showButton: false);
      case 3:
        return const CadastrarFaixa();
      case 4:
        return const Sobre();
      default:
        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 50,
                ),
                Text(
                  'Home',
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF404046),
                  ),
                ),
              ],
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 150),
                child: Image.asset(
                  'assets/image/background.jpg',
                  height: 500,
                  width: 500,
                ),
              ),
            ),
          ],
        );
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
      backgroundColor: const Color(0xFF1d1e2b),
      body: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  ListTile(
                    title: Image.asset(
                      'assets/image/logo.png',
                      height: 100,
                      width: 100,
                    ),
                  ),
                  Divider(thickness: 1, color: Colors.grey[300]),
                  Expanded(
                    child: ListView(
                      children: [
                        buildListTile(
                          Icons.person,
                          "Alunos",
                          () {
                            _onItemTapped(0);
                          },
                        ),
                        buildListTile(
                          Icons.person,
                          "Faixas",
                          () {
                            _onItemTapped(1);
                          },
                        ),
                        ExpansionTile(
                          leading: const Icon(
                            Icons.group,
                            color: Colors.white54,
                          ),
                          iconColor: Colors.white54,
                          collapsedIconColor: Colors.white54,
                          title: Text(
                            "Cadastros",
                            style: GoogleFonts.poppins(
                              fontSize: 15,
                              color: Colors.white54,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          children: <Widget>[
                            buildSubListTile(
                              "Cadastrar Aluno",
                              () {
                                _onItemTapped(2);
                              },
                            ),
                            buildSubListTile(
                              "Cadastrar Faixa",
                              () {
                                _onItemTapped(3);
                              },
                            ),
                          ],
                        ),
                        buildListTile(
                          Icons.info,
                          "Sobre",
                          () {
                            _onItemTapped(4);
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 4,
              child: Container(
                color: const Color(0xFFF1F3F6),
                child: Navigator(
                  key: _navigatorKey,
                  onGenerateRoute: (settings) {
                    return MaterialPageRoute(
                      builder: (context) => _getSelectedScreen(_selectedIndex),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  ListTile buildListTile(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(
        icon,
        size: 25,
        color: Colors.white54,
      ),
      title: Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: 15,
          color: Colors.white54,
          fontWeight: FontWeight.w600,
        ),
      ),
      onTap: onTap,
    );
  }

  ListTile buildSubListTile(String title, VoidCallback onTap) {
    return ListTile(
      contentPadding: const EdgeInsets.only(
        left: 40,
      ),
      title: Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: 14,
          color: Colors.white54,
          fontWeight: FontWeight.w600,
        ),
      ),
      onTap: onTap,
    );
  }
}

class CustomButton extends StatelessWidget {
  final String text;
  final IconData icon;
  final Color iconColor;
  final Color backgroundColor;
  final String value;

  CustomButton({
    super.key,
    required this.text,
    required this.icon,
    required this.iconColor,
    required this.backgroundColor,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 4,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: GoogleFonts.poppins(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  text,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 35,
            ),
          ),
        ],
      ),
    );
  }
}
