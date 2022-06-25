
import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:my_kom/consts/order_status.dart';
import 'package:my_kom/module_authorization/enums/user_role.dart';
import 'package:my_kom/module_authorization/model/app_user.dart';
import 'package:my_kom/module_company/models/company_model.dart';
import 'package:my_kom/module_company/models/product_model.dart';
import 'package:my_kom/module_dashbord/models/advertisement_model.dart';
import 'package:my_kom/module_dashbord/models/more_statis_model.dart';
import 'package:my_kom/module_dashbord/models/order_state_chart.dart';
import 'package:my_kom/module_dashbord/models/process_statis_model.dart';
import 'package:my_kom/module_dashbord/models/store_model.dart';
import 'package:my_kom/module_dashbord/models/zone_models.dart';
import 'package:my_kom/module_dashbord/requests/add_company_request.dart';
import 'package:my_kom/module_dashbord/requests/add_product_request.dart';
import 'package:my_kom/module_dashbord/response/company_store_detail_response.dart';
import 'package:my_kom/module_dashbord/response/store_detail_response.dart';
import 'package:my_kom/module_localization/presistance/localization_preferences_helper.dart';
import 'package:my_kom/module_localization/service/localization_service/localization_b;oc_service.dart';
import 'package:my_kom/module_orders/model/order_model.dart';
import 'package:my_kom/module_orders/request/accept_order_request/accept_order_request.dart';
import 'package:my_kom/module_orders/response/order_status/order_status_response.dart';
import 'package:rxdart/rxdart.dart';

class DashBoardService{
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final PublishSubject<List<StoreModel>?> storesPublishSubject =
  new PublishSubject();

  final PublishSubject<List<CompanyModel>?> companyStoresPublishSubject =
  new PublishSubject();

  final PublishSubject<List<ProductModel>?> productCompanyStoresPublishSubject =
  new PublishSubject();



  final PublishSubject<MoreStatisticsModel?> moreStatisPublishSubject =
  new PublishSubject();


  final PublishSubject<Map<String,List<AppUser>>?> usersPublishSubject =
  new PublishSubject();

  final LocalizationPreferencesHelper _localizationPreferencesHelper = LocalizationPreferencesHelper();

  Future<StoreModel?> addStore(StoreModel storeModel)async{

    try{
      var document =await _firestore.collection('stores').add(storeModel.toJson());
      for(int i=0;i < storeModel.zones.length;i++){
        ZoneModel zoneModel = storeModel.zones[i];
        zoneModel.storeID =document.id;
         await _firestore.collection('zones').add(zoneModel.toJson()!);
      }
      storeModel.id = document.id;
      return storeModel;
    }catch(e){
      return null;
    }

  }

  Future<void> getAllStores() async {
    try{
      _firestore.collection('stores').snapshots().listen((event) async {
        List<StoreModel> list = [];
        for (int i = 0; i < event.docs.length; i++) {
          QueryDocumentSnapshot element2 = event.docs[i];
          Map <String, dynamic> map = element2.data() as Map<String, dynamic>;
          map['id'] = element2.id;
          StoreModel store = StoreModel.fromJson(map);
          list.add(store);
        }
        storesPublishSubject.add(list);
      });
    }catch(e){
      storesPublishSubject.add(null);

    }

  }



  Future<bool>  updateOrder(String orderId, OrderModel order)async {
    await Future.delayed(Duration(seconds: 1));
    String state ;
    switch (order.status) {
      case OrderStatus.GOT_CAPTAIN:{
        state = OrderStatus.GOT_CAPTAIN.name;
      }
      break;
      case OrderStatus.IN_STORE:{
        state = OrderStatus.IN_STORE.name;
      }
      break;
      case OrderStatus.DELIVERING:{
        state = OrderStatus.DELIVERING.name;
      }
      break;
      case OrderStatus.GOT_CASH:{
        state = OrderStatus.GOT_CASH.name;
      }
      break;
      case OrderStatus.FINISHED:{
        state = OrderStatus.FINISHED.name;
      }
      break;
      default:
        return false;
    }
    try{
      updateOrderRequest request = updateOrderRequest(orderID: orderId , state: state);
      _firestore.collection('orders').doc(orderId).update(request.toJson()).then((value) {
      });
      return true;
    }catch(e){
      return false;
    }

  }

