import 'package:badges/badges.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_kom/module_company/models/product_model.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_kom/consts/colors.dart';
import 'package:my_kom/module_company/screen/widgets/app_icon.dart';
import 'package:my_kom/module_company/screen/widgets/expanded_text_widget.dart';
import 'package:my_kom/module_shoping/bloc/add_remove_product_quantity_bloc.dart';
import 'package:my_kom/module_shoping/bloc/shopping_cart_bloc.dart';
import 'package:my_kom/module_shoping/shoping_routes.dart';
import 'package:my_kom/utils/size_configration/size_config.dart';



class PriductDetailScreen extends StatefulWidget {
  final ProductModel productModel;
   PriductDetailScreen(
      {required this.productModel, Key? key});
  @override
  State<PriductDetailScreen> createState() => _PriductDetailScreenState();
}

class _PriductDetailScreenState extends State<PriductDetailScreen> {
  late final AddRemoveProductQuantityBloc addRemoveBloc;
  @override
  void initState() {
    addRemoveBloc = AddRemoveProductQuantityBloc();
    super.initState();
    
  }
  @override
  void dispose() {
addRemoveBloc.close();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    ShopCartBloc shopCartBlocProvided = context.read<ShopCartBloc>();
    return Scaffold(
      body: Material(

        child: CustomScrollView(
          slivers: [
            SliverAppBar(
           automaticallyImplyLeading: false,
              toolbarHeight: 11.9 * SizeConfig.heightMulti,
              pinned: true
              ,
              backgroundColor: ColorsConst.mainColor,
              expandedHeight: SizeConfig.screenHeight * 0.35,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconWidget(icon:Icons.arrow_back, onPress: (){
                    Navigator.pop(context);
                  }),
                  BlocBuilder<ShopCartBloc,CartState>(
                      bloc: shopCartBlocProvided,
                      builder: (context,state) {

                        return Container(
                          alignment: Alignment.center,
                          width:SizeConfig.heightMulti *7,
                          height: SizeConfig.heightMulti *7,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withOpacity(0.8)
                          ),
                          child:Badge(
                            // position: BadgePosition.topEnd(top: 0, end: 3),
                            animationDuration: Duration(milliseconds: 300),
                            animationType: BadgeAnimationType.slide,
                            badgeContent: Text(
                            (state is CartLoaded)?  state.cart.products.length.toString():'0',
                              style: TextStyle(color: Colors.white),
                            ),
                            child: IconButton(
                                icon: Icon(Icons.shopping_cart_outlined,color: Colors.black,),
                                onPressed: () {
                                  Navigator.pushNamed(context, ShopingRoutes.SHOPE_SCREEN);
                                }),
                          ),
                        );
                      }
                  ),


                ],
              ),
              flexibleSpace: FlexibleSpaceBar(
                background:     Container(
            width: double.infinity,
            child:CachedNetworkImage(
              maxHeightDiskCache: 5,
              imageUrl: widget.productModel.imageUrl,
              progressIndicatorBuilder: (context, l, ll) =>
                  CircularProgressIndicator(
                    value: ll.progress,
                  ),
              errorWidget: (context, s, l) => Icon(Icons.error),
              fit: BoxFit.cover,
            ),

          ),



              ),
              bottom: PreferredSize(
                preferredSize: Size.fromHeight(20),
                child: Container(
                  padding: EdgeInsets.only(bottom: 10,top: 10),
                    decoration: BoxDecoration(
                        color: Colors.white
                        ,borderRadius: BorderRadius.only(

                      topLeft:Radius.circular(20),
                        topRight: Radius.circular(20)
                    ))
                    ,child: Center(child: Text(widget.productModel.title,style: GoogleFonts.lato(
                  fontWeight: FontWeight.bold,
                  fontSize: SizeConfig.titleSize * 3.5,
                  color: Colors.black87

                  )
                ))) ,
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20,),
                    Text('Description',style: TextStyle(
                        fontSize: 20,
                        color: Colors.black54,
                        fontWeight: FontWeight.w600),),
                    SizedBox(height: 10,),
                     ExpadedTextWidget(text: widget.productModel.description),
                       SizedBox(
                  height: 10,
                ),
                // Text(
                //   'Specifications',
                //   style: TextStyle(
                //       fontSize: 20,
                //       color: Colors.black54,
                //       fontWeight: FontWeight.w600),
                // ),
                //
                // Container(
                //   padding: EdgeInsets.symmetric(horizontal: 10),
                //   child: Column(children: [
                //     Divider(
                //       color: Colors.black,
                //
                //       endIndent: 10,
                //     ),
                //    ...widget.productModel.specifications.map((e) =>       Container(
                //      margin: EdgeInsets.symmetric(vertical: 5),
                //      child: Row(
                //        children: [
                //          Text(
                //            '${e.name} : ',
                //            style: TextStyle(fontWeight: FontWeight.w800),
                //          ),
                //          Text('${e.value}  '),
                //
                //        ],
                //      ),
                //    ),),
                //     SizedBox(height: 20,)
                //
                //   ]),
                // ),
                  ],
                ),
              ),
            )

          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(8),
        height: 120,
        decoration: BoxDecoration(
            color: Colors.grey.shade200
            ,borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20))),
        child:               Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween
              ,
              children: [

                Container(
                    width: SizeConfig.widhtMulti * 30
                    ,height: 6 * SizeConfig.heightMulti
                    ,  child: LayoutBuilder(
                  builder:
                      (BuildContext context, BoxConstraints constraints) {
                    double w = constraints.maxWidth;

                    return Container(
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                        boxShadow: [BoxShadow(color: Colors.black12)],
                          borderRadius: BorderRadius.circular(10)
,
                          color: Colors.white.withOpacity(0.1),
                      ),
                      child: Stack(
                        children: [
                          Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            children: [
                              Container(

                                decoration: BoxDecoration(
                                    color: ColorsConst.mainColor,
                                    borderRadius: BorderRadius.circular(10)
                                ),
                                width: w / 3,
                                child: IconButton(
                                    onPressed: () {
                                        addRemoveBloc.removeOne();
                                    },
                                    icon: Icon(
                                      Icons.remove,
                                      size: SizeConfig.imageSize * 5,
                                      color: Colors.white,
                                    )),
                              ),
                              BlocBuilder<AddRemoveProductQuantityBloc , int>(
                                  bloc:addRemoveBloc ,
                                  builder: (context,state){
                                   return  Container(
                                      child: Text( state.toString(),style: TextStyle(fontWeight: FontWeight.w500,),),
                                    );
                                  })
                           ,
                              Container(
                                decoration: BoxDecoration(
                                    color: ColorsConst.mainColor,
                                    borderRadius: BorderRadius.circular(10)
                                ),
                                width: w / 3,
                                child: Center(
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
                )),
                Text('${widget.productModel.price}  AED',
                  style: GoogleFonts.lato(
                      color: ColorsConst.mainColor,
                      fontSize: SizeConfig.titleSize * 2.8,
                      fontWeight: FontWeight.bold
                  ),
                ),
              ],
            ),

            Builder(
              builder:(context)=> Container(
                clipBehavior: Clip.antiAlias,
                height: 7.3 * SizeConfig.heightMulti,
                decoration: BoxDecoration(
                    color: ColorsConst.mainColor,
                    borderRadius: BorderRadius.circular(10)),
                child: MaterialButton(
                  onPressed: () {
                    if(addRemoveBloc.state == 0){
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content:  Text('Select the number of items required',style: TextStyle(color: Colors.white ,letterSpacing: 1, fontWeight: FontWeight.bold,),),
                        backgroundColor: Colors.black54,
                        duration: const Duration(seconds: 1),

                      ));
                    }
                    else{
                      shopCartBlocProvided.addProductsToCart(widget.productModel,addRemoveBloc.state).then((value) {

                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content:  Text('${addRemoveBloc.state} Items have been added',style: TextStyle(color: Colors.white ,letterSpacing: 1, fontWeight: FontWeight.bold,),),
                          backgroundColor: Colors.black54,
                          duration: const Duration(seconds: 1),

                        ));
                        addRemoveBloc.clear();
                      });
                    }

                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Add to cart',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: SizeConfig.titleSize * 2.7),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Icon(Icons.shopping_cart_outlined,
                          color: Colors.white)
                    ],
                  ),
                ),
              ),
            ),

          ]),
        ),
      ),
    );
  }
}



