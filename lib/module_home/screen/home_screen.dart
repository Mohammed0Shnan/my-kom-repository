import 'dart:io' show Platform;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_kom/module_authorization/authorization_routes.dart';
import 'package:my_kom/module_authorization/service/auth_service.dart';
import 'package:my_kom/module_company/bloc/all_company_bloc.dart';
import 'package:my_kom/module_company/bloc/recomended_products_bloc.dart';
import 'package:my_kom/module_company/models/product_model.dart';
import 'package:my_kom/module_company/screen/widgets/login_sheak_alert.dart';
import 'package:my_kom/module_dashbord/bloc/all_store_bloc.dart';
import 'package:my_kom/module_dashbord/bloc/filter_zone_bloc.dart';
import 'package:my_kom/module_dashbord/models/store_model.dart';
import 'package:my_kom/module_home/models/search_model.dart';
import 'package:my_kom/module_home/widgets/descovary_grid_widget.dart';
import 'package:my_kom/module_home/widgets/menu_item.dart';
import 'package:my_kom/module_home/widgets/page_view_widget.dart';
import 'package:my_kom/module_home/widgets/shimmer_list.dart';
import 'package:my_kom/module_profile/profile_routes.dart';
import 'package:my_kom/module_shoping/screen/wallet_screen.dart';
import 'package:my_kom/utils/size_configration/size_config.dart';
import 'package:shimmer/shimmer.dart';
class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  final FilterZoneCubit _filterZoneCubit = FilterZoneCubit();
  final RecommendedProductsCompanyBloc _recommendedProductsCompanyBloc = RecommendedProductsCompanyBloc();
  @override
  void initState() {
    allCompanyBloc.getAllCompany(_filterZoneCubit.state.searchModel.storeId);

    _recommendedProductsCompanyBloc.getRecommendedProducts('tYxGSb6QQEn3bPOeHr6X');
    super.initState();
  }

  List<String> offers = [
    'assets/page1.png',
    'assets/page2.png',
    'assets/page3.png',
    'assets/page4.png',
  ];

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(

      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black,),
        elevation: 0,
        leading: Builder(
          builder: (context){
            return IconButton(
            icon: const Icon(
            Icons.menu,
            ),
            onPressed: () {
            Scaffold.of(context).openDrawer();
            },
            tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
            );
          },
        ) ,


        backgroundColor: Colors.white,
        title:    GestureDetector(
          onTap: (){
            showSearch(context: context, delegate: ZoneSearch()).then((value) {
              if(value != null){
                _filterZoneCubit.setFilter(value);

              }
            });
          },
          child: Container(
            child: Column(
              children: [
                Text(
                  'Delivery to',
                  style: TextStyle(
                      color: Colors.black45,
                      fontSize: SizeConfig.titleSize * 2),
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
                  bloc: _filterZoneCubit,
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
          IconButton(onPressed: () {}, icon: Icon(Icons.search_rounded,color: Colors.black54,))

        ],
      ),
      drawer: Drawer(
        backgroundColor: Colors.white,
        child:  SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  height: 100,
               clipBehavior: Clip.antiAlias,
               decoration: BoxDecoration(
                 shape: BoxShape.circle
               ),
               child: Image.asset('assets/logo3.png'),
                ),
                SizedBox(height: 10,),
                Divider(height:5 ,thickness: 0.5,color: Colors.grey,indent: 32,endIndent: 32,),
                InkWell(
                  onTap: (){
                    Navigator.pop(context);
                  },
                  child: menuItem(

                      icon: Icons.home,
                      title: 'Home'
                  ),
                ),
                InkWell(
                  onTap: (){
                    AuthService().isLoggedIn.then((value) {
                      if(value)
                        Navigator.pushNamed(context, ProfileRoutes.PROFILE_SCREEN,arguments: null);

                      else
                        loginCheakAlertWidget(context);
                    });
                  },
                  child: menuItem(
                      icon: Icons.person,
                      title: 'Profile'
                  ),
                ),
                InkWell(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder:(context)=> WalletScreen()));
                  },
                  child: menuItem(
                      icon: Icons.shopping_basket,
                      title: 'My Wallet'
                  ),
                ),
                SizedBox(height: 30,),
                Divider(height:5 ,thickness: 0.5,color: Colors.grey,indent: 32,endIndent: 32,),
                menuItem(
                    icon: Icons.settings,
                    title: 'Setting'
                ),
                InkWell(
                  onTap: (){
                    AuthService().logout().then((value) {
                      Navigator.pushNamed(context, AuthorizationRoutes.LOGIN_SCREEN);
                    });
                  },
                  child: menuItem(
                      icon: Icons.edit,
                      title: 'Logout'
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Material(
        child: SafeArea(
            child: Column(
          children: [
            Container(
                // height: SizeConfig.screenHeight * 0.32,
                child: BlocBuilder<RecommendedProductsCompanyBloc,RecommendedProductsCompanyStates>(
                  bloc: _recommendedProductsCompanyBloc,
                  builder: (context,state) {
                    if(state is RecommendedProductsCompanySuccessState){
                      List<ProductModel> products = state.data;

                      return PageViewWidget(
                          itemCount: products.length,
                          hieght: SizeConfig.screenHeight * 0.25,
                          pageBuilder: (index) {
                            return Container(
                              margin:
                              EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              child: Container(
                                clipBehavior: Clip.antiAlias,
                                height: SizeConfig.screenHeight * 0.2,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),

                                  border:Border.all(
                                      color: Colors.black12,
                                      width: 1

                                  ),
                                ),
                                child:CachedNetworkImage(
                                  maxHeightDiskCache: 5,
                                  imageUrl: products[index].imageUrl,
                                  progressIndicatorBuilder: (context, l, ll) =>
                                      CircularProgressIndicator(
                                        value: ll.progress,
                                      ),
                                  errorWidget: (context, s, l) => Icon(Icons.error),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            );
                          });
                    }else if (state is RecommendedProductsCompanyErrorState){
                      return Center(
                        child: Text(state.message),
                      );
                    }else{
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
              height: 20,
            ),
            Expanded(
              child: BlocConsumer<AllCompanyBloc, AllCompanyStates>(
                bloc: allCompanyBloc,
                listener: (context, state) {},
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
      ),
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
    await allCompanyBloc.getAllCompany(_filterZoneCubit.state.searchModel.storeId);
  }
}
class ZoneSearch extends SearchDelegate<SearchModel?>{
  final AllStoreBloc allStoreBloc = AllStoreBloc();
  late List<StoreModel>stores;

  ZoneSearch(){
    allStoreBloc.getAllStore();
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

     return BlocBuilder<AllStoreBloc,AllStoreStates>(
       bloc: allStoreBloc,
       builder: (context,state) {
         if(state is AllStoreSuccessState){
           List<SearchModel> zones = [];
           List<StoreModel>stores =  state.data;
           stores.forEach((store) {

             store.zones.forEach((element) {
               zones.add(SearchModel(storeId: store.id, zoneName: element.name));
             });
           });

           final suggestionList = zones.where((element) =>element.zoneName.startsWith(query) ).toList();

           return ListView.builder(
               itemCount:suggestionList.length ,
               itemBuilder: (context,index){
                 return ListTile(leading: Icon(Icons.location_city),
                   onTap: (){
                    close(context, suggestionList[index]);
                   },
                   title: RichText(
                     text: TextSpan(
                         text: suggestionList[index].zoneName.substring(0,query.length),
                         style: TextStyle(color: Colors.black54,fontWeight: FontWeight.bold,fontSize: 22),
                         children: [
                           TextSpan(
                             text: suggestionList[index].zoneName.substring(query.length),
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