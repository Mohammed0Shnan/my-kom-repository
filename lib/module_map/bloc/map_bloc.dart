

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:my_kom/module_map/service/map_service.dart';

class MapBloc extends Bloc<MapEvents, MapStates> {
  final MapService _service = MapService();
  MapBloc() : super(MapInitState()) {
    on<MapEvents>((MapEvents event, Emitter<MapStates> emit) {
      if (event is MapLoadingEvent)
        emit(MapLoadingState());
      else if (event is MapSuccessEvent) emit(MapSuccessState(event.data));
      else if (event is MapGestureSuccessEvent) emit(MapGestureSuccessState(event.data));

      else if (event is MapErrorEvent) emit(MapErrorState());

      else if(event is MapSuccessSavePositionEvent){
        emit(MapSuccessSavePositionState());
      }
    });
  }

  Future<void> getCurrentPosition() async {

    this.add(MapLoadingEvent());
    _service.getCurrentLocation().then((value) {
      this.add(MapErrorEvent());
      // if(value == null){
      // this.add(MapErrorEvent());
      // }else{
      //   this.add(MapSuccessEvent(value));
      // }
    });     
  }

  Future<void> getGesturePosition(LatLng latLng ,String description) async {
    this.add(MapGestureSuccessEvent(MapData(latitude: latLng.longitude,longitude: latLng.longitude,name:description)));
  }

 //  Future<void> savePosition(Position position , String description)async{
 // this.add(MapLoadingEvent());
 //    _service.saveLocation(position,description).then((value) {
 //      if(value == null){
 //      this.add(MapErrorEvent());
 //      }else{
 //        this.add(MapSuccessSavePositionEvent());
 //      }
 //    });
 //  }

  Future<void> saveLocation(LatLng latLng, String description) async {
    this.add(MapLoadingEvent());
    _service.saveLocation(latLng,description).then((value) {
      if(value == null){
        this.add(MapErrorEvent());
      }else{
        this.add(MapSuccessSavePositionEvent());
      }
    });
  }
}

abstract class MapEvents {}

class MapInitEvent extends MapEvents {}

class MapSuccessEvent extends MapEvents {
  MapData data;
  MapSuccessEvent(this.data);
}
class MapGestureSuccessEvent extends MapEvents {
  MapData data;
  MapGestureSuccessEvent(this.data);
}

class MapLoadingEvent extends MapEvents {}

class MapErrorEvent extends MapEvents {}
class MapSuccessSavePositionEvent extends MapEvents {}

abstract class MapStates {}

class MapInitState extends MapStates {}

class MapSuccessState extends MapStates {
  MapData data;  MapSuccessState(this.data);
}
class MapGestureSuccessState extends MapStates {
  MapData data;  MapGestureSuccessState(this.data);
}

class MapLoadingState extends MapStates {}
class MapSuccessSavePositionState extends MapStates {}
class MapErrorState extends MapStates {}

class MapData{
  double longitude,latitude;
  String name;
  MapData({required this.latitude ,required this.longitude ,required this.name});
}

MapBloc mapBloc = MapBloc();
