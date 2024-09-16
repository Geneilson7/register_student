import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Faixa extends StatefulWidget {
  final String label;
  final int? selectedFaixaId; // Mude para int?
  final List<Map<String, dynamic>> faixas; // id e descricao
  final ValueChanged<int?> onChanged; // Mude para int?

  const Faixa({
    Key? key,
    required this.label,
    required this.selectedFaixaId,
    required this.faixas,
    required this.onChanged,
  }) : super(key: key);

  @override
  State<Faixa> createState() => _FaixaState();
}

class _FaixaState extends State<Faixa> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFF1F4FF).withOpacity(0.9),
          borderRadius: BorderRadius.circular(11),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DropdownButtonFormField<int>(
              value: widget.selectedFaixaId,
              onChanged: widget.onChanged,
              items: widget.faixas.map<DropdownMenuItem<int>>((faixa) {
                return DropdownMenuItem<int>(
                  value: faixa['id'], // deve ser int
                  child: Text(faixa['descricao']),
                );
              }).toList(),
              decoration: InputDecoration(
                label: Text(widget.label),
                fillColor: const Color(0xFFF1F4FF).withOpacity(0.9),
                filled: true,
                labelStyle: GoogleFonts.poppins(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                    color: const Color(0xFF626262)),
                isDense: true,
                border: OutlineInputBorder(
                  borderSide:
                      const BorderSide(color: Color(0xFF262c40), width: 2.0),
                  borderRadius: BorderRadius.circular(11),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide:
                      const BorderSide(color: Color(0xFF262c40), width: 2.0),
                  borderRadius: BorderRadius.circular(11),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide:
                      const BorderSide(color: Color(0xFF262c40), width: 2.0),
                  borderRadius: BorderRadius.circular(11),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderSide:
                      const BorderSide(color: Color(0xFF262c40), width: 2.0),
                  borderRadius: BorderRadius.circular(11),
                ),
                errorBorder: OutlineInputBorder(
                  borderSide:
                      const BorderSide(color: Color(0xFF262c40), width: 2.0),
                  borderRadius: BorderRadius.circular(11),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