  Future<bool> addCompanyToStore(String storeId, AddCompanyRequest request)async {
    try{
      request.storeId = storeId;
     await _firestore.collection('companies').add(request.toJson()!);

      return true;
    }catch(e){
      return false;
    }
  }

  Future<bool> addProductToCompany(String storeId, String companyId, AddProductRequest request) async {
    try{
      request.companyId = companyId;
      await _firestore.collection('products').add(request.toJson()!);
      return true;
    }catch(e){
      return false;
    }
  }

  Future<StoreModel?> getStoreDetail(String storeId) async{
    try{
      /// store detail
    return  await  _firestore.collection('stores').doc(storeId).get().then((value)async {
       Map <String, dynamic> map = value.data() as Map<String, dynamic>;

       /// Zones
      return await _firestore.collection('zones').where('store_id',isEqualTo: storeId).get().then((zones) {
        List<  Map<String, dynamic>> zoneList = [];
        zones.docs.forEach((zone)
         {
           Map<String, dynamic> z = zone.data();
           zoneList.add(z);
         });
        map['zones'] =zoneList;
        StoreDetailResponse res = StoreDetailResponse.storeDetail(map);
         StoreModel storeModel = StoreModel(id: '',zones: []);
         storeModel.id = storeId;
         storeModel.name = res.name;
         storeModel.location = res.location;
         storeModel.locationName = res.locationName;
         storeModel.zones = res.zones;
         return storeModel;
       });


      });
     //  print('ssssssssssssssssssssss');
     //
     //  /// company detail
     // _firestore.collection('stores').doc(storeId).collection('companies').snapshots().listen((event) async{
     //   List< Map <String, dynamic>> map2 =   < Map <String, dynamic>>[];
     //   for (int i = 0; i < event.docs.length; i++) {
     //     List< Map <String, dynamic>> products =   < Map <String, dynamic>>[];
     //     QueryDocumentSnapshot element2 = event.docs[i];
     //     Map <String, dynamic> compa = element2.data() as Map<String, dynamic>;
     //    await _firestore.collection('stores').doc(storeId).collection('companies').doc(element2.id).
     //     map2.add(m);
     //   }
     //
     //   map['companies'] = map2;
     //  });
     //  print('22222222222222222222222222');
     //
     //  print('###############################');
     //
     //
     //
     //  print(map);
     //  /// products detail
     //  // await  _firestore.collection('stores').doc(storeId).collection('companies').snapshots().forEach((element) {
     //  //   List< Map <String, dynamic>> map2 =   < Map <String, dynamic>>[];
     //  //
     //  //   for (int i = 0; i < element.docs.length; i++) {
     //  //     QueryDocumentSnapshot element2 = element.docs[i];
     //  //     Map <String, dynamic> m = element2.data() as Map<String, dynamic>;
     //  //     map2.add(m);
     //  //   }
     //  //   map['companies'] = map2;
     //  // });

      return null;
    }catch(e){
      return null;
    }
  }

  Future<void> addAdvertisements()async{

  }


  Future<CompanyStoreDetailResponse?> getCompaniesStoreDetail(String storeId) async {
    try {
      /// store detail
      await _firestore
          .collection('companies').where('store_id',isEqualTo: storeId)
          .snapshots()
          .forEach((element) {
        List<CompanyModel> companyList = [];
        element.docs.forEach((element) {
          Map<String, dynamic> map = element.data() as Map<String, dynamic>;
          map['id'] = element.id;

          CompanyStoreDetailResponse res = CompanyStoreDetailResponse.fromJsom(
              map);
          CompanyModel companyModel = CompanyModel(
              id: res.id, name: res.name, imageUrl: res.imageUrl,description:res.description );
          companyModel.storeId = res.storeId;
          companyList.add(companyModel);
        });
        companyStoresPublishSubject.add(companyList);
      });
    }catch(e){
      companyStoresPublishSubject.add(null);
    }
  }

  Future<CompanyStoreDetailResponse?> getProductsCompanyStoreDetail(String storeId,String companyId) async {
    try {
      /// store detail
      await _firestore.collection('products').where('company_id',isEqualTo: companyId)
          .snapshots()
          .forEach((element) {
        List<ProductModel> productsList = [];
        element.docs.forEach((element) {

          Map<String, dynamic> map = element.data() as Map<String, dynamic>;
          print(map);
          map['id'] = element.id;
          ProductModel productModel = ProductModel.fromJson(map);
          productsList.add(productModel);
        });

        productCompanyStoresPublishSubject.add(productsList);
      });
    }catch(e){
      productCompanyStoresPublishSubject.add(null);

    }
  }

