// To parse this JSON data, do
//
//     final categoryModel = categoryModelFromJson(jsonString);

import 'dart:convert';

List<CategoryModel> categoryModelFromJson(String str) => List<CategoryModel>.from(json.decode(str).map((x) => CategoryModel.fromJson(x)));

String categoryModelToJson(List<CategoryModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CategoryModel {
  CategoryModel({
   required this.id,
   required this.name,
   required this.img,
  });

  int id;
  String name;
  String img;

  factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
    id: json["id"],
    name: json["name"],
    img: json["img"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "img": img,
  };

  @override
  String toString() {
    return 'CategoryModel{id: $id, name: $name, img: $img}';
  }
}
