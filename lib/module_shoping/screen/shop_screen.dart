import 'dart:math';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_credit_card/credit_card_brand.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:my_kom/consts/colors.dart';
import 'package:my_kom/consts/delivery_times.dart';
import 'package:my_kom/consts/payment_method.dart';
import 'package:my_kom/module_authorization/model/app_user.dart';
import 'package:my_kom/module_authorization/presistance/auth_prefs_helper.dart';
import 'package:my_kom/module_authorization/screens/widgets/top_snack_bar_widgets.dart';
import 'package:my_kom/module_authorization/service/auth_service.dart';
import 'package:my_kom/module_company/models/product_model.dart';
import 'package:my_kom/module_map/map_routes.dart';
import 'package:my_kom/module_map/models/address_model.dart';
import 'package:my_kom/module_map/service/map_service.dart';
import 'package:my_kom/module_orders/response/orders/orders_response.dart';
import 'package:my_kom/module_orders/state_manager/new_order/new_order.state_manager.dart';
import 'package:my_kom/module_orders/ui/screens/complete_order_screen.dart';
import 'package:my_kom/module_persistence/sharedpref/shared_preferences_helper.dart';
import 'package:my_kom/module_shoping/bloc/check_address_bloc.dart';
import 'package:my_kom/module_shoping/bloc/payment_methode_number_bloc.dart';
import 'package:my_kom/module_shoping/bloc/shopping_cart_bloc.dart';
import 'package:my_kom/module_shoping/models/card_model.dart';
import 'package:my_kom/module_shoping/service/stripe.dart';
import 'package:my_kom/utils/size_configration/size_config.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';

