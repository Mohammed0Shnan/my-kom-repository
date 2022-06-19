import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:my_kom/module_authorization/presistance/auth_prefs_helper.dart';
import 'package:my_kom/module_authorization/service/auth_service.dart';
import 'package:my_kom/module_dashbord/response/store_detail_response.dart';
import 'package:my_kom/module_map/bloc/map_bloc.dart';
import 'package:my_kom/module_persistence/sharedpref/shared_preferences_helper.dart';

import '../models/address_model.dart';

class MapService {
  // final SharedPreferencesHelper _preferencesHelper = SharedPreferencesHelper();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final AuthPrefsHelper _authPrefsHelper = AuthPrefsHelper();

  Future<MapData> getCurrentLocation() async {

      // AddressModel? addressModel = await _authPrefsHelper.getAddress();
      // if(addressModel != null){
      //   MapData mapData = MapData(latitude: addressModel.latitude, longitude: addressModel.longitude, name: addressModel.description, message: 'success', isError: false);
      //   return mapData;
      // }
     // else {
        try {
          bool serviceEnabled;
          LocationPermission permission;
          serviceEnabled = await Geolocator.isLocationServiceEnabled();
          if (!serviceEnabled) {
            Future.error('Location services are disabled');
            throw('Location services are disabled');
          }

          permission = await Geolocator.checkPermission();
          if (permission == LocationPermission.denied) {
            permission = await Geolocator.requestPermission();
            if (permission == LocationPermission.denied) {
              Future.error('Location permissions are denied');
              throw('Location permissions are denied');

            }
          }

          if (permission == LocationPermission.deniedForever) {
            Future.error(
                'Location permissions are permanently denied, we cannot request permissions.');
            throw( 'Location permissions are permanently denied, we cannot request permissions.');

          }

          Position position = await Geolocator.getCurrentPosition(
              desiredAccuracy: LocationAccuracy.high);

          String s = await getPositionDetail(
              LatLng(position.latitude, position.longitude));
          return MapData(name: s,
              longitude: position.longitude,
              latitude: position.latitude,
              isError: false,
              message: 'success'
          );

        }catch(e){
          return MapData.error(e.toString());
        }
       // }


  }

  // Future<DocumentReference?> saveLocation(Position position ,String desciption) async {
  //   await Future.delayed(Duration(seconds: 2));
  //   FirebaseFirestore fire = await FirebaseFirestore.instance;
  //
  //   // Fetch geo location  from latitude and longitude
  //   Geoflutterfire geoflutterfire = Geoflutterfire();
  //   GeoFirePoint point = geoflutterfire.point(
  //       latitude: position.latitude, longitude: position.longitude);
  //  // Fetch name from latitude and longitude
  //  //  List<Placemark>? placemarks =
  //  //      await getPositionDetail(LatLng(position.latitude, position.longitude));
  //  //  Placemark place1 = placemarks![0];
  //  //  Placemark place2 = placemarks[1];
  //  //  String _positionName =
  //  //      "${place1.name} ${place2.name} ${place1.subLocality}${place1.subAdministrativeArea} ${place1.postalCode}";
  //
  //   return fire
  //       .collection('locations')
  //       .add({'position': point.data, 'name': desciption});
  // }

  Future<bool> saveLocation(LatLng latLng ,String description) async {
    // AddressModel addressModel = AddressModel(description: description, latitude: latLng.latitude, longitude: latLng.longitude, geoData: {});
    // FirebaseFirestore fire = await FirebaseFirestore.instance;
    // try{
    //   return fire
    //       .collection('locations')
    //       .add(addressModel.toJson());
    // }catch(e){
    //   throw(e.toString());
    // }
    await Future.delayed(Duration(milliseconds: 100));
    return true;

  }

  Future<String> getPositionDetail(LatLng latLng) async {
   List<Placemark> placemarks = await placemarkFromCoordinates(
       latLng.latitude, latLng.longitude,
       localeIdentifier: 'en');
   String address = _getDetailFromPlacemark(placemarks);
    return address;
  }

  Future<String> getSubArea(LatLng latLng)async{
    List<Placemark> placemarks = await placemarkFromCoordinates(
        latLng.latitude, latLng.longitude,
        localeIdentifier: 'en');
    print('_______________________ get sub area in service -------------');
    Placemark place1 = placemarks[0];
    print(place1);
    if(place1.subAdministrativeArea == ''){
      print('sub area is empity');
      print(place1.administrativeArea);

    }else{
      print('sub area is not empity');
      print(place1.subAdministrativeArea);

    }
    print( place1.administrativeArea!);
    print('_______________________ get sub area in service -------------');

    return place1.locality!;
  }

  String _getDetailFromPlacemark(List<Placemark>? placemarks) {
    Placemark place1 = placemarks![0];
    Placemark place2 = placemarks[1];
    String _currentAddress =

        "${place1.name} ${place2.name} ${place1.subLocality}${place2
        .subLocality} ";
    return _currentAddress;
  }
 Future<String> getDumyPosition()async{
    try {
      bool serviceEnabled;
      LocationPermission permission;
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        Future.error('Location services are disabled');
        throw('Location services are disabled');
      }

      permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          Future.error('Location permissions are denied');
          throw('Location permissions are denied');

        }
      }

      if (permission == LocationPermission.deniedForever) {
        Future.error(
            'Location permissions are permanently denied, we cannot request permissions.');
        throw( 'Location permissions are permanently denied, we cannot request permissions.');

      }
     String subArea = await getSubArea(LatLng(37.42270380149313, -122.08567522466183));
    return subArea;

    }catch(e){

return '';

    }
  }

 Future<String?> getSubAreaPosition(LatLng? latLng)async {
   late String subArea ;
   try{
     if(latLng == null){
       MapData data =  await getCurrentLocation();
       //subArea = await getSubArea(LatLng(37.42270380149313, -122.08567522466183));
       subArea = await getSubArea(LatLng(data.latitude,data.longitude));
       print('================ current position ==================');
       print(subArea);
       print('==================================');
     }else{
       print('============== sub area selected positioned ====================');

       subArea = await getSubArea(latLng);
       print(subArea);
       print('==================================');

     }
     return subArea;

   }catch(e){
     return null;
   }
  }

 Future<bool> checkAddressInArea(String storeId,String address) async{
   List<String> zones = await _firestore.collection('stores').doc(storeId).get().then((value) {
     Map<String, dynamic> map  =value.data() as Map<String, dynamic>;
     StoreDetailResponse response = StoreDetailResponse.storeDetail(map);
     List<String> z = [];
     response.zones.forEach((element) {
       z.add(element.name);
     });
     return z;
   });
  return zones.contains(address);

  }


}
