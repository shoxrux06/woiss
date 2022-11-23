import 'dart:io';

import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart';

class PdfApi{

  static Future<File> saveDocument({required String name, required Document pdf}) async{
    final bytes = await pdf.save();
    final path = (await getExternalStorageDirectory())?.path;
    final file = File('$path/$name');
    await file.writeAsBytes(bytes, flush: true);
    return file;
  }
  static Future openFile(File file) async{
    final url = file.path;

    await OpenFile.open(url);
  }
}