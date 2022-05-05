class AddressModel{
 late final double latitude, longitude;
 late final String description;
late  final Map<String , dynamic> geoData;
 AddressModel({required this.description , required this.latitude , required this.longitude , required this.geoData});
 Map<String, dynamic> toJson(){
  Map<String , dynamic> map = Map<String,dynamic>();
  map['name'] = this.description;
  map['position'] = {
   'latitude': this.latitude,
   'longitude':this.longitude
  };
  map['geoData']=this.geoData;
  return map;
 }



 AddressModel.fromJson(Map<String , dynamic> map){
  this.latitude = map['latitude'];
  this.longitude = map['longitude'];
  this.description = map['description'];
  this.geoData = map['geoData'];

 }

}