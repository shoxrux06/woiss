// To parse this JSON data, do
//
//     final addClientModel = addClientModelFromJson(jsonString);

import 'dart:convert';

AddClientModel addClientModelFromJson(String str) => AddClientModel.fromJson(json.decode(str));

String addClientModelToJson(AddClientModel data) => json.encode(data.toJson());

class AddClientModel {
  AddClientModel({
   required this.phone,
   required this.fullname,
   required this.address,
   required this.discount,
   required this.id,
  });

  String phone;
  String fullname;
  String address;
  int discount;
  int id;

  factory AddClientModel.fromJson(Map<String, dynamic> json) => AddClientModel(
    phone: json["phone"],
    fullname: json["fullname"],
    address: json["address"],
    discount: json["discount"],
    id: json["id"],
  );

  Map<String, dynamic> toJson() => {
    "phone": phone,
    "fullname": fullname,
    "address": address,
    "discount": discount,
    "id": id,
  };
}
