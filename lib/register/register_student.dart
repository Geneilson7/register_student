// ignore_for_file: avoid_print, use_build_context_synchronously, deprecated_member_use
import 'package:flutter/material.dart';
import 'package:register_student/src/home_page.dart';
import 'package:register_student/util/form.dart';


class RegistreStudent extends StatefulWidget {
  final bool isEditMode; // Indica se estamos em modo de edição ou não
  final int? productId;

  const RegistreStudent({
    Key? key,
    this.isEditMode = false,
    this.productId,
  }) : super(key: key);

  @override
  State<RegistreStudent> createState() => _RegistreStudentState();
}

class _RegistreStudentState extends State<RegistreStudent> {
  TextEditingController codigoController = TextEditingController();
  TextEditingController cpfcnpjController = TextEditingController();
  TextEditingController razaosocialController = TextEditingController();
  TextEditingController fantaziaController = TextEditingController();
  TextEditingController contatoController = TextEditingController();
  String cidadeValue = '';
  TextEditingController enderecoController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  int? selectedClienteId;
  String? userId;
 

  final _formKey = GlobalKey<FormState>();
  bool isEntrando = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (context) => const HomePage(),
              ),
              (route) => false,
            );
          },
          iconSize: 20,
          icon: const Icon(Icons.arrow_back_ios),
          color: const Color(0xFF1F41BB),
        ),
        title: Text(
          widget.isEditMode ? 'Alterar Aluno' : 'Cadastrar Aluno',
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Color(0xFF404046),
          ),
        ),
        centerTitle: true,
        toolbarHeight: 60,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 60,
            vertical: 5,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [                
                Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: TextFormField(
                    decoration: textFormField("Nome"),
                    controller: razaosocialController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Razão Social não pode está vazio.";
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: 50,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(11),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF1F41BB).withOpacity(0.2),
                          spreadRadius: 0,
                          blurRadius: 4,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF262c40),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(11),
                        ),
                      ),
                      onPressed: () async {
                        // Logica
                        // cadastrarClienteAction(context);                      
                      },
                      child: const Center(
                        child: Text(
                          'Concluir',
                          style: TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                // Padding(
                //     padding: EdgeInsets.only(top: widget.isEditMode ? 20 : 68)),
                // Align(
                //   alignment: Alignment.bottomCenter,
                //   child: Image.asset(
                //     'assets/images/logo.png',
                //     height: 120,
                //     width: 120,
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  botaoEnviarClicado() {
    String codigo = codigoController.text;
    String cpfcnpj = cpfcnpjController.text;
    String razaosocial = razaosocialController.text;
    String fantazia = fantaziaController.text;
    String contato = contatoController.text;
    String email = emailController.text;

    if (_formKey.currentState!.validate()) {
      if (isEntrando) {
        _entrarUsuario(
          codigo: codigo,
          cpfcnpj: cpfcnpj,
          razaosocial: razaosocial,
          fantazia: fantazia,
          contato: contato,
          email: email,
        );
      } else {
        return null;
      }
    }
  }

  _entrarUsuario({
    required String codigo,
    required String cpfcnpj,
    required String razaosocial,
    required String fantazia,
    required String contato,
    required String email,
  }) {
    return _entrarUsuario(
        codigo: codigo,
        cpfcnpj: cpfcnpj,
        razaosocial: razaosocial,
        fantazia: fantazia,
        contato: contato,
        email: email);
  }
}
