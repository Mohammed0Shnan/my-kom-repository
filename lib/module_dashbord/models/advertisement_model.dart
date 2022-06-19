

class AdvertisementModel{
  late String id;
  late String storeID;
  late String imageUrl;
  late String route;
  AdvertisementModel({required this.id , required this.imageUrl,required this.route,required this.storeID});

  Map<String ,dynamic> toJson(){
    final Map<String, dynamic> data = <String, dynamic>{};
    data['imageUrl'] = this.imageUrl;
    data['storeID'] = this.storeID;
    data['route'] = this.route;
    return data;
  }

  AdvertisementModel.fromJson(Map<String, dynamic> data){
    this.id = data['id'];
    this.imageUrl= data['imageUrl'];
    this.storeID= data['storeID'];
    this.route= data['route'];
  }
}