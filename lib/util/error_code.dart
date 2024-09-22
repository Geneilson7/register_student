import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ErrorPage extends StatefulWidget {
  final String label;
  const ErrorPage({
    super.key,
    required this.label,
  });

  @override
  State<ErrorPage> createState() => _ErrorPageState();
}

class _ErrorPageState extends State<ErrorPage> {
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
            widget.label,
            style: GoogleFonts.poppins(
              fontSize: 18,
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
