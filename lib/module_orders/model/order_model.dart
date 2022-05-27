

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:my_kom/consts/order_status.dart';
import 'package:my_kom/module_company/models/product_model.dart';
import 'package:my_kom/module_orders/response/orders/orders_response.dart';

class OrderModel {
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
 late String status;
 late String? cardId;
 // late GeoJson to;
 // late String addressName;
 // late LatLng toOnMap;
 // late String from;
 // late  DateTime creationTime;
 // late  String paymentMethod;
 // late  OrderStatus status;
 // late  String ownerPhone;
 // late String captainPhone;
 // late String clientPhone;
 // late String chatRoomId;
 // late  String storeName;
 // late  String distance;

 //



 OrderModel();
  OrderModel.mainDetailsFromJson(Map<String, dynamic> json) {

   this.id = json['id'];
   this.addressName = json['address_name'];
   this.description = json['description'];
   this.orderValue = json['order_value'];
   this.status = json['status'];
  }


 OrderModel.formJson(Map<String, dynamic> json) {

  this.id = json['id'];
  this.addressName = json['address_name'];
  this.description = json['description'];
  this.orderValue = json['order_value'];
 }


}
