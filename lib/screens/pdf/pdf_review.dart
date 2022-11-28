import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:furniture_app/data/model/invoice.dart';
import 'package:furniture_app/providers/invoice_provider.dart';
import 'package:furniture_app/screens/custom_snackbar.dart';
import 'package:furniture_app/screens/pdf/pdfexport/pdfexport.dart';
import 'package:furniture_app/utils/color_resources.dart';
import 'package:printing/printing.dart';
import 'package:provider/provider.dart';

class PdfPreviewPage extends StatefulWidget {
  final Invoice invoice;
  const PdfPreviewPage({Key? key, required this.invoice}) : super(key: key);

  @override
  State<PdfPreviewPage> createState() => _PdfPreviewPageState();
}

class _PdfPreviewPageState extends State<PdfPreviewPage> {
  String languageCode = '';

  @override
  void initState() {
    // TODO: implement initState
    uploadFile();
    super.initState();
  }

  void uploadFile() async {
    final file = await makePdf(widget.invoice, languageCode);
    print('file --->>>$file');
    context.read<InvoiceProvider>().uploadInvoices(widget.invoice.order?.id?? 01, widget.invoice.order?.status == 1? 'comm':'cont', file);
    final invoiceModel = context.read<InvoiceProvider>().invoiceUploadModel;
    print('invoice Model ---> $invoiceModel');
    showCustomSuccessSnackBar(invoiceModel?.message);
  }
  @override
  Widget build(BuildContext context) {
    languageCode = Localizations.localeOf(context).languageCode;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        leadingWidth: screenWidth >=600?100:54,
        backgroundColor: ColorsResources.PRIMARY_BACKROUND_COLOR,
        // title: Text('PDF Preview'),
      ),
      body: PdfPreview(
        canChangePageFormat: true,
        build: (_) {
          return makePdf(widget.invoice, languageCode);
        },
      ),
    );
  }
}