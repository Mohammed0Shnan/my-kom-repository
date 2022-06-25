
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:my_kom/consts/colors.dart';
import 'package:my_kom/module_authorization/authorization_routes.dart';
import 'package:my_kom/module_authorization/service/auth_service.dart';
import 'package:my_kom/module_dashbord/screen/add_products_screen.dart';
import 'package:my_kom/module_dashbord/screen/add_store_screen.dart';
import 'package:my_kom/module_dashbord/screen/all_store_screen.dart';
import 'package:my_kom/module_dashbord/screen/statistacses_screen.dart';
import 'package:my_kom/module_dashbord/screen/users_screen.dart';
import 'package:my_kom/module_home/screen/home_screen.dart';
import 'package:my_kom/module_notifications/service/fire_notification_service/fire_notification_service.dart';
import 'package:my_kom/module_orders/ui/screens/captain_orders/captain_orders.dart';
import 'package:my_kom/module_orders/ui/screens/owner_orders.dart';

class DashBoardScreen extends StatefulWidget {
  final OwnerOrdersScreen ordersScreen = OwnerOrdersScreen();
  final AddStoreScreen addStoreScreen = AddStoreScreen();
  final AllStoreScreen allStoreScreen = AllStoreScreen();
  final AddProductScreen _addProductScreen = AddProductScreen();
  final StatistacsesScreen _statistacsesScreen = StatistacsesScreen();
  final UsersScreen _usersScreen = UsersScreen();

  @override
  State<DashBoardScreen> createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<DashBoardScreen> {
  int current_index = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(

        body: _getActiveScreen(),

        bottomNavigationBar: CurvedNavigationBar(
          color: ColorsConst.mainColor,
          backgroundColor: Colors.grey.shade50,
          onTap: (index) {
            current_index = index;
            setState(() {});
          },
          items: [
            Icon(Icons.home, color: Colors.white),
            Icon(Icons.list, color: Colors.white),
            Icon(Icons.store, color: Colors.white),
            Icon(Icons.add_circle, color: Colors.white),
            Icon(Icons.baby_changing_station_sharp, color: Colors.white),
            Icon(Icons.person, color: Colors.white),
            Icon(
              Icons.logout,
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
        return widget.ordersScreen;

      }
      case 1 : {
        return widget.addStoreScreen;
      }
      case 2 : {        return widget.allStoreScreen;

      }
      case 3 : {        return widget._addProductScreen;

      }
      case 4 : {        return widget._statistacsesScreen;

      }
      case 5 : {        return widget._usersScreen;

      }
      case 6 : {
        return Scaffold(
          body:        Center(child: TextButton(
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
