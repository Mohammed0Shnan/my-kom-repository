import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_kom/module_dashbord/services/DashBoard_services.dart';
import 'package:my_kom/module_orders/model/order_model.dart';

class UpdateStatusBloc extends Bloc< UpdateStatusEvent,  UpdateStatusStates> {
  final DashBoardService _service = DashBoardService();

  UpdateStatusBloc() : super( UpdateStatusInitState()) {
    on<UpdateStatusEvent>((UpdateStatusEvent event,
        Emitter<UpdateStatusStates> emit) {
      if (event is UpdateStatusLoadingEvent)
        emit(UpdateStatusLoadingState());
      else if (event is UpdateStatusErrorEvent) {
        emit(UpdateStatusErrorState(message: event.message));
      }
      else if (event is UpdateStatusSuccessEvent)
        emit(UpdateStatusSuccessState());
    });
  }


updateOrder(OrderModel order){
  this.add(UpdateStatusLoadingEvent());

  _service.updateOrder(order.id, order).then((value) {
    if(value){
      this.add(UpdateStatusSuccessEvent());

    }else{
      this.add(UpdateStatusErrorEvent(message: 'Not Updating Order !! Try Again'));

    }
  });
}}
abstract class  UpdateStatusEvent {}
class  UpdateStatusInitEvent  extends  UpdateStatusEvent  {}

class  UpdateStatusSuccessEvent  extends  UpdateStatusEvent  {
  UpdateStatusSuccessEvent();
}

class  UpdateStatusLoadingEvent  extends  UpdateStatusEvent  {}
class  UpdateStatusErrorEvent  extends  UpdateStatusEvent  {
  String message;
  UpdateStatusErrorEvent({required this.message});
}
abstract class  UpdateStatusStates {}

class  UpdateStatusInitState extends  UpdateStatusStates {}
class  UpdateStatusSuccessState extends  UpdateStatusStates {
     UpdateStatusSuccessState();
}
class  UpdateStatusLoadingState extends  UpdateStatusStates {}
class  UpdateStatusErrorState extends  UpdateStatusStates {
    String message;
    UpdateStatusErrorState({required this.message});
}

