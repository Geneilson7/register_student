// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:register_student/register/register_student.dart';
import 'package:register_student/shared/dao/student_dao.dart';
import 'package:register_student/shared/models/student_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();

  List<Student> student = [];

  StudentDao studentDao = StudentDao();

  void selecionarTodosOsStudents() async {
    try {
      List<Student> retorno = await studentDao.selecionarTodos();
      student.clear();
      student.addAll(retorno);
      setState(() {});
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Erro ao buscar aluno'),
        ),
      );
    }
  }

  @override
  void initState() {
    selecionarTodosOsStudents();
    super.initState();
  }

  // List<Cliente> filterClientes(List<Cliente> clientes, String query) {
  //   if (query.isEmpty) {
  //     return clientes;
  //   }
  //   final lowerQuery = query.toLowerCase();
  //   return clientes.where((cliente) {
  //     final id = cliente.id.toString().toLowerCase();
  //     final name = cliente.name.toLowerCase();
  //     return id.contains(lowerQuery) || name.contains(lowerQuery);
  //   }).toList();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFFFFF),
        title: const Text(
          "Alunos",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Color(0xff404046),
          ),
        ),
        centerTitle: true,
        toolbarHeight: 60,
        elevation: 0,
      ),
      body:
          //  FutureBuilder<List<Cliente>>(
          //   future: _futureClientes,
          //   builder: (context, snapshot) {
          //     if (snapshot.connectionState == ConnectionState.waiting) {
          //       return const Center(child: CircularProgressIndicator());
          //     } else if (snapshot.hasError) {
          //       return Center(child: Text('Error: ${snapshot.error}'));
          //     } else {
          //       final List<Cliente> filteredClientes = filterClientes(snapshot.data!, _searchController.text);

          //       return
          Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 10),
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
                  setState(() {});
                },
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.transparent,
                  isDense: true,
                  hintText: 'Pesquisar',
                  hintStyle: const TextStyle(
                    color: Color(0xFF15133D),
                    fontSize: 14,
                    fontStyle: FontStyle.italic,
                  ),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          onPressed: () {
                            _searchController.clear();
                            setState(() {});
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
          Expanded(
            child: ListView.builder(
              primary: false,
              shrinkWrap: true,
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              itemCount: student.length,
              itemBuilder: (context, index) {
                Student students = student[index];
                // final user = users[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 60,
                    vertical: 5,
                  ),
                  child: Container(
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
                      child: Row(
                        children: [
                          Expanded(
                            child: ListTile(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              onTap: () async {
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => RegistreStudent(
                                      student: students,
                                    ),
                                  ),
                                ).then((value) => selecionarTodosOsStudents());
                              },
                              tileColor: const Color(0xFFFFFFFF),
                              leading: Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF262c40),
                                  borderRadius: BorderRadius.circular(40),
                                ),
                                child: Center(
                                  child: Text(
                                    // user.id.toString().toUpperCase(),
                                    students.id.toString(),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ),
                              title: Padding(
                                padding: const EdgeInsets.only(left: 10.0),
                                child: Text(
                                  // cliente.name.toUpperCase(),
                                  students.nome,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF1C1C1C),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          // ElevatedButton(
                          //   onPressed: () async {
                          // setState(() {
                          //   selectedClienteId = int.tryParse(cliente.id);
                          // });
                          // showDialog(
                          //   context: context,
                          //   builder: (_) {
                          //     return ButtonDialogCliente(
                          //       productId: selectedClienteId,
                          //     );
                          //   },
                          // );
                          //   },
                          //   style: ElevatedButton.styleFrom(
                          //     backgroundColor: Colors.transparent,
                          //     elevation: 0,
                          //     padding: EdgeInsets.zero,
                          //     shape: RoundedRectangleBorder(
                          //       borderRadius: BorderRadius.circular(10),
                          //     ),
                          //   ),
                          //   child: const Icon(
                          //     Icons.more_vert,
                          //     color: Color(0xFFD8DEF3),
                          //     size: 30,
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 50),
        child: FloatingActionButton(
          onPressed: () async {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => RegistreStudent(),
              ),
            ).then(
              (value) => selecionarTodosOsStudents(),
            );
          },
          backgroundColor: const Color(0xFF262c40),
          foregroundColor: const Color(0xFFFFFFFF),
          child: const Icon(Icons.add, size: 30),
        ),
      ),
    );
  }
}
