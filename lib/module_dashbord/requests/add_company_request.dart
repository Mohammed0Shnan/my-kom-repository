import 'package:my_kom/module_company/models/product_model.dart';

class AddCompanyRequest {
  late final String id;
  late final String storeId;
  late final String name;
  late String description;
  late String imageUrl;
  late List<ProductModel> products;
  AddCompanyRequest({required this.name, required this.description, required this.imageUrl});


  Map<String, dynamic>? toJson() {
    Map<String, dynamic> map = {};
    map['store_id'] = this.storeId;
    map['name'] = this.name;
    map['imageUrl'] = this.imageUrl;
    map['description'] = this.description;
    return map;
  }
}



