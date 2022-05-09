import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:my_kom/consts/colors.dart';
import 'package:my_kom/module_about/animations/fade_animation.dart';
import 'package:my_kom/module_company/bloc/all_company_bloc.dart';
import 'package:my_kom/module_company/models/company_model.dart';
import 'package:my_kom/module_company/screen/company_products_screen.dart';
import 'package:my_kom/module_home/bloc/cubits.dart';
import 'package:my_kom/module_home/bloc/open_close_shop_bloc.dart';
import 'package:my_kom/module_home/widgets/descovary_grid_widget.dart';
import 'package:my_kom/module_home/widgets/descovary_list_widget.dart';
import 'package:my_kom/module_home/widgets/page_view_widget.dart';
import 'package:my_kom/module_home/widgets/shimmer_list.dart';
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
      body: Material(
        child: SafeArea(
            child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                    child: Badge(
                  position: BadgePosition.topEnd(top: 0, end: 3),
                  animationDuration: Duration(milliseconds: 300),
                  animationType: BadgeAnimationType.slide,
                  badgeContent: Text(
                    '1',
                    style: TextStyle(color: Colors.white),
                  ),
                  child: IconButton(
                      icon: Icon(Icons.shopping_cart),
                      onPressed: () {
                      //  openCloseShopBloc.openShop();
                      }),
                )),
                Flexible(
                  child: Container(
                    child: Column(
                      children: [
                        Text(
                          'Delivery to',
                          style: TextStyle(
                              color: Colors.black45,
                              fontSize: SizeConfig.titleSize * 2),
                        ),
                        Text('امارة دبي')
                      ],
                    ),
                  ),
                ),
                IconButton(onPressed: () {}, icon: Icon(Icons.search_rounded))
              ],
            ),
            Container(
                height: SizeConfig.screenHeight * 0.29,
                child: PageViewWidget(
                    itemCount: offers.length,
                    hieght: SizeConfig.screenHeight * 0.26,
                    pageBuilder: (index) {
                      return Container(
                        padding: EdgeInsets.all(10),
                        margin: const EdgeInsets.fromLTRB(10, 10, 10, 20),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: const [
                              BoxShadow(
                                  offset: Offset(0, 2),
                                  color: ColorsConst.mainColor,
                                  blurRadius: 5,
                                  spreadRadius: 0)
                            ]),
                        child: Image.asset(
                          offers[index],
                          fit: BoxFit.fill,
                        ),
                      );
                    })),
            Row(
              children: [
                Spacer(),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: BlocBuilder<SwitchItemCubit, SwitchItemState>(
                    bloc: switchItemBloc,
                    builder: (context, state) {
                      switch (state) {
                        case SwitchItemState.LIST:
                          return IconButton(
                              onPressed: () {
                                switchItemBloc.changeState();
                              },
                              icon: Icon(Icons.list,color: Colors.black38,));
                        case SwitchItemState.GRID:
                          return IconButton(
                              onPressed: () {
                                switchItemBloc.changeState();
                              },
                              icon: Icon(Icons.grid_4x4,color: Colors.black38,));
                      }
                    },
                  ),
                ),
              ],
            ),
            
            Expanded(
              
              child: BlocConsumer<AllCompanyBloc, AllCompanyStates>(
                bloc: allCompanyBloc,
                listener: (context, state) {},
                builder: (context, state) {
                  if (state is AllCompanySuccessState) {
                    return BlocBuilder<SwitchItemCubit, SwitchItemState>(
                        bloc: switchItemBloc,
                        builder: (context, showState) {
                          if (showState == SwitchItemState.LIST)
                            return DescoveryListWidget(
                                data: state.data,
                                onRefresh: () {
                                  _onRefresh();
                                });
                          else
                            return DescoveryGridWidget(
                              data: state.data,
                              onRefresh: () {
                                _onRefresh();
                              },
                            );
                        });
                  } else if (state is AllCompanyErrorState) {
                    return Center(
                        child: Container(
                      child: Text(state.message),
                    ));
                  } else
                    return ShimmerList();
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
