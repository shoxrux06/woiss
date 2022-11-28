import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../utils/app_constants.dart';

class InvoiceRepo {
  Future<dynamic> getCommercials(int userId) async {
    final _prefs = await SharedPreferences.getInstance();
    final response = await http.get(
      Uri.parse(
          'https://woiss.biohealthpharm.uz/api/users/orders?user_id=$userId'),
      headers: {
        'Authorization': 'Basic ' + base64.encode(
            utf8.encode(_prefs.getString(AppConstants.TOKEN) ?? '')),
      },
    );
    final int statusCode = response.statusCode;
    var resultClass = json.decode(response.body);
    if (statusCode == 200) {
      print('############$resultClass getCommercials');
      return resultClass;
    } else {
      return null;
    }
  }

  Future<dynamic> getContracts(int userId) async {
    final _prefs = await SharedPreferences.getInstance();
    final response = await http.get(
      Uri.parse('https://woiss.biohealthpharm.uz/api/users/contracts?user_id=$userId'),
      headers: {'Authorization': 'Basic ' + base64.encode(utf8.encode(_prefs.getString(AppConstants.TOKEN) ?? '')),
      },
    );
    final int statusCode = response.statusCode;
    var resultClass = json.decode(response.body);
    if (statusCode == 200) {
      print('############$resultClass getContracts');
      return resultClass;
    } else {
      return null;
    }
  }

  Future<dynamic> uploadInvoices(int id, String type, Uint8List file) async {
    final _prefs = await SharedPreferences.getInstance();

    Map<String, String> headers = {
      // "Accept": "application/json",
      'Authorization': 'Basic ' + base64.encode(utf8.encode(_prefs.getString(AppConstants.TOKEN) ?? '')),
    };
    final request = http.MultipartRequest('POST', Uri.parse('https://woiss.biohealthpharm.uz/api/orders/upload-file'),);

    request.headers.addAll(headers);

    var pdf = http.MultipartFile.fromBytes('file', file,filename: 'some-file-name.pdf',);

    print('pdf ---> $pdf');

    request.fields['id'] = id.toString();
    request.fields['type'] = type;
    request.files.add(pdf);

    var response = await request.send();

    final int statusCode = response.statusCode;
    var responseData = await response.stream.toBytes();

    var result = jsonDecode(String.fromCharCodes(responseData));

    if (statusCode == 200) {
      print('############$result');
      return result;
    } else {
      return null;
    }
  }

}