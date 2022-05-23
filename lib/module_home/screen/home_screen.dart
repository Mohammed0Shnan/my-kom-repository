import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:my_kom/consts/colors.dart';
import 'package:my_kom/module_about/animations/fade_animation.dart';
import 'package:my_kom/module_authorization/authorization_routes.dart';
import 'package:my_kom/module_authorization/service/auth_service.dart';
import 'package:my_kom/module_company/bloc/all_company_bloc.dart';
import 'package:my_kom/module_company/models/company_model.dart';
import 'package:my_kom/module_company/screen/company_products_screen.dart';
import 'package:my_kom/module_home/bloc/cubits.dart';
import 'package:my_kom/module_home/bloc/open_close_shop_bloc.dart';
import 'package:my_kom/module_home/widgets/descovary_grid_widget.dart';
import 'package:my_kom/module_home/widgets/descovary_list_widget.dart';
import 'package:my_kom/module_home/widgets/menu_item.dart';
import 'package:my_kom/module_home/widgets/page_view_widget.dart';
import 'package:my_kom/module_home/widgets/shimmer_list.dart';
import 'package:my_kom/module_home/widgets/side_bar_widget.dart';
import 'package:my_kom/module_profile/profile_routes.dart';
import 'package:my_kom/module_shoping/shoping_routes.dart';
import 'package:my_kom/utils/size_configration/size_config.dart';
import 'package:badges/badges.dart';
import 'package:cached_network_image/cached_network_image.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    allCompanyBloc.getAllCompany();
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
        title:    Container(
          child: Column(
            children: [
              Text(
                'Delivery to',
                style: TextStyle(
                    color: Colors.black45,
                    fontSize: SizeConfig.titleSize * 2),
              ),
              Text('امارة دبي',style: TextStyle(
                  color: Colors.black45,
                  fontSize: SizeConfig.titleSize * 2),)
            ],
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
                    Navigator.pushNamed(context, ProfileRoutes.PROFILE_SCREEN);
                  },
                  child: menuItem(
                      icon: Icons.person,
                      title: 'Profile'
                  ),
                ),
                menuItem(
                    icon: Icons.shopping_basket,
                    title: 'Orders'
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
                      icon: Icons.logout,
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
                child: PageViewWidget(
                    itemCount: offers.length,
                    hieght: SizeConfig.screenHeight * 0.25,
                    pageBuilder: (index) {
                      return Container(
                        margin:
                            EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        child: Container(
                          clipBehavior: Clip.antiAlias,
                          height: SizeConfig.screenHeight * 0.2,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),

                            border:Border.all(
                              color: Colors.black12,
                              width: 1

                            ),
                          ),
                          child: Image.asset(
                            offers[index],
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    })),
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

  Future<void> _onRefresh() async {
    await allCompanyBloc.getAllCompany();
  }
}
