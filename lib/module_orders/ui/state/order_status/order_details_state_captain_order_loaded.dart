//
// import 'package:flutter/material.dart';
// import 'package:my_kom/consts/order_status.dart';
// import 'package:my_kom/module_orders/model/order_model.dart';
// import 'package:my_kom/module_orders/orders_routes.dart';
// import 'package:my_kom/module_orders/ui/screens/order_status/order_status_screen.dart';
// import 'package:my_kom/module_orders/ui/state/order_status/order_status.state.dart';
// import 'package:my_kom/module_orders/ui/widgets/communication_card/communication_card.dart';
// import 'package:my_kom/module_orders/util/whatsapp_link_helper.dart';
// import 'package:my_kom/module_orders/utils/icon_helper/order_progression_helper.dart';
// import 'package:step_progress_indicator/step_progress_indicator.dart';
// import 'package:timeago/timeago.dart' as timeago;
//
// class OrderDetailsStateCaptainOrderLoaded extends OrderDetailsState {
//   OrderModel currentOrder;
//   final _distanceCalculator = TextEditingController();
//
//   OrderDetailsStateCaptainOrderLoaded(
//     this.currentOrder,
//     OrderStatusScreenState screenState,
//   ) : super(screenState);
//
//   @override
//   Widget getUI(BuildContext context) {
//     return WillPopScope(
//       onWillPop: () async{
//        await Navigator.of(context).pushNamedAndRemoveUntil(
//             OrdersRoutes.CAPTAIN_ORDERS_SCREEN, (route) => false);
//        return true;
//       },
//       child: SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: OrderProgressionHelper.getStatusIcon(
//                   currentOrder.status, context),
//             ),
//             Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: StepProgressIndicator(
//                 totalSteps: 5,
//                 currentStep: currentOrder.status.index,
//               ),
//             ),
//             Text(
//               timeago.format(currentOrder.creationTime),
//               textAlign: TextAlign.center,
//               style: TextStyle(
//                 fontWeight: FontWeight.bold,
//                 fontSize: 26,
//               ),
//             ),
//             SizedBox(
//               height: 56,
//             ),
//             // To Progress the Order
//             _getNextStageCard(context),
//             // To Chat with Store owner in app
//
//             // To WhatsApp with store owner
//
//             // To WhatsApp with client
//             currentOrder.ownerPhone != null
//                 ? GestureDetector(
//                     onTap: () {
//                       var url = WhatsAppLinkHelper.getWhatsAppLink(
//                           currentOrder.clientPhone);
//                      // launch(url);
//                     },
//               child: Text('whatsappWithClient'),
//                     // child: CommunicationCard(
//                     //   text: S.of(context).whatsappWithClient,
//                     //   image: FaIcon(
//                     //     FontAwesomeIcons.whatsapp,
//                     //     color: Theme.of(context).brightness == Brightness.dark
//                     //         ? Colors.white
//                     //         : Colors.black,
//                     //   ),
//                     // ),
//                   )
//                 : Container(),
//             // To Open Maps
//             GestureDetector(
//               onTap: () {
//                 var url = WhatsAppLinkHelper.getMapsLink(
//                     currentOrder.to.lat, currentOrder.to.lat);
//                // launch(url);
//               },
//               child: Text('getDirection'),
//               // child: CommunicationCard(
//               //   text: S.of(context).getDirection,
//               //   image: FaIcon(
//               //     FontAwesomeIcons.mapSigns,
//               //     color: Theme.of(context).brightness == Brightness.dark
//               //         ? Colors.white
//               //         : Colors.black,
//               //   ),
//               // ),
//             ),
//             Container(
//               height: 36,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _getNextStageCard(BuildContext context) {
//     if (currentOrder.status == OrderStatus.FINISHED) {
//       return Container();
//     }
//     print(currentOrder.status);
//     if (currentOrder.status == OrderStatus.GOT_CASH) {
//       return Card(
//         elevation: 4,
//         child: Container(
//           height: 72,
//           width: MediaQuery.of(context).size.width,
//           child: Flex(
//             direction: Axis.horizontal,
//             children: [
//               IconButton(
//                   icon: Icon(Icons.add_road_outlined),
//                   onPressed: () {
//                     if (_distanceCalculator.text.isNotEmpty) {
//                       screenState.requestOrderProgress(
//                           currentOrder, _distanceCalculator.text);
//                     } else {
//                       //screenState.showSnackBar(S.of(context).pleaseProvideTheDistance);
//                     }
//                   }),
//               Expanded(
//                 child: TextFormField(
//                   controller: _distanceCalculator,
//                   decoration: InputDecoration(
//                     hintText: '45',
//                     labelText:'finishOrderProvideDistanceInKm'// S.of(context).finishOrderProvideDistanceInKm,
//                   ),
//                   keyboardType: TextInputType.number,
//                 ),
//               ),
//               IconButton(
//                   icon: Icon(Icons.check),
//                   onPressed: () {
//                     if (_distanceCalculator.text.isNotEmpty) {
//                       screenState.requestOrderProgress(
//                           currentOrder, _distanceCalculator.text);
//                     } else {
//                      // screenState.showSnackBar(S.of(context).pleaseProvideTheDistance);
//                     }
//                   }),
//             ],
//           ),
//         ),
//       );
//     } else if (currentOrder.status == OrderStatus.DELIVERING) {
//       return Card(
//         elevation: 4,
//         child: Container(
//           height: 72,
//           width: MediaQuery.of(context).size.width,
//           child: Flex(
//             direction: Axis.horizontal,
//             children: [
//               IconButton(
//                   icon: Icon(Icons.add_road_outlined),
//                   onPressed: () {
//                     if (_distanceCalculator.text.isNotEmpty) {
//                       screenState.requestOrderProgress(
//                           currentOrder, _distanceCalculator.text);
//                     } else {
//                      // screenState.showSnackBar(S.of(context).pleaseProvideTheDistance);
//                     }
//                   }),
//               Expanded(
//                 child: TextFormField(
//                   controller: _distanceCalculator,
//                   decoration: InputDecoration(
//                     hintText: '56',
//                     labelText:'finishOrderProvideDistanceInKm'// S.of(context).finishOrderProvideDistanceInKm,
//                   ),
//                   keyboardType: TextInputType.number,
//                 ),
//               ),
//               IconButton(
//                   icon: Icon(Icons.check),
//                   onPressed: () {
//                     if (_distanceCalculator.text.isNotEmpty) {
//                       screenState.requestOrderProgress(
//                           currentOrder, _distanceCalculator.text);
//                     } else {
//                      // screenState.showSnackBar(S.of(context).pleaseProvideTheDistance);
//                     }
//                   }),
//             ],
//           ),
//         ),
//       );
//     } else {
//       return GestureDetector(
//         onTap: () {
//           screenState.requestOrderProgress(currentOrder);
//         },
//         child: CommunicationCard(
//           text: OrderProgressionHelper.getNextStageHelper(
//             currentOrder.status,
//             currentOrder.paymentMethod.toLowerCase().contains('ca'),
//             context,
//           ),
//           color: Theme.of(context).accentColor,
//           textColor: Colors.white,
//           image: Icon(
//             Icons.navigate_next_sharp,
//             color: Theme.of(context).brightness == Brightness.dark
//                 ? Colors.white
//                 : Colors.black,
//           ),
//         ),
//       );
//     }
//   }
// }
