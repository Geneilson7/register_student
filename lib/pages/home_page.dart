// ignore_for_file: use_build_context_synchronously, deprecated_member_use

import 'package:flutter/material.dart';
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

  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _cpfController = TextEditingController();
  final TextEditingController _rgController = TextEditingController();
  final TextEditingController _dtnascimentoController = TextEditingController();
  final TextEditingController _pcdController = TextEditingController();
  final TextEditingController _sexoController = TextEditingController();
  final TextEditingController _statusController = TextEditingController();
  final TextEditingController _bairroController = TextEditingController();
  final TextEditingController _enderecoController = TextEditingController();
  final TextEditingController _municipioController = TextEditingController();
  final TextEditingController _responsavelController = TextEditingController();
  final TextEditingController _telefoneController = TextEditingController();
  final TextEditingController _telresponsavelController =
      TextEditingController();
  final TextEditingController _cepController = TextEditingController();
  final TextEditingController _escolaController = TextEditingController();
  final TextEditingController _endescolaController = TextEditingController();
  final TextEditingController _turnoescolarController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _refreshItems();
  }

  void _refreshItems() async {
    final data = await dbHelper.getAlunos();
    setState(() {
      _items = data;
    });
  }

  void _deleteItem(int id) async {
    await dbHelper.deleteAluno(id);
    _refreshItems();
  }

  void _updateItem(int id) async {
    if (_nomeController.text.isEmpty) return;
    await dbHelper.updateAluno(id, {
      'nome': _nomeController.text,
      'cpf': _cpfController.text,
      'rg': _rgController.text,
      'dtnascimento': _dtnascimentoController.text,
      'pcd': _pcdController.text,
      'sexo': _sexoController.text,
      'status': _statusController.text,
      'bairro': _bairroController.text,
      'endereco': _enderecoController.text,
      'municipio': _municipioController.text,
      'responsavel': _responsavelController.text,
      'telefone': _telefoneController.text,
      'telresponsavel': _telresponsavelController.text,
      'cep': _cepController.text,
      'escola': _escolaController.text,
      'endescola': _endescolaController.text,
      'turnoescolar': _turnoescolarController.text
    });
    _clearControllers();
    _refreshItems();
  }

  void _clearControllers() {
    _nomeController.clear();
    _cpfController.clear();
    _rgController.clear();
    _dtnascimentoController.clear();
    _pcdController.clear();
    _sexoController.clear();
    _statusController.clear();
    _bairroController.clear();
    _enderecoController.clear();
    _municipioController.clear();
    _responsavelController.clear();
    _telefoneController.clear();
    _telresponsavelController.clear();
    _cepController.clear();
    _escolaController.clear();
    _endescolaController.clear();
    _turnoescolarController.clear();
  }

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
      body: Column(
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
              itemCount: _items.length,
              itemBuilder: (context, index) {
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
                                    builder: (context) => CadastrarAluno(
                                      alunoId: _items[index]['id'],
                                    ),
                                  ),
                                ).then((value) => _refreshItems());
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
                                    _items[index]['id']
                                        .toString()
                                        .toUpperCase(),
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
                                  _items[index]['nome']
                                      .toString()
                                      .toUpperCase(),
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF1C1C1C),
                                  ),
                                ),
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    ),
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (_) {
                                          return AlertDialog(
                                            title: const Text(
                                              'Confirmação',
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w500,
                                                color: Color(0xFF000000),
                                              ),
                                            ),
                                            content: const Text(
                                                'Deseja realmente concluir a exclusão?'),
                                            actions: <Widget>[
                                              ElevatedButton(
                                                onPressed: () async {
                                                  _deleteItem(
                                                      _items[index]['id']);

                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          WillPopScope(
                                                        onWillPop: () async {
                                                          Navigator
                                                              .pushReplacement(
                                                            context,
                                                            MaterialPageRoute(
                                                              builder: (context) =>
                                                                  const HomePage(),
                                                            ),
                                                          );
                                                          return false;
                                                        },
                                                        child: const HomePage(),
                                                      ),
                                                    ),
                                                  );
                                                },
                                                style: ElevatedButton.styleFrom(
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            13),
                                                  ),
                                                  elevation: 3,
                                                  backgroundColor:
                                                      const Color(0xFFda2828),
                                                ),
                                                child: const Text(
                                                  'Sim',
                                                  style: TextStyle(
                                                    color: Color(0xFFFFFFFF),
                                                  ),
                                                ),
                                              ),
                                              ElevatedButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                style: ElevatedButton.styleFrom(
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            13),
                                                  ),
                                                  elevation: 3,
                                                  backgroundColor:
                                                      const Color(0xFF008000),
                                                ),
                                                child: const Text(
                                                  'Não',
                                                  style: TextStyle(
                                                    color: Color(0xFFFFFFFF),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
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
                builder: (context) => const CadastrarAluno(),
              ),
            );
            // .then(
            //   (value) => selecionarTodosOsStudents(),
            // );
          },
          backgroundColor: const Color(0xFF262c40),
          foregroundColor: const Color(0xFFFFFFFF),
          child: const Icon(Icons.add, size: 30),
        ),
      ),
    );
  }
}
