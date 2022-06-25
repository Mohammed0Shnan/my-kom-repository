import 'package:my_kom/module_company/models/company_model.dart';
import 'package:my_kom/module_dashbord/models/zone_models.dart';
import 'package:my_kom/module_orders/response/orders/orders_response.dart';

class StoreModel{
  late String id;
  late String name;
  late GeoJson location;
  late String locationName;
  late List<ZoneModel> zones;
  late List<CompanyModel> companies;
  StoreModel({required this.id , required this.zones});
   Map<String ,dynamic> toJson(){
     final Map<String, dynamic> data = <String, dynamic>{};
     data['name'] = this.name;
     data['location_name'] = this.locationName;
     data['location'] = this.location.toJson();
  //   data['zones'] = this.zones.map((e) =>e.toJson()).toList();
     return data;
   }
  StoreModel.fromJson(Map<String, dynamic> data){
    this.id = data['id'];
  this.name= data['name'];
  this.locationName= data['location_name'];

    this.location=GeoJson.fromJson(data['location'] );
    List<ZoneModel> zoneFromResponse = [];
    if( data['zones'] != null){
      data['zones'].forEach((v) {
        zoneFromResponse.add(ZoneModel.fromJson(v));
      });
    }

    this.zones = zoneFromResponse;
    if( data['companies'] != null){
     List<CompanyModel> companyFromResponse = [];
     data['companies'].forEach((v) {
       companyFromResponse.add(CompanyModel.fromJson(v));
     });
     this.companies = companyFromResponse;
   }else{
     this.companies = [];

   }



  }
}