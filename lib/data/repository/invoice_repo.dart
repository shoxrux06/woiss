import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../utils/app_constants.dart';

class InvoiceRepo{

  Future<dynamic> getCommercials(int userId) async {
    final _prefs = await SharedPreferences.getInstance();
    final response = await http.get(
      Uri.parse('https://woiss.biohealthpharm.uz/api/users/orders?user_id=$userId'),
      headers: {
        'Authorization': 'Basic ' + base64.encode(utf8.encode(_prefs.getString(AppConstants.TOKEN) ?? '')),
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
      headers: {
        'Authorization': 'Basic ' + base64.encode(utf8.encode(_prefs.getString(AppConstants.TOKEN) ?? '')),
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

}