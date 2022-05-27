
import 'package:flutter/material.dart';
import 'package:my_kom/consts/colors.dart';
import 'package:my_kom/module_about/about_routes.dart';
import 'package:my_kom/module_about/service/about_service.dart';
import 'package:my_kom/module_authorization/authorization_routes.dart';
import 'package:my_kom/module_authorization/enums/user_role.dart';
import 'package:my_kom/module_authorization/service/auth_service.dart';
import 'package:my_kom/module_dashbord/dashboard_routes.dart';
import 'package:my_kom/module_home/navigator_routes.dart';
import 'package:my_kom/utils/size_configration/size_config.dart';
import 'package:flutter_svg/flutter_svg.dart';
class SplashScreen extends StatefulWidget {
  final AuthService _authService;
   final AboutService _aboutService;
  // final ProfileService _profileService;

  SplashScreen(
    this._authService,
     this._aboutService,
    // this._profileService,
  );
 
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
       WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      _getNextRoute().then((route) async{
        await Future.delayed(Duration(seconds: 1));
        Navigator.of(context).pushNamedAndRemoveUntil(route, (route) => false);
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(MediaQuery.of(context).size);

    return Scaffold(
      backgroundColor: ColorsConst.mainColor,
      body: Center(
        child: Container(
            width: SizeConfig.imageSize * 10,
            height:  SizeConfig.imageSize * 10,
            color: Colors.white,
            child:SvgPicture.asset('assets/1.svg')// Image.asset('assets/logo2.png',fit: BoxFit.contain,),
          ),
      ),
//  AnimatedSplashScreen(
//         splash: Container(
//           color: Colors.white,
//           width: 50,
//           height: 50,
//         ),
//         backgroundColor: ColorsConst.Splash,
//         animationDuration: Duration(milliseconds: 200),
//         duration: 900,
//         centered: true,
//         curve: Curves.easeInOut,
//         function: () async{
//         await  _getNextRoute();
//         },
//         splashIconSize: 50,

//         splashTransition: SplashTransition.fadeTransition,
//         nextScreen: ,
//          )
    );
  }

  Future<String> _getNextRoute() async {
    try {
      var isInited = await widget._aboutService.isInited();
     //if (isInited) {
        return AboutRoutes.ROUTE_ABOUT;
      //  }

     // // Is LoggedIn
     //  UserRole? role = await widget._authService.userRole;
     //  if(role != null){
     //
     //    if (role == UserRole.ROLE_OWNER) {
     //      return DashboardRoutes.DASHBOARD_SCREEN;
     //      // return OrdersRoutes.OWNER_ORDERS_SCREEN;
     //    }  else{
     //      return NavigatorRoutes.NAVIGATOR_SCREEN;
     //      //return OrdersRoutes.CAPTAIN_ORDERS_SCREEN;
     //    }
     //  }
     //
     //  // Is Not LoggedInt
     // else {
     //     return NavigatorRoutes.NAVIGATOR_SCREEN;
     //  //  return AuthorizationRoutes.LOGIN_SCREEN;
     //  }
    } catch (e) {
      return AboutRoutes.ROUTE_ABOUT;  // about screen
    }
  }
}


