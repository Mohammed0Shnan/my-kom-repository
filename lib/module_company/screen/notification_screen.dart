import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:my_kom/consts/colors.dart';
import 'package:my_kom/module_authorization/presistance/auth_prefs_helper.dart';
import 'package:my_kom/module_authorization/screens/widgets/top_snack_bar_widgets.dart';
import 'package:my_kom/module_map/models/address_model.dart';
import 'package:my_kom/module_orders/model/order_model.dart';
import 'package:my_kom/module_orders/response/orders/orders_response.dart';
import 'package:my_kom/module_orders/state_manager/new_order/new_order.state_manager.dart';
import 'package:my_kom/module_orders/state_manager/notifications_bloc.dart';
import 'package:my_kom/module_shoping/bloc/payment_methode_number_bloc.dart';
import 'package:my_kom/module_shoping/models/card_model.dart';
import 'package:my_kom/utils/size_configration/size_config.dart';


class NotificationsScreen extends StatefulWidget {


  @override
  State<StatefulWidget> createState() => NotificationsScreenState();
}

class NotificationsScreenState extends State<NotificationsScreen> {
  final NotificationsBloc _notificationsBloc = NotificationsBloc();
  final NewOrderBloc _orderBloc = NewOrderBloc();
  final PaymentMethodeNumberBloc paymentMethodeNumberBloc = PaymentMethodeNumberBloc();
  final AuthPrefsHelper _authPrefsHelper =AuthPrefsHelper();
  @override
  void initState() {
    super.initState();
    _authPrefsHelper.getAddress().then((value) {
      addressModel = value!;
    }
    );
    _notificationsBloc.getNotifications();
  }
  late String paymentGroupValue = '';
  late String cardId= '';
  late AddressModel addressModel ;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorsConst.mainColor,
        title:Text('Notifications',style: GoogleFonts.lato(
            fontSize: 21,
            fontWeight: FontWeight.bold,
            color: Colors.white
        ),),
      ),
      backgroundColor: Colors.grey.shade50,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 8,),
            Expanded(
              child: getNotifications()
            ),
          ],
        ),
      ),

    );
  }
  Future<void> onRefreshMyOrder()async {
    _notificationsBloc.getNotifications();
  }
  Widget getNotifications(){
    return BlocConsumer<NotificationsBloc ,NotificationsStates >(
        bloc: _notificationsBloc,
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

          if(state is NotificationsErrorState)
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

          else if(state is NotificationsSuccessState) {
            List<NotificationModel> notifications = state.notifications;

            if(notifications.isEmpty)
              return Center(
                child: Container(child: Text('Empty !!'),),
              );
            else
              return RefreshIndicator(
                onRefresh: ()=>onRefreshMyOrder(),
                child: ListView.separated(
                  itemCount:notifications.length,
                  separatorBuilder: (context,index){
                    return SizedBox(height: 8,);
                  },
                  itemBuilder: (context,index){
                    return Stack(
                      children: [
                        Container(
                          height:300 ,
                        ),
                        Container(
                          height: 275,
                          width: double.infinity,
                          padding: EdgeInsets.all(10),
                          margin: EdgeInsets.only(left: 20,right: 20,top: 15),
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

                                Spacer(),
                                  Text('#ID : '+ notifications[index].offerId.toString() ,style: GoogleFonts.lato(
                                      color: ColorsConst.mainColor,
                                      fontSize: 20,
                                      letterSpacing: 1,
                                      fontWeight: FontWeight.bold
                                  ),)
                                  // InkWell(
                                  //     onTap: (){
                                  //
                                  //      deleteOrderCheckAlertWidget(maincontext, orderID: orders[index].id);
                                  //     },
                                  //     child: Icon(Icons.close,color:Colors.black54 ,)),
                                ],
                              ),
                              SizedBox(height: 20,),
                              Text('Title  : '+ notifications[index].title,style: GoogleFonts.lato(
                                  color: Colors.black54,
                                  fontSize: 20,
                                  letterSpacing: 1,
                                  fontWeight: FontWeight.bold
                              ),),
                              SizedBox(height: 8),
                            Expanded(
                                  child: PageView.builder(
                                      itemCount: notifications[index].imageUrl.length,
                                      itemBuilder: (context,i){
                                    return Container(
                                      child: CachedNetworkImage(
                                        maxHeightDiskCache: 5,
                                        imageUrl: notifications[index].imageUrl[i],
                                        progressIndicatorBuilder: (context, l, ll) =>
                                            CircularProgressIndicator(
                                              value: ll.progress,
                                            ),
                                        errorWidget: (context, s, l) => Icon(Icons.error),
                                        fit: BoxFit.cover,
                                      ),
                                    );
                                  }),
                                ),

                              SizedBox(height: 4,),


                              // SizedBox(height: 4,),
                              // Text(''+ '    AED',style: GoogleFonts.lato(
                              //     fontSize: 14,
                              //     color: ColorsConst.mainColor,
                              //     fontWeight: FontWeight.bold
                              // )),
                              // SizedBox(height: 4,),

                            ],
                          ),
                        ),
                        Positioned(
                            top: 0,
                            left: 10,
                            child: Container(
                              height: 70,
                              width: 70,
                              clipBehavior: Clip.antiAlias,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  image:AssetImage('assets/offer.png'),
                                  fit: BoxFit.cover
                                )
                              ),
                            )),
                        Positioned(
                          bottom: 5,
                          right: 20,
                          child: Container(
                            height: 35,
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(
                              color: ColorsConst.mainColor
                              ,

                              borderRadius: BorderRadius.circular(5)
                          ),
                          child: MaterialButton(
                            onPressed: () {
                              showMaterialModalBottomSheet(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(topLeft: Radius.circular(30),
                                      topRight: Radius.circular(30)
                                  ),
                                ),
                                context: context,
                                builder: (context) => SingleChildScrollView(
                                  controller: ModalScrollController.of(context),
                                  child: Container(
                                    padding: EdgeInsets.all(20),
                                    height: SizeConfig.screenHeight * 0.8,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Center(child: IconButton(onPressed: (){
                                          Navigator.pop(context);
                                        }, icon: Icon(Icons.keyboard_arrow_down_outlined ,size: 30,)))
                                        ,SizedBox(height: 25,),

                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text('Title : ' + notifications[index].title,style: TextStyle(
                                                fontSize: 20,
                                                color: Colors.black54,
                                                fontWeight: FontWeight.w600),),
                                            Text(notifications[index].price.toString(),style: TextStyle(
                                                fontSize: 20,
                                                color: Colors.green,
                                                fontWeight: FontWeight.w600),),
                                          ],
                                        ),
                                        SizedBox(height: 10,),
                                        Text('Description : ',style: TextStyle(
                                            fontSize: 20,
                                            color: Colors.black54,
                                            fontWeight: FontWeight.w600),),
                                        SizedBox(height: 10,),
                                        Expanded(
                                          child: Text(notifications[index].description,style: TextStyle(
                                              fontSize: 17,
                                              color: Colors.black54,
                                              fontWeight: FontWeight.w600),),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),

                                        Spacer(),
                                        Center(
                                          child: Container(
                                            width: 100,
                                            color: ColorsConst.mainColor,
                                            child: MaterialButton(onPressed: (){

                                              showMaterialModalBottomSheet(
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.only(topLeft: Radius.circular(30),
                                                      topRight: Radius.circular(30)
                                                  ),
                                                ),
                                                context: context,
                                                builder: (context) => SingleChildScrollView(
                                                  controller: ModalScrollController.of(context),
                                                  child: BlocBuilder<PaymentMethodeNumberBloc,PaymentState>(
                                                      bloc: paymentMethodeNumberBloc,
                                                      builder: (context,state) {
                                                        return Container(
                                                          padding: EdgeInsets.symmetric(horizontal: 10),
                                                          height: SizeConfig.screenHeight * 0.8 ,
                                                          clipBehavior: Clip.antiAlias,
                                                          decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.only(topLeft: Radius.circular(30),
                                                                topRight: Radius.circular(30)
                                                            ),
                                                          ),
                                                          child: Column(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              IconButton(onPressed: (){
                                                                Navigator.of(context).pop();
                                                              }, icon:Icon(Icons.clear) ),
                                                              Text('Pay by card' , style:TextStyle(

                                                                  color: Colors.black54,
                                                                  fontWeight: FontWeight.bold,
                                                                  fontSize: SizeConfig.titleSize*2.9

                                                              ),),
                                                              SizedBox(height: 15,),
                                                              Container(
                                                                margin: EdgeInsets.symmetric(horizontal: 20),

                                                                child: ListView.separated(
                                                                  separatorBuilder: (context,index){
                                                                    return  SizedBox(height: 8,);
                                                                  },
                                                                  shrinkWrap:true ,
                                                                  itemCount: state.cards.length,
                                                                  itemBuilder: (context,index){
                                                                    CardModel  card =   state.cards[index];
                                                                    return   Center(
                                                                      child: Container(
                                                                        width: double.infinity,
                                                                        height: 6.8 * SizeConfig.heightMulti,
                                                                        decoration: BoxDecoration(
                                                                            borderRadius: BorderRadius.circular(10),
                                                                            color: Colors.grey.shade50,
                                                                            border: Border.all(
                                                                                color: Colors.black26,
                                                                                width: 2
                                                                            )
                                                                        ),
                                                                        child: Row(
                                                                          mainAxisSize: MainAxisSize.min,

                                                                          children: [
                                                                            Radio<String>(
                                                                              value: card.id,
                                                                              groupValue: paymentMethodeNumberBloc.state.paymentMethodeCreditGroupValue,
                                                                              onChanged: (value) {
                                                                                paymentMethodeNumberBloc.changeSelect(value!);
                                                                              },
                                                                              activeColor: Colors.green,
                                                                            ),
                                                                            Icon(Icons.payment),
                                                                            SizedBox(width: 10,),

                                                                            Text(card.cardNumber , style: GoogleFonts.lato(
                                                                                color: Colors.black54,
                                                                                fontSize: SizeConfig.titleSize * 2.1,
                                                                                fontWeight: FontWeight.bold
                                                                            ),),
                                                                            Spacer(),
                                                                            IconButton(onPressed: (){
                                                                              paymentMethodeNumberBloc.removeOne(state.cards[index]);
                                                                            }, icon: Icon(Icons.delete,color: Colors.red,)),

                                                                          ],
                                                                        ),
                                                                      ),
                                                                    );

                                                                  },

                                                                ),
                                                              ),
                                                              SizedBox(height:25,),
                                                              // Center(
                                                              //   child: GestureDetector(
                                                              //     onTap: (){
                                                              //       // Navigator.push(context, MaterialPageRoute(builder: (context)=>
                                                              //       //     BlocProvider.value(
                                                              //       //         value: paymentMethodeNumberBloc,
                                                              //       //         child: AddCardScreen())
                                                              //       // ));
                                                              //       //  paymentMethodeNumberBloc.addOne();
                                                              //     },
                                                              //     child: Container(
                                                              //       margin: EdgeInsets.symmetric(horizontal: 20),
                                                              //
                                                              //       width: SizeConfig.screenWidth ,
                                                              //       height: 6.8 * SizeConfig.heightMulti,
                                                              //       decoration: BoxDecoration(
                                                              //           borderRadius: BorderRadius.circular(10),
                                                              //           color: Colors.grey.shade50,
                                                              //           border: Border.all(
                                                              //               color: Colors.black26,
                                                              //               width: 2
                                                              //           )
                                                              //       ),
                                                              //       child: Row(
                                                              //         mainAxisSize: MainAxisSize.min,
                                                              //
                                                              //         children: [
                                                              //
                                                              //           Icon(Icons.add),
                                                              //           SizedBox(width: 10,),
                                                              //
                                                              //           Text('Add a card', style: GoogleFonts.lato(
                                                              //               color: Colors.black54,
                                                              //               fontSize: SizeConfig.titleSize * 2.6,
                                                              //               fontWeight: FontWeight.bold
                                                              //           )
                                                              //             ,)
                                                              //         ],
                                                              //       ),
                                                              //     ),
                                                              //   ),
                                                              // ),
                                                              Spacer(),
                                                              Center(
                                                                child: BlocConsumer<NewOrderBloc,CreateOrderStates>(
                                                                    bloc: _orderBloc,
                                                                    listener: (context,state)async{
                                                                      if(state is CreateOrderSuccessState)
                                                                      {
                                                                        snackBarSuccessWidget(context, 'Offer Requested Successfully!!');
                                                                      }
                                                                      else if(state is CreateOrderErrorState)
                                                                      {
                                                                        snackBarSuccessWidget(context, 'The Offer Was Not Requested!!');
                                                                      }
                                                                    },
                                                                    builder: (context,state) {
                                                                      bool isLoading = state is CreateOrderLoadingState?true:false;
                                                                      return AnimatedContainer(
                                                                        duration: Duration(milliseconds: 200),
                                                                        clipBehavior: Clip.antiAlias,
                                                                        height: 8.44 * SizeConfig.heightMulti,
                                                                        width:isLoading?60: SizeConfig.screenWidth * 0.8,
                                                                        padding: EdgeInsets.all(isLoading?8:0 ),
                                                                        margin: EdgeInsets.symmetric(horizontal: 20),
                                                                        decoration: BoxDecoration(
                                                                            color: ColorsConst.mainColor,
                                                                            borderRadius: BorderRadius.circular(10)
                                                                        ),
                                                                        child:isLoading?Center(child: CircularProgressIndicator(color: Colors.white,)): MaterialButton(
                                                                          onPressed: () {
                                                                            /// Offer Request
                                                                            cardId =  paymentMethodeNumberBloc.state.paymentMethodeCreditGroupValue;
                                                                            GeoJson geoJson = GeoJson(lat: addressModel.latitude, lon: addressModel.longitude);
                                                                        //    _orderBloc.addNewOrder(product: requestProduct, deliveryTimes: deliveryTimesGroupValue, date:_expiry_date! , destination: geoJson,addressName: addressModel.description, phoneNumber: phoneNumber, paymentMethod: paymentGroupValue,numberOfMonth: numberOfMonth, orderValue: orderValue, cardId: cardId);
                                                                          },
                                                                          child: Text('Confirmation', style: TextStyle(color: Colors.white,
                                                                              fontSize: SizeConfig.titleSize * 2.7),),

                                                                        ),
                                                                      );
                                                                    }
                                                                ),
                                                              ),
                                                              SizedBox(height: SizeConfig.screenHeight * 0.05,)
                                                            ],
                                                          ),
                                                        );
                                                      }
                                                  ),
                                                ),
                                              );

                                            },child: Text('Request',style: TextStyle(color: Colors.white),),)
                                            ,
                                          ),
                                        )
                                      ],
                                    ),
                                  )
                                ),
                              );
                            },
                            child: Text('Details', style: TextStyle(
                                color: Colors.white,
                                fontSize: SizeConfig.titleSize * 2.7,
                            fontWeight: FontWeight.bold
                            ),),

                          ),
                        ),)
                      ],
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



}
