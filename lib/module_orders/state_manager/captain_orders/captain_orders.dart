
import 'package:my_kom/module_authorization/exceptions/auth_exception.dart';
import 'package:my_kom/module_orders/service/orders/orders.service.dart';
import 'package:my_kom/module_orders/ui/screens/captain_orders/captain_orders.dart';
import 'package:my_kom/module_orders/ui/state/captain_orders/captain_orders_list_state.dart';
import 'package:my_kom/module_orders/ui/state/captain_orders/captain_orders_list_state_error.dart';
import 'package:my_kom/module_orders/ui/state/captain_orders/captain_orders_list_state_loading.dart';
import 'package:my_kom/module_orders/ui/state/captain_orders/captain_orders_list_state_orders_loaded.dart';
import 'package:my_kom/module_orders/ui/state/captain_orders/captain_orders_list_state_unauthorized.dart';
import 'package:rxdart/rxdart.dart';

class CaptainOrdersListStateManager {
  final OrdersService _ordersService = OrdersService();
 // final ProfileService _profileService;

  final PublishSubject<CaptainOrdersListState> _stateSubject = PublishSubject();
  //final PublishSubject<ProfileResponseModel> _profileSubject = PublishSubject();

  //Stream<ProfileResponseModel> get profileStream => _profileSubject.stream;
  Stream<CaptainOrdersListState> get stateStream => _stateSubject.stream;

 // CaptainOrdersListStateManager(this._ordersService);

  void getProfile() {
    // _profileService
    //     .getProfile()
    //     .then((profile) => _profileSubject.add(profile));
  }

  void getMyOrders(CaptainOrdersScreenState screenState) {
    CaptainOrdersListStateLoading(screenState);
    Future.wait([
      _ordersService.getNearbyOrders(),
      _ordersService.getCaptainOrders()
    ]).then((value) {
      _stateSubject.add(
          CaptainOrdersListStateOrdersLoaded(screenState, value[0]!, value[1]!));
    }).catchError((e) {
      if (e is UnauthorizedException) {
        _stateSubject.add(CaptainOrdersListStateUnauthorized(screenState));
      } else {
        _stateSubject
            .add(CaptainOrdersListStateError(e.toString(), screenState));
      }
    });
  }
}
