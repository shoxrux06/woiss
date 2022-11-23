import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../utils/app_constants.dart';

class AuthRepo {
  final SharedPreferences? sharedPreferences;

  AuthRepo({
    required this.sharedPreferences,
  });

  Future<dynamic> loginMethod(  
      {required String email, required String password}) async {
    final response = await http.post(
      Uri.parse('https://woiss.biohealthpharm.uz/api/auth'),
      headers: {},
      body: {"email": email, "password": password},
    );

    final int statusCode = response.statusCode;

    var resultClass = json.decode(response.body);
    if (statusCode == 200 && resultClass['status'] == true) {
      print('############$resultClass loginMethod');
      return resultClass;
    } else {}
    return resultClass;
  }

  Future<dynamic> getBranchAgentList() async {
    final _prefs = await SharedPreferences.getInstance();
    final response = await http.get(
      Uri.parse('https://woiss.biohealthpharm.uz/api/users/branch-users'),
      headers: {
        'Authorization': 'Basic ' +
            base64.encode(
                utf8.encode(_prefs.getString(AppConstants.TOKEN) ?? '')),
      },
    );

    final int statusCode = response.statusCode;

    if (statusCode == 200) {
      final resultClass = jsonDecode(response.body);
      return resultClass;
    } else {
      return null;
    }
  }

  Future<dynamic> checkPassword({required String email, required String token}) async {
    final response = await http.post(
      Uri.parse('https://woiss.biohealthpharm.uz/api/check'),
      headers: {},
      body: {"email": email, "token": token},
    );

    final int statusCode = response.statusCode;

    var resultClass = json.decode(response.body);
    if (statusCode == 200 && resultClass['status'] == true) {
      print('############$resultClass checkPassword 200');
      return resultClass;
    } else {
      print('############$resultClass checkPassword other');
    }
    return resultClass;
  }
}
