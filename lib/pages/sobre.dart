import 'package:flutter/material.dart';

class Sobre extends StatefulWidget {
  const Sobre({super.key});

  @override
  State<Sobre> createState() => _SobreState();
}

class _SobreState extends State<Sobre> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFFFFF),
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text(
          'Sobre',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Color(0xFF000000),
          ),
        ),
        centerTitle: true,
        toolbarHeight: 60,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 5,
        ),
        child: Column(
          children: [
            Center(
              child: Card(
                color: const Color(0XFFFFFFFF).withOpacity(0.9),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  side: const BorderSide(color: Color(0xFF1F41BB), width: 0.3),
                ),
                child: const Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Sobre o Software',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Bem-vindo ao GENTECH Jiu-Jitsu!\n\n'
                        'Este software foi desenvolvido para atender especificamente às necessidades dos nossos usuários, oferecendo uma solução eficaz e personalizada. Nosso compromisso é fornecer uma ferramenta confiável, segura e fácil de usar, que otimize suas atividades e melhore a sua experiência.\n\n'
                        'Termos de Uso\n\n'
                        'É importante ressaltar que o GENTECH Jiu-Jitsu foi projetado exclusivamente para uso pessoal ou interno na sua organização. Ao utilizar este software, você concorda com os seguintes termos:\n\n'
                        '1. Proibição de Comercialização: Não é permitido comercializar, vender, alugar ou licenciar este software para terceiros. Ele deve ser utilizado apenas pelos usuários autorizados.\n\n'
                        '2. Distribuição: Você não pode distribuir cópias deste software a terceiros. Qualquer forma de compartilhamento não autorizado é estritamente proibida.\n\n'
                        '3. Modificação: Não é permitido modificar, descompilar, fazer engenharia reversa ou criar trabalhos derivados com base neste software, exceto se expressamente autorizado por nós.\n\n'
                        '4. Responsabilidade: O uso deste software é de sua total responsabilidade. Não nos responsabilizamos por quaisquer danos diretos, indiretos, incidentais ou consequentes decorrentes do uso ou incapacidade de uso do software.\n\n'
                        '5. Atualizações e Suporte: Nós nos reservamos o direito de atualizar o software periodicamente para melhorar a funcionalidade e a segurança. O suporte técnico é oferecido apenas para usuários registrados.\n\n'
                        'Contato\n\n'
                        'Se você tiver dúvidas ou precisar de suporte, entre em contato conosco através do e-mail: gentechsoftwareoficial@gmail.com\n\n'
                        'Obrigado por escolher o GENTECH Jiu-Jitsu. Estamos empenhados em proporcionar a melhor experiência possível e apreciamos sua compreensão e cooperação em relação aos nossos termos de uso.',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(
                  height: 50,
                  width: 120,
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
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(11),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Center(
                        child: Text(
                          'Ciente',
                          style: TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
