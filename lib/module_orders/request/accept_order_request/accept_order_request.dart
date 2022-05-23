class AcceptOrderRequest {
  late String orderID;
  late String duration;

  AcceptOrderRequest({required this.orderID,required this.duration});

  AcceptOrderRequest.fromJson(Map<String, dynamic> json) {
    orderID = json['orderID'];
    duration = json['duration'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['orderID'] = this.orderID;
    data['duration'] = this.duration;
    return data;
  }
}
