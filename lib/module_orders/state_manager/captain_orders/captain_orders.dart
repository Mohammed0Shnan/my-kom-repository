
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_kom/module_authorization/exceptions/auth_exception.dart';
import 'package:my_kom/module_orders/model/order_model.dart';
import 'package:my_kom/module_orders/service/orders/orders.service.dart';
import 'package:my_kom/module_orders/ui/screens/captain_orders/captain_orders.dart';

class CaptainOrdersListBloc extends Bloc<CaptainOrdersListEvent,CaptainOrdersListStates>{
  final OrdersService _ordersService = OrdersService();

  CaptainOrdersListBloc(initialState) : super(initialState) {

    on<CaptainOrdersListEvent>((CaptainOrdersListEvent event, Emitter<CaptainOrdersListStates> emit) {
      if (event is CaptainOrdersListLoadingEvent)
        emit(CaptainOrdersListLoadingState());
      else if (event is CaptainOrdersListErrorEvent){
        emit(CaptainOrdersListErrorState(message: event.message));
      }
      else if (event is CaptainOrdersListSuccessEvent)
        emit(CaptainOrdersListSuccessState(data: event.data));
    });
  }



  void getMyOrders() {
  //   Future.wait([
  //     _ordersService.getNearbyOrders(),
  //     _ordersService.getCaptainOrders()
  //   ]).then((value) {
  //     _stateSubject.add(
  //         CaptainOrdersListStateOrdersLoaded(screenState, value[0]!, value[1]!));
  //   }).catchError((e) {
  //     if (e is UnauthorizedException) {
  //       _stateSubject.add(CaptainOrdersListStateUnauthorized(screenState));
  //     } else {
  //       _stateSubject
  //           .add(CaptainOrdersListStateError(e.toString(), screenState));
  //     }
  //   });
  }
}

abstract class CaptainOrdersListEvent { }
class CaptainOrdersListInitEvent  extends CaptainOrdersListEvent  {}

class CaptainOrdersListSuccessEvent  extends CaptainOrdersListEvent  {
  List<OrderModel>  data;
  CaptainOrdersListSuccessEvent({required this.data});
}

class CaptainOrdersListLoadingEvent  extends CaptainOrdersListEvent  {}

class CaptainOrdersListErrorEvent  extends CaptainOrdersListEvent  {
  String message;
  CaptainOrdersListErrorEvent({required this.message});
}

abstract class CaptainOrdersListStates {}

class CaptainOrdersListInitState extends CaptainOrdersListStates {}

class CaptainOrdersListSuccessState extends CaptainOrdersListStates {
  List<OrderModel>  data;
  CaptainOrdersListSuccessState({required this.data});
}

class CaptainOrdersListLoadingState extends CaptainOrdersListStates {}

class CaptainOrdersListErrorState extends CaptainOrdersListStates {
  String message;
  CaptainOrdersListErrorState({required this.message});
}
