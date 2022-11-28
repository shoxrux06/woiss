class MyOrderItem {
  MyOrderItem({
    required this.product_id,
    required this.quantity,
    required this.color,
    required this.size,
    required this.iodp,
  });

  int product_id;
  int quantity;
  String color;
  String size;
  double iodp;

  factory MyOrderItem.fromJson(Map<String, dynamic> json) => MyOrderItem(
    product_id: json["product_id"],
    quantity: json["quantity"],
    color: json["color"],
    size: json["size"],
    iodp: json["iodp"],
  );

  Map<String, dynamic> toJson() => {
    "product_id": product_id,
    "quantity": quantity,
    "color": color,
    "size": size,
    "iodp": iodp,
  };

  @override
  String toString() {
    return 'MyOrderItem{product_id: $product_id, quantity: $quantity, color: $color, size: $size,  iodp: $iodp}';
  }
}