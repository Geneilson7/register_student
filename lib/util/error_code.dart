import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ErrorPage extends StatelessWidget {
  const ErrorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/image/404.png',
            width: 450,
            height: 450,
          ),
          Text(
            'Ups!... nenhum resultado encontrado',
            style: GoogleFonts.poppins(
              fontSize: 32,
              color: const Color(0xFF000000),
              fontWeight: FontWeight.w300,
            ),
          ),
          // const Text(
          //   'não foram encontrados dados para exibir',
          //   style: TextStyle(
          //     fontSize: 15,
          //     color: Colors.grey,
          //   ),
          // ),
        ],
      ),
    );
  }
}
