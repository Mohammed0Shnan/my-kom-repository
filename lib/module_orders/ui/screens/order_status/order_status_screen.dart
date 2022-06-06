
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:my_kom/consts/colors.dart';
import 'package:my_kom/consts/order_status.dart';
import 'package:my_kom/consts/payment_method.dart';
import 'package:my_kom/module_orders/model/order_model.dart';
import 'package:my_kom/module_orders/orders_routes.dart';
import 'package:my_kom/module_orders/state_manager/order_detail_bloc.dart';
import 'package:my_kom/module_orders/state_manager/order_status/order_status.state_manager.dart';
import 'package:my_kom/module_orders/ui/state/order_status/order_status.state.dart';
import 'package:my_kom/module_orders/ui/widgets/communication_card/communication_card.dart';
import 'package:my_kom/module_orders/utils/icon_helper/order_progression_helper.dart';
import 'package:my_kom/utils/size_configration/size_config.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

class OrderStatusScreen extends StatefulWidget {


  // OrderStatusScreen(
  //   this._stateManager,
  // );

  @override
  OrderStatusScreenState createState() => OrderStatusScreenState();
}

class OrderStatusScreenState extends State<OrderStatusScreen> {
  final OrderStatusBloc _bloc = OrderStatusBloc();
 late String orderId;

  @override
  void initState() {
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      orderId = ModalRoute.of(context)!.settings.arguments.toString() ;
      _bloc.getOrderDetails(orderId);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: (){
            Navigator.of(context).pop();
          },
        ),
        backgroundColor: ColorsConst.mainColor,
        elevation: 0,
        title: Text(
         'Tracking Screen',
          style: TextStyle(
            color: Colors.white
          ),
        ),
      ),
      body: BlocBuilder<OrderStatusBloc,OrderStatusStates>(
        bloc: _bloc,
        builder: (context,state) {

          if(state is OrderStatusSuccessState){
            OrderModel currentOrder = state.data;
           int currentIndex = currentOrder.status.index;
            return WillPopScope(
              onWillPop: () async{
                await Navigator.of(context).pushNamedAndRemoveUntil(
                    OrdersRoutes.CAPTAIN_ORDERS_SCREEN, (route) => false);
                return true;
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: SizeConfig.screenHeight * 0.8,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text('GOT CAPTAIN',style: TextStyle(fontWeight: FontWeight.w700,fontSize: (currentIndex == 1)? SizeConfig.titleSize * 3.4:SizeConfig.titleSize * 3,color:(currentIndex == 1)? ColorsConst.mainColor:Colors.grey),),
                        Text('IN STORE',style: TextStyle(fontWeight: FontWeight.w700,fontSize: (currentIndex == 2)? SizeConfig.titleSize * 3.4:SizeConfig.titleSize * 3,color:(currentIndex == 2)? ColorsConst.mainColor:Colors.grey)),
                        Text('DELIVERING',style: TextStyle(fontWeight: FontWeight.w700,fontSize: (currentIndex == 3)? SizeConfig.titleSize * 3.4:SizeConfig.titleSize * 3,color:(currentIndex == 3)? ColorsConst.mainColor:Colors.grey)),
                        if(currentOrder.payment == PaymentMethodConst.CASH_MONEY)
                        Text('GOT CASH',style: TextStyle(fontWeight: FontWeight.w700,fontSize:   (currentIndex == 4)? SizeConfig.titleSize * 3.4:SizeConfig.titleSize * 3,color: (currentIndex == 4)? ColorsConst.mainColor:Colors.grey),),
                        Text('FINISHED',style: TextStyle(fontWeight: FontWeight.w700,fontSize:   (currentIndex == 5)? SizeConfig.titleSize * 3.4:SizeConfig.titleSize * 3,color: (currentIndex == 5)? ColorsConst.mainColor:Colors.grey),),
                      ],
                    ),
                  ),
                  SizedBox(width: SizeConfig.screenWidth * 0.1,),
                  Container(height: SizeConfig.screenHeight * 0.8,
                    child:
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: StepProgressIndicator(
                        currentStep: currentIndex,
                        size: 10 * SizeConfig.widhtMulti,
                        direction: Axis.vertical,
                        roundedEdges: Radius.circular(10),
                        padding:2,
                        selectedColor: ColorsConst.mainColor,
                        customStep: (index, color, _) => color == ColorsConst.mainColor
                            ? Container(
                          color: color,
                          child: Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 25,
                          ),
                        )
                            : Container(
                          color: color,
                          child: Icon(
                            Icons.remove,
                          ),
                        ),
                        totalSteps:  (currentOrder.payment == PaymentMethodConst.CASH_MONEY)?5:4,


                      ),
                    ),),

                ],
              ),
            );
          }
          else if (state is OrderStatusErrorState)
            {
              return Center(child: Container(
                width: 50,
                height: 30,
                child: Text('Error'),
              ),);
            }
          else {
            return Center(child: Container(
              width: 30,
              height: 30,
              child: CircularProgressIndicator(color: ColorsConst.mainColor,),
            ),);
          }

        }
      )
    );
  }

  //
  //
  // void requestOrderProgress(OrderModel currentOrder) {
  //   late  OrderStatus newStatus;
  //   switch (currentOrder.status) {
  //     case OrderStatus.INIT:
  //       newStatus = OrderStatus.GOT_CAPTAIN;
  //       break;
  //     case OrderStatus.GOT_CAPTAIN:
  //       newStatus = OrderStatus.IN_STORE;
  //       break;
  //     case OrderStatus.IN_STORE:
  //       newStatus = OrderStatus.DELIVERING;
  //       break;
  //     case OrderStatus.DELIVERING:
  //       newStatus = currentOrder.payment == PaymentMethodConst.CASH_MONEY
  //           ? OrderStatus.GOT_CAPTAIN
  //           : OrderStatus.FINISHED;
  //       break;
  //     case OrderStatus.GOT_CASH:
  //       newStatus = OrderStatus.FINISHED;
  //       break;
  //     case OrderStatus.FINISHED:
  //       break;
  //   }
  //
  //   //currentOrder.distance = distance!;
  //   currentOrder.status = newStatus;
  //
  // }
}
