import 'package:flutter/material.dart';

class InvoiceModel {
  final String customer;
  final String address;
  final String name;
  final List<LineItem> items;
  InvoiceModel({
    required this.customer,
    required this.address,
    required this.items,
    required this.name,
  });
  double totalCost() {
    return items.fold(0, (previousValue, element) => previousValue + element.cost);
  }
}

class LineItem {
  final String description;
  final double cost;
  final String color;
  final double size;
  final String image;

  LineItem(this.description, this.cost, this.color, this.size, this.image);
}