// ignore_for_file: use_build_context_synchronously, deprecated_member_use, avoid_print

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:register_student/pages/sobre.dart';
import 'package:register_student/services/db_helper.dart';
import 'package:register_student/pages/cadastrar_aluno.dart';

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
        return CadastrarAluno(showButton: false);
      case 1:
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
                        ExpansionTile(
                          leading: const Icon(
                            Icons.group,
                            color: Colors.white54,
                          ),
                          iconColor: Colors.white54,
                          collapsedIconColor: Colors.white54,
                          title: Text(
                            "Cadastro",
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
                                _onItemTapped(0);
                              },
                            ),
                            buildSubListTile(
                              "Cadastrar Faixa",
                              () {},
                            ),
                          ],
                        ),
                        buildListTile(
                          Icons.info,
                          "Sobre",
                          () {
                            _onItemTapped(1);
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              // Column(
              //   children: [
              //     DrawerHeader(
              //       child: Image.asset(
              //         'assets/image/logo.png',
              //         color:  Color(0xFFFFFFFF),
              //         width: 400,
              //         fit: BoxFit.contain,
              //       ),
              //     ),
              //     ListTile(
              //       onTap: () {
              //         Navigator.push(
              //           context,
              //           MaterialPageRoute(
              //             builder: (context) =>  CadastrarAluno(),
              //           ),
              //         );
              //       },
              //       leading:  Icon(
              //         Icons.group,
              //         size: 25,
              //         color: Colors.white54,
              //         // color: Color(0xFF000000),
              //       ),
              //       title:  Text(
              //         "Cadastrar Aluno",
              //         style: GoogleFonts.poppins(
              //           color: Colors.white54,
              //           fontWeight: FontWeight.w600,
              //         ),
              //       ),
              //     ),
              //     ListTile(
              //       onTap: () {
              //         Navigator.push(
              //           context,
              //           MaterialPageRoute(
              //             builder: (context) =>  CadastrarAluno(),
              //           ),
              //         );
              //       },
              //       leading:  Icon(
              //         Icons.group,
              //         size: 25,
              //         color: Colors.white54,
              //         // color: Color(0xFF000000),
              //       ),
              //       title:  Text(
              //         "Cadastrar Faixa",
              //         style: GoogleFonts.poppins(
              //           color: Colors.white54,
              //           fontWeight: FontWeight.w600,
              //         ),
              //       ),
              //     ),
              //     ListTile(
              //       onTap: () {
              //         Navigator.push(
              //           context,
              //           MaterialPageRoute(
              //             builder: (context) =>  Sobre(),
              //           ),
              //         );
              //       },
              //       leading:  Icon(
              //         Icons.info,
              //         size: 25,
              //         color: Colors.white54,
              //         // color: Color(0xFF000000),
              //       ),
              //       title:  Text(
              //         "Sobre",
              //         style: GoogleFonts.poppins(
              //           color: Colors.white54,
              //           fontWeight: FontWeight.w600,
              //         ),
              //       ),
              //     ),
              //   ],
              // ),
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
            // Expanded(
            //   flex: 4,
            //   child: Container(
            //     // decoration:  BoxDecoration(
            //     //   image: DecorationImage(
            //     //     image: AssetImage(
            //     //       'assets/image/background.jpg',
            //     //     ),
            //     //     fit: BoxFit.fill,
            //     //     opacity: 10,
            //     //   ),
            //     // ),
            //     color: const Color(0xffecf0f4),
            //     child: Column(
            //       children: [
            //         Padding(
            //           padding: const EdgeInsets.only(top: 20),
            //           child: Row(
            //             mainAxisAlignment: MainAxisAlignment.center,
            //             children: [
            //               Text(
            //                 "Home",
            //                 style: GoogleFonts.poppins(
            //                   fontSize: 20,
            //                   fontWeight: FontWeight.w700,
            //                   color: const Color(0xFF000000),
            //                 ),
            //               ),
            //             ],
            //           ),
            //         ),
            //         const SizedBox(
            //           height: 10,
            //         ),
            //         Padding(
            //           padding: const EdgeInsets.only(top: 10),
            //           child: Row(
            //             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //             children: [
            //               Expanded(
            //                 child: CustomButton(
            //                   text: 'Matriculados',
            //                   icon: Icons.group,
            //                   iconColor: Colors.blueAccent,
            //                   backgroundColor: const Color(0xFF2E374B),
            //                   value: '$_alunoCount',
            //                 ),
            //               ),
            //               Expanded(
            //                 child: CustomButton(
            //                   text: 'Ativos',
            //                   icon: Icons.check_circle,
            //                   iconColor: Colors.green,
            //                   backgroundColor: const Color(0xFF2E374B),
            //                   value: '$_ativoCount',
            //                 ),
            //               ),
            //               Expanded(
            //                 child: CustomButton(
            //                   text: 'Inativos',
            //                   icon: Icons.cancel,
            //                   iconColor: Colors.red,
            //                   backgroundColor: const Color(0xFF2E374B),
            //                   value: '$_inativoCount',
            //                 ),
            //               ),
            //             ],
            //           ),
            //         ),
            //         Padding(
            //           padding: const EdgeInsets.symmetric(
            //               horizontal: 15, vertical: 10),
            //           child: Container(
            //             decoration: BoxDecoration(
            //               color: Colors.white,
            //               borderRadius: BorderRadius.circular(10),
            //               boxShadow: [
            //                 BoxShadow(
            //                   color: Colors.grey.withOpacity(0.5),
            //                   spreadRadius: 0,
            //                   blurRadius: 7,
            //                   offset: const Offset(0, 3),
            //                 ),
            //               ],
            //             ),
            //             child: TextFormField(
            //               controller: _searchController,
            //               onChanged: (value) {
            //                 _performSearch(value);
            //               },
            //               decoration: InputDecoration(
            //                 filled: true,
            //                 fillColor: Colors.transparent,
            //                 isDense: true,
            //                 hintText: 'Pesquisar',
            //                 hintStyle: GoogleFonts.poppins(
            //                   color: const Color(0xFF15133D),
            //                   fontSize: 14,
            //                   fontStyle: FontStyle.italic,
            //                 ),
            //                 suffixIcon: _searchController.text.isNotEmpty
            //                     ? IconButton(
            //                         onPressed: () {
            //                           _searchController.clear();
            //                           _performSearch('');
            //                         },
            //                         icon: const Icon(
            //                           Icons.clear,
            //                           color: Colors.black,
            //                           size: 21,
            //                         ),
            //                       )
            //                     : const Icon(
            //                         Icons.search,
            //                         color: Colors.black,
            //                         size: 21,
            //                       ),
            //                 border: OutlineInputBorder(
            //                   borderRadius: BorderRadius.circular(10),
            //                   borderSide: const BorderSide(
            //                     width: 0,
            //                     style: BorderStyle.none,
            //                   ),
            //                 ),
            //               ),
            //             ),
            //           ),
            //         ),
            //         Padding(
            //           padding: const EdgeInsets.symmetric(horizontal: 15),
            //           child: Container(
            //             decoration: BoxDecoration(
            //               color: Colors.white,
            //               borderRadius: BorderRadius.circular(10),
            //               boxShadow: [
            //                 BoxShadow(
            //                   color: Colors.grey.withOpacity(0.5),
            //                   spreadRadius: 2,
            //                   blurRadius: 7,
            //                   offset: const Offset(0, 4),
            //                 ),
            //               ],
            //             ),
            //             child: Column(
            //               crossAxisAlignment: CrossAxisAlignment.stretch,
            //               children: [
            //                 SingleChildScrollView(
            //                   child: DataTable(
            //                     columns: [
            //                       DataColumn(
            //                         label: Text(
            //                           'Código',
            //                           style: GoogleFonts.poppins(
            //                             color: Colors.black,
            //                             fontWeight: FontWeight.bold,
            //                             fontSize: 16,
            //                           ),
            //                         ),
            //                       ),
            //                       DataColumn(
            //                         label: Text(
            //                           'Nome',
            //                           style: GoogleFonts.poppins(
            //                             color: Colors.black,
            //                             fontWeight: FontWeight.bold,
            //                             fontSize: 16,
            //                           ),
            //                         ),
            //                       ),
            //                       DataColumn(
            //                         label: Text(
            //                           'Turno',
            //                           style: GoogleFonts.poppins(
            //                             color: Colors.black,
            //                             fontWeight: FontWeight.bold,
            //                             fontSize: 16,
            //                           ),
            //                         ),
            //                       ),
            //                       DataColumn(
            //                         label: Text(
            //                           'Status',
            //                           style: GoogleFonts.poppins(
            //                             color: Colors.black,
            //                             fontWeight: FontWeight.bold,
            //                             fontSize: 16,
            //                           ),
            //                         ),
            //                       ),
            //                       DataColumn(
            //                         label: Text(
            //                           'Ações',
            //                           style: GoogleFonts.poppins(
            //                             color: Colors.black,
            //                             fontWeight: FontWeight.bold,
            //                             fontSize: 16,
            //                           ),
            //                         ),
            //                       ),
            //                     ],
            //                     rows: _items.asMap().entries.map((entry) {
            //                       final index = entry.key;
            //                       final item = entry.value;

            //                       return DataRow(
            //                         color: MaterialStateProperty.resolveWith<
            //                             Color?>(
            //                           (Set<MaterialState> states) {
            //                             Color? statusColor =
            //                                 _getStatusColor(item['status']);
            //                             if (statusColor !=
            //                                 const Color(0xFFFFFFFF)) {
            //                               return statusColor;
            //                             }
            //                             return index.isEven
            //                                 ? Colors.grey[200]
            //                                 : Colors.white;
            //                           },
            //                         ),
            //                         cells: [
            //                           DataCell(
            //                             Text(
            //                               item['id'].toString().toUpperCase(),
            //                               style: GoogleFonts.poppins(
            //                                 fontWeight: FontWeight.bold,
            //                                 color: Colors.black,
            //                                 fontSize: 16,
            //                               ),
            //                             ),
            //                             onTap: () async {
            //                               await Navigator.push(
            //                                 context,
            //                                 MaterialPageRoute(
            //                                   builder: (context) =>
            //                                       CadastrarAluno(
            //                                           alunoId: item['id']),
            //                                 ),
            //                               ).then((value) => _refreshItems());
            //                             },
            //                           ),
            //                           DataCell(
            //                             Text(
            //                               item['nome'].toString().toUpperCase(),
            //                               style: GoogleFonts.poppins(
            //                                 fontSize: 16,
            //                                 fontWeight: FontWeight.w700,
            //                                 color: const Color(0xFF1C1C1C),
            //                               ),
            //                             ),
            //                             onTap: () async {
            //                               await Navigator.push(
            //                                 context,
            //                                 MaterialPageRoute(
            //                                   builder: (context) =>
            //                                       CadastrarAluno(
            //                                           alunoId: item['id']),
            //                                 ),
            //                               ).then((value) => _refreshItems());
            //                             },
            //                           ),
            //                           DataCell(
            //                             Text(
            //                               item['turnotreino']
            //                                   .toString()
            //                                   .toUpperCase(),
            //                               style: GoogleFonts.poppins(
            //                                 fontSize: 16,
            //                                 fontWeight: FontWeight.w700,
            //                                 color: const Color(0xFF1C1C1C),
            //                               ),
            //                             ),
            //                             onTap: () async {
            //                               await Navigator.push(
            //                                 context,
            //                                 MaterialPageRoute(
            //                                   builder: (context) =>
            //                                       CadastrarAluno(
            //                                           alunoId: item['id']),
            //                                 ),
            //                               ).then((value) => _refreshItems());
            //                             },
            //                           ),
            //                           DataCell(
            //                             Text(
            //                               item['status']
            //                                   .toString()
            //                                   .toUpperCase(),
            //                               style: GoogleFonts.poppins(
            //                                 fontSize: 16,
            //                                 fontWeight: FontWeight.w700,
            //                                 color: const Color(0xFF1C1C1C),
            //                               ),
            //                             ),
            //                             onTap: () async {
            //                               await Navigator.push(
            //                                 context,
            //                                 MaterialPageRoute(
            //                                   builder: (context) =>
            //                                       CadastrarAluno(
            //                                           alunoId: item['id']),
            //                                 ),
            //                               ).then((value) => _refreshItems());
            //                             },
            //                           ),
            //                           DataCell(
            //                             IconButton(
            //                               icon: const Icon(
            //                                 Icons.delete,
            //                                 color: Colors.red,
            //                               ),
            //                               onPressed: () {
            //                                 showDialog(
            //                                   context: context,
            //                                   builder: (_) {
            //                                     return AlertDialog(
            //                                       title: Text(
            //                                         'Confirmação',
            //                                         style: GoogleFonts.poppins(
            //                                           fontSize: 18,
            //                                           fontWeight:
            //                                               FontWeight.w500,
            //                                           color: const Color(
            //                                               0xFF000000),
            //                                         ),
            //                                       ),
            //                                       content: const Text(
            //                                           'Deseja realmente concluir a exclusão?'),
            //                                       actions: <Widget>[
            //                                         ElevatedButton(
            //                                           onPressed: () async {
            //                                             _deleteItem(item['id']);
            //                                             Navigator
            //                                                 .pushReplacement(
            //                                               context,
            //                                               MaterialPageRoute(
            //                                                 builder:
            //                                                     (context) =>
            //                                                         HomePage(),
            //                                               ),
            //                                             );
            //                                           },
            //                                           style: ElevatedButton
            //                                               .styleFrom(
            //                                             shape:
            //                                                 RoundedRectangleBorder(
            //                                               borderRadius:
            //                                                   BorderRadius
            //                                                       .circular(13),
            //                                             ),
            //                                             elevation: 3,
            //                                             backgroundColor:
            //                                                 const Color(
            //                                                     0xFFda2828),
            //                                           ),
            //                                           child: Text(
            //                                             'Sim',
            //                                             style: GoogleFonts.poppins(
            //                                                 color: const Color(
            //                                                     0xFFFFFFFF)),
            //                                           ),
            //                                         ),
            //                                         ElevatedButton(
            //                                           onPressed: () {
            //                                             Navigator.of(context)
            //                                                 .pop();
            //                                           },
            //                                           style: ElevatedButton
            //                                               .styleFrom(
            //                                             shape:
            //                                                 RoundedRectangleBorder(
            //                                               borderRadius:
            //                                                   BorderRadius
            //                                                       .circular(13),
            //                                             ),
            //                                             elevation: 3,
            //                                             backgroundColor:
            //                                                 const Color(
            //                                                     0xFF008000),
            //                                           ),
            //                                           child: Text(
            //                                             'Não',
            //                                             style: GoogleFonts.poppins(
            //                                                 color: const Color(
            //                                                     0xFFFFFFFF)),
            //                                           ),
            //                                         ),
            //                                       ],
            //                                     );
            //                                   },
            //                                 );
            //                               },
            //                             ),
            //                           ),
            //                         ],
            //                       );
            //                     }).toList(),
            //                   ),
            //                 ),
            //               ],
            //             ),
            //           ),
            //         ),

            //         // Expanded(
            //         //   child: ListView.builder(
            //         //     primary: false,
            //         //     shrinkWrap: true,
            //         //     keyboardDismissBehavior:
            //         //         ScrollViewKeyboardDismissBehavior.onDrag,
            //         //     itemCount: _items.length,
            //         //     itemBuilder: (context, index) {
            //         //       // final user = users[index];

            //         //       return Padding(
            //         //         padding:  EdgeInsets.symmetric(
            //         //           horizontal: 60,
            //         //           vertical: 5,
            //         //         ),
            //         //         child: Container(
            //         //           decoration: BoxDecoration(
            //         //             borderRadius: BorderRadius.circular(25),
            //         //             boxShadow: [
            //         //               BoxShadow(
            //         //                 color: Colors.grey.withOpacity(0.5),
            //         //                 spreadRadius: 0,
            //         //                 blurRadius: 5,
            //         //                 offset:  Offset(0, 3),
            //         //               ),
            //         //             ],
            //         //           ),
            //         //           child: Card(
            //         //             color: _getStatusColor(_items[index]['status']),
            //         //             elevation: 0,
            //         //             child: Row(
            //         //               children: [
            //         //                 Expanded(
            //         //                   child: ListTile(
            //         //                     shape: RoundedRectangleBorder(
            //         //                       borderRadius:
            //         //                           BorderRadius.circular(20),
            //         //                     ),
            //         //                     onTap: () async {
            //         //                       await Navigator.push(
            //         //                         context,
            //         //                         MaterialPageRoute(
            //         //                           builder: (context) =>
            //         //                               CadastrarAluno(
            //         //                             alunoId: _items[index]['id'],
            //         //                           ),
            //         //                         ),
            //         //                       ).then((value) => _refreshItems());
            //         //                     },
            //         //                     tileColor: _getStatusColor(
            //         //                         _items[index]['status']),
            //         //                     leading: Container(
            //         //                       width: 40,
            //         //                       height: 40,
            //         //                       decoration: BoxDecoration(
            //         //                         color:  Color(0xFF262c40),
            //         //                         borderRadius:
            //         //                             BorderRadius.circular(40),
            //         //                       ),
            //         //                       child: Center(
            //         //                         child: Text(
            //         //                           // user.id.toString().toUpperCase(),
            //         //                           _items[index]['id']
            //         //                               .toString()
            //         //                               .toUpperCase(),
            //         //                           style:  GoogleFonts.poppins(
            //         //                             color: Colors.white,
            //         //                             fontWeight: FontWeight.bold,
            //         //                             fontSize: 16,
            //         //                           ),
            //         //                         ),
            //         //                       ),
            //         //                     ),
            //         //                     title: Padding(
            //         //                       padding:
            //         //                            EdgeInsets.only(left: 10.0),
            //         //                       child: Text(
            //         //                         // cliente.name.toUpperCase(),
            //         //                         _items[index]['nome']
            //         //                             .toString()
            //         //                             .toUpperCase(),
            //         //                         style:  GoogleFonts.poppins(
            //         //                           fontSize: 16,
            //         //                           fontWeight: FontWeight.w700,
            //         //                           color: Color(0xFF1C1C1C),
            //         //                         ),
            //         //                       ),
            //         //                     ),
            //         //                     trailing: Row(
            //         //                       mainAxisSize: MainAxisSize.min,
            //         //                       children: [
            //         //                         IconButton(
            //         //                           icon:  Icon(
            //         //                             Icons.delete,
            //         //                             color: Colors.red,
            //         //                           ),
            //         //                           onPressed: () {
            //         //                             showDialog(
            //         //                               context: context,
            //         //                               builder: (_) {
            //         //                                 return AlertDialog(
            //         //                                   title:  Text(
            //         //                                     'Confirmação',
            //         //                                     style: GoogleFonts.poppins(
            //         //                                       fontSize: 18,
            //         //                                       fontWeight:
            //         //                                           FontWeight.w500,
            //         //                                       color:
            //         //                                           Color(0xFF000000),
            //         //                                     ),
            //         //                                   ),
            //         //                                   content:  Text(
            //         //                                       'Deseja realmente concluir a exclusão?'),
            //         //                                   actions: <Widget>[
            //         //                                     ElevatedButton(
            //         //                                       onPressed: () async {
            //         //                                         _deleteItem(
            //         //                                             _items[index]
            //         //                                                 ['id']);

            //         //                                         Navigator.push(
            //         //                                           context,
            //         //                                           MaterialPageRoute(
            //         //                                             builder:
            //         //                                                 (context) =>
            //         //                                                     WillPopScope(
            //         //                                               onWillPop:
            //         //                                                   () async {
            //         //                                                 Navigator
            //         //                                                     .pushReplacement(
            //         //                                                   context,
            //         //                                                   MaterialPageRoute(
            //         //                                                     builder:
            //         //                                                         (context) =>
            //         //                                                              HomePage(),
            //         //                                                   ),
            //         //                                                 );
            //         //                                                 return false;
            //         //                                               },
            //         //                                               child:
            //         //                                                    HomePage(),
            //         //                                             ),
            //         //                                           ),
            //         //                                         );
            //         //                                       },
            //         //                                       style: ElevatedButton
            //         //                                           .styleFrom(
            //         //                                         shape:
            //         //                                             RoundedRectangleBorder(
            //         //                                           borderRadius:
            //         //                                               BorderRadius
            //         //                                                   .circular(
            //         //                                                       13),
            //         //                                         ),
            //         //                                         elevation: 3,
            //         //                                         backgroundColor:
            //         //                                              Color(
            //         //                                                 0xFFda2828),
            //         //                                       ),
            //         //                                       child:  Text(
            //         //                                         'Sim',
            //         //                                         style: GoogleFonts.poppins(
            //         //                                           color: Color(
            //         //                                               0xFFFFFFFF),
            //         //                                         ),
            //         //                                       ),
            //         //                                     ),
            //         //                                     ElevatedButton(
            //         //                                       onPressed: () {
            //         //                                         Navigator.of(
            //         //                                                 context)
            //         //                                             .pop();
            //         //                                       },
            //         //                                       style: ElevatedButton
            //         //                                           .styleFrom(
            //         //                                         shape:
            //         //                                             RoundedRectangleBorder(
            //         //                                           borderRadius:
            //         //                                               BorderRadius
            //         //                                                   .circular(
            //         //                                                       13),
            //         //                                         ),
            //         //                                         elevation: 3,
            //         //                                         backgroundColor:
            //         //                                              Color(
            //         //                                                 0xFF008000),
            //         //                                       ),
            //         //                                       child:  Text(
            //         //                                         'Não',
            //         //                                         style: GoogleFonts.poppins(
            //         //                                           color: Color(
            //         //                                               0xFFFFFFFF),
            //         //                                         ),
            //         //                                       ),
            //         //                                     ),
            //         //                                   ],
            //         //                                 );
            //         //                               },
            //         //                             );
            //         //                           },
            //         //                         ),
            //         //                       ],
            //         //                     ),
            //         //                   ),
            //         //                 ),
            //         //               ],
            //         //             ),
            //         //           ),
            //         //         ),
            //         //       );
            //         //     },
            //         //   ),
            //         // ),
            //       ],
            //     ),
            //   ),
            // ),
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
