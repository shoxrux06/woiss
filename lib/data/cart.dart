import 'package:flutter/cupertino.dart';
import 'model/response/custom_product_model.dart';

class Cart {
  int id;
  final ValueNotifier<int> quantity;
  final CustomProductModel product;

  Cart({
    required this.id,
    required this.product,
    required this.quantity,
  });

  @override
  String toString() {
    return 'Cart{id: $id, quantity: $quantity, product: $product}';
  }
}
