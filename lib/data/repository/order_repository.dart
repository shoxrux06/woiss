import 'dart:convert';
import 'package:furniture_app/utils/app_constants.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../model/response/my_order_item.dart';

class OrderRepository {
  Future<dynamic> postOrder({
    required String userId,
    required String orderNumber,
    required String customerId,
    required String totalAmount,
    required List<MyOrderItem> orderItem
  }) async {
    final _prefs = await SharedPreferences.getInstance();
    final requestParameters = {
      'user_id': userId,
      'order_number': orderNumber,
      'customer_id': customerId,
      'amount': totalAmount,
      'order_items':List.from(orderItem.map((x) => x.toJson()))
    };

    final response = await http.post(
      Uri.parse('https://woiss.biohealthpharm.uz/api/orders'),
      headers: {
        'Authorization': 'Basic ' + base64.encode(utf8.encode(_prefs.getString(AppConstants.TOKEN) ?? "")),
        'Content-Type': 'application/json'
      },
      body: jsonEncode(requestParameters),
    );

    final int statusCode = response.statusCode;

    var resultClass = jsonDecode(response.body);

    if (statusCode == 200) {
      return resultClass;
    } else {
      return null;
    }
  }

  Future<dynamic> editOrder({
    required int? orderId,
    required List<MyOrderItem> orderItems
  }) async {
    final _prefs = await SharedPreferences.getInstance();
    final requestParameters = {
      'order_items':List.from(orderItems.map((x) => x.toJson()))
    };

    final response = await http.put(
      Uri.parse('https://woiss.biohealthpharm.uz/api/orders/$orderId'),
      headers: {
        'Authorization': 'Basic ' + base64.encode(utf8.encode(_prefs.getString(AppConstants.TOKEN) ?? "")),
        'Content-Type': 'application/json'
      },
      body: jsonEncode(requestParameters),
    );

    final int statusCode = response.statusCode;

    var resultClass = jsonDecode(response.body);

    if (statusCode == 200) {
      return resultClass;
    } else {
      return null;
    }
  }

  Future<dynamic> editContract({
    required int? orderId,
    required List<MyOrderItem> orderItems
  }) async {
    final _prefs = await SharedPreferences.getInstance();
    final requestParameters = {
      'order_items':List.from(orderItems.map((x) => x.toJson()))
    };

    final response = await http.put(
      Uri.parse('https://woiss.biohealthpharm.uz/api/contracts/$orderId'),
      headers: {
        'Authorization': 'Basic ' + base64.encode(utf8.encode(_prefs.getString(AppConstants.TOKEN) ?? "")),
        'Content-Type': 'application/json'
      },
      body: jsonEncode(requestParameters),
    );

    final int statusCode = response.statusCode;

    var resultClass = jsonDecode(response.body);

    if (statusCode == 200) {
      return resultClass;
    } else {
      return null;
    }
  }
  Future<dynamic> postContract({
    required String userId,
    required String contractNumber,
    required String customerId,
    required String totalAmount,
    required List<MyOrderItem> orderItem
  }) async {
    final _prefs = await SharedPreferences.getInstance();
    final requestParameters = {
      'user_id': userId,
      'order_number': contractNumber,
      'customer_id': customerId,
      'amount': totalAmount,
      'order_items':List.from(orderItem.map((x) => x.toJson()))
    };

    final response = await http.post(
      Uri.parse('https://woiss.biohealthpharm.uz/api/contracts'),
      headers: {
        'Authorization': 'Basic ' + base64.encode(utf8.encode(_prefs.getString(AppConstants.TOKEN) ?? "")),
        'Content-Type': 'application/json'
      },
      body: jsonEncode(requestParameters),
    );

    final int statusCode = response.statusCode;

    var resultClass = jsonDecode(response.body);

    if (statusCode == 200) {
      return resultClass;
    } else {
      return null;
    }
  }
}
