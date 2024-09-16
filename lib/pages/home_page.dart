// ignore_for_file: use_build_context_synchronously, deprecated_member_use, avoid_print

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:register_student/pages/alunos.dart';
import 'package:register_student/pages/faixa.dart';
import 'package:register_student/pages/professores.dart';
import 'package:register_student/pages/sobre.dart';
import 'package:register_student/register/cadastrar_faixa.dart';
import 'package:register_student/register/cadastrar_professor.dart';
import 'package:register_student/services/db_helper.dart';
import 'package:register_student/register/cadastrar_aluno.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final DBHelper dbHelper = DBHelper();

  int? _selectedIndex;
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();
  }

  // void _onItemTapped(int index) {
  //   setState(() {
  //     _selectedIndex = index;
  //   });
  // }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    _navigatorKey.currentState?.pushReplacement(
      MaterialPageRoute(builder: (context) => _getSelectedScreen(index)),
    );
  }

  Widget _getSelectedScreen(int? selectedIndex) {
    switch (selectedIndex) {
      case 0:
        return const AlunosScreen();
      case 1:
        return const ProfessorScreen();
      case 2:
        return const FaixaScreen();
      case 3:
        return const CadastrarAluno(
          showButton: false,
        );
      case 4:
        return const CadastrarPofessor(
          showButton: false,
        );
      case 5:
        return const CadastrarFaixa(
          showButton: false,
        );
      case 6:
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
            const Spacer(),
            Center(
              child: Image.asset(
                'assets/image/screen.png',
                height: 400,
                width: 400,
              ),
            ),
            const Spacer(),
          ],
        );
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
                          'assets/image/aluno.png',
                          "Alunos",
                          () {
                            _onItemTapped(0);
                          },
                        ),
                        buildListTile(
                          'assets/image/professojiujtsu.png',
                          "Professores",
                          () {
                            _onItemTapped(1);
                          },
                        ),
                        buildListTile(
                          'assets/image/faixa.png',
                          "Faixas",
                          () {
                            _onItemTapped(2);
                          },
                        ),
                        ExpansionTile(
                          leading: Image.asset(
                            'assets/image/cadastro.png',
                            height: 26,
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
                                _onItemTapped(3);
                              },
                            ),
                            buildSubListTile(
                              "Cadastrar Professor",
                              () {
                                _onItemTapped(4);
                              },
                            ),
                            buildSubListTile(
                              "Cadastrar Faixa",
                              () {
                                _onItemTapped(5);
                              },
                            ),
                          ],
                        ),
                        buildListTile(
                          'assets/image/sobre.png',
                          "Sobre",
                          () {
                            _onItemTapped(6);
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
                    // Sempre renderize a tela com base no selectedIndex, sem empilhar.
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

  ListTile buildListTile(String imagePath, String title, VoidCallback onTap) {
    return ListTile(
      leading: Image.asset(
        imagePath,
        // width: 30,
        height: 22,
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

  const CustomButton({
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
