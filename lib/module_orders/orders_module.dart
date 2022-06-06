
import 'package:flutter/material.dart';
import 'package:my_kom/abstracts/module/my_module.dart';
import 'package:my_kom/module_orders/orders_routes.dart';
import 'package:my_kom/module_orders/ui/screens/captain_orders/captain_orders.dart';
import 'package:my_kom/module_orders/ui/screens/order_detail.dart';
import 'package:my_kom/module_orders/ui/screens/order_status/order_status_screen.dart';
import 'package:my_kom/module_orders/ui/screens/owner_orders.dart';

class OrdersModule extends MyModule {

  final CaptainOrdersScreen _captainOrdersScreen;
  final OwnerOrdersScreen _ownerOrdersScreen;
  final OrderDetailScreen _detailScreen;
  final OrderStatusScreen _statusScreen;

  OrdersModule(

    this._captainOrdersScreen,
      this._ownerOrdersScreen,
      this._detailScreen,
      this._statusScreen
  ) ;

  Map<String, WidgetBuilder> getRoutes() {
    return {

      OrdersRoutes.CAPTAIN_ORDERS_SCREEN: (context) => _captainOrdersScreen,
      OrdersRoutes.OWNER_ORDERS__SCREEN: (context) => _ownerOrdersScreen,
       OrdersRoutes.ORDER_DETAIL_SCREEN: (context) => _detailScreen,
      OrdersRoutes.ORDER_STATUS_SCREEN: (context) =>_statusScreen,

    };
  }
}
