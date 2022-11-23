// import 'dart:io';
//
// import 'package:flutter/services.dart';
// import 'package:furniture_app/data/model/invoice.dart';
// import 'package:furniture_app/screens/cart/widgets/pdf_api.dart';
// import 'package:pdf/pdf.dart';
// import 'package:pdf/widgets.dart' as pw;
//
// class PdfInvoiceApi {
//   static Future<File> generate(Invoice invoice) async {
//     final font = await rootBundle.load("assets/fonts/OpenSans-Regular.ttf");
//     var freeSans = pw.Font.ttf(font);
//     var myTheme = pw.ThemeData.withFont(
//       bold:freeSans,
//     );
//     final pdf = pw.Document(
//       theme: myTheme,
//     );
//
//
//
//     pdf.addPage(
//       pw.MultiPage(
//         pageFormat: PdfPageFormat.a4,
//         build: (context) => [
//           buildTitle(invoice,freeSans ),
//         ],
//       ),
//     );
//     return PdfApi.saveDocument(name: 'my_invoice.pdf', pdf: pdf);
//   }
//
//   static pw.Widget buildTitle(Invoice invoice, pw.Font freeSans) {
//     return pw.Column(children: [
//       pw.Text('Invoice', style: pw.TextStyle(fontSize: 24, font: freeSans)),
//       pw.SizedBox(height: 24),
//       pw.Text(invoice.id),
//     ]);
//   }
// }
