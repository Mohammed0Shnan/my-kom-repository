import 'package:my_kom/injecting/components/app.component.dart';
import 'package:my_kom/main.dart';
import 'package:my_kom/module_about/about_module.dart';
import 'package:my_kom/module_about/service/about_service.dart';
import 'package:my_kom/module_authorization/authorization_module.dart';
import 'package:my_kom/module_authorization/screens/login_screen.dart';
import 'package:my_kom/module_authorization/screens/register_screen.dart';
import 'package:my_kom/module_authorization/service/auth_service.dart';
import 'package:my_kom/module_company/company_module.dart';
import 'package:my_kom/module_company/screen/company_products_screen.dart';
import 'package:my_kom/module_home/navigator_module.dart';
import 'package:my_kom/module_home/screen/home_screen.dart';
import 'package:my_kom/module_home/screen/navigator_screen.dart';
import 'package:my_kom/module_home/screen/shop_navigator_screen.dart';
import 'package:my_kom/module_map/map_module.dart';
import 'package:my_kom/module_map/screen/map_screen.dart';
import 'package:my_kom/module_profile/screen/profile_screen.dart';
import 'package:my_kom/module_shoping/screen/shop_screen.dart';
import 'package:my_kom/module_splash/screen/splash_screen.dart';
import 'package:my_kom/module_splash/splash_module.dart';
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
      _createAboutModule(),
      _createSplashModule(),
      _createNavigatorModule(),
      _createAuthorizationModule(),
      _createMapModule(),
      _createCompanyModule()
      );

  WapperModule _createWapperModule() => WapperModule(Wrapper());
  AboutModule _createAboutModule() => AboutModule();
  SplashModule _createSplashModule() =>
      SplashModule(SplashScreen(AuthService(), AboutService()));
  NavigatorModule _createNavigatorModule() =>
      NavigatorModule(ShopNavigatorScreen(
        navigatorScreen: NavigatorScreen(
          homeScreen: HomeScreen(),
          profileScreen: ProfileScreen(),
        ),
        shopScreen: ShopScreen(),
      ));
  AuthorizationModule _createAuthorizationModule() =>
      AuthorizationModule(LoginScreen(), RegisterScreen());
  MapModule _createMapModule() => MapModule(MapScreen());

  CompanyModule _createCompanyModule()=> CompanyModule(CompanyProductScreen(company: null,));
  MyApp get app {
    return _createApp();
  }
}
