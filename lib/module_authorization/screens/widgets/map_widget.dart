import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:my_kom/module_authorization/bloc/map_bloc.dart';
import 'package:my_kom/module_authorization/service/map_service.dart';
import 'package:search_map_location/search_map_location.dart';
import 'package:search_map_location/utils/google_search/place.dart';

class MapWidget extends StatefulWidget {
  const MapWidget({Key? key}) : super(key: key);

  @override
  State<MapWidget> createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  Completer<GoogleMapController> _controller = Completer();

  final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(25.313997026675395, 55.3825169429183),
    zoom: 15,
  );
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    mapBloc.getCurrentPosition();
  }

  final Set<Marker> _markers = Set<Marker>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              color: Colors.red,
              child: SearchLocation(
                apiKey: 'AIzaSyBNRUekR6R3TGyiuvLow72hNH5S61u0ffg',
                // The language of the autocompletion
                language: 'en',
                //Search only work for this specific country
                country: 'BD',
                onSelected: (Place place) async {
                  final geolocation = await place.geolocation;
                  print(place.description);
                  // Will animate the GoogleMap camera, taking us to the selected position with an appropriate zoom
                  // final GoogleMapController controller = await _controller.future;
                  // controller.animateCamera(CameraUpdate.newLatLng(geolocation!.coordinates));
                  // controller.animateCamera(CameraUpdate.newLatLngBounds(geolocation.bounds, 0));
                },
              ),
            ),
            Expanded(
              child: BlocConsumer<MapBloc, MapStates>(
                bloc: mapBloc,
                listener: (context, state) {
                  if (state is MapSuccessState) {
                    print('listnerrrrrrrrrrrrrrr');
                    _move(state.position);
                  }
                },
                builder: (context, state) {
                  return GoogleMap(
                    onTap: (v) {
                      print('on taaaaaap');
                      //  getDetailFromLocation(LatLng(v.latitude, v.longitude));
                      print(v);
                    },
                    markers: _markers,
                    myLocationButtonEnabled: true,
                    myLocationEnabled: true,
                    zoomGesturesEnabled: true,
                    tiltGesturesEnabled: true,
                    zoomControlsEnabled: false,
                    scrollGesturesEnabled: true,
                    rotateGesturesEnabled: true,
                    mapType: MapType.normal,
                    initialCameraPosition: _kGooglePlex,
                    onMapCreated: (GoogleMapController controller) {
                      _controller.complete(controller);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: BlocConsumer<MapBloc, MapStates>(

        bloc: mapBloc,
        listener: (context,state){
          if(state is MapSuccessSavePositionState){
            showDialog(context: context, builder: (context){
              return Container(
                width: 200,
                height: 100,
                child: Center(child: Text('Saving')),
              );
            });
          }
        },
        builder: (context, state) {
          return FloatingActionButton(
            onPressed: () {
              if (state is MapSuccessState) {
                mapBloc.savePosition(state.position);
              };
            },
            child: Icon(Icons.save),
          );
        },
      ),
    );
  }

  getDetailFromLocation(LatLng latLng) async {
    List<Placemark>? placemarks = await MapService().getPositionDetail(latLng);
    Placemark place1 = placemarks![0];
    Placemark place2 = placemarks[1];
    String _currentAddress =
        "${place1.name} ${place2.name} ${place1.subLocality}${place1.subAdministrativeArea} ${place1.postalCode}";
    print('++++++++++++++++++++++++++++++++++++++');
    print('================ currnt address ======================');
    print(_currentAddress);
    print('++++++++++++++++++++++++++++++++++++++');
    Marker marker = Marker(
        markerId: MarkerId('_current_position'),
        infoWindow: InfoWindow(title: 'My Location'),
        icon: BitmapDescriptor.defaultMarker,
        position: latLng);
    _setMarker(marker);
  }

  Future<void> _move(Position position) async {
    LatLng latLng = LatLng(position.latitude, position.longitude);
    Marker marker = Marker(
        markerId: MarkerId('_current_position'),
        infoWindow: InfoWindow(title: 'My Location'),
        icon: BitmapDescriptor.defaultMarker,
        position: latLng);

    CameraPosition cameraPosition = CameraPosition(target: latLng, zoom: 16);
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
    _setMarker(marker);
  }

  save(Position position) async {
    MapService mapService = MapService();
    await mapService.saveLocation(position);
  }

  _setMarker(Marker marker) {
    _markers.clear();
    _markers.add(marker);
    setState(() {});
  }
}
