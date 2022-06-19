import 'package:flutter/material.dart';
import 'package:my_kom/consts/colors.dart';
import 'package:my_kom/module_authorization/service/auth_service.dart';
import 'package:my_kom/module_home/screen/home_screen.dart';
import 'package:my_kom/module_home/screen/setting_screen.dart';
import 'package:my_kom/module_orders/ui/screens/captain_orders/captain_orders.dart';
import 'package:my_kom/module_profile/screen/profile_screen.dart';

class NavigatorScreen extends StatefulWidget {
  final HomeScreen homeScreen;
  final CaptainOrdersScreen orderScreen;
  final ProfileScreen _profileScreen = ProfileScreen();
  final SettingScreen _settingScreen = SettingScreen();
  final AuthService _authService = AuthService();

  NavigatorScreen(
      {required this.homeScreen,required this.orderScreen, Key? key})
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

          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(

            borderRadius: BorderRadius.only(topLeft: Radius.circular(20),
            topRight:  Radius.circular(20),

            ),
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
                label: 'Home',
                icon: Icon(Icons.home_outlined)),
              BottomNavigationBarItem(label: 'Orders',icon: Icon(Icons.description_outlined),
                backgroundColor: ColorsConst.mainColor,
              ),
              BottomNavigationBarItem(label: 'profile',icon: Icon(Icons.perm_identity),
                backgroundColor: ColorsConst.mainColor,
              ),
              BottomNavigationBarItem(label: 'More',icon: Icon(Icons.widgets_outlined),

                backgroundColor: ColorsConst.mainColor,),

            ],
          ),
        ),
        // bottomNavigationBar: CurvedNavigationBar(
        //   color: ColorsConst.mainColor,
        //   backgroundColor: Colors.grey.shade50,
        //   onTap: (index) {
        //     current_index = index;
        //     setState(() {});
        //   },
        //   items: [
        //     Icon(Icons.home, color: Colors.white),
        //     Icon(Icons.list, color: Colors.white),
        //     Icon(
        //       Icons.notifications,
        //       color: Colors.white,
        //     ),
        //   ],
        //   animationDuration: Duration(milliseconds: 100),
        //   animationCurve: Curves.easeIn,
        // )

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
          return widget._profileScreen;

      }
      case 3:{
        return widget._settingScreen;
      }
    }
  }
}
