class ProductModel {
  late final String id;
  late final String title;
  late final String description;
  late final double price;
  late final double? old_price;
  late final int quantity;
  late final imageUrl;
  ProductModel(
      {required this.id,
      required this.title,
      required this.description,
      required this.price,
      required this.old_price,
      required this.imageUrl,
      required this.quantity});

  ProductModel.fromJson(Map<String, dynamic> map) {
    this.id = map['id'];
    this.title = map['title'];
    this.description = map['description'];
    this.price = map['price'];
    this.old_price = map['old_price'];
    this.quantity = map['quantity'];
    this.quantity = map['imageUrl'];
  }

  Map<String, dynamic>? toJson() {
    Map<String, dynamic> map = {};
    map['id'] = this.id;
    map['title'] = this.title;
    map['description'] = this.description;
    map['price'] = this.price;
    map['old_price'] = this.old_price;
    map['quantity'] = this.quantity;
    map['imageUrl'] = this.quantity;
    return map;
  }
}
