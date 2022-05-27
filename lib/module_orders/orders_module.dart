
import 'package:flutter/material.dart';
import 'package:my_kom/abstracts/module/my_module.dart';
import 'package:my_kom/module_orders/orders_routes.dart';
import 'package:my_kom/module_orders/ui/screens/captain_orders/captain_orders.dart';
import 'package:my_kom/module_orders/ui/screens/order_detail.dart';

class OrdersModule extends MyModule {

  final CaptainOrdersScreen _captainOrdersScreen;
  final OrderDetailScreen _detailScreen;

  OrdersModule(

    this._captainOrdersScreen,
      this._detailScreen
  ) ;

  Map<String, WidgetBuilder> getRoutes() {
    return {

      OrdersRoutes.CAPTAIN_ORDERS_SCREEN: (context) => _captainOrdersScreen,
       OrdersRoutes.ORDER_DETAIL_SCREEN: (context) => _detailScreen,
    };
  }
}
