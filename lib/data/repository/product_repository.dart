import 'dart:convert';

import 'package:furniture_app/data/model/response/category_model.dart';
import 'package:furniture_app/data/model/response/product_model.dart';
import 'package:furniture_app/utils/app_constants.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ProductRepository {
  Future<List<CategoryModel>> getCategoryList() async {
    final _prefs = await SharedPreferences.getInstance();

    final response = await http.get(
      Uri.parse('https://woiss.biohealthpharm.uz/api/categories'),
      headers: {
        'Authorization': 'Basic ' + base64.encode(utf8.encode(_prefs.getString(AppConstants.TOKEN)??'')),
      },
    );
    final int statusCode = response.statusCode;

    var resultClass = json.decode(response.body);
    List<CategoryModel> categoryList = [];
    if (statusCode == 200) {
      categoryList = List<CategoryModel>.from(resultClass.map((x) => CategoryModel.fromJson(x)));
      print('############${response.body} response.body');
      return categoryList;
    } else {

    }
    return categoryList;
  }

  Future<List<ProductModel>> getProductList(int categoryId) async {
    final _prefs = await SharedPreferences.getInstance();

    final response = await http.get(
      Uri.parse('https://woiss.biohealthpharm.uz/api/products?category_id=$categoryId'),
      headers: {
        'Authorization': 'Basic ' + base64.encode(utf8.encode(_prefs.getString(AppConstants.TOKEN)?? '')),
      },
    );
    final int statusCode = response.statusCode;

    var resultClass = json.decode(response.body);
    List<ProductModel> prodList = [];
    if (statusCode == 200) {
      print('############$resultClass getProductList');
      print('############${response.contentLength} length');
      prodList = List<ProductModel>.from(resultClass.map((x) => ProductModel.fromJson(x)));
      print('############${prodList.length} prodList length');
      return prodList;
    } else {
    }
    return prodList;
  }
}
