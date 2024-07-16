// ignore_for_file: avoid_print, use_build_context_synchronously, deprecated_member_use, must_be_immutable, use_key_in_widget_constructors
import 'package:flutter/material.dart';
import 'package:register_student/shared/dao/student_dao.dart';
import 'package:register_student/shared/models/student_model.dart';
import 'package:register_student/src/home_page.dart';
import 'package:register_student/util/form.dart';

class RegistreStudent extends StatefulWidget {
  Student? student;
  RegistreStudent({this.student});

  @override
  State<RegistreStudent> createState() => _RegistreStudentState();
}

class _RegistreStudentState extends State<RegistreStudent> {
  final _formKey = GlobalKey<FormState>();

  Student student = Student.empty();

  StudentDao studentDao = StudentDao();

  TextEditingController txtNome = TextEditingController();
  TextEditingController txtCpfCnpj = TextEditingController();
  TextEditingController txtRg = TextEditingController();
  TextEditingController txtDtnascimento = TextEditingController();
  TextEditingController txtPcd = TextEditingController();
  TextEditingController txtSexo = TextEditingController();
  TextEditingController txtStatus = TextEditingController();
  TextEditingController txtBairro = TextEditingController();
  TextEditingController txtEndereco = TextEditingController();
  TextEditingController txtMunicipio = TextEditingController();
  TextEditingController txtResponsavel = TextEditingController();
  TextEditingController txtTelefone = TextEditingController();
  TextEditingController txtTelresponsavel = TextEditingController();
  TextEditingController txtCep = TextEditingController();
  TextEditingController txtEscola = TextEditingController();
  TextEditingController txtEndescola = TextEditingController();
  TextEditingController txtTurnoescolar = TextEditingController();

  void iniciarDadosStudent() {
    if (widget.student != null) {
      txtNome.text = widget.student!.nome;
      txtCpfCnpj.text = widget.student!.cpf;
      txtRg.text = widget.student!.rg;
      txtDtnascimento.text = widget.student!.dtnascimento;
      txtPcd.text = widget.student!.pcd;
      txtSexo.text = widget.student!.sexo;
      txtStatus.text = widget.student!.status;
      txtBairro.text = widget.student!.bairro;
      txtEndereco.text = widget.student!.endereco;
      txtMunicipio.text = widget.student!.municipio;
      txtResponsavel.text = widget.student!.responsavel;
      txtTelefone.text = widget.student!.telefone;
      txtTelresponsavel.text = widget.student!.telresponsavel;
      txtCep.text = widget.student!.cep;
      txtEscola.text = widget.student!.escola;
      txtEndescola.text = widget.student!.endescola;
      txtTurnoescolar.text = widget.student!.turnoescolar;
      student = widget.student!;
    }
  }

  void salvar() {
    student.nome = txtNome.text;
    student.cpf = txtCpfCnpj.text;
    student.rg = txtRg.text;
    student.dtnascimento = txtDtnascimento.text;
    student.pcd = txtPcd.text;
    student.sexo = txtSexo.text;
    student.status = txtStatus.text;
    student.bairro = txtBairro.text;
    student.endereco = txtEndereco.text;
    student.municipio = txtMunicipio.text;
    student.responsavel = txtResponsavel.text;
    student.telefone = txtTelefone.text;
    student.telresponsavel = txtTelresponsavel.text;
    student.cep = txtCep.text;
    student.escola = txtEscola.text;
    student.endescola = txtEndescola.text;
    student.turnoescolar = txtTurnoescolar.text;
    if (student.id == null) {
      adicionarStudent();
      return;
    }
    atualizarStudent();
  }

  void adicionarStudent() async {
    try {
      Student retorno = await studentDao.adicionar(student);
      student.id = retorno.id;
      mostrarMensagem('Aluno cadastrado com sucesso');
      setState(() {});
    } catch (error) {
      print(error);
      mostrarMensagem('Erro ao cadastrar');
    }
  }

