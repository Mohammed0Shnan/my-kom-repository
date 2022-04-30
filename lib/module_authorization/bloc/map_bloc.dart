

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:my_kom/module_authorization/service/map_service.dart';

class MapBloc extends Bloc<MapEvents, MapStates> {
  final MapService _service = MapService();
  MapBloc() : super(MapInitState()) {
    on<MapEvents>((MapEvents event, Emitter<MapStates> emit) {
      print('rrrrrrrrrrrrrr');
      print(event);
      if (event is MapLoadingEvent)
        emit(MapLoadingState());
      else if (event is MapSuccessEvent) emit(MapSuccessState(event.position));
      else if (event is MapErrorEvent) emit(MapErrorState());

      else if(event is MapSuccessSavePositionEvent){
        emit(MapSuccessSavePositionState());
      }
    });
  }

  Future<void> getCurrentPosition() async {
    this.add(MapLoadingEvent());
    _service.getCurrentLocation().then((value) {
      if(value == null){
      this.add(MapErrorEvent());
      }else{
        this.add(MapSuccessEvent(value));
      }
    });     
  }

  Future<void> savePosition(Position position)async{
 this.add(MapLoadingEvent());
    _service.saveLocation(position).then((value) {
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
  Position position;
  MapSuccessEvent(this.position);
}

class MapLoadingEvent extends MapEvents {}

class MapErrorEvent extends MapEvents {}
class MapSuccessSavePositionEvent extends MapEvents {}

abstract class MapStates {}

class MapInitState extends MapStates {}

class MapSuccessState extends MapStates {
  Position position;
  MapSuccessState(this.position);
}

class MapLoadingState extends MapStates {}
class MapSuccessSavePositionState extends MapStates {}
class MapErrorState extends MapStates {}

MapBloc mapBloc = MapBloc();
