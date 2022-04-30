import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:my_kom/consts/colors.dart';
import 'package:my_kom/module_home/screen/home_screen.dart';
import 'package:my_kom/module_profile/screen/profile_screen.dart';

class NavigatorScreen extends StatefulWidget {
  final HomeScreen homeScreen;
  final ProfileScreen profileScreen;
  NavigatorScreen(
      {required this.homeScreen, required this.profileScreen, Key? key})
      : super(key: key);

  @override
  State<NavigatorScreen> createState() => _NavigatorScreenState();
}

class _NavigatorScreenState extends State<NavigatorScreen> {
  int current_index = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _getAvtiveScreen(),
        bottomNavigationBar: CurvedNavigationBar(
          color: ColorsConst.mainColor,
          backgroundColor: Colors.white,
          onTap: (index) {
            current_index = index;
            setState(() {});
          },
          items: [
            Icon(Icons.home, color: Colors.white),
            Icon(Icons.person, color: Colors.white),
            Icon(
              Icons.settings,
              color: Colors.white,
            )
          ],
          animationDuration: Duration(milliseconds: 100),
          animationCurve: Curves.easeIn,
        ));
  }

  _getAvtiveScreen(){
    switch(current_index){
      case 0 : {
        return widget.homeScreen;
        
      }
           case 1 : {
        return widget.profileScreen;
        
      }
      
      
    }
  }
}
