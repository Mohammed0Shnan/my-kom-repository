import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapService {
  // final SharedPreferencesHelper _preferencesHelper = SharedPreferencesHelper();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Position?> getCurrentLocation() async {
    await Future.delayed(Duration(seconds: 2));
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      return position;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<DocumentReference?> saveLocation(Position position) async {
    await Future.delayed(Duration(seconds: 2));
    FirebaseFirestore fire = await FirebaseFirestore.instance;

    // Fetch geo location  from latitude and longitude
    Geoflutterfire geoflutterfire = Geoflutterfire();
    GeoFirePoint point = geoflutterfire.point(
        latitude: position.latitude, longitude: position.longitude);

    // Fetch name from latitude and longitude
    // List<Placemark>? placemarks =
    //     await getPositionDetail(LatLng(position.latitude, position.longitude));
    // Placemark place1 = placemarks![0];
    // Placemark place2 = placemarks[1];
    // String _positionName =
    //     "${place1.name} ${place2.name} ${place1.subLocality}${place1.subAdministrativeArea} ${place1.postalCode}";
  String _positionName = 'dumy name';
    // Save In Fire Base
    return fire
        .collection('locations')
        .add({'position': point.data, 'name': _positionName});
  }

  Future<List<Placemark>?> getPositionDetail(LatLng latLng) async {
    List<Placemark> placemarks = await placemarkFromCoordinates(
        latLng.latitude, latLng.longitude,
        localeIdentifier: 'en');
    return placemarks;
  }
}
