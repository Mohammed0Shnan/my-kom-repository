
import 'package:my_kom/module_orders/response/orders/orders_response.dart';

class CreateOrderRequest {
 late String fromBranch;
 late GeoJson destination;
 late String note;
 late String payment;
 late String recipientName;
 late String recipientPhone;
 late String date;

  CreateOrderRequest(
      {required this.fromBranch,
     required this.destination,
     required this.note,
     required this.payment,
     required this.recipientName,
    required  this.recipientPhone,
     required this.date});

  CreateOrderRequest.fromJson(Map<String, dynamic> json) {
    fromBranch = json['fromBranch'];
    destination = GeoJson.fromJson(json['destination']);
    note = json['note'];
    payment = json['payment'];
    recipientName = json['recipientName'];
    recipientPhone = json['recipientPhone'];
    date = json['date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['fromBranch'] = this.fromBranch;
    data['destination'] = this.destination.toJson();
    data['note'] = this.note;
    data['payment'] = this.payment;
    data['recipientName'] = this.recipientName;
    data['recipientPhone'] = this.recipientPhone;
    data['date'] = this.date;
    return data;
  }
}