  Future<void> users()async {

    _firestore.collection('users').snapshots().listen((event) {
      Map<String,List<AppUser>> userList = {};
      List<AppUser> admins =[];
      List<AppUser> delivers =[];

      event.docs.forEach((element2) {
        Map <String, dynamic> u = element2.data() as Map<String,
            dynamic>;
        u['id'] = element2.id;

        AppUser appUser = AppUser.fromJsom(u);
        if (appUser.userRole == UserRole.ROLE_DELIVERY) {
          delivers.add(appUser);
        }
        else if(appUser.userRole == UserRole.ROLE_OWNER) {
          admins.add(appUser);
        }


      }
      );
      userList['users']= delivers;
      userList['admins']= admins;

      usersPublishSubject.add(userList);

    }).onError((e){
      usersPublishSubject.add(null);
    });

  }


 Future<List<OrderStateChart>?> getStatistics()async{
    try{

     await checkForAddDocumentToStatisticsCollection();

      List<OrderStateChart> list =await _firestore.collection('statistics').orderBy('dateTime').get().then((value) => value.docs.asMap().entries.map((entry) => OrderStateChart.fromSnapshot(entry.value,entry.key)).toList());

      return list;
    }catch(e){
      return null;
    }
 }


  Future<ProcessStatisticsModel> processStatisticsForDay(String time)async{
return   await _firestore.collection('orders').where('start_date',isEqualTo: time).get().then((value) {
    int orders = value.docs.length;
    double revenue = 0.0;
      value.docs.forEach((element) {
      revenue = element.data()['order_value'];
    });
      return ProcessStatisticsModel(orders: orders, revenue: revenue);
    });

  }
  Future<bool> checkForAddDocumentToStatisticsCollection()async {
    try {
      Map<String, dynamic> map = await _firestore.collection('utils')
          .get()
          .then((value) {
        return {'doc_id': value.docs[0].id,
          'date_for_add_statis': value.docs[0].data()['date_for_add_statis']
        };
      });

      DateTime date= DateTime.now();
      DateTime dateInStore = map['date_for_add_statis'].toDate();

//this also handles overflow into the next month
      DateTime dateInStoreAfterPro =  DateTime(dateInStore.year, dateInStore.month,dateInStore.day);
      DateTime dateNowAfterPro =  DateTime(date.year, date.month,date.day);

//store nextCheck somewhere

//in js there is no isAfter, you just use >
     // bool isAfter =  dateNowAfterPro.isAfter(dateInStoreAfterPro);

   //   bool isAfter =  date.isAfter(map['date_for_add_statis'].toDate());
    if(dateNowAfterPro.day == dateInStoreAfterPro.day){
      ProcessStatisticsModel result = await processStatisticsForDay(DateFormat('yyyy-MM-dd').format(date));
      result.dateTime = date;
      /// add document to statistics collection
      ///

     await _firestore.collection('statistics').add(result.toJson()!);

      /// update statistics day in fire store
      ///
      await _firestore.collection('utils').doc(map['doc_id']).update({
        'date_for_add_statis': date
      });
      return true;
    }else{
      return false;
    }
    } catch (e) {
      return false;
    }
  }

