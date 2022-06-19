import 'package:badges/badges.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_kom/consts/colors.dart';
import 'package:my_kom/module_authorization/service/auth_service.dart';
import 'package:my_kom/module_company/bloc/products_company_bloc.dart';
import 'package:my_kom/module_company/company_routes.dart';
import 'package:my_kom/module_company/models/company_arguments_route.dart';
import 'package:my_kom/module_company/models/company_model.dart';
import 'package:my_kom/module_company/models/product_model.dart';
import 'package:my_kom/module_authorization/screens/widgets/login_sheak_alert.dart';
import 'package:my_kom/module_company/screen/widgets/product_shimmer.dart';
import 'package:my_kom/module_shoping/bloc/add_remove_product_quantity_bloc.dart';
import 'package:my_kom/module_shoping/bloc/shopping_cart_bloc.dart';
import 'package:my_kom/module_shoping/shoping_routes.dart';
import 'dart:io' show Platform;

import 'package:my_kom/utils/size_configration/size_config.dart';

class CompanyProductScreen extends StatefulWidget {

  final AuthService _authService = AuthService();

  CompanyProductScreen({Key? key}) : super(key: key);

  @override
  State<CompanyProductScreen> createState() => _CompanyProductScreenState();
}

class _CompanyProductScreenState extends State<CompanyProductScreen> {
  final TextEditingController _serachController = TextEditingController();
  late final  CompanyModel company;
  @override
  void initState() {

    super.initState();
  }
  
