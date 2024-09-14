// import 'package:flutter/material.dart';
// import 'package:flutter_pdfview/flutter_pdfview.dart';
// import 'dart:io';

// import 'package:path_provider/path_provider.dart';

// class PDFViewerScreen extends StatelessWidget {
//   final String pdfPath;

//   PDFViewerScreen(this.pdfPath);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Visualizar PDF'),
//         actions: [
//           // Botão de Enviar PDF
//           IconButton(
//             icon: Icon(Icons.send),
//             onPressed: () {
//               // Função de enviar o PDF por e-mail ou outro método
//               _sendPDF(pdfPath);
//             },
//           ),
//           // Botão de Salvar PDF
//           IconButton(
//             icon: Icon(Icons.save),
//             onPressed: () {
//               // Função de salvar o PDF em uma localização permanente
//               _savePDF(pdfPath);
//             },
//           ),
//         ],
//       ),
//       body: PDFView(
//         filePath: pdfPath,
//       ),
//     );
//   }

//   void _sendPDF(String pdfPath) {
//     // Função para enviar o PDF (pode ser via e-mail, compartilhar, etc.)
//     // Exemplo com o pacote share_plus:
//     // Share.shareFiles([pdfPath], text: 'Aqui está o PDF do aluno');
//   }

//   void _savePDF(String pdfPath) async {
//     // Função para salvar o PDF em uma pasta do sistema
//     final dir = await getExternalStorageDirectory();
//     final String newPath = '${dir!.path}/saved_pdf.pdf';
//     final File file = File(pdfPath);
//     final File savedFile = await file.copy(newPath);
//     print('PDF salvo em: $newPath');
//   }
// }