  getMoreStatistics()async{
    _firestore.collection('orders').snapshots().listen((event) async{
      MoreStatisticsModel model = MoreStatisticsModel();

      /// for users
      Map<String,int> quantityMap = Map<String,int>();

      /// for products
      Map<String,int> productMap = Map<String,int>();


      event.docs.forEach((element) {
        if(!quantityMap.containsKey(element.data()['userId'])){
          quantityMap[element.data()['userId']]= 1;
        }
        else{
          quantityMap[element.data()['userId']] =    quantityMap[element.data()['userId']]! + 1;
        }

        List<String> ids = element.data()['products_ides'].cast<String>();

        ids.forEach((e) {
          if(!productMap.containsKey(e)){
            productMap[e]= 1;
          }
          else{
            productMap[e] =   productMap[e]! + 1;
          }
        });


      });
      Map<String ,int> sortedMap = SplayTreeMap<String,int>.from(quantityMap, (a, b) => a.compareTo(b));
      Map<String ,int> reverseSortedMap = LinkedHashMap.fromEntries(sortedMap.entries.toList().reversed);
     int index =0;
     List<String> ids=[];
      reverseSortedMap.forEach((key, value) {
        if(index < 5){
          ids.add(key);
          index ++;
        }
      });
      List<AppUser> users = [];
      for(int i=0;i<ids.length;i++){
        await _firestore.collection('users').doc(ids[i]).get().then((value) {
          Map <String, dynamic> u = value.data() as Map<String,
              dynamic>;
          u['id'] = value.id;

          AppUser appUser = AppUser.fromJsom(u);
          users.add(appUser);
        });
      }
      model.users = users;

      ///
      ///
      Map<String ,int> sortedProMap = SplayTreeMap<String,int>.from(productMap, (a, b) => a.compareTo(b));
      Map<String ,int> reverseProSortedMap = LinkedHashMap.fromEntries(sortedProMap.entries.toList().reversed);
       index =0;
      ids=[];
      reverseProSortedMap.forEach((key, value) {
        if(index < 5){
          ids.add(key);
          index ++;
        }
      });
       ids.add('uyf6a6EVO3lm4U6p2Zlh');
      ids.add('uyf6a6EVO3lm4U6p2Zlh');
      ids.add('uyf6a6EVO3lm4U6p2Zlh');
      ids.add('uyf6a6EVO3lm4U6p2Zlh');
      ids.add('uyf6a6EVO3lm4U6p2Zlh');

      print(ids);
      List<ProductModel> products = [];
      for(int i=0;i<5;i++){

        await  _firestore.collection('products').doc(ids[i]).get().then((value) {
          if(value.data()!=null){
            Map<String, dynamic> map = value.data() as Map<String, dynamic>;
            print(map);
            map['id'] = value.id;
            ProductModel productModel = ProductModel.fromJson(map);
            products.add(productModel);
          }

        });
      }
      products.forEach((element) {
        print(element.toJson());
      });
      model.products= products;
      moreStatisPublishSubject.add(model);
    }).onError((e){
      moreStatisPublishSubject.add(null);

    });
  }

 Future<bool> addAdvertisementToStore(AdvertisementModel request) async{
    try{
      await _firestore.collection('advertisements/').add(request.toJson());
      return true;
    }catch(e){
      return false;
    }
  }

  Future<CompanyModel?> getCompany(String id)async {
    try{
    CompanyModel c =  await _firestore.collection('companies').doc(id).get().then((value) {
      Map <String, dynamic> map = value.data() as Map<String, dynamic>;
      map['id'] = value.id;
      CompanyModel model =CompanyModel(id:  map['id'], name: map['name'], imageUrl:map['imageUrl'], description: '');
      return model;
      });
    return c;
    }catch(e){
      return null;
    }
  }



  Future<List<String>> getZoneNames(LatLng latLng)async{
    List<String> names = [];

    /// arabic name
    List<Placemark> placemarks = await placemarkFromCoordinates(
        latLng.latitude, latLng.longitude,
        localeIdentifier: 'ar',

    );
    Placemark place1 = placemarks[0];
    print(place1);
    String zone ='';
    if(place1.locality == ''){
      if(place1.subLocality ==''){
        if(place1.subAdministrativeArea ==''){
          zone = place1.administrativeArea!;
        }else{
          zone = place1.subAdministrativeArea!;
        }
      }else{
        zone = place1.subLocality!;
      }
    }else{
      zone=place1.locality!;
    }
    names.add(zone);
    zone ='';

    /// english name
  placemarks = await placemarkFromCoordinates(
        latLng.latitude, latLng.longitude,
        localeIdentifier: 'en');
   place1 = placemarks[0];
    if(place1.locality == ''){
      if(place1.subLocality ==''){
        if(place1.subAdministrativeArea ==''){
          zone = place1.administrativeArea!;
        }else{
          zone = place1.subAdministrativeArea!;
        }
      }else{
        zone = place1.subLocality!;
      }
    }else{
      zone=place1.locality!;
    }
    names.add(zone);
   print('================= names ====================');
   print(names);
   return names;
  }
  
}