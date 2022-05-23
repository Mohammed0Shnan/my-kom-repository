import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:my_kom/consts/colors.dart';
import 'package:my_kom/module_map/bloc/map_bloc.dart';
import 'package:my_kom/module_map/models/address_model.dart';
import 'package:my_kom/module_map/service/map_service.dart';
import 'package:my_kom/utils/size_configration/size_config.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  Completer<GoogleMapController> _controller = Completer();

  final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(25.313997026675395, 55.3825169429183),
    zoom: 15,
  );
  late final TextEditingController _searchController;
  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: '');
   mapBloc.getCurrentPosition();
  }

  final Set<Marker> _markers = Set<Marker>();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MapBloc, MapStates>(
      bloc: mapBloc,
      listener: (context, state) {
        if (state is MapSuccessState) {
          LatLng latLng = LatLng(state.data.latitude, state.data.longitude);
          _searchController.text = state.data.name;
          _move(latLng);
         // getDetailFromLocation(latLng);
        } else if (state is MapErrorState) {
          showTopSnackBar(
            context,
            CustomSnackBar.error(
                icon: Icon(Icons.location_off_sharp),
                message:
                   state.error_message),
          );
        } else if (state is MapSuccessSavePositionState) {
          showTopSnackBar(
            context,
            CustomSnackBar.success(
              backgroundColor: ColorsConst.mainColor,
              icon: Icon(Icons.location_on),
              message: state.message,
            ),
            displayDuration: Duration(seconds: 2),

          );
          AddressModel addressModel = AddressModel(description: _searchController.text, latitude: state.latitude, longitude:state.longitude, geoData: {});
          Navigator.pop(context, addressModel);
        }
      },
      builder: (context, state) {
        return Scaffold(
            body: SafeArea(
              child: Stack(
                children: [
                  Container(
                    height: SizeConfig.screenHeight,
                    width: SizeConfig.screenWidth,
                    child: GoogleMap(
                      onTap: (v) {
                        LatLng latLng = LatLng(v.latitude, v.longitude);
                        mapBloc.getGesturePosition(latLng, '').then((value) {
                          getDetailFromLocation(latLng);
                        });
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
                    ),
                  ),
                  if (state is MapLoadingState)
                    Positioned.fill(
                      child: Container(
                        child: Center(
                          child: CircularProgressIndicator(
                            color: ColorsConst.mainColor,
                          ),
                        ),
                      ),
                    )
                  // Container(
                  //   color: Colors.red,
                  //   height: 60,
                  //   width: SizeConfig.screenWidth,
                  //   // child: SearchLocation(
                  //   //   apiKey: 'AIzaSyBNRUekR6R3TGyiuvLow72hNH5S61u0ffg',
                  //   //   // The language of the autocompletion
                  //   //   language: 'en',
                  //   //   //Search only work for this specific country
                  //   //   country: 'BD',
                  //   //   onSelected: (Place place) async {
                  //   //     final geolocation = await place.geolocation;
                  //   //     print(place.description);
                  //   //     // Will animate the GoogleMap camera, taking us to the selected position with an appropriate zoom
                  //   //     // final GoogleMapController controller = await _controller.future;
                  //   //     // controller.animateCamera(CameraUpdate.newLatLng(geolocation!.coordinates));
                  //   //     // controller.animateCamera(CameraUpdate.newLatLngBounds(geolocation.bounds, 0));
                  //   //   },
                  //   // ),
                  // ),
                  ,
                  Positioned(
                      top: 10,
                      left: 10,
                      right: 10,
                      child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                    color:
                                        ColorsConst.mainColor.withOpacity(0.1),
                                    blurRadius: 2,
                                    spreadRadius: 1)
                              ]),
                          child: TextFormField(
                            controller: _searchController,
                            readOnly: true,
                            style: TextStyle(
                              fontWeight: FontWeight.w600
                            ),
                            decoration: InputDecoration(

                              prefixIcon: Icon(
                                Icons.location_on,
                                color: ColorsConst.mainColor,
                              ),
                              border: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: Colors.black,
                                    width: 10,
                                    style: BorderStyle.solid),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              // S.of(context).email,
                            ),
                            // Move focus to next
                          ))),
                  Positioned(
                      bottom: 15,
                      left: 15,
                      right: 15,
                      child: Material(
                        borderRadius: BorderRadius.circular(10),
                        color: ColorsConst.mainColor,
                        elevation: 10,
                        child: TextButton(
                          onPressed: (){
                            if (state is MapGestureSuccessState) {
                              LatLng latLng =
                              LatLng(state.data.latitude, state.data.longitude);
                              mapBloc.saveLocation(latLng, state.data.name);
                            }
                            else {
                              showTopSnackBar(
                                context,
                                CustomSnackBar.info(
                                  backgroundColor: ColorsConst.mainColor,
                                  icon: Icon(Icons.location_on),
                                  message: "Select the address and save !",
                                ),
                                displayDuration: Duration(seconds: 2),

                              );
                            }
                          },
                          child:  Text(
                            'Save',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: SizeConfig.titleSize * 3.8,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ))
                ],
              ),
            ),
            floatingActionButton: Container(
              margin: EdgeInsets.only(bottom: SizeConfig.screenHeight * 0.1 ),
              child: FloatingActionButton(
                onPressed: () {
                mapBloc.getCurrentPosition();
                },
                child: Icon(Icons.my_location),
              ),
            ));
      },
    );
  }

  getDetailFromLocation(LatLng latLng) async {
    String _currentAddress = await MapService().getPositionDetail(latLng);
    print(_currentAddress);
    Marker marker = Marker(
        markerId: MarkerId('_current_position'),
        infoWindow: InfoWindow(
          title: _currentAddress,
        ),
        icon: BitmapDescriptor.defaultMarker,
        position: latLng);

    _setMarker(marker);
    _searchController.text = _currentAddress;
  }

  Future<void> _move(LatLng latLng) async {
    CameraPosition cameraPosition = CameraPosition(target: latLng, zoom: 16);
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
  }

  _setMarker(Marker marker) {
    _markers.clear();
    _markers.add(marker);
  }
}
