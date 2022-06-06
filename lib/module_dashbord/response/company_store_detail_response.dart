

class CompanyStoreDetailResponse{
  late String id;
  late final String storeId;
  late String name;
  late String imageUrl;
  late String description;

  CompanyStoreDetailResponse();

  CompanyStoreDetailResponse.fromJsom(Map<String, dynamic> data){
    this.id= data['id'];
    this.name= data['name'];
    this.imageUrl= data['imageUrl'];
    this.description= data['description'];
    this.storeId= data['store_id'];

  }

}