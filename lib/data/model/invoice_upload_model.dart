// To parse this JSON data, do
//
//     final invoiceUploadModel = invoiceUploadModelFromJson(jsonString);

import 'dart:convert';

InvoiceUploadModel invoiceUploadModelFromJson(String str) => InvoiceUploadModel.fromJson(json.decode(str));

String invoiceUploadModelToJson(InvoiceUploadModel data) => json.encode(data.toJson());

class InvoiceUploadModel {
  InvoiceUploadModel({
    required this.status,
    required this.message,
  });

  String status;
  String message;

  factory InvoiceUploadModel.fromJson(Map<String, dynamic> json) => InvoiceUploadModel(
    status: json["status"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
  };

  @override
  String toString() {
    return 'InvoiceUploadModel{status: $status, message: $message}';
  }
}
