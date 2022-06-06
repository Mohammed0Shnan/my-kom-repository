import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_kom/module_map/models/address_model.dart';

class ZoneBloc extends Cubit<ZonesState> {

  ZoneBloc() : super(ZonesState(zones: [] ));


  addOne(String zone){

    ZonesState newState =  ZonesState(zones: List.from(state.zones)..add(zone));
     return emit(newState);
  }
  removeOne(String zone) {
    ZonesState newState =  ZonesState(zones: List.from(state.zones)..remove(zone));
    return emit(newState);
  }
  clear()=> emit(ZonesState(zones: []));

}
class ZonesState{
  List<String> zones;
  ZonesState({required this.zones });
}