class ShopScreen extends StatefulWidget {
   ShopScreen({Key? key}) : super(key: key);

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  late final _pageController;
  final PaymentMethodeNumberBloc paymentMethodeNumberBloc = PaymentMethodeNumberBloc();
  final NewOrderBloc _orderBloc = NewOrderBloc();
  final TextEditingController _newAddressController = TextEditingController(text: '');
  final CheckAddressBloc  _checkAddressBloc = CheckAddressBloc();
  final SharedPreferencesHelper _preferencesHelper =SharedPreferencesHelper();
  final MapService _mapService = MapService();
  @override
  void initState() {

    AuthPrefsHelper().getAddress().then((value) {
      if(value!= null){
        addressModel =  value;
        _newAddressController.text = value.description;
      }

    });
    _preferencesHelper.getCurrentStore().then((store) {

      if(store != null){
        storeId = store;
        AuthPrefsHelper().getAddress().then((address) {
          if(address != null){
            print('!!!!!!!!!!!!!!!!!!!!!!!!!');
            print(address.description);
            print('!!!!!!!!!!!!!!!!!!!!!!!!!');

            _getSubAreaForAddress(null);
          }
        });
      }
    });
    _pageController = PageController(
      initialPage: 0,
    );
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  late String storeId;
  int currentIndex = 0;

  List<String> nowTitle = [
    'Details and price of the shipment',
    'Destination,Shipping details and Pay',
  ];

  List<String> nextTitle = [
    'Next is the destination ,shipping details and Pay',
    'Next is order confirmation',
  ];
  double stateAngle = 0;
  double endAngle = 0;

  // request parameters
  late List<ProductModel> requestProduct;
  String deliveryTimesGroupValue = DeliveryTimesConst.ONE;
  int numberOfMonth = 0;
  DateTime? _expiry_date = DateTime.now();
  late AddressModel addressModel ;
  late String phoneNumber = '';
  late String paymentGroupValue = '';
  late double orderValue = 0.0;
  late String cardId= '';

  bool addressIsAccept =false;

  GlobalKey<ScaffoldState> _scaffoldState = GlobalKey<ScaffoldState>();
  bool orderNotComplete  = false;


  _getSubAreaForAddress( LatLng? latLng){
    _mapService.getSubAreaPosition(latLng).then((subArea) {
      if(subArea != null){
        _checkAddressBloc.checkAddress(storeId, subArea);
      }
    });
  }

  @override
  Widget build(BuildContext maincontext) {
    switch (currentIndex) {
      case 0:
        {
          print(pi);
          stateAngle = 0;
          endAngle = 2*pi/3;
        }
        break;
      case 1 :
        {
          stateAngle = 2*pi/3;
          endAngle = 4*pi/3 ;
        }
        break;
      case 2 :
        {
          stateAngle = 4*pi/3;
          endAngle = 2 * pi ;
        }
        break;
      case 3 :
        {
          stateAngle = 3 * pi / 2;
          endAngle = 2 * pi;
        }
        break;
    }
    return Scaffold(
      key: _scaffoldState,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        elevation: 0,
        title: Text(
          'Shopping Cart',
          style: TextStyle(color: Colors.black),
        ),
      ),

      body: SafeArea(
          child: Container(
            child: Column(
              children: [
                Container(
                  height: 11 * SizeConfig.heightMulti,
                  decoration: BoxDecoration(

                      color: Colors.white,
                    border: Border.all(
                      color: Colors.black12,
                      style:BorderStyle.solid
                    )

                  ),
                  child: Row(
                    children: [
                      TweenAnimationBuilder(
                          tween: Tween<double>(begin: 0.0, end: 1.0),
                          duration: Duration(seconds: 2),
                          builder: (context, double value, child) {
                            return Container(
                                width: 13 * SizeConfig.heightMulti,
                                height: 13 * SizeConfig.heightMulti,
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                child: Stack(
                                  children: [
                                    ShaderMask(
                                      shaderCallback: (rect) {
                                        return SweepGradient(

                                            startAngle: stateAngle,
                                            endAngle: endAngle,
                                            center: Alignment.center,
                                            stops: [
                                              value,
                                              value
                                            ],
                                            colors: [
                                              ColorsConst.mainColor,
                                              Colors.grey.withOpacity(0.2)
                                            ]).createShader(rect);
                                      },
                                      child: Container(
                                        width: 13 * SizeConfig.heightMulti,
                                        height: 13 * SizeConfig.heightMulti,
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.white),
                                      ),
                                    ),
                                    Center(
                                      child: Container(
                                        height: 8.8 * SizeConfig.heightMulti,
                                        width: 8.8 * SizeConfig.heightMulti,
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.white),
                                        child: Center(child: Text(
                                          '${currentIndex + 1} of 3',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              color: ColorsConst.mainColor),)),
                                      ),
                                    )
                                  ],
                                ));
                          }),
                      SizedBox(width: 10,),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(nowTitle[currentIndex],
                                style: TextStyle(
                                    color: ColorsConst.mainColor,
                                    fontWeight: FontWeight.w600,
                                    fontSize: SizeConfig.titleSize * 2.5)),
                            SizedBox(
                              height: 8,
                            ),
                            Text(nextTitle[currentIndex],
                                style: TextStyle(
                                    color: Colors.black45,
                                    fontSize: SizeConfig.titleSize * 2.1))
                          ],
                        ),
                      ),

                    ],
                  ),
                ),
                SizedBox(height: 10,),
                 Expanded(
                  child: PageView(
                    onPageChanged: (index) {
                      setState(() {
                        currentIndex = index;
                      });
                    },
                    controller: _pageController,
                    children: [
                      firstPage(),
                      secondPage(),
                     // thirdPage(),
                    ],

                  ),
                ),
              ],
            ),

          )),
    );
  }

  Widget _buildshoppingCard(
      {required ProductModel productModel, required int quantity}) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      height: SizeConfig.heightMulti * 14,
      width: double.infinity,
      child: Row(
        children: [
          Container(
            width: 10,
            decoration: BoxDecoration(
                color: ColorsConst.mainColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  bottomLeft: Radius.circular(20),

                )),
          ),
          Expanded(
            child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black12,
                        blurRadius: 5,
                        offset: Offset(0, 3))
                  ],
                ),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    double h = constraints.maxHeight;
                    double w = constraints.maxWidth;

                    return Row(
                      children: [
                        Container(
                          width: w / 4,
                       //   child: Image.network(productModel.imageUrl,fit: BoxFit.contain,),
                          child:CachedNetworkImage(
                            imageUrl: productModel.imageUrl,
                            progressIndicatorBuilder: (context, l, ll) =>
                                Center(
                                  child: Container(
                                    height: 30,
                                    width: 30,
                                    child: CircularProgressIndicator(
                                      value: ll.progress,
                                      color: Colors.black12,
                                    ),
                                  ),
                                ),
                            errorWidget: (context, s, l) => Icon(Icons.error),
                            fit: BoxFit.fill,
                          ),// Image.asset(productModel.imageUrl),
                        ),
                        SizedBox(width: 10,),
                        Container(
                          width: w/2.3,
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [

                                Text(
                                  productModel.title ,
                                  style: TextStyle(
                                      fontSize: SizeConfig.titleSize * 2.3, fontWeight: FontWeight.w600),
                                ),
                                Text('${productModel.quantity} حبة \ الكرتون'),
                                Text(
                                  '${productModel.price} AED',
                                  style: TextStyle(color: ColorsConst.mainColor),
                                )
                              ]),
                        ),
                        Spacer(),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              height: h / 3,
                              width: w /4,
                              clipBehavior: Clip.antiAlias,
                              decoration: BoxDecoration(
                                boxShadow: [BoxShadow(color: Colors.black12)],
                                borderRadius: BorderRadius.circular(5),
                                color: Colors.white.withOpacity(0.1),
                              ),
                              child: Stack(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        color: ColorsConst.mainColor,
                                        width: SizeConfig.widhtMulti * 8,
                                        child: IconButton(
                                            onPressed: () {
                                              shopCartBloc
                                                  .removeProductFromCart(
                                                  productModel);
                                            },
                                            icon: Icon(
                                              Icons.remove,
                                              size: SizeConfig.imageSize * 5,
                                              color: Colors.white,
                                            )),
                                      ),
                                      Container(
                                        child: Text(quantity.toString()),
                                      ),
                                      Container(
                                        width: SizeConfig.widhtMulti * 8,
                                        alignment: Alignment.center,
                                        color: ColorsConst.mainColor,
                                        child: Center(
                                          child: IconButton(
                                              onPressed: () {
                                                shopCartBloc.addProductToCart(
                                                    productModel);
                                              },
                                              icon: Icon(
                                                Icons.add,
                                                size: SizeConfig.imageSize * 5,
                                                color: Colors.white,
                                              )),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )
                      ],
                    );
                  },
                )),
          ),

        ],
      ),
    );
  }


  Widget firstPage() {
    return Column(
      children: [
        SizedBox(
          height: 5,
        ),
        Expanded(
          child: BlocBuilder<ShopCartBloc, CartState>(
              bloc: shopCartBloc,
              builder: (context, state) {
                if (state is CartLoading) {
                  return CircularProgressIndicator();
                }
                else if (state is CartLoaded) {
                  requestProduct = state.cart.products;
                  return ListView.builder(
                      shrinkWrap: true,
                      itemCount: state.cart
                          .productQuantity(state.cart.products)
                          .keys
                          .length,
                      itemBuilder: (context, index) {
                        return _buildshoppingCard(productModel: state.cart
                            .productQuantity(state.cart.products)
                            .keys
                            .elementAt(index),
                            quantity: state.cart
                                .productQuantity(state.cart.products)
                                .values
                                .elementAt(index)
                        );
                      });
                } else {
                  return Container(
                      child: Center(child: Text('Error in Load Items'),));
                }
              }),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Divider(height: 1, color: Colors.black38, thickness: 1),
              SizedBox(height: 10,),
              Text('Payment Summary',
                  style: GoogleFonts.lato(fontSize: SizeConfig.titleSize * 2.5,
                      fontWeight: FontWeight.w800,
                      color: Colors.black54)
              ),
              SizedBox(height: 8,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Total ', style: GoogleFonts.lato(
                      fontSize: SizeConfig.titleSize * 2.3,
                      fontWeight: FontWeight.w800,
                      color: Colors.black54),),
                  BlocBuilder<ShopCartBloc, CartState>(
                      bloc: shopCartBloc,
                      builder: (context, state) {
                        if (state is CartLoaded) {
                          return Text(state.cart.totalString,
                              style: GoogleFonts.lato(fontSize: SizeConfig
                                  .titleSize * 2.5,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.black54));
                        }
                        else {
                          return Text('', style: TextStyle(color: Colors
                              .black54, fontSize: SizeConfig.titleSize * 2.9));
                        }
                      }
                  ),

                ],),
              SizedBox(height: 10,),
              BlocBuilder<ShopCartBloc, CartState>(
                  bloc: shopCartBloc,
                  builder: (context, state) {
                    if (state is CartLoaded) {
                      if (!state.cart.minimum(220)) {
                        return Container(

                            width: double.maxFinite,
                            margin: EdgeInsets.symmetric(
                                horizontal: SizeConfig.widhtMulti * 5),
                            padding: EdgeInsets.symmetric(vertical: 5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Colors.red.shade50,

                            ),
                            child:
                            Center(child: Text(
                                'Minimum order is 220 AED ', style: GoogleFonts
                                .lato(fontSize: SizeConfig.titleSize * 2.3,
                                fontWeight: FontWeight.w800,
                                color: Colors.red))));
                      }
                      else
                        return Container();
                    }
                    else {
                      return Container();
                    }
                  }
              )


            ],
          ),
        ),
        Container(
          height: 6.78 * SizeConfig.heightMulti,
          margin: EdgeInsets.symmetric(
              horizontal: SizeConfig.widhtMulti * 3, vertical: 5),
          child: Row(
            children: [
              Expanded(
                child: Material(
                  elevation: 3,
                  child: Container(
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                        color: Colors.white
                        ,
                        border: Border.all(
                            color: ColorsConst.mainColor,
                            width: 2
                        ),
                        borderRadius: BorderRadius.circular(10)
                    ),
                    child: MaterialButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('Add More', style: TextStyle(
                          color: ColorsConst.mainColor,
                          fontSize: SizeConfig.titleSize * 2.7),),

                    ),
                  ),
                ),
              ),
              SizedBox(width: SizeConfig.widhtMulti * 3,),
              Expanded(child: Material(
                elevation:3,
                child: Container(
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                      color: ColorsConst.mainColor,
                      borderRadius: BorderRadius.circular(10)
                  ),
                  child: MaterialButton(
                    onPressed: () {
                      // if (_pageController.page == 3) {
                      //   _pageController.nextPage(
                      //       duration: Duration(milliseconds: 200),
                      //       curve: Curves.ease);
                      // }
                   //   else {

                        _pageController.nextPage(
                            duration: Duration(milliseconds: 200),
                            curve: Curves.ease);
                     // }
                    },
                    child: Text('Next', style: TextStyle(color: Colors.white,
                        fontSize: SizeConfig.titleSize * 2.7),),

                  ),
                ),
              ))
              ,
            ],
          ),
        ),


      ],
    );
  }

  Widget secondPage() {


    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        Expanded(
            child: SingleChildScrollView(child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10,),
                // Text('Delivery Times',
                //     style: GoogleFonts.lato(
                //         fontSize: SizeConfig.titleSize * 2.5,
                //         fontWeight: FontWeight.w800,
                //         color: Colors.black54)
                // ),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceAround,
                //   children: [
                //     Row(
                //       mainAxisSize: MainAxisSize.min,
                //       children: [
                //         Radio<String>(
                //           value: DeliveryTimesConst.ONE,
                //           groupValue: deliveryTimesGroupValue,
                //           onChanged: (value) {
                //             setState(() {
                //               deliveryTimesGroupValue = value!;
                //             });
                //           },
                //           activeColor: Colors.green,
                //         ),
                //         Text('Once', style: GoogleFonts.lato(
                //             color: Colors.black54,
                //             fontSize: SizeConfig.titleSize * 2,
                //             fontWeight: FontWeight.bold
                //         ),)
                //       ],
                //     ),
                //     Row(
                //       mainAxisSize: MainAxisSize.min,
                //
                //       children: [
                //         Radio<String>(
                //           value: DeliveryTimesConst.WEEKLY,
                //           groupValue: deliveryTimesGroupValue,
                //           onChanged: (value) {
                //             setState(() {
                //               deliveryTimesGroupValue = value!;
                //             });
                //           },
                //           activeColor: Colors.green,
                //         ),
                //         Text('Weekly', style: GoogleFonts.lato(
                //             color: Colors.black54,
                //             fontSize: SizeConfig.titleSize * 2,
                //             fontWeight: FontWeight.bold
                //         ),)
                //       ],
                //     ),
                //
                //     Row(
                //       mainAxisSize: MainAxisSize.min,
                //
                //       children: [
                //         Radio<String>(
                //           value: DeliveryTimesConst.MONTHLY,
                //           groupValue: deliveryTimesGroupValue,
                //           onChanged: (value) {
                //             setState(() {
                //               deliveryTimesGroupValue = value!;
                //             });
                //           },
                //           activeColor: Colors.green,
                //         ),
                //         Text('Monthly', style: GoogleFonts.lato(
                //             color: Colors.black54,
                //             fontSize: SizeConfig.titleSize * 2,
                //             fontWeight: FontWeight.bold
                //         ),)
                //       ],
                //     ),
                //
                //
                //   ],),
             //   SizedBox(height: 10,),
             //    Row(
             //      mainAxisAlignment: MainAxisAlignment.spaceBetween,
             //      children: [
             //        Column(
             //          crossAxisAlignment: CrossAxisAlignment.start,
             //
             //          children: [
             //            Text('Number of months', style: GoogleFonts.lato(
             //                color: Colors.black54,
             //                fontSize: SizeConfig.titleSize * 2.7,
             //                fontWeight: FontWeight.bold
             //            ),),
             //            SizedBox(height: 8,),
             //            Row(
             //              children: [
             //                Container(
             //                    width: SizeConfig.widhtMulti * 30
             //                    , height: 6 * SizeConfig.heightMulti
             //                    , child: LayoutBuilder(
             //                  builder:
             //                      (BuildContext context,
             //                      BoxConstraints constraints) {
             //                    double w = constraints.maxWidth;
             //
             //                    return Container(
             //                      clipBehavior: Clip.antiAlias,
             //                      decoration: BoxDecoration(
             //                        boxShadow: [
             //                          BoxShadow(color: Colors.black12)
             //                        ],
             //                        borderRadius: BorderRadius.circular(10)
             //                        ,
             //                        color: Colors.white.withOpacity(0.1),
             //                      ),
             //                      child: Stack(
             //                        children: [
             //                          Row(
             //                            mainAxisAlignment:
             //                            MainAxisAlignment.spaceBetween,
             //                            children: [
             //                              Container(
             //
             //                                decoration: BoxDecoration(
             //                                    color: ColorsConst.mainColor,
             //                                    borderRadius: BorderRadius
             //                                        .circular(10)
             //                                ),
             //                                width: w / 3,
             //                                child: IconButton(
             //                                    onPressed: () {
             //                                      if (numberOfMonth != 0)
             //                                        setState(() {
             //                                          numberOfMonth --;
             //                                        });
             //                                    },
             //                                    icon: Icon(
             //                                      Icons.remove,
             //                                      size: SizeConfig.imageSize *
             //                                          5,
             //                                      color: Colors.white,
             //                                    )),
             //                              ),
             //                              Text(numberOfMonth.toString(),
             //                                style: TextStyle(
             //                                  fontWeight: FontWeight.w500,),)
             //                              ,
             //                              Container(
             //                                decoration: BoxDecoration(
             //                                    color: ColorsConst.mainColor,
             //                                    borderRadius: BorderRadius
             //                                        .circular(10)
             //                                ),
             //                                width: w / 3,
             //                                child: Center(
             //                                  child: IconButton(
             //                                      onPressed: () {
             //                                        setState(() {
             //                                          numberOfMonth ++;
             //                                        });
             //                                      },
             //                                      icon: Icon(
             //                                        Icons.add,
             //                                        size: SizeConfig
             //                                            .imageSize * 5,
             //                                        color: Colors.white,
             //                                      )),
             //                                ),
             //                              ),
             //                            ],
             //                          ),
             //                        ],
             //                      ),
             //                    );
             //                  },
             //                )),
             //                SizedBox(width: 8,),
             //                Text('Month', style: GoogleFonts.lato(
             //                    color: Colors.black54,
             //                    fontSize: SizeConfig.titleSize * 2.5,
             //                    fontWeight: FontWeight.bold
             //                ))
             //              ],
             //            )
             //          ],
             //        ),
             //        Column(
             //          crossAxisAlignment: CrossAxisAlignment.start,
             //          children: [
             //            Text(
             //                'Application start date', style: GoogleFonts.lato(
             //                color: Colors.black54,
             //                fontSize: SizeConfig.titleSize * 2.7,
             //                fontWeight: FontWeight.bold
             //            )),
             //            SizedBox(height: 8,),
             //
             //            Container(
             //              alignment: Alignment.center,
             //              height: 40,
             //              width: 140,
             //              padding: EdgeInsets.symmetric(horizontal: 8,
             //                  vertical: 5),
             //              clipBehavior: Clip.antiAlias,
             //              decoration: BoxDecoration(
             //                borderRadius: BorderRadius.circular(5),
             //                color: Colors.grey.shade200,
             //
             //              ),
             //              child: Center(
             //                child: Row(
             //
             //                  children: [
             //                    Expanded(
             //                        child: Text(
             //                          _expiry_date != null
             //                              ? _expiry_date!.year.toString() +
             //                              '  /  ' +
             //                              _expiry_date!.month.toString() +
             //                              '  /  ' +
             //                              _expiry_date!.day.toString()
             //                              : '',
             //                          style: GoogleFonts.lato(
             //                              fontSize: SizeConfig.titleSize *
             //                                  2.5,
             //                              fontWeight: FontWeight.bold,
             //                              color: ColorsConst.mainColor
             //                          ),
             //                        )),
             //                    InkWell(
             //                      onTap: () {
             //                        DatePicker.showDatePicker(context,
             //                          showTitleActions: true,
             //                          minTime: DateTime(1990, 3, 5),
             //                          maxTime: DateTime.now(),
             //                          theme: DatePickerTheme(
             //                            headerColor: Colors.blue[900],
             //                            backgroundColor: Colors.blue,
             //                            itemStyle: TextStyle(
             //                                color: Colors.white,
             //                                fontWeight: FontWeight.bold,
             //                                fontSize: 18),
             //                            doneStyle: TextStyle(
             //                                color: Colors.white,
             //                                fontSize: 16),
             //                            cancelStyle: TextStyle(
             //                                color: Colors.white,
             //                                fontSize: 16),
             //                          ),
             //                          onChanged: (date) {
             //                            _expiry_date = date;
             //                          },
             //                          onConfirm: (date) {
             //                            _expiry_date = date;
             //                            setState(() {});
             //                          },
             //                          currentTime: DateTime.now(),
             //                        );
             //                      },
             //                      child: Container(
             //                        height: 30,
             //                        child: Icon(Icons.date_range,
             //                          color: ColorsConst.mainColor,),
             //                      ),
             //                    )
             //
             //                  ],
             //                ),
             //              ),
             //            ),
             //          ],
             //        )
             //      ],
             //    ),
             //    SizedBox(height: 15,),
             //    Text('The application will be sent ' +
             //        _getNameOfDay(_expiry_date!.day) + ' corresponding to  ' +
             //        _expiry_date!.year.toString() + '  /  ' +
             //        _expiry_date!.month.toString() + '  /  ' +
             //        _expiry_date!.day.toString(),
             //
             //        style: GoogleFonts.lato(
             //            fontSize: SizeConfig.titleSize * 2.6,
             //            fontWeight: FontWeight.bold,
             //            color: ColorsConst.mainColor
             //        )),
                //SizedBox(height: 20,),
                ///  Address
                ///

                Container(
                  margin: EdgeInsets.symmetric(horizontal: 8),
                  padding: EdgeInsets.all(8),
                  height: SizeConfig.screenHeight*0.21,
                  width: double.maxFinite,
                  decoration: BoxDecoration(
                      color: Colors.white ,
                    borderRadius: BorderRadius.circular(10),
                    // border: Border.all(
                    //   color: Colors.black38
                    // ),
                    boxShadow: [BoxShadow(
                      blurRadius: 5,
                      offset: Offset(0,4),
                      color: Colors.black12
                    ),
                      BoxShadow(
                          blurRadius: 1,
                          offset: Offset(0,-1),
                          color: Colors.black12
                      )
                    ]
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                height: SizeConfig.heightMulti * 7,
                                width: SizeConfig.heightMulti * 7,
                                padding: EdgeInsets.all(2),
                                clipBehavior: Clip.antiAlias,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    width: 2
                                  )

                                ),
                                child: Container(
                                        clipBehavior: Clip.antiAlias,

                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,

                                    ),
                                    child: Image.asset('assets/address_shopping.png')),
                              ),
                              SizedBox(width: 10,),
                              Text('Destination',style: TextStyle(
                                  fontWeight: FontWeight.bold,color: Colors.black45,fontSize: SizeConfig.titleSize * 2.5),),

                            ],
                          ),

                          TextButton(onPressed: (){
                            Navigator.pushNamed(
                                context, MapRoutes.MAP_SCREEN,arguments: false)
                                .then((value) {
                              if (value != null) {
                                addressModel = (value as AddressModel);
                                _newAddressController.text =
                                    addressModel.description;
                                addressModel = value;

                                /// Check Address
                                ///

                                LatLng latlang = LatLng(addressModel.latitude,addressModel.longitude);
                                print('========== address from map ========');
                                _getSubAreaForAddress(latlang);
                              }

                            });
                          }, child: Text('Change'))

                        ],
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Icon(Icons.location_on_outlined,color: Colors.blue,),
                          SizedBox(width: 5,),
                          Text('street :',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black45,fontSize: SizeConfig.titleSize * 2.5),),
                         SizedBox(width: 10,),
                          Expanded(
                            child: Container(
                              child: Row(
                                    children: [
                                      Expanded(
                                        child: TextFormField(
                                          readOnly: true,
                                          controller: _newAddressController,
                                          maxLines: 1,
                                          style:  TextStyle(
                                              fontSize:14,

                                              fontWeight: FontWeight.bold,
                                              color: Colors.grey[600]
                                          ),
                                          decoration: InputDecoration(
                                            border: InputBorder.none,
                                            //S.of(context).name,
                                          ),
                                          textInputAction: TextInputAction.next,
                                          // Move focus to next
                                        ),
                                      ),

                                      Container(
                                        height: SizeConfig.heightMulti * 6.5,
                                        width: SizeConfig.heightMulti * 6.5,
                                        padding: EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                        ),
                                        child: BlocBuilder<CheckAddressBloc , CheckAddressStates>(
                                          bloc: _checkAddressBloc,
                                          builder: (context,state) {
                                            if(state is CheckAddressLoadingState)
                                            return CircularProgressIndicator(color: ColorsConst.mainColor,);

                                            else if(state is CheckAddressErrorState){
                                              return Container(
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: Colors.red
                                                  ),
                                                  child: Icon(Icons.error , color: Colors.white,));
                                            }
                                            else if(state is CheckAddressSuccessState){
                                              return Container(
                                                  decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color: Colors.green
                                                  ),
                                                  child: Icon(Icons.check , color: Colors.white,));
                                              return Icon(Icons.check , color: Colors.green,);
                                            }
                                            else{
                                              return SizedBox.shrink();
                                            }
                                          }
                                        ),
                                      ),
                                    ],

                              ),
                            ),

                          ),

                        ],),
                      FutureBuilder<String?>(
                          initialData: null,
                          future: AuthPrefsHelper().getPhone(),
                          builder: (context,state) {
                            phoneNumber = '';
                            if(state.data == null){
                              phoneNumber  = '';
                            }
                            else
                              phoneNumber = state.data!;
                            return Row(
                              children: [
                                Icon(Icons.phone,color: Colors.blue,),
                                SizedBox(width: 5,),
                                Text('phone number :',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black45,fontSize: SizeConfig.titleSize * 2.5),),
                                SizedBox(width: 10,),

                                Text(phoneNumber,style: TextStyle(
                                    fontSize: 14,
                                    letterSpacing: 2,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey[600]
                                ),),

                              ],
                            );


                          }
                      ),


                    ],),
                ),
                SizedBox(height: 10,),

                ///  Address Worn
                BlocBuilder<CheckAddressBloc , CheckAddressStates>(
                    bloc: _checkAddressBloc,
                    builder: (context, state) {
                      if (state is CheckAddressErrorState) {
                          return Container(
                              width: double.maxFinite,
                              margin: EdgeInsets.symmetric(
                                  horizontal: SizeConfig.widhtMulti * 5),
                              padding: EdgeInsets.symmetric(vertical: 5),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: Colors.red.shade50,

                              ),
                              child:
                              Center(child: Text(
                                  'Please choose an destination that belongs to the export area',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts
                                  .lato(fontSize: SizeConfig.titleSize * 2.3,


                                  fontWeight: FontWeight.w800,
                                  color: Colors.red))));
                      }
                      else {
                        return Container();
                      }
                    }
                ),
                SizedBox(height: 10,),

                /// Payment Summary
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 8),
                  padding: EdgeInsets.all(8),
                  height: SizeConfig.screenHeight*0.23,
                  width: double.maxFinite,
                  decoration: BoxDecoration(
                      color: Colors.white ,
                     //  border: Border.all(
                     //   color: Colors.black38,
                     // ),
                      boxShadow: [BoxShadow(
    blurRadius: 5,
    offset: Offset(0,4),
    color: Colors.black12
    ),
    BoxShadow(
    blurRadius: 1,
    offset: Offset(0,-1),
    color: Colors.black12
    )
    ],
                      borderRadius: BorderRadius.circular(10)
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            height: SizeConfig.heightMulti * 7,
                            width: SizeConfig.heightMulti * 7,
                            clipBehavior: Clip.antiAlias,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle
                            ),
                            child: Container(
                                child: Image.asset('assets/summary_shopping.png')),
                          ),
                          SizedBox(width: 10,),
                          Text('Payment Summary',
                              style: GoogleFonts.lato(
                                  fontSize: SizeConfig.titleSize * 2.5,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.black54)
                          ),
                        ],
                      ),

                      SizedBox(height: 12,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Total ', style: GoogleFonts.lato(
                              fontSize: SizeConfig.titleSize * 2.2,
                              fontWeight: FontWeight.w800,
                              color: Colors.black54),),
                          BlocBuilder<ShopCartBloc, CartState>(
                              bloc: shopCartBloc,
                              builder: (context, state) {
                                if (state is CartLoaded) {
                                  return Text(state.cart.totalString,
                                      style: GoogleFonts.lato(
                                          fontSize: SizeConfig.titleSize * 2.5,
                                          fontWeight: FontWeight.w800,
                                          color: Colors.black54));
                                }
                                else {
                                  return Text('', style: TextStyle(
                                      color: Colors.black54,
                                      fontSize: SizeConfig.titleSize * 2.9));
                                }
                              }
                          ),

                        ],),

                      SizedBox(height: 8,),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Delivery Charge ', style: GoogleFonts.lato(
                              fontSize: SizeConfig.titleSize * 2.2,
                              fontWeight: FontWeight.w800,
                              color: Colors.black54),),
                          BlocBuilder<ShopCartBloc, CartState>(
                              bloc: shopCartBloc,
                              builder: (context, state) {
                                if (state is CartLoaded) {
                                  return Text(state.cart.deliveryFreeString,
                                      style: GoogleFonts.lato(
                                          fontSize: SizeConfig.titleSize * 2.5,
                                          fontWeight: FontWeight.w800,
                                          color: Colors.black54));
                                }
                                else {
                                  return Text('', style: TextStyle(
                                      color: Colors.black54,
                                      fontSize: SizeConfig.titleSize * 2.9));
                                }
                              }
                          ),

                        ],),


                      SizedBox(height: 8,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(' Order Value ', style: GoogleFonts.lato(
                              fontSize: SizeConfig.titleSize * 2.2,
                              fontWeight: FontWeight.w800,
                              color: Colors.black54),),
                          BlocBuilder<ShopCartBloc, CartState>(
                              bloc: shopCartBloc,
                              builder: (context, state) {
                                if (state is CartLoaded) {
                                  double total = state.cart.deliveryFee(state.cart.subTotal)+ state.cart.subTotal;
                                  orderValue = total;
                                  return Text(total.toString() ,
                                      style: GoogleFonts.lato(
                                          fontSize: SizeConfig.titleSize * 2.5,
                                          fontWeight: FontWeight.w800,
                                          color: Colors.black54));
                                }
                                else {
                                  return Text('', style: TextStyle(
                                      color: Colors.black54,
                                      fontSize: SizeConfig.titleSize * 2.9));
                                }
                              }
                          ),

                        ],),
                    ],
                  ),
                ),


                SizedBox(height: 10,),

                /// Payment Summary Worn
                ///
                BlocBuilder<ShopCartBloc, CartState>(
                    bloc: shopCartBloc,
                    builder: (context, state) {
                      if (state is CartLoaded) {
                        if (!state.cart.minimum(220)) {
                          orderNotComplete = true;
                          return Container(

                              width: double.maxFinite,
                              margin: EdgeInsets.symmetric(
                                  horizontal: SizeConfig.widhtMulti * 5),
                              padding: EdgeInsets.symmetric(vertical: 5),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: Colors.red.shade50,

                              ),
                              child:
                              Center(child: Text(
                                  'Minimum order is 220 AED ', style: GoogleFonts
                                  .lato(fontSize: SizeConfig.titleSize * 2.3,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.red))));
                        }
                        else
                          return Container();
                      }
                      else {
                        return Container();
                      }
                    }
                ),

                SizedBox(height: 8,),

                /// Payment Method
                ///
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 8),
                  padding: EdgeInsets.all(8),
                  height: SizeConfig.screenHeight*0.3,
                  width: double.maxFinite,
                  decoration: BoxDecoration(
                      color: Colors.white ,
                      // border: Border.all(
                      //     color: Colors.black38
                      // ),
                      boxShadow: [BoxShadow(
    blurRadius: 5,
    offset: Offset(0,4),
    color: Colors.black12
    ),
    BoxShadow(
    blurRadius: 1,
    offset: Offset(0,-1),
    color: Colors.black12
    )
    ],
                      borderRadius: BorderRadius.circular(10)
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            height: SizeConfig.heightMulti * 7,
                            width: SizeConfig.heightMulti * 7,
                            padding: EdgeInsets.all(2),
                            clipBehavior: Clip.antiAlias,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                              border: Border.all(
                                width: 2
                              )
                            ),
                            child: Container(
                                clipBehavior: Clip.antiAlias,

                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,

                                ),
                              child: Image.asset('assets/payment_icon.png',fit: BoxFit.cover,)),
                          ),
                          SizedBox(width: 10,),
                          Text('Payment Methods',

                              style: GoogleFonts.lato(
                                  fontSize: SizeConfig.titleSize * 2.5,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.black54)
                          ),
                        ],
                      ),

                      SizedBox(height: 15,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap:(){
                         setState(() {
                              paymentGroupValue = PaymentMethodConst.CASH_MONEY;
                          });
                              },
                            child: Material(
                              clipBehavior: Clip.antiAlias,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              elevation: 3,
                              child: Container(
                                width: SizeConfig.screenWidth * 0.25,
                                height: SizeConfig.heightMulti * 17,
                                clipBehavior: Clip.antiAlias,
                                decoration: BoxDecoration(
                                    color:paymentGroupValue == PaymentMethodConst.CASH_MONEY? Colors.blue: Colors.white,
                                   border: Border.all(
                                     color: Colors.black12
                                   )
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,

                                  children: [
                                    Container(
                                      height:  SizeConfig.heightMulti * 12,
                                      width: SizeConfig.screenWidth * 0.25,
                                      clipBehavior: Clip.antiAlias,

                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10),

                                      ),
                                      child: Image.asset('assets/payment_cash_icon.png',fit: BoxFit.fill,),
                                    ),
                                    Container(
                                      child:    Text('Cash Money', style: GoogleFonts.lato(
                                                  color: Colors.black54,
                                                  fontSize: SizeConfig.titleSize * 2.5,
                                                  fontWeight: FontWeight.bold
                                              ),)
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: SizeConfig.screenWidth * 0.1,),
                          GestureDetector(
                            onTap:(){
                              setState(() {
                                paymentGroupValue = PaymentMethodConst.CREDIT_CARD;
                              });
                            },
                            child: Material(
                              clipBehavior: Clip.antiAlias,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              elevation: 3,
                              child: Container(
                                width: SizeConfig.screenWidth * 0.25,
                                height: SizeConfig.heightMulti * 17,
                                clipBehavior: Clip.antiAlias,
                                decoration: BoxDecoration(
                                    color: paymentGroupValue == PaymentMethodConst.CREDIT_CARD? Colors.blue: Colors.white,
                                    border: Border.all(
                                        color: Colors.black12
                                    )
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      height:  SizeConfig.heightMulti * 12,
                                      width: SizeConfig.screenWidth * 0.25,
                                      clipBehavior: Clip.antiAlias,

                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),

                                      ),
                                      child: Image.asset('assets/payment_credit_icon.png',fit: BoxFit.fill,),
                                    ),
                                    Container(
                                        child:    Text('Credit card', style: GoogleFonts.lato(
                                            color: Colors.black54,
                                            fontSize: SizeConfig.titleSize * 2.5,
                                            fontWeight: FontWeight.bold
                                        ),)
                                    )
                                  ],
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                      // Center(
                      //   child: Container(
                      //     width: SizeConfig.screenWidth * 0.8,
                      //     height: 6.8 * SizeConfig.heightMulti,
                      //     decoration: BoxDecoration(
                      //         borderRadius: BorderRadius.circular(10),
                      //         color: Colors.grey.shade50,
                      //         border: Border.all(
                      //             color: Colors.black26,
                      //             width: 2
                      //         )
                      //     ),
                      //     child: Row(
                      //       mainAxisSize: MainAxisSize.min,
                      //
                      //       children: [
                      //         Radio<String>(
                      //           value: PaymentMethodConst.CREDIT_CARD,
                      //           groupValue: paymentGroupValue,
                      //           onChanged: (value) {
                      //             setState(() {
                      //               paymentGroupValue = value!;
                      //             });
                      //           },
                      //           activeColor: Colors.green,
                      //         ),
                      //         Icon(Icons.payment),
                      //         SizedBox(width: 10,),
                      //
                      //         Text('Credit card', style: GoogleFonts.lato(
                      //             color: Colors.black54,
                      //             fontSize: SizeConfig.titleSize * 2.6,
                      //             fontWeight: FontWeight.bold
                      //         ),)
                      //       ],
                      //     ),
                      //   ),
                      // ),
                      // SizedBox(height: SizeConfig.heightMulti * 2,),
                      // Center(
                      //   child: Container(
                      //     width: SizeConfig.screenWidth * 0.8,
                      //     height: 6.8 * SizeConfig.heightMulti,
                      //     decoration: BoxDecoration(
                      //         borderRadius: BorderRadius.circular(10),
                      //         color: Colors.grey.shade50,
                      //         border: Border.all(
                      //             color: Colors.black26,
                      //             width: 2
                      //         )
                      //     ),
                      //     child: Row(
                      //       mainAxisSize: MainAxisSize.min,
                      //
                      //       children: [
                      //         Radio<String>(
                      //           value: PaymentMethodConst.CASH_MONEY,
                      //           groupValue:paymentGroupValue,
                      //           onChanged: (value) {
                      //             setState(() {
                      //               paymentGroupValue = value!;
                      //             });
                      //           },
                      //           activeColor: Colors.green,
                      //         ),
                      //         Icon(Icons.payment),
                      //         SizedBox(width: 10,),
                      //
                      //         Text('Cash Money', style: GoogleFonts.lato(
                      //             color: Colors.black54,
                      //             fontSize: SizeConfig.titleSize * 2.6,
                      //             fontWeight: FontWeight.bold
                      //         ),)
                      //       ],
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                ),

                SizedBox(height: 50,),
              ],
            ),)


        ),

        Container(
          height: 6.78 * SizeConfig.heightMulti,
          margin: EdgeInsets.symmetric(
              horizontal: SizeConfig.widhtMulti * 3, vertical: 5),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                      color: Colors.white
                      ,
                      border: Border.all(
                          color: ColorsConst.mainColor,
                          width: 2
                      ),
                      borderRadius: BorderRadius.circular(10)
                  ),
                  child: MaterialButton(
                    onPressed: () {
                      currentIndex --;
                      _pageController.animateToPage(
                        currentIndex,
                        duration: const Duration(milliseconds: 100),
                        curve: Curves.easeInOut,
                      );
                    },
                    child: Text('Previous', style: TextStyle(
                        color: ColorsConst.mainColor,
                        fontSize: SizeConfig.titleSize * 2.7),),

                  ),
                ),
              ),
              SizedBox(width: SizeConfig.widhtMulti * 3,),
              Expanded(child: Container(
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                    color: ColorsConst.mainColor,
                    borderRadius: BorderRadius.circular(10)
                ),
                child:paymentGroupValue != PaymentMethodConst.CASH_MONEY? MaterialButton(
                    onPressed: () {
                      if(paymentGroupValue ==''){
                        _scaffoldState.currentState!.showSnackBar(SnackBar(content: Text('Select Payment Method')));
                      }
                      else if(!(_checkAddressBloc.state is CheckAddressSuccessState)){
                        _scaffoldState.currentState!.showSnackBar(SnackBar(content: Text('Choose a correct destination')));
                      }
                      else if(orderNotComplete){
                        _scaffoldState.currentState!.showSnackBar(SnackBar(content: Text('Complete The Order')));
                      }
                      else if(paymentGroupValue == PaymentMethodConst.CASH_MONEY){
                        GeoJson geoJson = GeoJson(lat: addressModel.latitude, lon: addressModel.longitude);
                        _orderBloc.addNewOrder(product: requestProduct, deliveryTimes: deliveryTimesGroupValue, date:_expiry_date! , destination: geoJson,addressName: addressModel.description, phoneNumber: phoneNumber, paymentMethod: paymentGroupValue,numberOfMonth: numberOfMonth, orderValue: orderValue, cardId: cardId);
                      }
                      else
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
                                        Center(
                                          child: GestureDetector(
                                            onTap: (){
                                              Navigator.push(context, MaterialPageRoute(builder: (context)=>
                                                  BlocProvider.value(
                                                      value: paymentMethodeNumberBloc,
                                                      child: AddCardScreen())
                                              ));
                                              //  paymentMethodeNumberBloc.addOne();
                                            },
                                            child: Container(
                                              margin: EdgeInsets.symmetric(horizontal: 20),

                                              width: SizeConfig.screenWidth ,
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

                                                  Icon(Icons.add),
                                                  SizedBox(width: 10,),

                                                  Text('Add a card', style: GoogleFonts.lato(
                                                      color: Colors.black54,
                                                      fontSize: SizeConfig.titleSize * 2.6,
                                                      fontWeight: FontWeight.bold
                                                  )
                                                    ,)
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        Spacer(),
                                        Center(
                                          child: BlocConsumer<NewOrderBloc,CreateOrderStates>(
                                              bloc: _orderBloc,
                                              listener: (context,state)async{
                                                if(state is CreateOrderSuccessState)
                                                {
                                                  shopCartBloc.startedShop();

                                                  snackBarSuccessWidget(context, 'Order Created Successfully!!');
                                                  Navigator.push(context, MaterialPageRoute(builder: (context)=>  CompleteOrderScreen(orderId: state.data.id)));
                                                  //  Navigator.pushNamedAndRemoveUntil(context, NavigatorRoutes.NAVIGATOR_SCREEN, (route)=>false);
                                                }
                                                else if(state is CreateOrderErrorState)
                                                {
                                                  snackBarSuccessWidget(context, 'The Order Was Not Created!!');
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
                                                      cardId =  paymentMethodeNumberBloc.state.paymentMethodeCreditGroupValue;
                                                      if(cardId ==''){
                                                        Fluttertoast.showToast(
                                                            msg: "Select a card to pay",
                                                            toastLength: Toast.LENGTH_LONG,
                                                            gravity: ToastGravity.TOP,
                                                            timeInSecForIosWeb: 1,
                                                            backgroundColor: Colors.white,
                                                            textColor: Colors.black,
                                                            fontSize: 18.0
                                                        );
                                                      }
                                                      else{
                                                        print('============= request =================');
                                                        print('products : ');
                                                        print(requestProduct);
                                                        print('delivery time : ${deliveryTimesGroupValue}');
                                                        print('month : ${numberOfMonth}');
                                                        print('start date  : ${_expiry_date}');
                                                        print('address date  : ${addressModel.description}');
                                                        print('address date  : ${addressModel.latitude}');
                                                        print('address date  : ${addressModel.longitude}');
                                                        print('phone  : ${phoneNumber}');
                                                        print('payment method : ${paymentGroupValue}');
                                                        print('order value  : ${orderValue}');
                                                        print('card id  : ${paymentMethodeNumberBloc.state.paymentMethodeCreditGroupValue}');
                                                        print('============= request =================');

                                                        GeoJson geoJson = GeoJson(lat: addressModel.latitude, lon: addressModel.longitude);
                                                        _expiry_date = DateTime.now();
                                                        _orderBloc.addNewOrder(product: requestProduct, deliveryTimes: deliveryTimesGroupValue, date:_expiry_date! , destination: geoJson,addressName: addressModel.description, phoneNumber: phoneNumber, paymentMethod: paymentGroupValue,numberOfMonth: numberOfMonth, orderValue: orderValue, cardId: cardId);

                                                      }

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
                      //  }
                    },
                    child: Text('Next', style: TextStyle(color: Colors.white,
                        fontSize: SizeConfig.titleSize * 2.7),)

                ):BlocConsumer<NewOrderBloc,CreateOrderStates>(
                    bloc: _orderBloc,
                    listener: (context,state)async{
                      if(state is CreateOrderSuccessState)
                      {
                        shopCartBloc.startedShop();

                        snackBarSuccessWidget(context, 'Order Created Successfully!!');
                        Navigator.push(context, MaterialPageRoute(builder: (context)=> CompleteOrderScreen(orderId: state.data.id)));
                        //  Navigator.pushNamedAndRemoveUntil(context, NavigatorRoutes.NAVIGATOR_SCREEN, (route)=>false);
                      }
                      else if(state is CreateOrderErrorState)
                      {
                        snackBarSuccessWidget(context, 'The Order Was Not Created!!');
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
                            if(orderNotComplete){
                              _scaffoldState.currentState!.showSnackBar(SnackBar(content: Text('Complete The Order')));

                            }
                            else if(!(_checkAddressBloc.state is CheckAddressSuccessState)){
                              _scaffoldState.currentState!.showSnackBar(SnackBar(content: Text('Choose a correct address')));

                            }
                            else{
                              print('============= request =================');
                              print('products : ');
                              print(requestProduct);
                              print('delivery time : ${deliveryTimesGroupValue}');
                              print('month : ${numberOfMonth}');
                              print('start date  : ${_expiry_date}');
                              print('address date  : ${addressModel.description}');
                              print('phone  : ${phoneNumber}');
                              print('payment method : ${paymentGroupValue}');
                              print('order value  : ${orderValue}');
                              print('card id  : ${paymentMethodeNumberBloc.state.paymentMethodeCreditGroupValue}');
                              print('============= request =================');

                              GeoJson geoJson = GeoJson(lat: addressModel.latitude, lon: addressModel.longitude);
                              _expiry_date = DateTime.now();
                              _orderBloc.addNewOrder(product: requestProduct, deliveryTimes: deliveryTimesGroupValue, date:_expiry_date! , destination: geoJson,addressName: addressModel.description, phoneNumber: phoneNumber, paymentMethod: paymentGroupValue,numberOfMonth: numberOfMonth, orderValue: orderValue, cardId: cardId);

                            }

                          },
                          child: Text('Confirmation', style: TextStyle(color: Colors.white,
                              fontSize: SizeConfig.titleSize * 2.5

                          ),),

                        ),
                      );
                    }
                ),
              ))
              ,
            ],
          ),
        ),


      ],
    );
  }

  Widget thirdPage() {
    return Column(
      children: [
        SizedBox(
          height: 5,
        ),

        Expanded(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10,),
                Text('Payment Summary',
                    style: GoogleFonts.lato(
                        fontSize: SizeConfig.titleSize * 2.5,
                        fontWeight: FontWeight.w800,
                        color: Colors.black54)
                ),
                SizedBox(height: 12,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Total ', style: GoogleFonts.lato(
                        fontSize: SizeConfig.titleSize * 2.3,
                        fontWeight: FontWeight.w800,
                        color: Colors.black54),),
                    BlocBuilder<ShopCartBloc, CartState>(
                        bloc: shopCartBloc,
                        builder: (context, state) {
                          if (state is CartLoaded) {
                            return Text(state.cart.totalString,
                                style: GoogleFonts.lato(
                                    fontSize: SizeConfig.titleSize * 2.5,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.black54));
                          }
                          else {
                            return Text('', style: TextStyle(
                                color: Colors.black54,
                                fontSize: SizeConfig.titleSize * 2.9));
                          }
                        }
                    ),

                  ],),
                SizedBox(height: 8,),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Delivery Charge ', style: GoogleFonts.lato(
                        fontSize: SizeConfig.titleSize * 2.3,
                        fontWeight: FontWeight.w800,
                        color: Colors.black54),),
                    BlocBuilder<ShopCartBloc, CartState>(
                        bloc: shopCartBloc,
                        builder: (context, state) {
                          if (state is CartLoaded) {
                            return Text(state.cart.deliveryFreeString,
                                style: GoogleFonts.lato(
                                    fontSize: SizeConfig.titleSize * 2.5,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.black54));
                          }
                          else {
                            return Text('', style: TextStyle(
                                color: Colors.black54,
                                fontSize: SizeConfig.titleSize * 2.9));
                          }
                        }
                    ),

                  ],),
                SizedBox(height: 8,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(' Order Value ', style: GoogleFonts.lato(
                        fontSize: SizeConfig.titleSize * 2.3,
                        fontWeight: FontWeight.w800,
                        color: Colors.black54),),
                    BlocBuilder<ShopCartBloc, CartState>(
                        bloc: shopCartBloc,
                        builder: (context, state) {
                          if (state is CartLoaded) {
                            double total = state.cart.deliveryFee(state.cart.subTotal)+ state.cart.subTotal;
                            orderValue = total;
                            return Text(total.toString() ,
                                style: GoogleFonts.lato(
                                    fontSize: SizeConfig.titleSize * 2.5,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.black54));
                          }
                          else {
                            return Text('', style: TextStyle(
                                color: Colors.black54,
                                fontSize: SizeConfig.titleSize * 2.9));
                          }
                        }
                    ),

                  ],),

                SizedBox(height: 20,),
                Divider(height: 1, color: Colors.black54,),
                SizedBox(height: 10,),
                Center(
                  child: Container(
                    width: SizeConfig.screenWidth * 0.8,
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
                          value: PaymentMethodConst.CREDIT_CARD,
                          groupValue: paymentGroupValue,
                          onChanged: (value) {
                            setState(() {
                              paymentGroupValue = value!;
                            });
                          },
                          activeColor: Colors.green,
                        ),
                        Icon(Icons.payment),
                        SizedBox(width: 10,),

                        Text('Credit card', style: GoogleFonts.lato(
                            color: Colors.black54,
                            fontSize: SizeConfig.titleSize * 2.6,
                            fontWeight: FontWeight.bold
                        ),)
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 8,),
                Center(
                  child: Container(
                    width: SizeConfig.screenWidth * 0.8,
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
                          value: PaymentMethodConst.CASH_MONEY,
                          groupValue:paymentGroupValue,
                          onChanged: (value) {
                            setState(() {
                              paymentGroupValue = value!;
                            });
                          },
                          activeColor: Colors.green,
                        ),
                        Icon(Icons.payment),
                        SizedBox(width: 10,),

                        Text('Cash Money', style: GoogleFonts.lato(
                            color: Colors.black54,
                            fontSize: SizeConfig.titleSize * 2.6,
                            fontWeight: FontWeight.bold
                        ),)
                      ],
                    ),
                  ),
                ),


              ],
            ),
          ),
        ),

        Container(
          height: 6.78 * SizeConfig.heightMulti,
          margin: EdgeInsets.symmetric(
              horizontal: SizeConfig.widhtMulti * 3, vertical: 5),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                      color: Colors.white
                      ,
                      border: Border.all(
                          color: ColorsConst.mainColor,
                          width: 2
                      ),
                      borderRadius: BorderRadius.circular(10)
                  ),
                  child: MaterialButton(
                    onPressed: () {
                      currentIndex --;
                      _pageController.animateToPage(
                        currentIndex,
                        duration: const Duration(milliseconds: 100),
                        curve: Curves.easeInOut,
                      );
                    },
                    child: Text('Previous', style: TextStyle(
                        color: ColorsConst.mainColor,
                        fontSize: SizeConfig.titleSize * 2.7),),

                  ),
                ),
              ),
              SizedBox(width: SizeConfig.widhtMulti * 3,),
              Expanded(child: Container(
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                    color: ColorsConst.mainColor,
                    borderRadius: BorderRadius.circular(10)
                ),
                child:paymentGroupValue != PaymentMethodConst.CASH_MONEY? MaterialButton(
                  onPressed: () {
                    // if(paymentGroupValue == PaymentMethodConst.CASH_MONEY){
                    //   GeoJson geoJson = GeoJson(lat: addressModel.latitude, lon: addressModel.longitude);
                    //   _orderBloc.addNewOrder(product: requestProduct, deliveryTimes: deliveryTimesGroupValue, date:_expiry_date! , destination: geoJson,addressName: addressModel.description, phoneNumber: phoneNumber, paymentMethod: paymentGroupValue,numberOfMonth: numberOfMonth, orderValue: orderValue, cardId: cardId);
                    // }else{

                    if(paymentGroupValue ==''){
                      _scaffoldState.currentState!.showSnackBar(SnackBar(content: Text('Select Payment Method')));
                    }
                    else if(orderNotComplete){
                      _scaffoldState.currentState!.showSnackBar(SnackBar(content: Text('Complete The Order')));
                    }
                    else if( !( _checkAddressBloc.state is CheckAddressSuccessState) ){
                      _scaffoldState.currentState!.showSnackBar(SnackBar(content: Text('Choose a correct destination')));

                    }
                    else if(paymentGroupValue == PaymentMethodConst.CASH_MONEY){
                      GeoJson geoJson = GeoJson(lat: addressModel.latitude, lon: addressModel.longitude);
                      _orderBloc.addNewOrder(product: requestProduct, deliveryTimes: deliveryTimesGroupValue, date:_expiry_date! , destination: geoJson,addressName: addressModel.description, phoneNumber: phoneNumber, paymentMethod: paymentGroupValue,numberOfMonth: numberOfMonth, orderValue: orderValue, cardId: cardId);
                    }
                    else
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
                                      Center(
                                        child: GestureDetector(
                                          onTap: (){
                                            Navigator.push(context, MaterialPageRoute(builder: (context)=>
                                                BlocProvider.value(
                                                    value: paymentMethodeNumberBloc,
                                                    child: AddCardScreen())
                                            ));
                                            //  paymentMethodeNumberBloc.addOne();
                                          },
                                          child: Container(
                                            margin: EdgeInsets.symmetric(horizontal: 20),

                                            width: SizeConfig.screenWidth ,
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

                                                Icon(Icons.add),
                                                SizedBox(width: 10,),

                                                Text('Add a card', style: GoogleFonts.lato(
                                                    color: Colors.black54,
                                                    fontSize: SizeConfig.titleSize * 2.6,
                                                    fontWeight: FontWeight.bold
                                                )
                                                  ,)
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      Spacer(),
                                      Center(
                                        child: BlocConsumer<NewOrderBloc,CreateOrderStates>(
                                            bloc: _orderBloc,
                                            listener: (context,state)async{
                                              if(state is CreateOrderSuccessState)
                                              {
                                                shopCartBloc.startedShop();

                                                snackBarSuccessWidget(context, 'Order Created Successfully!!');
                                                Navigator.push(context, MaterialPageRoute(builder: (context)=>  CompleteOrderScreen(orderId: state.data.id)));
                                              //  Navigator.pushNamedAndRemoveUntil(context, NavigatorRoutes.NAVIGATOR_SCREEN, (route)=>false);
                                              }
                                              else if(state is CreateOrderErrorState)
                                              {
                                                snackBarSuccessWidget(context, 'The Order Was Not Created!!');
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
                                                    cardId =  paymentMethodeNumberBloc.state.paymentMethodeCreditGroupValue;
                                                    if(cardId ==''){
                                                      Fluttertoast.showToast(
                                                          msg: "Select a card to pay",
                                                          toastLength: Toast.LENGTH_LONG,
                                                          gravity: ToastGravity.TOP,
                                                          timeInSecForIosWeb: 1,
                                                          backgroundColor: Colors.white,
                                                          textColor: Colors.black,
                                                          fontSize: 18.0
                                                      );
                                                    }
                                                   else{
                                                      print('============= request =================');
                                                      print('products : ');
                                                      print(requestProduct);
                                                      print('delivery time : ${deliveryTimesGroupValue}');
                                                      print('month : ${numberOfMonth}');
                                                      print('start date  : ${_expiry_date}');
                                                      print('address date  : ${addressModel.description}');
                                                      print('phone  : ${phoneNumber}');
                                                      print('payment method : ${paymentGroupValue}');
                                                      print('order value  : ${orderValue}');
                                                      print('card id  : ${paymentMethodeNumberBloc.state.paymentMethodeCreditGroupValue}');
                                                      print('============= request =================');

                                                      GeoJson geoJson = GeoJson(lat: addressModel.latitude, lon: addressModel.longitude);
                                                      _orderBloc.addNewOrder(product: requestProduct, deliveryTimes: deliveryTimesGroupValue, date:_expiry_date! , destination: geoJson,addressName: addressModel.description, phoneNumber: phoneNumber, paymentMethod: paymentGroupValue,numberOfMonth: numberOfMonth, orderValue: orderValue, cardId: cardId);

                                                    }

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
                  //  }
                  },
                  child: Text('Next', style: TextStyle(color: Colors.white,
                      fontSize: SizeConfig.titleSize * 2.7),)

                ):BlocConsumer<NewOrderBloc,CreateOrderStates>(
                    bloc: _orderBloc,
                    listener: (context,state)async{
                      if(state is CreateOrderSuccessState)
                      {
                        shopCartBloc.startedShop();

                        snackBarSuccessWidget(context, 'Order Created Successfully!!');
                        Navigator.push(context, MaterialPageRoute(builder: (context)=> CompleteOrderScreen(orderId: state.data.id)));
                        //  Navigator.pushNamedAndRemoveUntil(context, NavigatorRoutes.NAVIGATOR_SCREEN, (route)=>false);
                      }
                      else if(state is CreateOrderErrorState)
                      {
                        snackBarSuccessWidget(context, 'The Order Was Not Created!!');
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
                            if(orderNotComplete){
                              _scaffoldState.currentState!.showSnackBar(SnackBar(content: Text('Complete The Order')));

                            }
                            else{
                              print('============= request =================');
                              print('products : ');
                              print(requestProduct);
                              print('delivery time : ${deliveryTimesGroupValue}');
                              print('month : ${numberOfMonth}');
                              print('start date  : ${_expiry_date}');
                              print('address date  : ${addressModel.description}');
                              print('phone  : ${phoneNumber}');
                              print('payment method : ${paymentGroupValue}');
                              print('order value  : ${orderValue}');
                              print('card id  : ${paymentMethodeNumberBloc.state.paymentMethodeCreditGroupValue}');
                              print('============= request =================');

                              GeoJson geoJson = GeoJson(lat: addressModel.latitude, lon: addressModel.longitude);
                              _orderBloc.addNewOrder(product: requestProduct, deliveryTimes: deliveryTimesGroupValue, date:_expiry_date! , destination: geoJson,addressName: addressModel.description, phoneNumber: phoneNumber, paymentMethod: paymentGroupValue,numberOfMonth: numberOfMonth, orderValue: orderValue, cardId: cardId);

                            }

                          },
                          child: Text('Confirmation', style: TextStyle(color: Colors.white,
                              fontSize: SizeConfig.titleSize * 2.7),),

                        ),
                      );
                    }
                ),
              ))
              ,
            ],
          ),
        ),


      ],
    );
  }


  String _getNameOfDay(int d) {
    int day = 0;
    if (d < 8) {
      day = d;
    } else {
      day = (d / 7).floor();
    }
    String name = '';
    switch (day) {
      case 1:
        {
          name = 'Sunday';
        }
        break;
      case 2:
        {
          name = 'Monday';
        }
        break;
      case 3:
        {
          name = 'Tuesday';
        }
        break;
      case 4:
        {
          name = 'Wednesday';
        }
        break;
      case 5:
        {
          name = 'Thursday';
        }
        break;
      case 6:
        {
          name = 'Friday';
        }
        break;
      case 7:
        {
          name = 'Saturday';
        }
    }
    return name;
  }
}



class AddCardScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return AddCardScreenState();
  }
}

class AddCardScreenState extends State<AddCardScreen> {
  String cardNumber = '';
  String expiryDate = '';
  String cardHolderName = '';
  String cvvCode = '';
  bool isCvvFocused = false;
  bool useGlassMorphism = false;
  bool useBackgroundImage = false;
  OutlineInputBorder? border;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final AuthService authService = AuthService();

  @override
  void initState() {

    border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(
        
        color: Colors.grey.withOpacity(0.7),
        width: 2.0,
      ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Credit Card View Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          decoration: BoxDecoration(

            // image: !useBackgroundImage
            //     ? const DecorationImage(
            //   image: ExactAssetImage('assets/bg.png'),
            //   fit: BoxFit.fill,
            // )
            //     : null,
            color: Colors.white,
          ),
          child: SafeArea(
            child: Column(
              children: <Widget>[
                const SizedBox(
                  height: 30,
                ),
                CreditCardWidget(
                  glassmorphismConfig:
                  useGlassMorphism ? Glassmorphism.defaultConfig() : null,
                  cardNumber: cardNumber,
                  expiryDate: expiryDate,
                  cardHolderName: cardHolderName,
                  cvvCode: cvvCode,
                  showBackView: isCvvFocused,
                  obscureCardNumber: true,
                  obscureCardCvv: true,
                  isHolderNameVisible: true,
                  cardBgColor: Colors.red,
                  // backgroundImage:
                  // useBackgroundImage ? 'assets/card_bg.png' : null,
                  isSwipeGestureEnabled: true,
                  onCreditCardWidgetChange: (CreditCardBrand creditCardBrand) {},
                  customCardTypeIcons: <CustomCardTypeIcon>[
                    CustomCardTypeIcon(
                      cardType: CardType.mastercard,
                      cardImage: Image.asset(
                        'assets/mastercard.png',
                        height: 48,
                        width: 48,
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        CreditCardForm(
                          formKey: formKey,
                          obscureCvv: true,
                          obscureNumber: true,
                          cardNumber: cardNumber,
                          cvvCode: cvvCode,
                          isHolderNameVisible: true,
                          isCardNumberVisible: true,
                          isExpiryDateVisible: true,
                          cardHolderName: cardHolderName,
                          expiryDate: expiryDate,
                          themeColor: Colors.blue,
                          textColor: Colors.black45,
                          cardNumberDecoration: InputDecoration(
                            border:OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)
                            ) ,
                            labelText: 'Number',
                            hintText: 'XXXX XXXX XXXX XXXX',
                            hintStyle: const TextStyle(color: Colors.black45),
                            labelStyle: const TextStyle(color: Colors.black45),
                            focusedBorder: border,
                            enabledBorder: border,
                          ),
                          expiryDateDecoration: InputDecoration(
                            hintStyle: const TextStyle(color: Colors.black45),
                            labelStyle: const TextStyle(color: Colors.black45),
                            focusedBorder: border,
                            enabledBorder: border,
                            labelText: 'Expired Date',
                            hintText: 'XX/XX',
                          ),
                          cvvCodeDecoration: InputDecoration(
                            
                            hintStyle: const TextStyle(color: Colors.black45),
                            labelStyle: const TextStyle(color: Colors.black45),
                            focusedBorder: border,
                            enabledBorder: border,
                            labelText: 'CVV',
                            hintText: 'XXX',
                          ),
                          cardHolderDecoration: InputDecoration(
                            hintStyle: const TextStyle(color: Colors.black45),
                            labelStyle: const TextStyle(color: Colors.black45),
                            focusedBorder: border,
                            enabledBorder: border,
                            labelText: 'Card Holder',
                          ),
                          onCreditCardModelChange: onCreditCardModelChange,
                        ),

                        const SizedBox(
                          height: 20,
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            primary: const Color(0xff1b447b),
                          ),
                          child: Container(
                            margin: const EdgeInsets.all(12),
                            child: const Text(
                              'Validate',
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'halter',
                                fontSize: 14,
                                package: 'flutter_credit_card',
                              ),
                            ),
                          ),
                          onPressed: () async{
                            int? cvc = int.tryParse(cvvCode);
                            int? carNo = int.tryParse(cardNumber.replaceAll(RegExp(r"\s+\b|\b\s"), ""));
                            int? exp_year = int.tryParse(expiryDate.substring(3,5));
                            int? exp_month = int.tryParse(expiryDate.substring(0,2));
                            print("cvc num: ${cvc.toString()}");
                            print("card num: ${carNo.toString()}");
                            print("exp year: ${exp_year.toString()}");
                            print("exp month: ${exp_month.toString()}");
                            print(cardNumber.replaceAll(RegExp(r"\s+\b|\b\s"), ""));

                            StripeServices stripeServices = StripeServices();

                            AppUser user =await authService.getCurrentUser();
                            // CardModel card ;
                            // if(user.stripeId == null){
                            //   String stripeID = await stripeServices.createStripeCustomer(uid: user.id,email: user.email);
                            //   print('start print strip id ================================');
                            //   print("stripe id: $stripeID");
                            //   print('end print strip id ================================');
                            //   card = await stripeServices.addCard(stripeId: stripeID, month: exp_month!, year: exp_year!, cvc: cvc!, cardNumber: carNo!, userId: user.id);
                            // }else{
                            //   card = await   stripeServices.addCard(stripeId: user.stripeId!, month: exp_month!, year: exp_year!, cvc: cvc!, cardNumber: carNo!, userId: user.id);
                            // }
                             // PaymentMethodeNumberBloc bloc =  context.read<PaymentMethodeNumberBloc>();
                          //  bloc.getCards();
                            String card_number_in_firebase = carNo.toString().substring(0,4)+' **** **** ' +carNo.toString().substring(12,carNo.toString().length);
                            print(card_number_in_firebase);
                            CardModel card = CardModel(id: DateTime.now().toString(),cardNumber: card_number_in_firebase,
                            userID: user.id,month: exp_month!,year: exp_year!,last4: int.parse(carNo.toString().substring(11))

                            );

                            PaymentMethodeNumberBloc bloc =  context.read<PaymentMethodeNumberBloc>();
                           await bloc.addOne(card);
                            Navigator.of(context).pop();
                            //   user.hasCard();
                           // user.loadCardsAndPurchase(userId: user.user.uid);
                           // if (formKey.currentState!.validate()) {
                         //    PaymentMethodeNumberBloc bloc =  context.read<PaymentMethodeNumberBloc>();
                         //      CardModel card = CardModel(
                         //          id: bloc.state.cards.length+1, cardHolderName: cardHolderName, cardNumber: cardNumber, cvvCode: cvvCode, expiryDate: expiryDate);
                         //      bloc.addOne(card);
                         //     // Navigator.pop(context);
                         //  PaymentMethod  paymentMethod = await paymentService.createPaymentMethod();
                         //  print('ssssssssssssssssssssss');
                         //  print(paymentMethod.id);
                         // //   } else {
                         //      print('invalid!');
                         //  //  }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void onCreditCardModelChange(CreditCardModel? creditCardModel) {
    setState(() {
      cardNumber = creditCardModel!.cardNumber;
      expiryDate = creditCardModel.expiryDate;
      cardHolderName = creditCardModel.cardHolderName;
      cvvCode = creditCardModel.cvvCode;
      isCvvFocused = creditCardModel.isCvvFocused;
    });
  }
}



  /////////////////


