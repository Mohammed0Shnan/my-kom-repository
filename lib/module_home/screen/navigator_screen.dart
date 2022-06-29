import 'package:flutter/material.dart';
import 'package:my_kom/consts/colors.dart';
import 'package:my_kom/module_home/screen/home_screen.dart';
import 'package:my_kom/module_home/screen/setting_screen.dart';
import 'package:my_kom/module_orders/ui/screens/captain_orders/captain_orders.dart';
import 'package:my_kom/module_profile/screen/profile_screen.dart';
import 'package:my_kom/module_shoping/screen/shop_screen.dart';
import 'package:my_kom/generated/l10n.dart';

class NavigatorScreen extends StatefulWidget {
  final HomeScreen homeScreen;
  final CaptainOrdersScreen orderScreen;
  final ProfileScreen profileScreen ;
  final ShopScreen shopScreen ;
  final SettingScreen settingScreen ;

  NavigatorScreen(
      {required this.homeScreen,required this.orderScreen,required this.profileScreen,
        required this.settingScreen,required this.shopScreen,
        Key? key})
      : super(key: key);

  @override
  State<NavigatorScreen> createState() => _NavigatorScreenState();
}

class _NavigatorScreenState extends State<NavigatorScreen> {
  int current_index = 0;
  @override
  void initState() {

    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(

        body: _getActiveScreen(),


        bottomNavigationBar: Container(
          margin: EdgeInsets.only(bottom: 6,right: 8,left: 8),
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(

            borderRadius: BorderRadius.all(Radius.circular(10)),

            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                offset: Offset(0,-2),
                blurRadius: 5,
                spreadRadius: 1
              )
            ]
          ),
          child: BottomNavigationBar(
            selectedItemColor: Colors.white,

              unselectedItemColor: Colors.white,
              selectedIconTheme:IconThemeData(
                size: 30
              ) ,
              unselectedIconTheme:IconThemeData(
                  size: 20,
                color: Colors.white.withOpacity(0.5)
              ) , 
              showSelectedLabels: true,
              showUnselectedLabels: true,

              currentIndex: current_index,
            onTap: (index){
                  current_index = index;
                  setState(() {});
            },
            items: [
              BottomNavigationBarItem(
                backgroundColor: ColorsConst.mainColor,
                label: S.of(context)!.home,
                icon: Icon(Icons.home_outlined)),
              BottomNavigationBarItem(label:  S.of(context)!.orders,icon: Icon(Icons.description_outlined),
                backgroundColor: ColorsConst.mainColor,
              ),
              BottomNavigationBarItem(label:  S.of(context)!.profile,icon: Icon(Icons.perm_identity),
                backgroundColor: ColorsConst.mainColor,
              ),
              BottomNavigationBarItem(label:  S.of(context)!.ship,icon: Icon(Icons.shopping_cart_outlined),
                backgroundColor: ColorsConst.mainColor,
              ),
              BottomNavigationBarItem(label:  S.of(context)!.more,icon: Icon(Icons.widgets_outlined),
                backgroundColor: ColorsConst.mainColor,),
            ],
          ),
        ),

    );
  }
 Color _getNavItemColor(){
   if(current_index ==0)
     return Colors.blue;

   else if(current_index == 1)
     return Colors.red;

   else if(current_index == 2)
     return Colors.amberAccent;


   else
     return Colors.purpleAccent;
 }
 _getActiveScreen(){
    switch(current_index){
      case 0 : {
        return widget.homeScreen;
      }
       case 1 : {
           return widget.orderScreen;
      }
      case 2 : {
          return widget.profileScreen;
      }
      case 3 : {
        return widget.shopScreen;
      }
      case 4:{
        return widget.settingScreen;
      }
    }
  }
}
