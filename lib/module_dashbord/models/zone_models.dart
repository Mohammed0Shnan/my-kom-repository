class ZoneModel{
  late String name;

  ZoneModel({required this.name});

  Map<String, dynamic>? toJson() {
    Map<String, dynamic> map = {};
    map['name'] = this.name;
    return map;
  }


  ZoneModel.fromJson( Map<String, dynamic> map) {
    this.name =map['name'];

  }

}