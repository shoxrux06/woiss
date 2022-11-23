// To parse this JSON data, do
//
//     final productModel = productModelFromJson(jsonString);

import 'dart:convert';

List<ProductModel> productModelFromJson(String str) => List<ProductModel>.from(json.decode(str).map((x) => ProductModel.fromJson(x)));

String productModelToJson(List<ProductModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ProductModel {
  ProductModel({
   required this.id,
   required this.nameRu,
   required this.nameEn,
   required this.nameUz,
   required this.nameTr,
   required this.price,
   required this.branchPrice,
   required this.intBranchPrice,
   required this.img,
   required this.colorRu,
   required this.colorEn,
   required this.colorUz,
   required this.colorTr,
   required this.size,
   required this.position,
   required this.categoryName,
  });

  int id;
  String nameRu;
  String nameEn;
  String nameUz;
  String nameTr;
  int price;
  String branchPrice;
  int intBranchPrice;
  String img;
  String colorRu;
  String colorEn;
  String colorUz;
  String colorTr;
  String size;
  int position;
  String categoryName;

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
    id: json["id"],
    nameRu: json["name_ru"],
    nameEn: json["name_en"],
    nameUz: json["name_uz"],
    nameTr: json["name_tr"],
    price: json["price"],
    branchPrice: json["branchPrice"],
    intBranchPrice: json["intBranchPrice"],
    img: json["img"],
    colorRu: json["color_ru"],
    colorEn: json["color_en"],
    colorUz: json["color_uz"],
    colorTr: json["color_tr"],
    size: json["size"],
    position: json["position"],
    categoryName: json["category_name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name_ru": nameRu,
    "name_en": nameEn,
    "name_uz": nameUz,
    "name_tr": nameTr,
    "price": price,
    "branchPrice": branchPrice,
    "intBranchPrice": intBranchPrice,
    "img": img,
    "color_ru": colorRu,
    "color_en": colorEn,
    "color_uz": colorUz,
    "color_tr": colorTr,
    "size": size,
    "position": position,
    "category_name": categoryName,
  };

  @override
  String toString() {
    return 'ProductModel{id: $id, nameRu: $nameRu, nameEn: $nameEn, nameUz: $nameUz, nameTr: $nameTr, price: $price, branchPrice: $branchPrice, intBranchPrice: $intBranchPrice, img: $img, colorRu: $colorRu, colorEn: $colorEn, colorUz: $colorUz, colorTr: $colorTr, size: $size, position: $position, categoryName: $categoryName}';
  }
}

