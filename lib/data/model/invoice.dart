import 'package:furniture_app/data/cart.dart';
import 'package:furniture_app/data/model/client_payment.dart';
import 'package:furniture_app/data/model/response/order_get_model.dart';
import 'package:furniture_app/data/model/supplier_model.dart';

import 'client_model.dart';

class Invoice {
  final int id;
  final Result? client;
  final SupplierModel supplier;
  final Order? order;
  final List<OrderItem> orderItems;
  final DateTime dateTime;
  ClientPayment? clientPayment = ClientPayment(prepaidAmount: 0, remainingAmount: 0);

  Invoice({
    required this.id,
    required this.client,
    required this.supplier,
    required this.order,
    required this.orderItems,
    required this.dateTime,
    this.clientPayment
  });

  @override
  String toString() {
    return 'Invoice{id: $id, client: $client, supplier: $supplier, order: $order, dateTime: $dateTime}';
  }
}
