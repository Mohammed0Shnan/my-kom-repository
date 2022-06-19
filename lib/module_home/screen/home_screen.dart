import 'dart:io' show Platform;
import 'package:badges/badges.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_kom/consts/colors.dart';
import 'package:my_kom/module_company/bloc/all_company_bloc.dart';
import 'package:my_kom/module_company/bloc/check_zone_bloc.dart';
import 'package:my_kom/module_company/bloc/recomended_products_bloc.dart';
import 'package:my_kom/module_company/company_routes.dart';
import 'package:my_kom/module_company/models/company_arguments_route.dart';
import 'package:my_kom/module_company/models/company_model.dart';
import 'package:my_kom/module_dashbord/bloc/filter_zone_bloc.dart';
import 'package:my_kom/module_dashbord/enum/advertisement_type.dart';
import 'package:my_kom/module_dashbord/models/advertisement_model.dart';
import 'package:my_kom/module_home/models/search_model.dart';
import 'package:my_kom/module_home/widgets/descovary_grid_widget.dart';
import 'package:my_kom/module_home/widgets/page_view_widget.dart';
import 'package:my_kom/module_home/widgets/shimmer_list.dart';
import 'package:my_kom/module_map/bloc/map_bloc.dart';
import 'package:my_kom/module_map/map_routes.dart';
import 'package:my_kom/module_map/models/address_model.dart';
import 'package:my_kom/module_map/service/map_service.dart';
import 'package:my_kom/module_company/screen/notification_screen.dart';
import 'package:my_kom/module_persistence/sharedpref/shared_preferences_helper.dart';
import 'package:my_kom/utils/size_configration/size_config.dart';
import 'package:shimmer/shimmer.dart';
class HomeScreen extends StatefulWidget {
   bool isInit;
   final MapBloc mapBloc ;
   final FilterZoneCubit filterZoneCubit;
   final AllCompanyBloc allCompanyBloc;
   final RecommendedProductsCompanyBloc recommendedProductsCompanyBloc;
   final CheckZoneBloc checkZoneBloc;
  HomeScreen({required this.mapBloc,required this.filterZoneCubit,
    required  this.allCompanyBloc,
    required this.recommendedProductsCompanyBloc,
    required this.checkZoneBloc,
    required this.isInit,
    Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
final MapService mapService = MapService();
  final SharedPreferencesHelper _sharedPreferencesHelper = SharedPreferencesHelper();
@override
  void initState() {
  // Future.wait([
  //   _sharedPreferencesHelper.getCurrentSubArea(),
  //   _sharedPreferencesHelper.getCurrentStore(),
  // ]).then((value) {
  //
  // });
    _sharedPreferencesHelper.getCurrentSubArea().then((value) {
      print('========== init state home ==============');
      print(value);
      if(value == null)
        widget.mapBloc.getSubArea();
      else{
        widget.mapBloc.refresh(value);
      }
    });
   //widget.mapBloc.getSubArea();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    
    return BlocConsumer<MapBloc,MapStates>(
      bloc:  widget.mapBloc,
      listener: (context , state){
        if(state is MapSuccessState){
          if(state.isRefresh){
            if(widget.isInit){
              widget.isInit = !widget.isInit;
              widget.checkZoneBloc.checkZone(state.data.subArea);
            }
          }else{
            widget.checkZoneBloc.checkZone(state.data.subArea);
          }
          widget.filterZoneCubit.setFilter(SearchModel(storeId: '', zoneName:state.data.subArea));

          //allCompanyBloc.getAllCompany(state.data.subArea);
        }
      },
      builder: (context, state) {

        if(state is MapSuccessState){
            return Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                iconTheme: IconThemeData(color: Colors.black,),
                elevation: 0,
                leading: Builder(
                  builder: (context){
                    return Container(
                      width: 10,
                      child:  IconButton(
                          icon: Icon(Icons.notifications_active_outlined,color: Colors.black,),
                          onPressed: () {
                            Navigator.push(context,MaterialPageRoute(builder: (context)=> NotificationsScreen()));
                          }),
                      // child: Badge(
                      //   // position: BadgePosition.topEnd(top: 0, end: 3),
                      //   animationDuration: Duration(milliseconds: 300),
                      //   animationType: BadgeAnimationType.slide,
                      //
                      //   badgeContent: Text(
                      //     '0',
                      //     style: TextStyle(color: Colors.white),
                      //   ),
                      //   child: IconButton(
                      //       icon: Icon(Icons.notifications_active_outlined,color: Colors.black,),
                      //       onPressed: () {
                      //         Navigator.push(context,MaterialPageRoute(builder: (context)=> NotificationsScreen()));
                      //       }),
                      // ),
                    );
                  },
                ) ,

                backgroundColor: Colors.white,
                title:  GestureDetector(
                  onTap: (){
                    Navigator.of(context).pushNamed(MapRoutes.MAP_SCREEN).then((value) {
                      if (value != null) {
                        AddressModel addressModel = (value as AddressModel);
                        widget.filterZoneCubit.setFilter(SearchModel(storeId: '', zoneName: addressModel.subArea));
                        widget.checkZoneBloc.checkZone(addressModel.subArea);
                      }
                    });
                    // showSearch(context: context, delegate: ZoneSearch()).then((value) {
                    //   if(value != null){
                    //     _filterZoneCubit.setFilter(value);
                    //
                    //   }
                    // });
                  },
                  child: Container(
                    child: Column(
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.location_on_outlined,size: 18,color: Colors.black45,),
                            Text(
                              'Delivery to',
                              style: TextStyle(
                                  color: Colors.black45,
                                  fontSize: SizeConfig.titleSize * 2),
                            ),
                          ],
                        ),
                        // BlocBuilder<AllStoreBloc, AllStoreStates>(
                        //   bloc: allStoreBloc,
                        //   builder: (context,state) {
                        //     return DropdownButtonFormField<String>(
                        //       onTap: () {},
                        //       validator: (s) {
                        //         return s == null
                        //             ? 'company Is Required !'
                        //             : null;
                        //       },
                        //       decoration: InputDecoration(
                        //         border: InputBorder.none,
                        //         hintText: 'Store',
                        //         hintStyle: TextStyle(fontSize: 16),
                        //       ),
                        //       items: _getStoresDropDownList(
                        //           state is AllStoreSuccessState
                        //               ? state.data
                        //               : []),
                        //       onChanged: (s) {
                        //
                        //        // _companyID = s;
                        //
                        //       },
                        //     );
                        //   }
                        // ),
                        BlocBuilder<FilterZoneCubit,FilterZoneCubitState>(
                            bloc:  widget.filterZoneCubit,
                            builder: (context,state) {
                              return Text(state.searchModel.zoneName,style: TextStyle(
                                  color: Colors.black45,
                                  fontSize: SizeConfig.titleSize * 2),

                              );
                            }
                        )
                      ],
                    ),
                  ),
                ),
                centerTitle: true,
                actions: [
                  IconButton(onPressed: () {

                    showSearch(context: context, delegate: CompanySearch(widget.allCompanyBloc));
                  }, icon: Icon(Icons.search_rounded,color: Colors.black54,))

                ],
              ),
              body: BlocConsumer<CheckZoneBloc,CheckZoneStates>(
                bloc: widget.checkZoneBloc,
                listener: (context,state){
                  if(state is CheckZoneSuccessState){

                    widget.allCompanyBloc.getAllCompany(state.storeId);
                    widget.recommendedProductsCompanyBloc.getRecommendedProducts(state.storeId);
                  }
                  else if(state is CheckZoneErrorState){
                    print('@@@@@@@@@@@@@@@ zone error');
                    widget.allCompanyBloc.setInit();
                  }
                },
                builder: (context,state) {
                  if(state is CheckZoneSuccessState){
                    return Material(
                      child: SafeArea(
                          child: Column(
                            children: [
                              Container(
                                  margin: EdgeInsets.only(top: 8),
                                  child: BlocBuilder<RecommendedProductsCompanyBloc,RecommendedProductsCompanyStates>(
                                      bloc: widget.recommendedProductsCompanyBloc,
                                      builder: (context,state) {
                                        if(state is RecommendedProductsCompanySuccessState){
                                          List<AdvertisementModel> advertisement = state.data;
                                          print(advertisement);
                                          return PageViewWidget(
                                              itemCount: advertisement.length,
                                              hieght: SizeConfig.screenHeight * 0.22,
                                              pageBuilder: (index) {
                                                return GestureDetector(
                                                  onTap: (){
                                                    AdvertisementModel a =  advertisement[index];
                                                    List<String> route = a.route.split('/') ;
                                                    if(route[0] == AdvertisementType.ADVERTISEMENT_PRODUCT.name){
                                                      String productId = route[1];
                                                      Navigator.pushNamed(context, CompanyRoutes.PRODUCTS_DETAIL_SCREEN,arguments:productId );

                                                    }else if(route[0] == AdvertisementType.ADVERTISEMENT_COMPANY.name){
                                                      List<String> route_arrguments=  route[1].split('&');
                                                      print(route_arrguments);
                                                      String companyId =route_arrguments[0];
                                                      String companyName =route_arrguments[1];
                                                      CompanyArgumentsRoute argumentsRoute = CompanyArgumentsRoute();
                                                      argumentsRoute.companyId = companyId.replaceAll('id=','');
                                                      argumentsRoute.companyImage = advertisement[index].imageUrl;
                                                      argumentsRoute.companyName = companyName.replaceAll('name=','');
                                                      print(argumentsRoute.companyId);
                                                      print(argumentsRoute.companyName);
                                                     Navigator.pushNamed(context, CompanyRoutes.COMPANY_PRODUCTS_SCREEN,arguments: argumentsRoute);
                                                    }
                                                  },
                                                  child: Container(
                                                    clipBehavior: Clip.antiAlias,
                                                    height: SizeConfig.screenHeight * 0.22,
                                                    decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(20),
                                                      //
                                                      // image: DecorationImage(
                                                      //
                                                      //   image:NetworkImage(products[index].imageUrl,
                                                      //   ),
                                                      //   fit: BoxFit.fill,
                                                      //   onError: (s,w){
                                                      //
                                                      //   },
                                                      //
                                                      // ),
                                                      border:Border.all(
                                                          color: Colors.black12,
                                                          width: 1

                                                      ),
                                                    ),
                                                    child:CachedNetworkImage(

                                                      imageUrl: advertisement[index].imageUrl,
                                                      filterQuality: FilterQuality.high,
                                                      fadeInCurve: Curves.easeInOut,
                                                      progressIndicatorBuilder: (context, l, ll) =>
                                                          Center(
                                                            child: Container(width: 50,
                                                              height: 50,
                                                              child:  CircularProgressIndicator(
                                                                value: ll.progress,
                                                                color: Colors.black12,
                                                              ),),
                                                          ),

                                                      errorWidget: (context, s, l) => Icon(Icons.error),
                                                      fit: BoxFit.fill,
                                                    ),
                                                  ),
                                                );
                                              });
                                        }
                                        else if (state is RecommendedProductsCompanyErrorState){
                                          return Center(
                                            child: Text(state.message),
                                          );
                                        }
                                        else if (state is RecommendedProductsCompanyZoneErrorState){
                                          return Center(
                                            child: Text(state.message),
                                          );
                                        }
                                        else{
                                          return Shimmer.fromColors(
                                              baseColor: Colors.grey.shade300.withOpacity(0.8),
                                              highlightColor: Colors.grey.shade100,
                                              enabled: true,
                                              child: Container(
                                                height:  SizeConfig.screenHeight * 0.2,
                                                width:  SizeConfig.screenWidth * 0.8,
                                                color: Colors.white,
                                              ));
                                        }

                                      }
                                  )),
                              SizedBox(
                                height: 30,
                              ),
                              /// Offers
                              ///
                              // Container(
                              //   height: 150,
                              //   width: double.infinity,
                              //   color: Colors.black12,
                              //   child: Column(
                              //     crossAxisAlignment: CrossAxisAlignment.start,
                              //     children: [
                              //       Padding(
                              //           padding: EdgeInsets.symmetric(horizontal: 10),
                              //           child: Text('Offers',style: GoogleFonts.lato(
                              //             color: Colors.black45,
                              //             letterSpacing: 1,
                              //             fontWeight: FontWeight.bold,
                              //             fontSize: SizeConfig.titleSize * 2.5
                              //           ),)),
                              //       ListView.builder(
                              //         scrollDirection: Axis.horizontal,
                              //         shrinkWrap: true,
                              //           itemCount: 5,
                              //           itemBuilder: (context,index){
                              //         return Container(width: 100,
                              //         height: 100,
                              //           color: Colors.white,
                              //         );
                              //       })
                              //     ],
                              //   ),
                              // ),


                              /// Companies
                              ///

                              Expanded(
                                child: BlocConsumer<AllCompanyBloc, AllCompanyStates>(
                                  bloc: widget.allCompanyBloc,
                                  listener: (context, state) {
                                    // print('stteeeeeeeeeeeeeee');
                                    // print(state);
                                    // if (state is AllCompanySuccessState){
                                    //   print('SSSSSSSSSSSSSSSSSSSSSSSSSSSSS');
                                    //   print(state.data[0].storeId);
                                    //   _recommendedProductsCompanyBloc.getRecommendedProducts(state.data[0].storeId);
                                    // }
                                    // else if(state is AllCompanyZoneErrorState){
                                    //   _recommendedProductsCompanyBloc.getRecommendedProducts(null);
                                    // }

                                  },
                                  builder: (context, state) {
                                    if (state is AllCompanySuccessState) {
                                      return DescoveryGridWidget(
                                        data: state.data,
                                        onRefresh: () {
                                          _onRefresh();
                                        },
                                      );
                                    } else if (state is AllCompanyErrorState) {
                                      return Center(
                                          child: Container(
                                            child: Text(state.message),
                                          ));
                                    } else
                                      return ProductShimmerGridWidget();
                                  },
                                ),
                              )
                            ],
                          )),
                    );
                  }else if(state is CheckZoneLoadingState){
                   return Center(
                      child: Material(

                        elevation: 8,
                        clipBehavior: Clip.antiAlias,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)

                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.5),
                          ),
                          padding: EdgeInsets.all(10),

                          width: 140,
                          height: 70,
                          child: Center(child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text('please wait'),
                              Container(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(

                                  color: Colors.black54,),

                              ),
                            ],
                          ),),
                        ),
                      ),
                    );
                  }else if(state is CheckZoneErrorState){
                    return Center(
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(height: SizeConfig.screenHeight * 0.1,),
                            Container(
                              width: SizeConfig.screenWidth * 0.7,
                              child: Image.asset('assets/coming_soon.png'),

                            ),
                            SizedBox(height: 10,),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: SizeConfig.screenWidth * 0.1),
                              child:   Text('This area is currently unavailable Select the location manually',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.lato(
                                    fontSize: SizeConfig.titleSize * 2.3,
                                    color: Colors.black45,
                                  fontWeight: FontWeight.w800
                                ),
                            ),

                            )
                          ],
                        ),
                      ),
                    );
                  }else{
                    return Container();
                  }

                }
              )
            );

        }else if(state is MapLoadingState){
          return Scaffold(
            backgroundColor: Colors.black12.withOpacity(0.1),
            body: Center(
              child: Material(

                elevation: 8,
                clipBehavior: Clip.antiAlias,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)

                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.5),
                  ),
                  padding: EdgeInsets.all(10),

                  width: 140,
                  height: 70,
                  child: Center(child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text('please wait'),
                      Container(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(

                          color: Colors.black54,),

                      ),
                    ],
                  ),),
                ),
              ),
            ),
          );
        }
        else if(state is MapErrorState){
          return Scaffold(
           body: Center(
             child: Container(
               margin: EdgeInsets.symmetric(horizontal: 20),
               child: Column(
                 mainAxisAlignment: MainAxisAlignment.center,
                 children: [
                   Container(
                     height: 120,
                     child: Image.asset('assets/error.png'),
                   ),
                   SizedBox(height: 20,),
                   Text('Unable to determine the location, specify the location manually',
                   textAlign: TextAlign.center,
                     style: GoogleFonts.lato(
                       fontSize: 18,
                       fontWeight: FontWeight.w800,
                       color: Colors.black45
                     ),

                   ),
                   SizedBox(height: 20,),
                   Container(
                     height: 40,
                     width: SizeConfig.screenWidth *0.3,
                     color: ColorsConst.mainColor,
                     child: MaterialButton(
                       onPressed: (){
                         Navigator.of(context).pushNamed(MapRoutes.MAP_SCREEN).then((value) {
                           if (value != null) {
                             AddressModel addressModel = (value as AddressModel);
                             mapBloc.setLocationManually(addressModel.subArea);
                             widget.filterZoneCubit.setFilter(SearchModel(storeId: '', zoneName: addressModel.subArea));
                             widget.allCompanyBloc.getAllCompany(addressModel.subArea);
                           }
                         });
                         // showSearch(context: context, delegate: ZoneSearch()).then((value) {
                         //   if(value != null){
                         //     _filterZoneCubit.setFilter(value);
                         //
                         //   }
                         // });
                       },
                       child: Icon(Icons.location_on_outlined,size: 30,color: Colors.white,),
                     ),
                   )
                 ],
               ),
             ),
           ),
          );
        }
        else{
          return Scaffold();
        }


        
      }
    );
  }


  // List<DropdownMenuItem<String>> _getStoresDropDownList(
  //     List<StoreModel> stores) {
  //   print('stoooooooooooooooooreeeeeees');
  //   print(stores);
  //   var items = <DropdownMenuItem<String>>[];
  //   if (stores.length == 0) {
  //     return [
  //       DropdownMenuItem<String>(
  //         child: Text(''),
  //       )
  //     ];
  //   }
  //   stores.forEach((element) {
  //     items.add(DropdownMenuItem<String>(
  //       value: element.id,
  //       child: Text(
  //         '${element.name}',
  //         style: TextStyle(fontSize: 16),
  //       ),
  //     ));
  //   });
  //   print(items);
  //   return items;
  // }
  Future<void> _onRefresh() async {
    await widget.allCompanyBloc.getAllCompany( widget.filterZoneCubit.state.searchModel.storeId);
  }
}
class CompanySearch extends SearchDelegate<SearchModel?>{
  late AllCompanyBloc _allCompanyBloc ;


