import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

InputDecoration textFormField(String label) {
  return InputDecoration(
    label: Text(label),
    fillColor: const Color(0xFFF1F4FF).withOpacity(0.9),
    filled: true,
    labelStyle: GoogleFonts.poppins(
      fontWeight: FontWeight.w500,
      fontSize: 16,
      color: const Color(0xFF626262),
    ),
    isDense: true,
    border: OutlineInputBorder(
      borderSide: const BorderSide(color: Color(0xFF262c40), width: 2.0),
      borderRadius: BorderRadius.circular(11),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: Color(0xFF262c40), width: 2.0),
      borderRadius: BorderRadius.circular(11),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: Color(0xFF262c40), width: 2.0),
      borderRadius: BorderRadius.circular(11),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: Color(0xFF262c40), width: 2.0),
      borderRadius: BorderRadius.circular(11),
    ),
    errorBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: Color(0xFF262c40), width: 2.0),
      borderRadius: BorderRadius.circular(11),
    ),
  );
}
