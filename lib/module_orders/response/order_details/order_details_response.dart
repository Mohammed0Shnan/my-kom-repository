
import 'package:my_kom/module_company/models/product_model.dart';
import 'package:my_kom/module_orders/response/orders/orders_response.dart';

class OrderDetailResponse {
  late String id;
  late String userId;
  late String storeId;
  late List<ProductModel> products;
  late String deliveryTime;
  late int numberOfMonth;
  late String startDate;
  late String phone;
  late GeoJson destination;
  late String addressName;
  late double orderValue;
  late String description;
  late String payment;
  late String? cardId;

  OrderDetailResponse.fromJson(Map<String, dynamic> json) {

    this.id = json['id'];
    this.cardId = json['card_id'];
    this.destination =GeoJson.fromJson(json['destination'] );
    this.addressName = json['address_name'];
    this.deliveryTime = json['delivery_time'];
    this.description = json['description'];
    this.numberOfMonth = json['number_of_month'];
    this.orderValue = json['order_value'];
    this.payment = json['payment'];
    this.phone = json['phone'];
   List<ProductModel> productFromResponse = [];
    json['products'].forEach((v) {
      productFromResponse.add(ProductModel.fromJson(v));
    });
    this.products = productFromResponse;
    this.startDate = json['start_date'];
  }
}