  CompanySearch(AllCompanyBloc bloc){
    _allCompanyBloc = bloc;
   // allStoreBloc.getAllStore();
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [IconButton(onPressed: (){
      query ='';
    }, icon: Icon(Icons.clear))];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(onPressed: (){
      close(context, null);
    }, icon: AnimatedIcon(icon: AnimatedIcons.menu_arrow,progress: transitionAnimation,));
  }

  @override
  Widget buildResults(BuildContext context) {
    // TODO: implement buildResults
    throw UnimplementedError();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
     return BlocBuilder<AllCompanyBloc,AllCompanyStates>(
       bloc: _allCompanyBloc,
       builder: (context,state) {
         print('_______________________');
         print(state);
         if(state is AllCompanySuccessState){

           List<CompanyModel>companies =  state.data;
           // stores.forEach((store) {
           //
           //   store.zones.forEach((element) {
           //     zones.add(SearchModel(storeId: store.id, zoneName: element.name));
           //   });
           // });

           final suggestionList = companies.where((element) =>element.name.startsWith(query) ).toList();

           return ListView.builder(
               itemCount:suggestionList.length ,
               itemBuilder: (context,index){
                 return ListTile(leading: Icon(Icons.location_city),
                   onTap: (){
                    //close(context, suggestionList[index]);
                     CompanyArgumentsRoute argumentsRoute = CompanyArgumentsRoute();
                     argumentsRoute.companyId = suggestionList[index].id;
                     argumentsRoute.companyImage = suggestionList[index].imageUrl;
                     argumentsRoute.companyName = suggestionList[index].name;

                     Navigator.pushNamed(context, CompanyRoutes.COMPANY_PRODUCTS_SCREEN,arguments: argumentsRoute);
                   },
                   title: RichText(
                     text: TextSpan(
                         text: suggestionList[index].name.substring(0,query.length),
                         style: TextStyle(color: Colors.black54,fontWeight: FontWeight.bold,fontSize: 22),
                         children: [
                           TextSpan(
                             text: suggestionList[index].name.substring(query.length),
                             style: TextStyle(color: Colors.grey,fontSize: 18),

                           )
                         ]
                     ),
                   ),
                 );
               });
         }else{
           return CircularProgressIndicator();
         }

       }
     );
  }



}