//
// import 'package:flutter/material.dart';
// import 'package:my_kom/consts/order_status.dart';
// import 'package:my_kom/module_orders/model/order_model.dart';
// import 'package:my_kom/module_orders/orders_routes.dart';
// import 'package:my_kom/module_orders/state_manager/order_status/order_status.state_manager.dart';
// import 'package:my_kom/module_orders/ui/state/order_status/order_details_state_captain_order_loaded.dart';
// import 'package:my_kom/module_orders/ui/state/order_status/order_details_state_owner_order_loaded.dart';
// import 'package:my_kom/module_orders/ui/state/order_status/order_status.state.dart';
//
//
// class OrderStatusScreen extends StatefulWidget {
//   final OrderStatusStateManager _stateManager = OrderStatusStateManager();
//
//   // OrderStatusScreen(
//   //   this._stateManager,
//   // );
//
//   @override
//   OrderStatusScreenState createState() => OrderStatusScreenState();
// }
//
// class OrderStatusScreenState extends State<OrderStatusScreen> {
//
//  late int orderId;
//  late OrderDetailsState currentState;
//
//   final _scaffoldKey = GlobalKey<ScaffoldState>();
//
//   void showSnackBar(String msg) {
//    // _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(msg)));
//   }
//
//   @override
//   void initState() {
//     // widget._stateManager.stateStream.listen((event) {
//     //   currentState = event;
//     //   if (mounted) {
//     //     setState(() {});
//     //   }
//     // });
//     super.initState();
//   }
//
//   void requestOrderProgress(OrderModel currentOrder, [ String? distance]) {
//   late  OrderStatus newStatus;
//     switch (currentOrder.status) {
//       case OrderStatus.INIT:
//         newStatus = OrderStatus.GOT_CAPTAIN;
//         break;
//       case OrderStatus.GOT_CAPTAIN:
//         newStatus = OrderStatus.IN_STORE;
//         break;
//       case OrderStatus.IN_STORE:
//         newStatus = OrderStatus.DELIVERING;
//         break;
//       case OrderStatus.DELIVERING:
//         newStatus = currentOrder.paymentMethod == 'CASH'
//             ? OrderStatus.GOT_CAPTAIN
//             : OrderStatus.FINISHED;
//         break;
//       case OrderStatus.GOT_CASH:
//         newStatus = OrderStatus.FINISHED;
//         break;
//       case OrderStatus.FINISHED:
//         break;
//     }
//
//     currentOrder.distance = distance!;
//     currentOrder.status = newStatus;
//     //widget._stateManager.updateOrder(currentOrder, this);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     if (currentState == null) {
//       // orderId = ModalRoute.of(context).settings.arguments;
//       // widget._stateManager.getOrderDetails(orderId, this);
//       // currentState = OrderDetailsStateInit(this);
//     }
//     return Scaffold(
//       resizeToAvoidBottomInset: false,
//       appBar: AppBar(
//         key: _scaffoldKey,
//         leading: IconButton(
//           icon: Icon(Icons.navigate_before),
//           onPressed: () {
//             if (currentState is OrderDetailsStateOwnerOrderLoaded) {
//               Navigator.of(context).pushNamedAndRemoveUntil(
//                   OrdersRoutes.OWNER_ORDERS_SCREEN, (route) => false);
//             } else if (currentState is OrderDetailsStateCaptainOrderLoaded) {
//               Navigator.of(context).pushNamedAndRemoveUntil(
//                   OrdersRoutes.CAPTAIN_ORDERS_SCREEN, (route) => false);
//             } else {
//               Navigator.of(context).pop();
//             }
//           },
//         ),
//         title: Text(
//          'detail',
//           style: TextStyle(
//             color: Theme.of(context).brightness == Brightness.dark
//                 ? Colors.white
//                 : Colors.black,
//           ),
//         ),
//         actions: [
//           IconButton(
//               icon: Icon(Icons.flag),
//               onPressed: () {
//                 // showDialog(
//                 //   context: context,
//                 //   child: Dialog(
//                 //     child: ReportDialogWidget(),
//                 //   ),
//                 // ).then((value) {
//                 //   if (value == null) {
//                 //     return;
//                 //   }
//                 //   if (value is String) {
//                 //     if (value.isNotEmpty) {
//                 //       widget._stateManager.report(orderId, value);
//                 //       showSnackBar(S.of(context).reportSent);
//                 //     }
//                 //   }
//                 // });
//               }),
//         ],
//       ),
//       body: currentState.getUI(context),
//     );
//   }
// }
