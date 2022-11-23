import 'dart:convert';
import 'package:furniture_app/data/model/user.dart';
import 'package:furniture_app/utils/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CacheManager {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  // Future<bool> saveUser(List<MyUser> users) async {
  //   final SharedPreferences prefs = await _prefs;
  //   return await prefs.setString(AppConstants.USER, jsonEncode(users));
  // }

  // Future<List<MyUser>> getUsers() async {
  //   final SharedPreferences prefs = await _prefs;
  //   final List<dynamic> jsonData =  jsonDecode(prefs.getString(AppConstants.USER)?? '[]');
  //   print('jsonData>>>> $jsonData');
  //   List<MyUser> list = [];
  //   list = List<MyUser>.from(jsonData.map((x) => MyUser.fromJson(x)));
  //   return list;
  // }

  Future<bool> saveToken(String token) async {
    final SharedPreferences prefs = await _prefs;
    return await prefs.setString(AppConstants.TOKEN, token);
  }

  Future<bool> saveAppLang(String appLang) async {
    final SharedPreferences prefs = await _prefs;
    return await prefs.setString(AppConstants.APP_LANG, appLang);
  }

  Future<bool> saveUserId(int? userId) async {
    final SharedPreferences prefs = await _prefs;
    return prefs.setInt(AppConstants.USER_ID, userId ?? 0);
  }

  Future<bool> saveUserName(String userName) async {
    final SharedPreferences prefs = await _prefs;
    return prefs.setString(AppConstants.USER_NAME, userName);
  }

  Future<bool> saveUserEmail(String userEmail) async {
    final SharedPreferences prefs = await _prefs;
    return prefs.setString(AppConstants.USER_EMAIL, userEmail);
  }

  Future<bool> saveCustomerId(int? customerId) async {
    final SharedPreferences prefs = await _prefs;
    return prefs.setInt(AppConstants.CUSTOMER_ID, customerId ?? 0);
  }

  Future<bool> saveCustomerAddress(String? customerAddress) async {
    final SharedPreferences prefs = await _prefs;
    return prefs.setString(AppConstants.CUSTOMER_ADDRESS, customerAddress ?? '');
  }

  Future<bool> saveCustomerFullName(String? customerFullName) async {
    final SharedPreferences prefs = await _prefs;
    return prefs.setString(AppConstants.CUSTOMER_FULLNAME, customerFullName ?? '');
  }

  Future<bool> saveCustomerPhone(String? customerPhone) async {
    final SharedPreferences prefs = await _prefs;
    return prefs.setString(AppConstants.CUSTOMER_PHONE, customerPhone ?? '');
  }

  Future<bool> saveOrderId(int orderId) async {
    final SharedPreferences prefs = await _prefs;
    return prefs.setInt(AppConstants.ORDER_ID, orderId);
  }

  Future<bool> saveBranchPhone(String clientPhone) async {
    final SharedPreferences prefs = await _prefs;
    return prefs.setString(AppConstants.BRANCH_PHONE, clientPhone);
  }


  Future<String?> getToken() async {
    final SharedPreferences prefs = await _prefs;
    String? token;
    print('****************************************************************');
    token = prefs.getString(AppConstants.TOKEN);
    print('****************************----------------$token');
    return token;
  }

  Future<int?> getUserId() async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getInt(AppConstants.USER_ID);
  }

  Future<String?> getUserName() async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getString(AppConstants.USER_NAME);
  }

  Future<String?> getAppLang() async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getString(AppConstants.APP_LANG);
  }

  Future<String?> getBranchPhone() async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getString(AppConstants.BRANCH_PHONE);
  }

  Future<String?> getUserEmail() async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getString(AppConstants.USER_EMAIL);
  }

  Future<int?> getOrderId() async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getInt(AppConstants.ORDER_ID);
  }

  Future<void> clearOrderId() async {
    final SharedPreferences prefs = await _prefs;
    prefs.remove(AppConstants.ORDER_ID);
  }
  Future<int?> getCustomerId() async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getInt(AppConstants.CUSTOMER_ID);
  }

  Future<String?> getCustomerAddress() async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getString(AppConstants.CUSTOMER_ADDRESS);
  }
  Future<String?> getCustomerFullName() async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getString(AppConstants.CUSTOMER_FULLNAME);
  }

  Future<String?> getCustomerPhone() async {
    final SharedPreferences prefs = await _prefs;
    return prefs.getString(AppConstants.CUSTOMER_PHONE);
  }
}
