import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_kom/consts/colors.dart';
import 'package:my_kom/consts/order_status.dart';
import 'package:my_kom/consts/payment_method.dart';
import 'package:my_kom/module_dashbord/bloc/update_status_bloc.dart';
import 'package:my_kom/module_orders/model/order_model.dart';
import 'package:my_kom/module_orders/orders_routes.dart';
import 'package:my_kom/module_orders/state_manager/captain_orders/captain_orders.dart';
import 'package:my_kom/module_orders/ui/widgets/delete_order_sheak_alert.dart';
import 'package:my_kom/module_orders/util/whatsapp_link_helper.dart';
import 'package:my_kom/utils/size_configration/size_config.dart';
import 'package:url_launcher/url_launcher.dart';
class OwnerOrdersScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => OwnerOrdersScreenState();
}

class OwnerOrdersScreenState extends State<OwnerOrdersScreen> {

  final CaptainOrdersListBloc _ordersListBloc = CaptainOrdersListBloc();
  final UpdateStatusBloc _updateStatusBloc = UpdateStatusBloc();
  final String PENDING_ORDER = 'pending';
  final String FINISHED_ORDER = 'finished';
  late String current_tap ;

  @override
  void initState() {
    current_tap = PENDING_ORDER;
    super.initState();
    _ordersListBloc.getOwnerOrders();
  }
  @override
  Widget build(BuildContext context) {
  return BlocProvider.value(
    value: _ordersListBloc,
    child: Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8,vertical: 5),
              child: Text('Orders',style: GoogleFonts.lato(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.black45
              ),),
            ),
            SizedBox(height: 8,),
            getAccountSwitcher(),
            SizedBox(height: 8,),

