// To parse this JSON data, do
//
//     final ordersGetModel = ordersGetModelFromJson(jsonString);

import 'dart:convert';

OrdersGetModel ordersGetModelFromJson(String str) => OrdersGetModel.fromJson(json.decode(str));

String ordersGetModelToJson(OrdersGetModel data) => json.encode(data.toJson());

class OrdersGetModel {
  OrdersGetModel({
   required this.status,
   required this.order,
  });

  String status;
  Order order;

  factory OrdersGetModel.fromJson(Map<String, dynamic> json) => OrdersGetModel(
    status: json["status"],
    order: Order.fromJson(json["order"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "order": order.toJson(),
  };
}

class Order {
  Order({
   required this.id,
   required this.userId,
   required this.date,
   required this.amount,
   required this.status,
   required this.orderNumber,
   required this.orderItems,
   required this.username,
   required this.branch,
   required this.customer,
  });

  int id;
  int userId;
  DateTime date;
  int amount;
  int status;
  String orderNumber;
  List<OrderItem> orderItems;
  String username;
  String branch;
  Customer customer;

  factory Order.fromJson(Map<String, dynamic> json) => Order(
    id: json["id"],
    userId: json["user_id"],
    date: DateTime.parse(json["date"]),
    amount: json["amount"],
    status: json["status"],
    orderNumber: json["order_number"],
    orderItems: List<OrderItem>.from(json["orderItems"].map((x) => OrderItem.fromJson(x))),
    username: json["username"],
    branch: json["branch"],
    customer: Customer.fromJson(json["customer"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "date": date.toIso8601String(),
    "amount": amount,
    "status": status,
    "order_number": orderNumber,
    "orderItems": List<dynamic>.from(orderItems.map((x) => x.toJson())),
    "username": username,
    "branch": branch,
    "customer": customer.toJson(),
  };
}

class Customer {
  Customer({
   required this.id,
   required this.fullname,
   required this.phone,
   required this.address,
   required this.discount,
  });

  int id;
  String fullname;
  String phone;
  String address;
  int discount;

  factory Customer.fromJson(Map<String, dynamic> json) => Customer(
    id: json["id"],
    fullname: json["fullname"],
    phone: json["phone"],
    address: json["address"],
    discount: json["discount"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "fullname": fullname,
    "phone": phone,
    "address": address,
    "discount": discount,
  };
}

class OrderItem {
  OrderItem({
   required this.id,
   required this.productId,
   required this.orderId,
   required this.quantity,
   required this.color,
   required this.size,
  });

  int id;
  ProductId productId;
  int orderId;
  int quantity;
  String color;
  String size;

  factory OrderItem.fromJson(Map<String, dynamic> json) => OrderItem(
    id: json["id"],
    productId: ProductId.fromJson(json["product_id"]),
    orderId: json["order_id"],
    quantity: json["quantity"],
    color: json["color"],
    size: json["size"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "product_id": productId.toJson(),
    "order_id": orderId,
    "quantity": quantity,
    "color": color,
    "size": size,
  };
}

class ProductId {
  ProductId({
   required this.id,
   required this.nameRu,
   required this.colorRu,
   required this.size,
   required this.desc,
   required this.img,
   required this.status,
   required this.categoryId,
   required this.price,
   required this.nameEn,
   required this.nameUz,
   required this.nameTr,
   required this.colorEn,
   required this.colorUz,
   required this.colorTr,
   required this.position,
  });

  int id;
  String nameRu;
  String colorRu;
  String size;
  dynamic desc;
  String img;
  int status;
  CategoryId categoryId;
  Price price;
  String nameEn;
  String nameUz;
  String nameTr;
  String colorEn;
  String colorUz;
  String colorTr;
  int position;

  factory ProductId.fromJson(Map<String, dynamic> json) => ProductId(
    id: json["id"],
    nameRu: json["name_ru"],
    colorRu: json["color_ru"],
    size: json["size"],
    desc: json["desc"],
    img: json["img"],
    status: json["status"],
    categoryId: CategoryId.fromJson(json["category_id"]),
    price: Price.fromJson(json["price"]),
    nameEn: json["name_en"],
    nameUz: json["name_uz"],
    nameTr: json["name_tr"],
    colorEn: json["color_en"],
    colorUz: json["color_uz"],
    colorTr: json["color_tr"],
    position: json["position"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name_ru": nameRu,
    "color_ru": colorRu,
    "size": size,
    "desc": desc,
    "img": img,
    "status": status,
    "category_id": categoryId.toJson(),
    "price": price.toJson(),
    "name_en": nameEn,
    "name_uz": nameUz,
    "name_tr": nameTr,
    "color_en": colorEn,
    "color_uz": colorUz,
    "color_tr": colorTr,
    "position": position,
  };
}

class CategoryId {
  CategoryId({
   required this.id,
   required this.name,
   required this.img,
  });

  int id;
  String name;
  String img;

  factory CategoryId.fromJson(Map<String, dynamic> json) => CategoryId(
    id: json["id"],
    name: json["name"],
    img: json["img"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "img": img,
  };
}

class Price {
  Price({
   required this.price,
   required this.branchPrice,
   required this.intBranchPrice,
  });

  int price;
  String branchPrice;
  int intBranchPrice;

  factory Price.fromJson(Map<String, dynamic> json) => Price(
    price: json["price"],
    branchPrice: json["branchPrice"],
    intBranchPrice: json["intBranchPrice"],
  );

  Map<String, dynamic> toJson() => {
    "price": price,
    "branchPrice": branchPrice,
    "intBranchPrice": intBranchPrice,
  };
}
