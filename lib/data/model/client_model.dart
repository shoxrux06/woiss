// To parse this JSON data, do
//
//     final clientModel = clientModelFromJson(jsonString);

import 'dart:convert';

ClientModel clientModelFromJson(String str) => ClientModel.fromJson(json.decode(str));

String clientModelToJson(ClientModel data) => json.encode(data.toJson());

class ClientModel {
  ClientModel({
   required this.status,
   required this.result,
  });

  bool status;
  Result result;

  factory ClientModel.fromJson(Map<String, dynamic> json) => ClientModel(
    status: json["status"],
    result: Result.fromJson(json["result"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "result": result.toJson(),
  };

  @override
  String toString() {
    return 'ClientModel{status: $status, result: $result}';
  }
}

class Result {
  Result({
   required this.phone,
   required this.fullname,
   required this.address,
   required this.discount,
   required this.id,
  });

  String phone;
  String fullname;
  String address;
  int? discount;
  int id;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
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

  @override
  String toString() {
    return 'Result{phone: $phone, fullname: $fullname, address: $address, discount: $discount, id: $id}';
  }
}
