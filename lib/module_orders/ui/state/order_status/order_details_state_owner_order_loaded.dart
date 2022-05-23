
import 'package:flutter/material.dart';
import 'package:my_kom/consts/order_status.dart';
import 'package:my_kom/module_orders/model/order_model.dart';
import 'package:my_kom/module_orders/ui/screens/order_status/order_status_screen.dart';
import 'package:my_kom/module_orders/ui/state/order_status/order_status.state.dart';
import 'package:my_kom/module_orders/ui/widgets/communication_card/communication_card.dart';
import 'package:my_kom/module_orders/util/whatsapp_link_helper.dart';
import 'package:my_kom/module_orders/utils/icon_helper/order_progression_helper.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';


import 'package:timeago/timeago.dart' as timeago;

import '../../../../generated/l10n.dart';
import '../../../orders_routes.dart';

class OrderDetailsStateOwnerOrderLoaded extends OrderDetailsState {
  OrderModel currentOrder;

  OrderDetailsStateOwnerOrderLoaded(
    this.currentOrder,
    OrderStatusScreenState screenState,
  ) : super(screenState);

  @override
  Widget getUI(BuildContext context) {
    return WillPopScope(
      onWillPop: () async{
     await   Navigator.of(context).pushNamedAndRemoveUntil(
            OrdersRoutes.OWNER_ORDERS_SCREEN, (route) => false);
        return true;
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Flex(
            direction: Axis.vertical,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: OrderProgressionHelper.getStatusIcon(
                    currentOrder.status, context),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  OrderProgressionHelper.getCurrentStageHelper(
                      currentOrder.status, context),
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: StepProgressIndicator(
                  totalSteps: 5,
                  currentStep: currentOrder.status.index,
                ),
              ),
              Text(
                timeago.format(currentOrder.creationTime, locale: 'ar'),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ],
          ),
          currentOrder.status == OrderStatus.INIT ? Container() :Flex(
            direction: Axis.vertical,
            children: [
              GestureDetector(
                onTap: () {
                  // Navigator.of(context).pushNamed(
                  //   ChatRoutes.chatRoute,
                  //   arguments: currentOrder.chatRoomId,
                  // );
                },
                child: CommunicationCard(
                  text:'openChatRoom',// S.of(context).openChatRoom,
                  image: Icon(
                    Icons.chat_rounded,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white
                        : Colors.black,
                  ), color: Colors.red, textColor:Colors.red,
                ),
              ),
              GestureDetector(
                onTap: () {
                  var url = WhatsAppLinkHelper.getWhatsAppLink(
                      currentOrder.captainPhone);
                  //launch(url);
                },
                child: Text('whatsappWithCaptain'),
                // child: CommunicationCard(
                //   text: S.of(context).whatsappWithCaptain,
                //   image: FaIcon(
                //     FontAwesomeIcons.whatsapp,
                //     color: Colors.green,
                //   ),
                // ),
              ),
              currentOrder.clientPhone == null
                  ? Container()
                  : GestureDetector(
                      onTap: () {
                        var url = WhatsAppLinkHelper.getWhatsAppLink(
                            currentOrder.clientPhone);
                     //   launch(url);
                      },
                child: Text('whatsappWithClient'),
                      // child: CommunicationCard(
                      //   text: S.of(context).whatsappWithClient,
                      //   image: FaIcon(
                      //     FontAwesomeIcons.whatsapp,
                      //     color: Colors.green,
                      //   ),
                      // ),
                    ),
              Container(
                height: 48,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
