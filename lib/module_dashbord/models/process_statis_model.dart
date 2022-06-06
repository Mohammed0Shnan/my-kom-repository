
class ProcessStatisticsModel {
  late int orders;
  late double revenue;
  late DateTime dateTime;

  ProcessStatisticsModel({required this.orders, required this.revenue});

  Map<String, dynamic>? toJson() {
    Map<String, dynamic> map = {};
    map['orders'] = this.orders;
    map['revenue'] = this.revenue;
    map['dateTime'] = this.dateTime;
    return map;
  }

}