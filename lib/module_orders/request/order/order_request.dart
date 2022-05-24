
import 'package:my_kom/module_orders/response/orders/orders_response.dart';

class CreateOrderRequest {
  late String userId;
 late String fromBranch;
 late GeoJson destination;
 late String phone;
 late String payment;

 late String date;

  CreateOrderRequest(
      {
        required this.userId,
        required this.fromBranch,
     required this.destination,
     required this.phone,
     required this.payment,
     required this.date});

  CreateOrderRequest.fromJson(Map<String, dynamic> json) {
    fromBranch = json['fromBranch'];
    destination = GeoJson.fromJson(json['destination']);
    phone = json['phone'];
    payment = json['payment'];
    date = json['date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['userId'] = this.userId;
    data['fromBranch'] = this.fromBranch;
    data['destination'] = this.destination.toJson();
    data['phone'] = this.phone;
    data['payment'] = this.payment;
    data['date'] = this.date;
    return data;
  }
}
