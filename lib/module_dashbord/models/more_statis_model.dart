
import 'package:my_kom/module_authorization/model/app_user.dart';
import 'package:my_kom/module_company/models/product_model.dart';

class MoreStatisticsModel {
  late List<AppUser> users;
  late List<ProductModel> products;

  MoreStatisticsModel();

  Map<String, dynamic>? toJson() {
    Map<String, dynamic> map = {};
    map['orders'] = this.users;

    return map;
  }

}