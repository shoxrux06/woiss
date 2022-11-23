import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:furniture_app/data/model/invoice.dart';
import 'package:furniture_app/screens/pdf/pdfexport/pdfexport.dart';
import 'package:furniture_app/utils/color_resources.dart';
import 'package:printing/printing.dart';

class PdfPreviewPage extends StatelessWidget {
  final Invoice invoice;
  const PdfPreviewPage({Key? key, required this.invoice}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final screenWidth = MediaQuery.of(context).size.width;

    String languageCode = Localizations.localeOf(context).languageCode;
    return Scaffold(
      appBar: AppBar(
        leadingWidth: screenWidth >=600?100:54,
        backgroundColor: ColorsResources.PRIMARY_BACKROUND_COLOR,
        // title: Text('PDF Preview'),
      ),
      body: PdfPreview(
        canChangePageFormat: true,
        build: (context) => makePdf(invoice, languageCode),
      ),
    );
  }
}