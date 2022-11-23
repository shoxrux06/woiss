import 'dart:convert';
import 'package:furniture_app/utils/cache_manager.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../utils/app_constants.dart';

class ClientRepo {
  Future<dynamic> searchClient(String phoneNumber) async {
    final _prefs = await SharedPreferences.getInstance();
    CacheManager cacheManager = CacheManager();
    final response = await http.get(
      Uri.parse(
          'https://woiss.biohealthpharm.uz/api/customers/search?phone=$phoneNumber'),
      headers: {
        'Authorization': 'Basic ' +
            base64.encode(
                utf8.encode(_prefs.getString(AppConstants.TOKEN) ?? '')),
      },
    );

    final int statusCode = response.statusCode;

    var resultClass = json.decode(response.body);
    if (statusCode == 200 && resultClass['status'] == true) {
      print('############$resultClass loginMethod');
      await cacheManager.saveCustomerId(resultClass['result']['id']);
      return resultClass;
    } else {
      return null;
    }
  }

  Future<dynamic> addClient(
      String fullname, String phone, String address, String discount) async {
    final _prefs = await SharedPreferences.getInstance();
    final requestParams = {
      'fullname': fullname,
      'phone': phone,
      'address': address,
      'discount': discount,
    };
    final response = await http.post(
      Uri.parse('https://woiss.biohealthpharm.uz/api/customers'),
      headers: {
        'Authorization': 'Basic ' + base64.encode(
                utf8.encode(_prefs.getString(AppConstants.TOKEN) ?? '')),
      },
      body: requestParams,
    );

    final int statusCode = response.statusCode;
    var resultClass = json.decode(response.body);

    if (statusCode == 200) {
      print('############$resultClass addClient');
      return resultClass;
    } else {
      return null;
    }
  }

  Future<dynamic> editClient(int clientId, String fullname, String phone,
      String address, int discount) async {
    final _prefs = await SharedPreferences.getInstance();
    final requestParams = {
      'fullname': fullname,
      'phone': phone,
      'address': address,
      'discount': discount.toString(),
    };
    final response = await http.put(
      Uri.parse('https://woiss.biohealthpharm.uz/api/customers/$clientId'),
      headers: {
        'Authorization': 'Basic ' + base64.encode(utf8.encode(_prefs.getString(AppConstants.TOKEN) ?? '')),
      },
      body: requestParams,
    );

    final int statusCode = response.statusCode;

    var resultClass = json.decode(response.body);

    if (statusCode == 200 && resultClass['status'] == true) {
      print('############$resultClass editClient');
      return resultClass;
    } else {
      return null;
    }
  }


}
