
import 'package:my_kom/module_authorization/service/auth_service.dart';
import 'package:my_kom/module_orders/service/orders/orders.service.dart';
import 'package:rxdart/rxdart.dart';

class OrderStatusStateManager {
  // final OrdersService _ordersService;
  // final AuthService _authService;
  // final ReportService _reportService;

  // final PublishSubject<OrderDetailsState> _stateSubject = new PublishSubject();

  // Stream<OrderDetailsState> get stateStream => _stateSubject.stream;

  // OrderStatusStateManager(
  //     this._ordersService, this._authService, this._reportService);

  // void getOrderDetails(int orderId, OrderStatusScreenState screenState) {
  //   _stateSubject.add(OrderDetailsStateLoading(screenState));

  //   _ordersService.getOrderDetails(orderId).then((order) {
  //     if (order == null) {
  //       _stateSubject.add(OrderDetailsStateError(
  //           'Error Loading Data from the Server', screenState));
  //       return;
  //     } else {
  //       _authService.userRole.then((role) {
  //         if (role == UserRole.ROLE_CAPTAIN) {
  //           _stateSubject
  //               .add(OrderDetailsStateCaptainOrderLoaded(order, screenState));
  //         } else if (role == UserRole.ROLE_OWNER) {
  //           _stateSubject
  //               .add(OrderDetailsStateOwnerOrderLoaded(order, screenState));
  //         } else {
  //           _stateSubject.add(OrderDetailsStateError(
  //               'Error Defining Login Type', screenState));
  //         }
  //       });
  //     }
  //   });
  // }

  // void updateOrder(OrderModel model, OrderStatusScreenState screenState) {
  //   _ordersService.updateOrder(model.id, model).then((value) {
  //     getOrderDetails(model.id, screenState);
  //   });
  // }

  // void report(int orderId, String reason) {
  //   _reportService.createReport(orderId, reason);
  // }
}
