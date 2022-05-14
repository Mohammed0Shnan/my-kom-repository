import 'package:badges/badges.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:my_kom/consts/colors.dart';
import 'package:my_kom/module_company/bloc/products_company_bloc.dart';
import 'package:my_kom/module_company/models/company_model.dart';
import 'package:my_kom/module_company/models/product_model.dart';
import 'package:my_kom/module_company/screen/products_detail_screen.dart';
import 'package:my_kom/module_company/screen/widgets/product_shimmer.dart';
import 'package:my_kom/module_home/bloc/open_close_shop_bloc.dart';
import 'package:my_kom/module_shoping/shoping_routes.dart';
import 'dart:io' show Platform;

import 'package:my_kom/utils/size_configration/size_config.dart';

class CompanyProductScreen extends StatefulWidget {
  final CompanyModel? company;

  CompanyProductScreen({required this.company, Key? key}) : super(key: key);

  @override
  State<CompanyProductScreen> createState() => _CompanyProductScreenState();
}

class _CompanyProductScreenState extends State<CompanyProductScreen> {
  late String company_id;
  @override
  void initState() {
    //     WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
    //   company_id = ModalRoute.of(context)!.settings.arguments.toString();
    // });
    super.initState();
    productsCompanyBloc.getProducts(widget.company!.id);
  }