  void atualizarStudent() async {
    try {
      if (await studentDao.atualizar(student)) {
        mostrarMensagem('Cadastro atualizado com sucesso');
        return;
      }
      mostrarMensagem('Nenhum dados alterados');
    } catch (error) {
      print(error);
      mostrarMensagem('Erro ao atualizar cadastro');
    }
  }

  void deletar() async {
    try {
      if (student.id != null) {
        if (await studentDao.deletar(student)) {
          mostrarMensagem('Cadastro deletado com sucesso');
          Navigator.pop(context);
          return;
        }
        mostrarMensagem('Nenhum cadastro deletado');
      }
      mostrarMensagem('Não é possivel deletar cadastro não registrado');
    } catch (error) {
      print(error);
      mostrarMensagem('Erro ao deletar cadastro');
    }
  }

  void mostrarMensagem(mensagem) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensagem),
      ),
    );
  }

  @override
  void initState() {
    iniciarDadosStudent();
    super.initState();
  }

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
          widget.student != null ? 'Cadastrar aluno' : 'Atulizar cadastro',
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
                    controller: txtNome,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Campo obrigatório.";
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: TextFormField(
                    decoration: textFormField("CPF"),
                    controller: txtCpfCnpj,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Campo obrigatório.";
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: TextFormField(
                    decoration: textFormField("RG"),
                    controller: txtRg,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Campo obrigatório.";
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: TextFormField(
                    decoration: textFormField("Data nascimento"),
                    controller: txtDtnascimento,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Campo obrigatório.";
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: TextFormField(
                    decoration: textFormField("PCD"),
                    controller: txtPcd,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Campo obrigatório.";
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: TextFormField(
                    decoration: textFormField("Sexo"),
                    controller: txtSexo,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Campo obrigatório.";
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: TextFormField(
                    decoration: textFormField("Status"),
                    controller: txtStatus,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Campo obrigatório.";
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: TextFormField(
                    decoration: textFormField("Bairro"),
                    controller: txtBairro,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Campo obrigatório.";
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: TextFormField(
                    decoration: textFormField("Endereço"),
                    controller: txtEndereco,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Campo obrigatório.";
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: TextFormField(
                    decoration: textFormField("Municipio"),
                    controller: txtMunicipio,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Campo obrigatório.";
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: TextFormField(
                    decoration: textFormField("Responsavel"),
                    controller: txtResponsavel,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Campo obrigatório.";
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: TextFormField(
                    decoration: textFormField("Telefone"),
                    controller: txtTelefone,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Campo obrigatório.";
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: TextFormField(
                    decoration: textFormField("Telefone Responsavel"),
                    controller: txtTelresponsavel,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Campo obrigatório.";
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: TextFormField(
                    decoration: textFormField("CEP"),
                    controller: txtCep,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Campo obrigatório.";
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: TextFormField(
                    decoration: textFormField("Escola"),
                    controller: txtEscola,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Campo obrigatório.";
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: TextFormField(
                    decoration: textFormField("Endereço escolar"),
                    controller: txtEndescola,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Campo obrigatório.";
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 15),
                  child: TextFormField(
                    decoration: textFormField("Turno escolar"),
                    controller: txtTurnoescolar,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Campo obrigatório.";
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
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
                            if (_formKey.currentState!.validate()) {
                              salvar();
                            }
                          },
                          child: const Center(
                            child: Text(
                              'Salvar',
                              style: TextStyle(
                                fontSize: 19,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8.0),
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
                            backgroundColor:
                                student.id == null ? Colors.grey : const Color.fromARGB(255, 204, 16, 16),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(11),
                            ),
                          ),
                          onPressed: () async {
                            // Logica
                            student.id == null
                                ? print('Não é possivel deletar')
                                : deletar();
                          },
                          child: const Center(
                            child: Text(
                              'Deletar',
                              style: TextStyle(
                                fontSize: 19,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
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
}
