import 'package:my_kom/module_company/models/product_model.dart';

class AddProductRequest {
  late final String id;
  late final String companyId;
  late final String title;
  late String description;
  late String imageUrl;
  late final int quantity;
  late final double price;
  late final double? old_price;
  late final isRecommended;
  late final List<SpecificationsModel> specifications;

  late List<ProductModel> products;
  AddProductRequest({required this.title,required this.isRecommended, required this.description, required this.imageUrl,required this.quantity,required this.price});


  Map<String, dynamic>? toJson() {
    Map<String, dynamic> map = {};
    map['title'] = this.title;
    map['company_id'] = this.companyId;
    map['imageUrl'] = this.imageUrl;
    map['description'] = this.description;
    map['quantity'] = this.quantity;
    map['price'] = this.price;
    map['old_price'] = null;
    map['isRecommended'] = this.isRecommended;
   // map['specifications'] = this.specifications.map((e) =>e.toJson()).toList();
    return map;
  }
}
