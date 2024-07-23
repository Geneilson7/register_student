import 'package:flutter/material.dart';

class Pcd extends StatelessWidget {
  final String label;
  final String? selectedValue;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  const Pcd({
    Key? key,
    required this.label,
    required this.selectedValue,
    required this.items,
    required this.onChanged,
  }) : super(key: key);

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
            DropdownButtonFormField<String>(
              value: selectedValue!.isNotEmpty ? selectedValue : null,
              onChanged: onChanged,
              items: [
                const DropdownMenuItem<String>(
                  value: null,
                  child: Text('Selecione'),
                ),
                ...items.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }),
              ],
              decoration: InputDecoration(
                label: Text(label),
                fillColor: const Color(0xFFF1F4FF).withOpacity(0.9),
                filled: true,
                labelStyle: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                    color: Color(0xFF626262)),
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