            Expanded(
              child: AnimatedSwitcher(
                duration: Duration(milliseconds: 500),
                child: current_tap == PENDING_ORDER
                    ? getPendingOrders()
                    : getFinishedOrders(),
              ),
            ),


          ],
        ),
      ),

    ),
  );
  }

  Widget getPendingOrders(){
    return      Stack(
      alignment: Alignment.center,
      children: [
        getOrders(),
        Positioned.fill(
            child: BlocBuilder<UpdateStatusBloc,UpdateStatusStates>(
                bloc: _updateStatusBloc,
                builder: (context,state) {
                  if(state is UpdateStatusLoadingState){
                    return Center(
                      child: Container(
                        padding: EdgeInsets.all(10),
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10)
                        ),
                        child: CircularProgressIndicator(color: ColorsConst.mainColor,),
                      ),
                    );
                  }

                  return SizedBox.shrink();
                }
            ))
      ],
    );
  }

  Widget getFinishedOrders(){
    return  BlocConsumer<CaptainOrdersListBloc ,CaptainOrdersListStates >(
      bloc: _ordersListBloc,
      listener: (context ,state){
    },
      builder: (maincontext,state) {

        if(state is CaptainOrdersListErrorState)
          return Center(
            child: GestureDetector(
              onTap: (){

              },
              child: Container(
                color: ColorsConst.mainColor,
                padding: EdgeInsets.symmetric(),
                child: Text(state.message,style: TextStyle(fontWeight: FontWeight.w800, color: Colors.white),),
              ),
            ),
          );

        else if(state is CaptainOrdersListSuccessState) {
          List<OrderModel> orders = state.previousOrders;

          if(orders.isEmpty)
            return Center(
              child: Container(child: Text('Empty !!'),),
            );
          else
            return RefreshIndicator(
              onRefresh: ()=>onRefreshMyOrder(),
              child: ListView.separated(
                itemCount:orders.length,
                separatorBuilder: (context,index){
                  return SizedBox(height: 8,);
                },
                itemBuilder: (context,index){

                  return GestureDetector(
                    onTap: (){
                      var url = WhatsAppLinkHelper.getMapsLink(
                          orders[index].destination.lat,  orders[index].destination.lon);
                      launchUrl(Uri.parse(url));
                     // Navigator.pushNamed(maincontext, OrdersRoutes.ORDER_DETAIL_SCREEN , arguments:orders[index].id );
                    },
                    child: Container(
                      height: 150,
                      width: double.infinity,
                      padding: EdgeInsets.only(top: 10,left: 10,right: 10),
                      margin: EdgeInsets.symmetric(horizontal: 16,vertical: 5),
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black12,
                              blurRadius:2,
                              spreadRadius: 1
                          )
                        ],
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [

                              Text('Details',style: GoogleFonts.lato(
                                  fontSize: 16,
                                  color: Colors.black54,
                                  fontWeight: FontWeight.w800
                              ),),
                              InkWell(
                                  onTap: (){

                                    deleteOrderCheckAlertWidget(maincontext, orderID: orders[index].id);
                                  },
                                  child: Icon(Icons.close,color:Colors.black54 ,)),
                            ],
                          ),
                          SizedBox(height: 8,),
                          Expanded(
                            child: Text(orders[index].description,overflow: TextOverflow.ellipsis,style: GoogleFonts.lato(
                                fontSize: 12,
                                color: Colors.black45,
                                fontWeight: FontWeight.w800
                            )),
                          ),
                          SizedBox(height: 4,),

                          Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(Icons.location_on_outlined , color: Colors.black45,),
                              Expanded(
                                child: Text(orders[index].addressName,overflow: TextOverflow.ellipsis,style: GoogleFonts.lato(
                                  fontSize: 12,
                                  color: Colors.black45,
                                  fontWeight: FontWeight.w800,

                                )),
                              )

                            ],),
                          SizedBox(height: 4,),
                          Text(orders[index].orderValue.toString() + '    AED',style: GoogleFonts.lato(
                              fontSize: 14,
                              color: ColorsConst.mainColor,
                              fontWeight: FontWeight.bold
                          )),
                          SizedBox(height: 8,),
                          Container(
                            height: 35,
                            clipBehavior: Clip.antiAlias,
                            decoration: BoxDecoration(
                                color: ColorsConst.mainColor,
                                borderRadius: BorderRadius.circular(10)
                            ),
                            child: MaterialButton(
                              onPressed: () {
                                requestOrderProgress(orders[index]);
                                // Navigator.pushNamed(context, OrdersRoutes.ORDER_STATUS_SCREEN,arguments:  orders[index].id);
                              },
                              child:   Center(child: Text('Finish ',style: TextStyle(color: Colors.white),)),


                            ),
                          )

                        ],
                      ),
                    ),
                  );
                },
              ),
            );}
        else  return Center(
            child: Container(
              width: 40,
              height: 40,
              child: CircularProgressIndicator(color: ColorsConst.mainColor,),
            ),
          );

      }
    );
  }
  Widget getAccountSwitcher() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: SizeConfig.widhtMulti * 3),
      child: BlocBuilder<CaptainOrdersListBloc ,CaptainOrdersListStates >(
          bloc: _ordersListBloc,
          builder: (context, state) {
            int curNumber =0;
            int preNumber =0;
            if(state is CaptainOrdersListSuccessState){
              curNumber = state.currentOrders.length;
              preNumber = state.previousOrders.length;
            }
            return Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      current_tap = PENDING_ORDER;
                      if (mounted) {
                        setState(() {});
                      }
                    },
                    child: AnimatedContainer(
                        duration: Duration(milliseconds: 500),
                        padding: EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: current_tap == PENDING_ORDER
                              ? ColorsConst.mainColor
                              : Colors.transparent,

                        ),
                        child: Center(child: Text('Pending Orders (${curNumber})',style: TextStyle(
                            color: current_tap == PENDING_ORDER ?Colors.white: ColorsConst.mainColor,
                            fontWeight: FontWeight.w600,
                            fontSize: 16
                        ),))),
                  ),
                ),
                Expanded(
                  child:GestureDetector(
                    onTap: () {
                      current_tap = FINISHED_ORDER;
                      if (mounted) {
                        setState(() {});
                      }
                    },
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 500),
                      padding: EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),

                        color:    current_tap == FINISHED_ORDER
                            ? ColorsConst.mainColor
                            : Colors.transparent,
                      ),
                      child:Center(child: Text('Finished Orders (${preNumber})',style: TextStyle(
                          color: current_tap == FINISHED_ORDER ?Colors.white: ColorsConst.mainColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 16
                      ))),
                    ),
                  ),
                )

              ],
            );
          }
      ),
    );
  }
  Future<void> onRefreshMyOrder()async {
    _ordersListBloc.getOwnerOrders();
  }
 Widget getOrders(){
    return BlocConsumer<CaptainOrdersListBloc ,CaptainOrdersListStates >(
      bloc: _ordersListBloc,
      listener: (context ,state){
        // print(state);
        // if (state is CaptainOrderDeletedErrorState){
        //   if(state.message == 'Error'){
        //    snackBarErrorWidget(context, 'Error in deleted !!');
        //   }
        //   else{
        //     snackBarSuccessWidget(context, 'Success Deleted , Refresh !!');
        //   }
        // }
        // else if(state is CaptainOrdersListSuccessState ){
        //   if(state.message !=null){
        //     snackBarSuccessWidget(context, 'Success Deleted , Refresh !!');
        //   }
        // }
      },
      builder: (maincontext,state) {

         if(state is CaptainOrdersListErrorState)
          return Center(
            child: GestureDetector(
              onTap: (){

              },
              child: Container(
                color: ColorsConst.mainColor,
                padding: EdgeInsets.symmetric(),
                child: Text(state.message,style: TextStyle(fontWeight: FontWeight.w800, color: Colors.white),),
              ),
            ),
          );

        else if(state is CaptainOrdersListSuccessState) {
           List<OrderModel> orders = state.currentOrders;

           if(orders.isEmpty)
             return Center(
               child: Container(child: Text('Empty !!'),),
             );
           else
          return RefreshIndicator(
          onRefresh: ()=>onRefreshMyOrder(),
          child: ListView.separated(
            itemCount:orders.length,
            separatorBuilder: (context,index){
              return SizedBox(height: 8,);
            },
            itemBuilder: (context,index){

              return GestureDetector(
                onTap: (){
                  Navigator.pushNamed(maincontext, OrdersRoutes.ORDER_DETAIL_SCREEN, arguments:orders[index].id);
                },
                child: Container(
                  height: 150,
                  width: double.infinity,
                  padding: EdgeInsets.only(top: 10,left: 10,right: 10),
                  margin: EdgeInsets.symmetric(horizontal: 16,vertical: 5),
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius:2,
                        spreadRadius: 1
                      )
                    ],
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        child: Image.asset('assets/order.png',fit: BoxFit.fill,),
                      ),
                      SizedBox(width: 8,),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [

                                Row(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.symmetric(horizontal: 8),
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(30),
                                          color: ColorsConst.mainColor.withOpacity(0.1)
                                      ),
                                      child: Text('Num : '+orders[index].customerOrderID.toString() ,style: GoogleFonts.lato(
                                          color: ColorsConst.mainColor,
                                          fontSize: 18,
                                          letterSpacing: 1,
                                          fontWeight: FontWeight.bold
                                      ),),
                                    ),
                                    SizedBox(width: 8,),
                                    InkWell(
                                        onTap: (){

                                          deleteOrderCheckAlertWidget(maincontext, orderID: orders[index].id);
                                        },
                                        child: Icon(Icons.close,color:Colors.black54 ,)),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(height: 8,),
                            Expanded(
                              child: Text(orders[index].description,overflow: TextOverflow.ellipsis,style: GoogleFonts.lato(
                                  fontSize: 12,
                                  color: Colors.black45,
                                  fontWeight: FontWeight.w800
                              )),
                            ),
                            SizedBox(height: 4,),

                            Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                              Icon(Icons.location_on_outlined , color: Colors.black45,),
                              Expanded(
                                child: Text(orders[index].addressName,overflow: TextOverflow.ellipsis,style: GoogleFonts.lato(
                                    fontSize: 12,
                                    color: Colors.black45,
                                    fontWeight: FontWeight.w800,

                                )),
                              )

                            ],),
                            SizedBox(height: 4,),
                            Text(orders[index].orderValue.toString() + '    AED',style: GoogleFonts.lato(
                                fontSize: 14,
                                color: ColorsConst.mainColor,
                                fontWeight: FontWeight.bold
                            )),
                            SizedBox(height: 8,),
                            Container(
                              height: 30,
                              clipBehavior: Clip.antiAlias,
                              decoration: BoxDecoration(
                                  color: ColorsConst.mainColor,
                                  borderRadius: BorderRadius.circular(10)
                              ),
                              child: MaterialButton(
                                onPressed: () {
                                  requestOrderProgress(orders[index]);
                                  // Navigator.pushNamed(context, OrdersRoutes.ORDER_STATUS_SCREEN,arguments:  orders[index].id);
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    Text('Update Status To ',style: TextStyle(color: Colors.white,fontSize: SizeConfig.titleSize * 1.9),),
                                    Icon(Icons.arrow_forward ,color: Colors.white,),
                                    Text(_getNextState(orders[index]),style: TextStyle(color: Colors.white,fontSize: SizeConfig.titleSize * 1.9))
                                  ],
                                ),

                              ),
                            )

                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );}
        else  return Center(
             child: Container(
               width: 40,
               height: 40,
               child: CircularProgressIndicator(color: ColorsConst.mainColor,),
             ),
           );

      }
    );
  }

  String _getNextState(OrderModel currentOrder) {
    String state ='';
    switch (currentOrder.status) {
      case OrderStatus.INIT:
        state = 'GOT CAPTAIN';
        break;
      case OrderStatus.GOT_CAPTAIN:
        state = 'IN STORE';
        break;
      case OrderStatus.IN_STORE:
        state ='DELIVERING';
        break;
      case OrderStatus.DELIVERING:
        state = currentOrder.payment == PaymentMethodConst.CASH_MONEY
            ? 'GOT CASH'
            : 'FINISHED';
        break;
      case OrderStatus.GOT_CASH:
        state = 'FINISHED';
        break;
      case OrderStatus.FINISHED:
        state = 'FINISHED';
        break;
    }
    return state;
  }
  void requestOrderProgress(OrderModel currentOrder) {
    print('===============================');
    print(currentOrder.status);
    late  OrderStatus newStatus;
    switch (currentOrder.status) {
      case OrderStatus.INIT:
        newStatus = OrderStatus.GOT_CAPTAIN;
        break;
      case OrderStatus.GOT_CAPTAIN:
        newStatus = OrderStatus.IN_STORE;
        break;
      case OrderStatus.IN_STORE:
        newStatus = OrderStatus.DELIVERING;
        break;
      case OrderStatus.DELIVERING:
        newStatus = currentOrder.payment == PaymentMethodConst.CASH_MONEY
            ? OrderStatus.GOT_CASH
            : OrderStatus.FINISHED;
        break;
      case OrderStatus.GOT_CASH:
        newStatus = OrderStatus.FINISHED;
        break;
      case OrderStatus.FINISHED:
        break;
    }

    //currentOrder.distance = distance!;
    currentOrder.status = newStatus;
    _updateStatusBloc.updateOrder(currentOrder);
  }
}
