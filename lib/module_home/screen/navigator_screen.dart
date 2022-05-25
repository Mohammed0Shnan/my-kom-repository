import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:my_kom/consts/colors.dart';
import 'package:my_kom/module_authorization/authorization_routes.dart';
import 'package:my_kom/module_authorization/service/auth_service.dart';
import 'package:my_kom/module_home/screen/home_screen.dart';
import 'package:my_kom/module_orders/ui/screens/captain_orders/captain_orders.dart';

class NavigatorScreen extends StatefulWidget {
  final HomeScreen homeScreen;
  final CaptainOrdersScreen orderScreen;
  NavigatorScreen(
      {required this.homeScreen,required this.orderScreen, Key? key})
      : super(key: key);

  @override
  State<NavigatorScreen> createState() => _NavigatorScreenState();
}

class _NavigatorScreenState extends State<NavigatorScreen> {
  int current_index = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(

        body: _getActiveScreen(),

        bottomNavigationBar: CurvedNavigationBar(
          color: ColorsConst.mainColor,
          backgroundColor: Colors.white,
          onTap: (index) {
            current_index = index;
            setState(() {});
          },
          items: [
            Icon(Icons.home, color: Colors.white),
            Icon(Icons.list, color: Colors.white),
            Icon(
              Icons.border_outer_rounded,
              color: Colors.white,
            ),
          
          ],
          animationDuration: Duration(milliseconds: 100),
          animationCurve: Curves.easeIn,
        ));
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
        return Scaffold(
          body: Center(child: TextButton(
            onPressed: (){
              AuthService().logout().then((value) {
                Navigator.pushNamed(context, AuthorizationRoutes.LOGIN_SCREEN);
              });
            },
            child: Text('Logout'),
          ),),
        );
      }
      
      
    }
  }
}