  @override
  Widget build(BuildContext context) {
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
                        tag: 'company' + widget.company!.id,
                        child: Container(
                          height: SizeConfig.imageSize * 12,
                          width: SizeConfig.imageSize * 12,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: widget.company!.imageUrl.length == 0
                                ? Container(
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: new ExactAssetImage(
                                            'assets/logo_background.png'),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  )
                                : CachedNetworkImage(
                                    maxHeightDiskCache: 5,
                                    imageUrl: widget.company!.imageUrl,
                                    progressIndicatorBuilder:
                                        (context, l, ll) =>
                                            CircularProgressIndicator(
                                      value: ll.progress,
                                    ),
                                    errorWidget: (context, s, l) =>
                                        Icon(Icons.error),
                                    fit: BoxFit.cover,
                                  ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        widget.company!.name,
                        style: TextStyle(
                            fontSize: SizeConfig.titleSize * 3.5,
                            fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Badge(
                      position: BadgePosition.topEnd(top: 0, end: 3),
                      animationDuration: Duration(milliseconds: 300),
                      animationType: BadgeAnimationType.slide,
                      badgeContent: Text(
                        '1',
                        style: TextStyle(color: Colors.white),
                      ),
                      child: IconButton(
                          icon: Icon(Icons.shopping_cart_outlined),
                          onPressed: () {
                      Navigator.pushNamed(context, ShopingRoutes.SHOPE_SCREEN);
                          }),
                    ),
                  )
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
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      prefixIcon: IconButton(
                        icon: Icon(
                          Icons.search,
                          size: 28,
                          color: Colors.black38,
                        ),
                        onPressed: () {},
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
                      return _buildProductListWidget(state.data);
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
              Container(height: 80,
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
                  Text('Minimum order',style: TextStyle(fontSize: SizeConfig.titleSize * 2.3,fontWeight: FontWeight.w600,color: Colors.black54),),
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      color: ColorsConst.mainColor,
                      borderRadius: BorderRadius.circular(10)
                    ),
                   child: MaterialButton(
                     onPressed: (){},
                     child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('See the cart',style: TextStyle(color: Colors.white,fontSize: SizeConfig.titleSize * 2.7),),
                            Text('200 AED',style: TextStyle(color: Colors.white,fontSize: SizeConfig.titleSize * 2.7))
                          ],
                        ),
                   ),
                  ),
                ],
              ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProductListWidget(List<ProductModel> data) {
    if (data.length == 0) {
      return Center(
          child: Container(
        child: Text('Empty !!!'),
      ));
    } else {
      return AnimationLimiter(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 5),
          child: RefreshIndicator(
            onRefresh: () => onRefresh(),
            child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
                childAspectRatio: 0.6,
                children: List.generate(
                    data.length,
                    (index) => AnimationConfiguration.staggeredGrid(
                          position: index,
                          columnCount: 2,
                          duration: Duration(milliseconds: 350),
                          child: ScaleAnimation(
                              child: FadeInAnimation(
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            PriductDetailScreen(productModel: data[index],companyImge: widget.company!.imageUrl,)));
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
                                  tag:'product'+data[index].id,
                                  child: Column(
                                    children: [
                                      Flexible(
                                        flex: 3,
                                        child: Stack(
                                          children: [
                                            Container(
                                              width: double.infinity,
                                              child: ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                child: data[index]
                                                            .imageUrl
                                                            .length !=
                                                        0
                                                    ? Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          image:
                                                              DecorationImage(
                                                            image: new ExactAssetImage(
                                                                data[index]
                                                                    .imageUrl),
                                                            fit: BoxFit.cover,
                                                          ),
                                                        ),
                                                      )
                                                    : CachedNetworkImage(
                                                        maxHeightDiskCache: 10,
                                                        imageUrl: data[index]
                                                            .imageUrl,
                                                        progressIndicatorBuilder:
                                                            (context, l, ll) =>
                                                                CircularProgressIndicator(
                                                          value: ll.progress,
                                                        ),
                                                        errorWidget: (context,
                                                                s, l) =>
                                                            Icon(Icons.error),
                                                        fit: BoxFit.cover,
                                                      ),
                                              ),
                                            ),
                                            (data[index].old_price != null)
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
                                                        'خصم',
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
                                      Flexible(
                                        flex: 4,
                                        child: Padding(
                                          padding: EdgeInsets.only(top: 8),
                                          child: Column(
                                            children: [
                                              Container(
                                                child: Row(
                                                  children: [
                                                    Expanded(
                                                      child: Text(
                                                        data[index]
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
                                                    (data[index].old_price !=
                                                            null)
                                                        ? Expanded(
                                                            child: Text(
                                                              data[index]
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
                                                            ),
                                                          )
                                                        : SizedBox.shrink(),
                                                  ],
                                                ),
                                              ),
                                              Flexible(
                                                flex: 2,
                                                child: Padding(
                                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                                  child: Row(
                                                    children: [
                                                      Expanded(
                                                        child: Text(
                                                          data[index]
                                                              .price
                                                              .toString(),
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black26,
                                                              fontWeight:
                                                                  FontWeight.w700,
                                                              fontSize: SizeConfig
                                                                      .titleSize *
                                                                  2.5),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding: EdgeInsets.symmetric(horizontal: 10),

                                                        child: Text(
                                                          data[index].title,
                                                          style: TextStyle(
                                                              fontSize: SizeConfig
                                                                      .titleSize *
                                                                  2.3,
                                                              fontWeight:
                                                                  FontWeight.bold,
                                                              overflow: TextOverflow
                                                                  .ellipsis),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Flexible(
                                                flex: 3,
                                                child: Container(
                                                  child: Text(
                                                      data[index].description),
                                                ),
                                              ),
                                              Spacer(),
                                              Flexible(
                                                  flex: 2,
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Expanded(
                                                        child: Container(
                                                          height: 35,
                                                          child: ElevatedButton
                                                              .icon(
                                                            onPressed: () {},
                                                            label: Text(
                                                              'اضف',
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
                                                                          onPressed: () {},
                                                                          icon: Icon(
                                                                            Icons.minimize_sharp,
                                                                            size:
                                                                                SizeConfig.imageSize * 5,
                                                                            color:
                                                                                Colors.white,
                                                                          )),
                                                                    ),
                                                                    Container(
                                                                        child: Text('100'),
                                                                    ),
                                                                    Container(
                                                                      width: w /
                                                                          3,
                                                                      color: ColorsConst
                                                                          .mainColor,
                                                                      child:
                                                                          Center(
                                                                        child: IconButton(
                                                                            onPressed: () {},
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
                                                  ))
                                            ],
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          )),
                        ))),
          ),
        ),
      );
    }
  }

 Future<void> onRefresh()async {
    productsCompanyBloc.getProducts('1');
  }
}
