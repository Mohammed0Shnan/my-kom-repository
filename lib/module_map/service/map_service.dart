import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:my_kom/module_map/bloc/map_bloc.dart';

import '../models/address_model.dart';

class MapService {
  // final SharedPreferencesHelper _preferencesHelper = SharedPreferencesHelper();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<MapData> getCurrentLocation() async {
    await Future.delayed(Duration(seconds: 2));
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

  Future<DocumentReference> saveLocation(LatLng latLng ,String description) async {
    AddressModel addressModel = AddressModel(description: description, latitude: latLng.latitude, longitude: latLng.longitude, geoData: {});
    await Future.delayed(Duration(seconds: 2));
    FirebaseFirestore fire = await FirebaseFirestore.instance;
    try{
      return fire
          .collection('locations')
          .add(addressModel.toJson());
    }catch(e){
      throw(e.toString());
    }

  }

  Future<String> getPositionDetail(LatLng latLng) async {
   List<Placemark> placemarks = await placemarkFromCoordinates(
       latLng.latitude, latLng.longitude,
       localeIdentifier: 'en');
   String address = _getDetailFromPlacemark(placemarks);
    return address;
  }

  String _getDetailFromPlacemark(List<Placemark>? placemarks) {
    Placemark place1 = placemarks![0];
    Placemark place2 = placemarks[1];
    String _currentAddress =

        "${place1.name} ${place2.name} ${place1.subLocality}${place1
        .subAdministrativeArea} ";
    return _currentAddress;
  }
}