 bool isInit =true;
  @override
  Widget build(BuildContext context) {

    CompanyArgumentsRoute argumentsRoute =   (ModalRoute.of(context)!.settings.arguments) as CompanyArgumentsRoute;
    company = CompanyModel(id: argumentsRoute.companyId, name: argumentsRoute.companyName, imageUrl: argumentsRoute.companyImage, description: 'description');
    if(isInit){
      productsCompanyBloc.getProducts( company.id);
      setState(() {
        isInit = !isInit;
      });
    }

    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      IconButton(
                          onPressed: () {
                            
                            Navigator.of(context).pop();
                          },
                          icon: Icon(Platform.isIOS
                              ? Icons.arrow_back_ios
                              : Icons.arrow_back)),
                      Hero(
                        tag: 'company' + company.id,
                        child: Container(
                          height: SizeConfig.imageSize * 12,
                          width: SizeConfig.imageSize * 12,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                          
                            // child: Image.network( widget.company!.imageUrl,
                            // fit: BoxFit.cover,
                            // )
                            child: CachedNetworkImage(
                              imageUrl: company.imageUrl,
                              progressIndicatorBuilder:
                                  (context, l, ll) =>
                                  Center(
                                    child: Container(
                                      height: 10,
                                      width: 10,
                                      child: CircularProgressIndicator(
                                        value: ll.progress,
                                        color: Colors.black12,
                                      ),
                                    ),
                                  ),
                              errorWidget: (context, s, l) =>
                                  Icon(Icons.error),
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                     company.name,
                        style: TextStyle(
                            fontSize: SizeConfig.titleSize * 3.3,
                            color: Colors.black54,
                            fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                  BlocBuilder<ShopCartBloc,CartState>(
                      bloc: shopCartBloc,
                      builder: (context,state) {
                        return Container(
                          margin: EdgeInsets.symmetric(horizontal: 12),

                          alignment: Alignment.center,
                          width:SizeConfig.heightMulti *7,
                          height: SizeConfig.heightMulti *7,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withOpacity(0.8)
                          ),
                          child:     Badge(
                            // position: BadgePosition.topEnd(top: 0, end: 3),
                            animationDuration: Duration(milliseconds: 300),
                            animationType: BadgeAnimationType.slide,
                            badgeContent: Text(
                           state is CartLoaded?   state.cart.products.length.toString():'0',
                              style: TextStyle(color: Colors.white),
                            ),
                            child: IconButton(
                                icon: Icon(Icons.shopping_cart_outlined,color: Colors.black,),
                                onPressed: () {
                                  widget._authService.isLoggedIn.then((value) {
                                    if(value){
                                      Navigator.pushNamed(context, ShopingRoutes.SHOPE_SCREEN);

                                    }else{
                                      loginCheakAlertWidget(context);
                                    }
                                  });
                                }),
                          ),
                        );
                      }
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(color: Colors.black26, blurRadius: 2)
                    ]),
                child: TextField(
                  controller: _serachController,
                  onChanged: (String query){
                    productsCompanyBloc.search(query);
                  },
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      prefixIcon: IconButton(
                        icon: Icon(
                          Icons.search,
                          size: 28,
                          color: Colors.black38,
                        ),
                        onPressed: () {
                          productsCompanyBloc.search(_serachController.text);
                        },
                      ),
                      hintText: 'Search for your products',
                      hintStyle: TextStyle(color: Colors.black26)),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Expanded(
                child: BlocConsumer<ProductsCompanyBloc, ProductsCompanyStates>(
                  bloc: productsCompanyBloc,
                  listener: (context, state) {},
                  builder: (context, state) {
                    if (state is ProductsCompanySuccessState)
                      return  _buildProductListWidget(state.data);
                    else if (state is ProductsCompanyErrorState) {
                      return Center(
                          child: Container(
                        child: Text(state.message),
                      ));
                    } else
                      return ProductShimmerList();
                  },
                ),
              ),

            ],
          ),
        ),
      ),
      bottomNavigationBar:  Container(height: 80,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
            boxShadow: [BoxShadow(
                offset:Offset(0,-5),
                color: Colors.black12,
                blurRadius: 3
            )]

        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text('Minimum order 200 AED',style: TextStyle(fontSize: SizeConfig.titleSize * 2.3,fontWeight: FontWeight.w600,color: Colors.black54),),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                  color: ColorsConst.mainColor,
                  borderRadius: BorderRadius.circular(10)
              ),
              child: MaterialButton(
                onPressed: (){
                  widget._authService.isLoggedIn.then((value) {
                    if(value){
                      Navigator.pushNamed(context, ShopingRoutes.SHOPE_SCREEN);

                    }else{
                      loginCheakAlertWidget(context);
                    }
                  });
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('See the cart',style: TextStyle(color: Colors.white,fontSize: SizeConfig.titleSize * 2.7),),
                    BlocBuilder<ShopCartBloc,CartState>(
                        bloc: shopCartBloc,
                        builder: (context,state) {
                          if(state is CartLoaded ){

                            return Text(state.cart.totalString,style: TextStyle(color: Colors.white,fontSize: SizeConfig.titleSize * 2.7));
                          }
                          else{
                            return Text('',style: TextStyle(color: Colors.white,fontSize: SizeConfig.titleSize * 2.7));
                          }

                        }
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductListWidget(List<ProductModel> items) {

    if (items.length == 0) {
      return Center(
        child:  Container(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                      height: SizeConfig.screenHeight * 0.3,
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30)
                      ),
                      child: Image.asset('assets/empity.png',fit: BoxFit.fill,)),
                  SizedBox(height: 10,),
                  Text('No data to display',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.black45),)
                ],
              ),
            )),
      );
    } else {

            return AnimationLimiter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: RefreshIndicator(
                  onRefresh: () => onRefresh(),

                  child: GridView.count(
                      crossAxisCount: 2,
                      crossAxisSpacing: 15,
                      mainAxisSpacing: 15,
                      childAspectRatio: 0.6,
                      children: List.generate(
                          items.length,
                              (index){
                                final AddRemoveProductQuantityBloc addRemoveBloc =AddRemoveProductQuantityBloc();
                         return  AnimationConfiguration.staggeredGrid(
                            position: index,
                            columnCount: 2,
                            duration: Duration(milliseconds: 350),
                            child: ScaleAnimation(
                                child: FadeInAnimation(
                                  child: GestureDetector(
                                    onTap: () {
                                      print('product id clicked');
                                      print(items[index].id );
                                      Navigator.pushNamed(context, CompanyRoutes.PRODUCTS_DETAIL_SCREEN,arguments:items[index].id );

                                    },
                                    child: Container(
                                      clipBehavior: Clip.antiAlias,
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(10),
                                          boxShadow: [
                                            BoxShadow(
                                                color: Colors.black12,
                                                blurRadius: 3,
                                                offset: Offset(0, 5))
                                          ]),
                                      child: Hero(
                                        tag:'product'+items[index].id,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            AspectRatio(
                                              aspectRatio:  1.5,
                                              child: Container(
                                                child: Stack(
                                                  children: [
                                                    Container(
                                                      width: double.infinity,
                                                      child: ClipRRect(
                                                        borderRadius:
                                                        BorderRadius.circular(10),
                                                          // child: Image.network( items[index].imageUrl,
                                                          //   fit: BoxFit.fitHeight,
                                                          // )
                                                        child:  CachedNetworkImage(
                                                          imageUrl: items[index]
                                                              .imageUrl,
                                                          progressIndicatorBuilder:
                                                              (context, l, ll) =>
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
                                                          errorWidget: (context,
                                                              s, l) =>
                                                              Center(child: Icon(Icons.error,size: 40,color: Colors.black45,)),
                                                          fit: BoxFit.fill,
                                                        ),
                                                      ),
                                                    ),
                                                    (items[index].old_price != null)
                                                        ? Positioned(
                                                        top: 0,
                                                        right: 0,
                                                        child: Container(
                                                          alignment:
                                                          Alignment.center,
                                                          width: SizeConfig
                                                              .widhtMulti *
                                                              15,
                                                          height: SizeConfig
                                                              .heightMulti *
                                                              5,
                                                          decoration: BoxDecoration(
                                                              color: Colors.orange,
                                                              borderRadius:
                                                              BorderRadius.only(
                                                                  bottomLeft: Radius
                                                                      .circular(
                                                                      10))),
                                                          child: Text(
                                                            'ٌRival',
                                                            style: TextStyle(
                                                                color: Colors.white,
                                                                fontWeight:
                                                                FontWeight.w400,
                                                                fontSize: SizeConfig
                                                                    .titleSize *
                                                                    3),
                                                          ),
                                                        ))
                                                        : SizedBox.shrink()
                                                  ],
                                                ),
                                              ),
                                            ),
                                            SizedBox(height: 10,),
                                            Expanded(
                                              child: Padding(
                                                padding: EdgeInsets.only(top: 8),
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      padding: EdgeInsets.symmetric(horizontal: 5),
                                                      child: Row(
                                                        children: [
                                                          (items[index].old_price !=
                                                              null)
                                                              ? Text(
                                                            items[index]
                                                                .old_price
                                                                .toString(),
                                                            overflow:
                                                            TextOverflow
                                                                .ellipsis,
                                                            style: TextStyle(
                                                                decoration:
                                                                TextDecoration
                                                                    .lineThrough,
                                                                color: Colors
                                                                    .black26,
                                                                fontWeight:
                                                                FontWeight
                                                                    .w700,
                                                                fontSize:
                                                                SizeConfig
                                                                    .titleSize *
                                                                    3),
                                                          )
                                                              : SizedBox.shrink(),
                                                          SizedBox(width: 8,),
                                                          Expanded(
                                                            child: Text(
                                                              items[index]
                                                                  .price
                                                                  .toString(),
                                                              overflow: TextOverflow
                                                                  .ellipsis,
                                                              style: TextStyle(
                                                                  color: Colors.green,
                                                                  fontWeight:
                                                                  FontWeight.w700,
                                                                  fontSize: SizeConfig
                                                                      .titleSize *
                                                                      4),
                                                            ),
                                                          ),

                                                        ],
                                                      ),
                                                    ),
                                                    SizedBox(height: 5,),
                                                    Padding(
                                                      padding: EdgeInsets.symmetric(horizontal: 5),
                                                      child: Row(
                                                        children: [

                                                          Expanded(
                                                            child: Padding(
                                                              padding: EdgeInsets.symmetric(horizontal: 5),

                                                              child: Text(
                                                                items[index].title,
                                                                style: TextStyle(
                                                                    fontSize: SizeConfig
                                                                        .titleSize *
                                                                        2.1,
                                                                    fontWeight:
                                                                    FontWeight.bold,
                                                                    overflow: TextOverflow
                                                                        .ellipsis),
                                                              ),
                                                            ),
                                                          ),
                                                          Text(
                                                            items[index]
                                                                .quantity
                                                                .toString() + ' Plot',
                                                            style: TextStyle(
                                                                color:
                                                                Colors.black26,
                                                                fontWeight:
                                                                FontWeight.w700,
                                                                fontSize: SizeConfig
                                                                    .titleSize *
                                                                    2.2),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    SizedBox(height: 5,),
                                                    Expanded(
                                                      child: Container(

                                                        padding: EdgeInsets.symmetric(horizontal: 10),
                                                        child: Text(
                                                          items[index].description,
                                                          overflow: TextOverflow.ellipsis,
                                                          maxLines: 3,
                                                          style: GoogleFonts.lato(
                                                              fontSize: SizeConfig.titleSize * 2,
                                                              color: Colors.black54,
                                                              fontWeight: FontWeight.w600
                                                          ),
                                                        ),
                                                      ),
                                                    ),


                                                  ],
                                                ),
                                              ),
                                            ),
                                            Container(
                                              height: SizeConfig.heightMulti *5,
                                              child: Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment
                                                    .spaceBetween,
                                                children: [
                                                  Container(
                                                    // height: 10,
                                                    child: ElevatedButton
                                                        .icon(
                                                      onPressed: () {
                                                        widget._authService.isLoggedIn.then((value) {
                                                          if(value){
                                                            if(addRemoveBloc.state == 0){

                                                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                                                content:  Text('Select the number of items required',style: TextStyle(color: Colors.white ,letterSpacing: 1, fontWeight: FontWeight.bold,),),
                                                                backgroundColor: Colors.black54,
                                                                duration: const Duration(seconds: 1),

                                                              ));
                                                            }
                                                            else{
                                                              shopCartBloc.addProductsToCart(items[index],addRemoveBloc.state).then((value) {
                                                                addRemoveBloc.clear();
                                                              });
                                                            }

                                                          }else{
                                                            loginCheakAlertWidget(context);
                                                          }
                                                        });

                                                      },
                                                      label: Text(
                                                        'ِAdd',
                                                        style: TextStyle(
                                                            color: Colors
                                                                .white,
                                                            fontWeight:
                                                            FontWeight
                                                                .w900),
                                                      ),
                                                      icon: Icon(
                                                        Icons
                                                            .shopping_cart_outlined,
                                                        size: SizeConfig
                                                            .imageSize *
                                                            5,
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 8,
                                                  ),
                                                  Expanded(
                                                      child: LayoutBuilder(
                                                        builder: (BuildContext
                                                        context,
                                                            BoxConstraints
                                                            constraints) {
                                                          double w = constraints
                                                              .maxWidth;

                                                          return Container(
                                                            clipBehavior:
                                                            Clip.antiAlias,
                                                            decoration:
                                                            BoxDecoration(
                                                              boxShadow: [
                                                                BoxShadow(
                                                                    color: Colors
                                                                        .black12)
                                                              ],
                                                              borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                  5),
                                                              color: Colors
                                                                  .white
                                                                  .withOpacity(
                                                                  0.1),
                                                            ),
                                                            child: Stack(
                                                              children: [
                                                                Row(
                                                                  mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                                  children: [
                                                                    Container(
                                                                      color: ColorsConst
                                                                          .mainColor,
                                                                      width: w /
                                                                          3,
                                                                      child: IconButton(
                                                                          onPressed: () {
                                                                            addRemoveBloc.removeOne();
                                                                          },
                                                                          icon: Icon(
                                                                            Icons.remove,
                                                                            size:
                                                                            SizeConfig.imageSize * 5,
                                                                            color:
                                                                            Colors.white,
                                                                          )),
                                                                    ),
                                                                    BlocBuilder<AddRemoveProductQuantityBloc , int>(
                                                                        bloc:addRemoveBloc ,
                                                                        builder: (context,state){
                                                                          return  Container(
                                                                            child: Text( state.toString(),style: TextStyle(fontWeight: FontWeight.w500,),),
                                                                          );
                                                                        }),
                                                                    Container(
                                                                      width: w /
                                                                          3,
                                                                      color: ColorsConst
                                                                          .mainColor,
                                                                      child:
                                                                      Center(
                                                                        child: IconButton(
                                                                            onPressed: () {
                                                                              addRemoveBloc.addOne();

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
                                                          );
                                                        },
                                                      ))
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                )),
                          );}))
                ),
              ),
            );



    }
  }

 Future<void> onRefresh()async {
    productsCompanyBloc.getProducts(company.id);
  }
}
