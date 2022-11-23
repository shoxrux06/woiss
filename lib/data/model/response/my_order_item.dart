class MyOrderItem {
  MyOrderItem({
    required this.product_id,
    required this.quantity,
    required this.color,
    required this.size,
  });

  int product_id;
  int quantity;
  String color;
  String size;

  factory MyOrderItem.fromJson(Map<String, dynamic> json) => MyOrderItem(
    product_id: json["product_id"],
    quantity: json["quantity"],
    color: json["color"],
    size: json["size"],
  );

  Map<String, dynamic> toJson() => {
    "product_id": product_id,
    "quantity": quantity,
    "color": color,
    "size": size,
  };

  @override
  String toString() {
    return 'MyOrderItem{product_id: $product_id, quantity: $quantity, color: $color, size: $size}';
  }
}