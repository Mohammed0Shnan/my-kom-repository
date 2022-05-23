

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:my_kom/consts/order_status.dart';
import 'package:my_kom/module_orders/response/orders/orders_response.dart';

class OrderModel {
 late int id;
 late GeoJson to;
 late LatLng toOnMap;
 late String from;
late  DateTime creationTime;
late  String paymentMethod;
late  OrderStatus status;
late  String ownerPhone;
 late String captainPhone;
 late String clientPhone;
 late String chatRoomId;
late  String storeName;
late  String distance;

  OrderModel({
   required this.id,
   required this.to,
   required this.from,
   required this.creationTime,
   required this.paymentMethod,
   required this.status,
   required this.storeName,
   required this.ownerPhone,
   required this.captainPhone,
   required this.clientPhone,
   required this.chatRoomId,
   required this.distance,
  });

  OrderModel.fromJson(Map<String, dynamic> json) {
    if (json == null) {
      return;
    }
    creationTime = json['date'];
    id = json['id'];
    from = json['fromBranch'];
    paymentMethod = json['payment'];
  }
}
