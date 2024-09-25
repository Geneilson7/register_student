// ignore_for_file: use_build_context_synchronously, deprecated_member_use, avoid_print

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:register_student/pages/alunos.dart';
import 'package:register_student/pages/eventos.dart';
import 'package:register_student/pages/faixas.dart';
import 'package:register_student/pages/fenquencias.dart';
import 'package:register_student/pages/lista_frequencia.dart';
import 'package:register_student/pages/professores.dart';
import 'package:register_student/pages/sobre.dart';
import 'package:register_student/pages/turma.dart';
import 'package:register_student/register/cadastrar_evento.dart';
import 'package:register_student/register/cadastrar_faixa.dart';
import 'package:register_student/register/cadastrar_professor.dart';
import 'package:register_student/register/cadastrar_turma.dart';
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
  bool isExpanded = true;

  @override
  void initState() {
    super.initState();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Alterado para `push` ao invés de `pushReplacement`
    _navigatorKey.currentState?.push(
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
        return const EventosScreen();
      case 4:
        return const FrequenciaScreen();
      case 5:
        return const ListagemFrequenciaScreen();
      case 6:
        return const TurmaScreen();
      case 7:
        return const CadastrarAluno(
          showButton: false,
        );
      case 8:
        return const CadastrarPofessor(
          showButton: false,
        );
      case 9:
        return const CadastrarFaixa(
          showButton: false,
        );
      case 10:
        return const CadastrarEvento(
          showButton: false,
        );
      case 11:
        return const CadastrarTurma(
          showButton: false,
        );
      case 12:
        return const Sobre();
      default:
        return _buildHomeScreen();
    }
  }

  Widget _buildHomeScreen() {
    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset(
            // 'assets/image/background.jpg',
            'assets/image/screen.png',
            // fit: BoxFit.cover,
          ),
        ),
        Column(
          children: [
            const SizedBox(height: 50),
            Center(
              child: Text(
                'Home',
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  // color: const Color(0xFFFFFFFF),
                  color: const Color(0xFF404046),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    // Definição de tamanhos de tela

    bool isMediumScreen =
        screenWidth >= 600 && screenWidth < 1366; // Telas médias (ex: tablets)
    bool isLargeScreen = screenWidth >= 1024; // Telas grandes (ex: desktops)

    // Definindo valores com base no tamanho da tela
    double topPosition = screenHeight * 0.4; // Altura proporcional
    double leftPosition = 0.0; // Inicializando
    double rightPosition = 0.0; // Inicializando
    double avatarRadius;
    double iconSize;

    // Condições para ajustar o posicionamento e tamanhos
    if (isLargeScreen && isExpanded) {
      leftPosition = screenWidth * 0.39; // Para telas grandes, quando expandido
      rightPosition = screenWidth * 0.79; // Ajuste a posição à direita
      avatarRadius = 16; // Tamanho maior em telas grandes
      iconSize = 16; // Tamanho do ícone maior
    } else if (isMediumScreen) {
      leftPosition = screenWidth * 0.05; // Para telas médias
      avatarRadius = 15; // Tamanho intermediário
      iconSize = 15; // Tamanho do ícone intermediário
    } else {
      leftPosition = screenWidth * 0.04; // Para telas pequenas
      avatarRadius = 15; // Tamanho padrão em telas pequenas
      iconSize = 15; // Tamanho do ícone padrão
    }
    return Scaffold(
      backgroundColor: const Color(0xFF1d1e2b),
      body: SafeArea(
        child: Stack(
          children: [
            Row(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width:
                      isExpanded ? MediaQuery.of(context).size.width * 0.2 : 82,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      if (isExpanded)
                        ListTile(
                          title: Image.asset(
                            'assets/image/logo.png',
                            height: 100,
                            width: 100,
                          ),
                        ),
                      if (isExpanded)
                        Divider(thickness: 1, color: Colors.grey[300]),
                      Expanded(
                        child: ListView(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 2),
                              child: ListTile(
                                leading: Image.asset(
                                  'assets/image/home.png',
                                  height: 26,
                                  color: Colors.white54,
                                ),
                                title: isExpanded
                                    ? Text(
                                        "Home",
                                        style: GoogleFonts.poppins(
                                          fontSize: 15,
                                          color: Colors.white54,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      )
                                    : null,
                                onTap: () {
                                  Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(
                                      builder: (context) => const HomePage(),
                                    ),
                                    (route) => false,
                                  );
                                },
                              ),
                            ),
                            ExpansionTile(
                              leading: Image.asset(
                                'assets/image/cadastro.png',
                                height: 26,
                                color: Colors.white54,
                              ),
                              iconColor: Colors.white54,
                              collapsedIconColor: Colors.white54,
                              title: isExpanded
                                  ? Text(
                                      "Cadastros",
                                      style: GoogleFonts.poppins(
                                        fontSize: 15,
                                        color: Colors.white54,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    )
                                  : const SizedBox.shrink(),
                              onExpansionChanged: (expanded) {
                                // Quando o ExpansionTile é expandido ou colapsado
                                if (!expanded) {
                                  // Se está colapsando, não faz nada
                                  return;
                                } else {
                                  // Se está expandindo, altera o estado
                                  setState(() {
                                    isExpanded = true;
                                  });
                                }
                              },
                              children: <Widget>[
                                buildSubListTile(
                                  title: "Cadastrar Aluno",
                                  index: 7,
                                  onTap: () {
                                    if (!isExpanded) {
                                      setState(() {
                                        isExpanded =
                                            true; // Abre o menu se estiver fechado
                                      });
                                    }
                                    _onItemTapped(7);
                                  },
                                ),
                                buildSubListTile(
                                  title: "Cadastrar Professor",
                                  index: 8,
                                  onTap: () {
                                    if (!isExpanded) {
                                      setState(() {
                                        isExpanded =
                                            true; // Abre o menu se estiver fechado
                                      });
                                    }
                                    _onItemTapped(8);
                                  },
                                ),
                                buildSubListTile(
                                  title: "Cadastrar Faixa",
                                  index: 9,
                                  onTap: () {
                                    if (!isExpanded) {
                                      setState(() {
                                        isExpanded =
                                            true; // Abre o menu se estiver fechado
                                      });
                                    }
                                    _onItemTapped(9);
                                  },
                                ),
                                buildSubListTile(
                                  title: "Cadastrar Evento",
                                  index: 10,
                                  onTap: () {
                                    if (!isExpanded) {
                                      setState(() {
                                        isExpanded =
                                            true; // Abre o menu se estiver fechado
                                      });
                                    }
                                    _onItemTapped(10);
                                  },
                                ),
                                buildSubListTile(
                                  title: "Cadastrar Turma",
                                  index: 11,
                                  onTap: () {
                                    if (!isExpanded) {
                                      setState(() {
                                        isExpanded =
                                            true; // Abre o menu se estiver fechado
                                      });
                                    }
                                    _onItemTapped(11);
                                  },
                                ),
                              ],
                            ),
                            buildListTile(
                              imagePath: 'assets/image/aluno.png',
                              index: 0,
                              title: "Alunos",
                              onTap: () {
                                _onItemTapped(0);
                              },
                            ),
                            buildListTile(
                              imagePath: 'assets/image/professojiujtsu.png',
                              index: 1,
                              title: "Professores",
                              onTap: () {
                                _onItemTapped(1);
                              },
                            ),
                            buildListTile(
                              imagePath: 'assets/image/faixa.png',
                              index: 2,
                              title: "Faixas",
                              onTap: () {
                                _onItemTapped(2);
                              },
                            ),
                            buildListTile(
                              imagePath: 'assets/image/evento.png',
                              index: 3,
                              title: "Eventos",
                              onTap: () {
                                _onItemTapped(3);
                              },
                            ),
                            buildListTile(
                              imagePath: 'assets/image/addfrequencia.png',
                              index: 4,
                              title: "Frequências",
                              onTap: () {
                                _onItemTapped(4);
                              },
                            ),
                            buildListTile(
                              imagePath: 'assets/image/listafrequencia.png',
                              index: 5,
                              title: "Lista de Frequências",
                              onTap: () {
                                _onItemTapped(5);
                              },
                            ),
                            buildListTile(
                              imagePath: 'assets/image/turma.png',
                              index: 6,
                              title: "Turmas",
                              onTap: () {
                                _onItemTapped(6);
                              },
                            ),
                            buildListTile(
                              imagePath: 'assets/image/sobre.png',
                              title: "Sobre",
                              onTap: () {
                                _onItemTapped(12);
                              },
                              index: 12,
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
                          builder: (context) =>
                              _getSelectedScreen(_selectedIndex),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
            AnimatedPositioned(
              duration: const Duration(milliseconds: 300),
              top: topPosition,
              left: isExpanded ? null : leftPosition,
              right: isExpanded ? rightPosition : null,
              child: CircleAvatar(
                radius: avatarRadius,
                backgroundColor: Colors.blueAccent,
                child: IconButton(
                  icon: Icon(isExpanded
                      ? Icons.arrow_back_ios
                      : Icons.arrow_forward_ios),
                  onPressed: () {
                    setState(() {
                      isExpanded = !isExpanded;
                    });
                  },
                  color: const Color(0xFFFFFFFF),
                  iconSize: iconSize,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildListTile({
    required int index,
    required String imagePath,
    required String title,
    required VoidCallback onTap,
  }) {
    bool isSelected = _selectedIndex == index;

    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: Container(
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF555555) : Colors.transparent,
            borderRadius: BorderRadius.circular(5),
            boxShadow: isSelected
                ? [
                    const BoxShadow(
                      color: Colors.black12,
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ]
                : [],
          ),
          child: ListTile(
            leading: Image.asset(
              imagePath,
              height: 22,
              color: isSelected ? Colors.blue : Colors.white54,
            ),
            title: isExpanded
                ? Text(
                    title,
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      color: isSelected ? Colors.blue : Colors.white54,
                      fontWeight: FontWeight.w600,
                    ),
                  )
                : null,
          ),
        ),
      ),
    );
  }

  Widget buildSubListTile({
    required String title,
    required VoidCallback onTap,
    required int index,
  }) {
    bool isSelected = _selectedIndex == index;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF555555) : Colors.transparent,
          borderRadius: BorderRadius.circular(5),
          boxShadow: isSelected
              ? [
                  const BoxShadow(
                    color: Colors.black12,
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ]
              : [],
        ),
        child: ListTile(
          onTap: onTap,
          title: isExpanded
              ? Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: isSelected ? Colors.blue : Colors.white54,
                    fontWeight: FontWeight.w600,
                  ),
                )
              : null,
        ),
      ),
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
