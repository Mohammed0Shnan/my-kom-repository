class CompanyModel {
  late final String id;
  late final String name;
  late String description;
  late String imageUrl;
  CompanyModel({required this.id, required this.name, required this.imageUrl});

  CompanyModel.fromJson(Map<String, dynamic> map) {
    this.id = map['id'];
    this.name = map['name'];
    this.imageUrl = map['imageUrl'];
  }

  Map<String, dynamic>? toJson() {
    Map<String, dynamic> map = {};
    map['id'] = this.id;
    map['name'] = this.name;
    map['imageUrl'] = this.imageUrl;
    return map;
  }
}
