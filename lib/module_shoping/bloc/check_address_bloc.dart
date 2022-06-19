import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_kom/module_map/service/map_service.dart';

class CheckAddressBloc extends Bloc<CheckAddressEvent, CheckAddressStates> {
  final MapService _service = MapService() ;

  CheckAddressBloc() : super(CheckAddressLoadingState()) {

    on<CheckAddressEvent>((CheckAddressEvent event, Emitter<CheckAddressStates> emit) {
      if (event is CheckAddressLoadingEvent)
        emit(CheckAddressLoadingState());
      else if (event is CheckAddressErrorEvent){
        emit(CheckAddressErrorState());
      }
      else if (event is CheckAddressSuccessEvent)
        emit(CheckAddressSuccessState());
    });
  }

  checkAddress( String storeId,String address) async{
    this.add(CheckAddressLoadingEvent());
    _service.checkAddressInArea(storeId, address).then((value) {
      if (value){
        this.add(CheckAddressSuccessEvent());
      } else{
        this.add(CheckAddressErrorEvent());
      }
    });
  }

}

abstract class CheckAddressEvent { }
class CheckAddressInitEvent  extends CheckAddressEvent  {}

class CheckAddressSuccessEvent  extends CheckAddressEvent  {

  CheckAddressSuccessEvent();
}

class CheckAddressLoadingEvent  extends CheckAddressEvent  {}

class CheckAddressErrorEvent  extends CheckAddressEvent  {

  CheckAddressErrorEvent();
}

abstract class CheckAddressStates {}

class CheckAddressInitState extends CheckAddressStates {}

class CheckAddressSuccessState extends CheckAddressStates {

  CheckAddressSuccessState();
}

class CheckAddressLoadingState extends CheckAddressStates {}

class CheckAddressErrorState extends CheckAddressStates {
  CheckAddressErrorState();
}

