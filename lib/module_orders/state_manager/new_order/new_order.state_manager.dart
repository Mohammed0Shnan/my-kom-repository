
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:my_kom/module_orders/response/branch.dart';
import 'package:my_kom/module_orders/response/orders/orders_response.dart';
import 'package:my_kom/module_orders/service/orders/orders.service.dart';
import 'package:my_kom/module_orders/ui/screens/new_order/new_order_screen.dart';
import 'package:my_kom/module_orders/ui/state/new_order/new_order.state.dart';
import 'package:rxdart/rxdart.dart';

class NewOrderStateManager {
  final OrdersService _service = OrdersService();
  final PublishSubject<NewOrderState> _stateSubject = new PublishSubject();

  Stream<NewOrderState> get stateStream => _stateSubject.stream;

//  NewOrderStateManager(this._service, this._profileService);

  void loadBranches(NewOrderScreenState screenState, LatLng location) {
     // _profileService.getMyBranches().then((value) {
       _stateSubject.add(NewOrderStateBranchesLoaded([], location, screenState));
   //  });
  }

  void addNewOrder(
      Branch fromBranch,
      GeoJson destination,
      String phone,
      String paymentMethod,
      String date) {
    //_stateSubject.add(NewOrderStateInit(screenState));
    _service
        .addNewOrder(fromBranch, destination, phone, paymentMethod,
         date)
        .then((response) {

      }
    ).catchError((e){
      
    });
  }
}



abstract class CreateOrderEvent { }
class CreateOrderInitEvent  extends CreateOrderEvent  {}

class CreateOrderSuccessEvent  extends CreateOrderEvent  {
  List <ProductModel>  data;
  CreateOrderSuccessEvent({required this.data});
}
class UpdateProductsCompanySuccessEvent  extends ProductsCompanyEvent  {

  UpdateProductsCompanySuccessEvent();
}

class ProductsCompanyLoadingEvent  extends ProductsCompanyEvent  {}

class ProductsCompanyErrorEvent  extends ProductsCompanyEvent  {
  String message;
  ProductsCompanyErrorEvent({required this.message});
}

abstract class ProductsCompanyStates {}

class ProductsCompanyInitState extends ProductsCompanyStates {}

class ProductsCompanySuccessState extends ProductsCompanyStates {
  List <ProductModel>  data;
  ProductsCompanySuccessState({required this.data});
}


class ProductsCompanyLoadingState extends ProductsCompanyStates {}

class ProductsCompanyErrorState extends ProductsCompanyStates {
  String message;
  ProductsCompanyErrorState({required this.message});
}