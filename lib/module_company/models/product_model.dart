class ProductModel {
  late final String id;
  late final String title;
  late final String description;
  late final double price;
  late final double? old_price;
  late final int quantity;
  late final imageUrl;
  late final int orderQuantity;
  late final List<SpecificationsModel> specifications;
  ProductModel(
      {required this.id,
      required this.title,
      required this.description,
      required this.price,
      required this.old_price,
      required this.imageUrl,
      required this.quantity,
      required this.specifications
      });

  ProductModel.fromJson(dynamic json) {
    Map<String ,dynamic> map = json as Map<String ,dynamic>;
    print('1111111111111111111111111111111111111111111111111111');
    print(map);
    this.id = map['id'];
    this.title = map['title'];
    this.description = map['description'];
    this.price = map['price'];
    this.old_price = map['old_price'] ;
    this.quantity = map['quantity'];
    this.orderQuantity = map['order_quantity'];
    this.imageUrl = map['image_url'];
    List<SpecificationsModel> specifications = [];
    map['specifications'].forEach((v) {
      specifications.add(SpecificationsModel.fromJson(v));
    });
    this.specifications = specifications;
  }

  Map<String, dynamic>? toJson() {
    Map<String, dynamic> map = {};
    map['id'] = this.id;
    map['title'] = this.title;
    map['description'] = this.description;
    map['price'] = this.price;
    map['old_price'] = this.old_price;
    map['quantity'] = this.quantity;
    map['order_quantity'] = this.orderQuantity;
    map['image_url'] = this.imageUrl;
   map['specifications'] = this.specifications.map((e) => e.toJson()).toList();
    return map;
  }
}

class SpecificationsModel {
  late final String name;
  late final String value;
  late final List<SpecificationsModel> specifications;
  SpecificationsModel(
      {required this.name,
        required this.value,

      });

  SpecificationsModel.fromJson(Map<String, dynamic> map) {
    this.name = map['name'];
    this.value = map['value'];

  }

  Map<String, dynamic>? toJson() {
    Map<String, dynamic> map = {};
    map['name'] = this.name;
    map['value'] = this.value;

    return map;
  }
}

