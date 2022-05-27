
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_kom/consts/colors.dart';
import 'package:my_kom/module_company/screen/widgets/expanded_text_widget.dart';
import 'package:my_kom/module_orders/model/order_model.dart';
import 'package:my_kom/module_orders/state_manager/order_detail_bloc.dart';
import 'package:my_kom/utils/size_configration/size_config.dart';

class OrderDetailScreen extends StatefulWidget {

  const OrderDetailScreen({Key? key}) : super(key: key);

  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  final OrderDetailBloc _detailBloc = OrderDetailBloc();
  late String orderID;
@override
  void initState() {
  WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
    orderID = ModalRoute.of(context)!.settings.arguments.toString();
    _detailBloc.getOrderDetail(orderId:orderID);
  });

    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
                title:   Text('Details',style: GoogleFonts.lato(
            fontSize: 20,
            color: Colors.white,
            fontWeight: FontWeight.bold
        ),),
          elevation: 0,
        backgroundColor: ColorsConst.mainColor,
      ),
      body:  BlocBuilder<OrderDetailBloc , OrderDetailStates>(
        bloc: _detailBloc,
        builder: (context,state) {
          if(state is OrderDetailErrorState)
            return Center(
              child: Container(
                child: Text(state.message),
              ),
            );
          else if(state is OrderDetailSuccessState){
            OrderModel order = state.data;
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20,),
                    Text('Description',style: GoogleFonts.lato(
                        fontSize: 20,
                        color: Colors.black54,
                        fontWeight: FontWeight.w600),),

                    SizedBox(height: 8,),
                    Text(order.description,style: GoogleFonts.lato(
                        fontSize: 12,
                        color: Colors.black45,
                        fontWeight: FontWeight.w800
                    )),
                    SizedBox(height: 12,),


                    Text('Address',style: GoogleFonts.lato(
                        fontSize: 20,
                        color: Colors.black54,
                        fontWeight: FontWeight.w600),),

                    SizedBox(height: 8,),


                    Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(Icons.location_on_outlined , color: Colors.black45,),
                        Expanded(
                          child: Text(order.addressName,style: GoogleFonts.lato(
                            fontSize: 12,
                            color: Colors.black45,
                            fontWeight: FontWeight.w800,

                          )),
                        )

                      ],),
                    SizedBox(height: 12,),
                    Text('Order Price',style: GoogleFonts.lato(
                        fontSize: 20,
                        color: Colors.black54,
                        fontWeight: FontWeight.w600),),

                    SizedBox(height: 8,),

                    Text(order.orderValue.toString() + '    AED',style: GoogleFonts.lato(
                        fontSize: 14,
                        color: ColorsConst.mainColor,
                        fontWeight: FontWeight.bold
                    )),
                    SizedBox(height: 12,),

                    Text('Phone',style: GoogleFonts.lato(
                        fontSize: 20,
                        color: Colors.black54,
                        fontWeight: FontWeight.w600),),

                    SizedBox(height: 8,),

                    Text(order.phone.toString() ,style: GoogleFonts.lato(
                        fontSize: 14,
                        color: Colors.black45,
                        fontWeight: FontWeight.bold
                    )),
                    SizedBox(height: 12,),
                    Text('Payment',style: GoogleFonts.lato(
                        fontSize: 20,
                        color: Colors.black54,
                        fontWeight: FontWeight.w600),),

                    SizedBox(height: 8,),

                    Text(order.payment.toString() ,style: GoogleFonts.lato(
                        fontSize: 14,
                        color: Colors.black45,
                        fontWeight: FontWeight.bold
                    )),
                    SizedBox(height:12,),
                    Text('Start Date',style: GoogleFonts.lato(
                        fontSize: 20,
                        color: Colors.black54,
                        fontWeight: FontWeight.w600),),

                    SizedBox(height: 8,),
                    Text(order.startDate.toString() ,style: GoogleFonts.lato(
                        fontSize: 14,
                        color: Colors.black45,
                        fontWeight: FontWeight.bold
                    )),
                    SizedBox(height: 12,),

                    Text('Delivery Time',style: GoogleFonts.lato(
                        fontSize: 20,
                        color: Colors.black54,
                        fontWeight: FontWeight.w600),),

                    SizedBox(height: 8,),

                    Text(order.deliveryTime.toString() ,style: GoogleFonts.lato(
                        fontSize: 14,
                        color: Colors.black45,
                        fontWeight: FontWeight.bold
                    )),
                    SizedBox(height: 12,),

                    Text('Products' ,style: GoogleFonts.lato(
                        fontSize: 20,
                        color: Colors.black45,
                        fontWeight: FontWeight.bold
                    )),
                    Container(
                      child: Column(children: [
                        Divider(
                          color: Colors.black,

                          endIndent: 10,
                        ),
                        Container(
                          height: 150,
                          padding: EdgeInsets.all(5),
                          width: double.infinity,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                              itemCount: order.products.length,
                              itemBuilder: (context,index){
                            return Container(
                              clipBehavior: Clip.antiAlias,
                              margin: EdgeInsets.symmetric(horizontal: 5,vertical: 4),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.black12,
                                        blurRadius: 3,
                                        offset: Offset(0, 5)),
                                    BoxShadow(
                                        color: Colors.black12,
                                        blurRadius: 3,
                                        offset: Offset(0, -1))
                                  ]),
                              child: Hero(
                                tag: 'product_'+order.products[index].id,
                                child: Column(
                                  children: [
                                    Flexible(
                                      flex: 4,
                                      child: Container(
                                        child: AspectRatio(
                                          aspectRatio: 1.3,
                                          child: ClipRRect(
                                            borderRadius:
                                            BorderRadius.circular(10),
                                            child:order.products[index]
                                                .imageUrl
                                                .length !=
                                                0
                                                ? Container(
                                              decoration: BoxDecoration(
                                                image: DecorationImage(
                                                  image:
                                                  new ExactAssetImage(
                                          order.products[index]
                                                          .imageUrl),
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            )
                                                : CachedNetworkImage(
                                              maxHeightDiskCache: 10,
                                              imageUrl:
                                              order.products[index].imageUrl,
                                              progressIndicatorBuilder:
                                                  (context, l, ll) =>
                                                  CircularProgressIndicator(
                                                    value: ll.progress,
                                                  ),
                                              errorWidget:
                                                  (context, s, l) =>
                                                  Icon(Icons.error),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),

                                    Flexible(
                                      flex: 2,
                                      child: Center(
                                        child: Padding(
                                          padding: EdgeInsets.only(top: 8),
                                          child: Text(
                                            order.products[index].title,
                                            style: TextStyle(
                                                fontSize:
                                                SizeConfig.titleSize * 2.2,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black54,
                                                overflow: TextOverflow.ellipsis),
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            );
                          }),
                        )

                      ]),
                    ),
                    SizedBox(height: 20,),
                  ],
                ),
              ),
            );
          }

          else {
            return Center(
              child: Container(
                width: 40,
                height: 40,
                child:CircularProgressIndicator(color: ColorsConst.mainColor,) ,
              ),
            );
          }
        }
      ),
    );
  }
}
