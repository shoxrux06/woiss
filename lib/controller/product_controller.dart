import 'package:furniture_app/data/model/response/category_model.dart';
import 'package:furniture_app/data/model/response/product_model.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_disposable.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

import '../data/repository/product_repository.dart';

class ProductController extends GetxController implements GetxService{

  ProductController({required this.productRepo});

  final ProductRepository productRepo;

  String searchCategoryString = '';

  String _searchProductString = '';

  String languageCode = '';


  updateCategoryString(String str){
    searchCategoryString = str;
    update();
  }

  updateProductString(String str, String languageCode){
    this.languageCode = languageCode;
    _searchProductString = str;
    update();
  }


  List<CategoryModel> _categoryList = [];

  List<CategoryModel> get categoryList => searchCategoryString.isEmpty
      ? _categoryList
      : _categoryList
      .where((element) => element.name.toLowerCase()
      .contains(searchCategoryString.toLowerCase()))
      .toList();

  List<ProductModel> _productList = [];


  List<ProductModel> get productList => _searchProductString.isEmpty
      ? _productList
      : _productList
      .where((element) {
    if (languageCode == 'en') {
      return element.nameEn.toLowerCase()
          .contains(_searchProductString.toLowerCase());
    } else if (languageCode == 'ru') {
      return element.nameRu.toLowerCase()
          .contains(_searchProductString.toLowerCase());
    } else if (languageCode == 'tr') {
      return element.nameTr.toLowerCase()
          .contains(_searchProductString.toLowerCase());
    } else if (languageCode == 'uz') {
      return element.nameUz.toLowerCase()
          .contains(_searchProductString.toLowerCase());
    }else {
      return false;
    }
  })
      .toList();

  getCategoryList() async {
    _categoryList = await productRepo.getCategoryList();
    update();
    print('*****************$_categoryList ***************** in Auth Controller getCategoryList');
  }

  getProductList(int categoryId) async{
    _productList = await productRepo.getProductList(categoryId);
    update();
    print('*****************${_productList} ***************** in Auth Controller getProductList');
  }

}