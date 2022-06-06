

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:my_kom/consts/order_status.dart';
import 'package:my_kom/module_company/models/product_model.dart';
import 'package:my_kom/module_orders/response/orders/orders_response.dart';

class OrderModel {
 late String id;
 late int customerOrderID;
 late String userId;
 late String storeId;
 late List<ProductModel> products;
 late String deliveryTime;
 late int numberOfMonth;
 late DateTime? startDate;
 late String phone;
 late GeoJson destination;
 late String addressName;
 late double orderValue;
 late String description;
 late String payment;
 late OrderStatus status;
 late String? cardId;

 late List<String> productIds;
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
   this.payment = json['payment'];
   this.customerOrderID =json['customer_order_id'];
   //this.startDate = json['start_date']==null?null:DateTime.parse(json['start_date']);


   // List<ProductModel> productFromResponse = [];
   // json['products'].forEach((v) {
   //  productFromResponse.add(ProductModel.fromJson(v));
   // });
   // this.products = productFromResponse;

   OrderStatus state = OrderStatus.INIT;
   if(json['status'] == OrderStatus.IN_STORE.name){
    state = OrderStatus.IN_STORE;
   }
   else if(json['status'] == OrderStatus.DELIVERING.name){
    state = OrderStatus.DELIVERING;
   }
   else if(json['status'] == OrderStatus.FINISHED.name){
    state = OrderStatus.FINISHED;
   }
   else if(json['status'] == OrderStatus.GOT_CAPTAIN.name){
    state = OrderStatus.GOT_CAPTAIN;
   }
   else if(json['status'] == OrderStatus.GOT_CASH.name){
    state = OrderStatus.GOT_CASH;
   }
   else
   {
    state = OrderStatus.INIT;
   }
   this.status = state;
  }


 // OrderModel.formJson(Map<String, dynamic> json) {
 //
 //  this.id = json['id'];
 //  this.addressName = json['address_name'];
 //  this.description = json['description'];
 //  this.orderValue = json['order_value'];
 // }


}
