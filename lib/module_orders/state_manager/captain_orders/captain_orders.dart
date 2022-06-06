
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_kom/module_authorization/exceptions/auth_exception.dart';
import 'package:my_kom/module_orders/model/order_model.dart';
import 'package:my_kom/module_orders/service/orders/orders.service.dart';
import 'package:my_kom/module_orders/ui/screens/captain_orders/captain_orders.dart';

class CaptainOrdersListBloc extends Bloc<CaptainOrdersListEvent,CaptainOrdersListStates>{
  final OrdersService _ordersService = OrdersService();

  CaptainOrdersListBloc() : super(CaptainOrdersListLoadingState()) {

    on<CaptainOrdersListEvent>((CaptainOrdersListEvent event, Emitter<CaptainOrdersListStates> emit) {
      if (event is CaptainOrdersListLoadingEvent)
        {
          emit(CaptainOrdersListLoadingState());

        }
      else if (event is CaptainOrdersListErrorEvent){
        emit(CaptainOrdersListErrorState(message: event.message));
      }

      else if (event is CaptainOrdersListSuccessEvent){
        emit(CaptainOrdersListSuccessState(currentOrders: event.currentOrders,previousOrders: event.previousOrders,message: null));
      }


      // else if (event is CaptainOrderDeletedSuccessEvent){
      //   if(this.state is CaptainOrdersListSuccessState)
      //     {
      //       print(event.orderID);
      //       print('------------------');
      //      List<OrderModel> state = (this.state as  CaptainOrdersListSuccessState ).data;
      //      state.forEach((element) {
      //        print(element.id);
      //      }); print('=============================================');
      //       List<OrderModel> list =[];
      //       state.forEach((element) {
      //         if(element.id != event.orderID)
      //           list.add(element);
      //       });
      //
      //       print(list);
      //       emit(CaptainOrdersListSuccessState(data:list,message:'success'));
      //     }
      //
      //   else
      //   {
      //     emit(CaptainOrderDeletedErrorState(message: 'Success, Refresh!!!',data:List.from(List.from( (this.state as  CaptainOrdersListSuccessState ).data) )));
      //   }
      // }
      // else if(event is CaptainOrderDeletedErrorEvent){
      //   emit(CaptainOrderDeletedErrorState(message: 'Error',data:List.from(List.from( (this.state as  CaptainOrdersListSuccessState ).data) )));
      // }
    });
  }



  void getMyOrders() {

     this.add(CaptainOrdersListLoadingEvent());
     _ordersService.orderPublishSubject.listen((value) {

       if(value != null){
         this.add(CaptainOrdersListSuccessEvent(currentOrders: value['cur']!,previousOrders: value['pre']!));

       }else
       {
         this.add(CaptainOrdersListErrorEvent(message: 'Error In Fetch Data !!'));
       }
     });
     _ordersService.getMyOrders();
  }

  void getOwnerOrders() {

    this.add(CaptainOrdersListLoadingEvent());
    _ordersService.orderPublishSubject.listen((value) {

      if(value != null){
        this.add(CaptainOrdersListSuccessEvent(currentOrders: value['cur']!,previousOrders: value['pre']!));

      }else
      {
        this.add(CaptainOrdersListErrorEvent(message: 'Error In Fetch Data !!'));
      }
    });
    _ordersService.getOwnerOrders();
  }



 Future<bool> deleteOrder(String orderID)async{
  return await _ordersService.deleteOrder(orderID);
   await _ordersService.deleteOrder(orderID).then((value) {
      //
      // if(value){
      //   add(CaptainOrderDeletedSuccessEvent(orderID:orderID));
      // }else{
      //  add(CaptainOrderDeletedErrorEvent(message: 'Error in order deleted !!!'));
      // }
    });
  }

  @override
  Future<void> close() {
    _ordersService.closeStream();
    return super.close();
  }
}

abstract class CaptainOrdersListEvent { }
class CaptainOrdersListInitEvent  extends CaptainOrdersListEvent  {}

class CaptainOrdersListSuccessEvent  extends CaptainOrdersListEvent  {
  List<OrderModel>  currentOrders;
  List<OrderModel>  previousOrders;
  CaptainOrdersListSuccessEvent({required this.currentOrders,required this.previousOrders});
}
class CaptainOrdersListLoadingEvent  extends CaptainOrdersListEvent  {}

class CaptainOrdersListErrorEvent  extends CaptainOrdersListEvent  {
  String message;
  CaptainOrdersListErrorEvent({required this.message});
}

class CaptainOrderDeletedErrorEvent  extends CaptainOrdersListEvent  {
  String message;
  CaptainOrderDeletedErrorEvent({required this.message});
}


class CaptainOrderDeletedSuccessEvent  extends CaptainOrdersListEvent  {
  String orderID;
  CaptainOrderDeletedSuccessEvent({required this.orderID});
}



abstract class CaptainOrdersListStates {}

class CaptainOrdersListInitState extends CaptainOrdersListStates {}

class CaptainOrdersListSuccessState extends CaptainOrdersListStates {
  List<OrderModel>  currentOrders;
  List<OrderModel>  previousOrders;

  String? message;
  CaptainOrdersListSuccessState({required this.currentOrders,required this.previousOrders,required this.message});
}
class CaptainOrdersListLoadingState extends CaptainOrdersListStates {}

class CaptainOrdersListErrorState extends CaptainOrdersListStates {
  String message;
  CaptainOrdersListErrorState({required this.message});
}

class CaptainOrderDeletedErrorState extends CaptainOrdersListStates {
  String message;
  List<OrderModel>  data;
  CaptainOrderDeletedErrorState({ required this.data,required this.message});
}




