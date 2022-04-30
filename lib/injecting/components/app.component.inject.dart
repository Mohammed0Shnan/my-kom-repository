import 'package:my_kom/injecting/components/app.component.dart';
import 'package:my_kom/main.dart';
import 'package:my_kom/module_authorization/authorization_module.dart';
import 'package:my_kom/module_authorization/screens/login_screen.dart';
import 'package:my_kom/module_authorization/screens/register_screen.dart';
import 'package:my_kom/module_home/navigator_module.dart';
import 'package:my_kom/module_home/screen/home_screen.dart';
import 'package:my_kom/module_home/screen/navigator_screen.dart';
import 'package:my_kom/module_home/screen/shop_navigator_screen.dart';
import 'package:my_kom/module_info_and_splash/info_splash_module.dart';
import 'package:my_kom/module_info_and_splash/screen/next_splash_screen.dart';
import 'package:my_kom/module_profile/screen/profile_screen.dart';
import 'package:my_kom/module_shoping/screen/shop_screen.dart';
import 'package:my_kom/module_wrapper/wrapper.dart';
import 'package:my_kom/module_wrapper/wrapper_module.dart';


class AppComponentInjector implements AppComponent {
  AppComponentInjector._();

  static Future<AppComponent> create() async {
    final injector = AppComponentInjector._();
    return injector;
  }
  MyApp _createApp() => MyApp(
    
    _createWapperModule(),
    _createInfoSplashModule(),
    _createNavigatorModule(),
    _createAuthorizationModule(),
  );
  
  WapperModule _createWapperModule() => WapperModule(Wrapper());
  InfoSplashModule _createInfoSplashModule()=>InfoSplashModule(NextSplashScreen());
  NavigatorModule _createNavigatorModule()=>NavigatorModule(ShopNavigatorScreen(navigatorScreen: NavigatorScreen(homeScreen: HomeScreen(),profileScreen: ProfileScreen(),),shopScreen: ShopScreen(),));
  AuthorizationModule _createAuthorizationModule() => AuthorizationModule(LoginScreen(), RegisterScreen());
  MyApp get app {
    return _createApp();
  }
}
