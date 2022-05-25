
import 'package:my_kom/utils/logger/logger.dart';

import 'package:my_kom/module_company/models/product_model.dart';
import 'package:my_kom/module_orders/response/orders/orders_response.dart';

class OrdersListResponse {
  late String userId;
  late String storeId;
  late String addressName;
  late double orderValue;
  late String description;

  OrdersListResponse(
      {
        required this.userId,
        required this.orderValue,
        required this.description,
        required this.addressName
      });

  // CreateOrderRequest.fromJson(Map<String, dynamic> json) {
  //   storeId = json['storeId'];
  //   destination = GeoJson.fromJson(json['destination']);
  //   phone = json['phone'];
  //   payment = json['payment'];
  //   date = json['date'];
  //   products = (json['products']).map((e) => null);
  // }

  Map<String, dynamic> mainDetailsToJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data['userId'] = this.userId;
    // data['storeId'] = this.storeId;
    data['description'] = this.description;
    data['order_value'] = this.orderValue;
    data['address_name'] = this.addressName;


    return data;
  }
}


class GeoJson {
 late double lat;
 late double lon;

  GeoJson({required this.lat,required this.lon});

  GeoJson.fromJson(dynamic data) {
    var json = <String, dynamic>{};
    if (data == null) {
      return;
    }
    if (data is List) {
      if (data.last is Map) {
        json = data.last;
      }
    }
    if (data != null) {
      if (data is Map) {
        lat = double.tryParse(json['lat'].toString())!;
        lon = double.tryParse(json['lon'].toString())!;
      }
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['lat'] = this.lat;
    data['lon'] = this.lon;
    return data;
  }
}




