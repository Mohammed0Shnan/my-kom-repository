import 'package:my_kom/injecting/components/app.component.dart';
import 'package:my_kom/main.dart';
import 'package:my_kom/module_about/about_module.dart';
import 'package:my_kom/module_about/screen/language_screen.dart';
import 'package:my_kom/module_about/service/about_service.dart';
import 'package:my_kom/module_authorization/authorization_module.dart';
import 'package:my_kom/module_authorization/screens/login_screen.dart';
import 'package:my_kom/module_authorization/screens/register_screen.dart';
import 'package:my_kom/module_authorization/service/auth_service.dart';
import 'package:my_kom/module_company/bloc/all_company_bloc.dart';
import 'package:my_kom/module_company/bloc/check_zone_bloc.dart';
import 'package:my_kom/module_company/bloc/recomended_products_bloc.dart';
import 'package:my_kom/module_company/company_module.dart';
import 'package:my_kom/module_company/screen/company_products_screen.dart';
import 'package:my_kom/module_company/screen/products_detail_screen.dart';
import 'package:my_kom/module_company/service/company_service.dart';
import 'package:my_kom/module_dashbord/bloc/filter_zone_bloc.dart';
import 'package:my_kom/module_dashbord/dashboard_module.dart';
import 'package:my_kom/module_dashbord/screen/dash_bord_screen.dart';
import 'package:my_kom/module_home/navigator_module.dart';
import 'package:my_kom/module_home/screen/home_screen.dart';
import 'package:my_kom/module_home/screen/navigator_screen.dart';
import 'package:my_kom/module_home/screen/setting_screen.dart';
import 'package:my_kom/module_localization/service/localization_service/localization_b;oc_service.dart';
import 'package:my_kom/module_map/bloc/map_bloc.dart';
import 'package:my_kom/module_map/map_module.dart';
import 'package:my_kom/module_map/screen/map_screen.dart';
import 'package:my_kom/module_orders/orders_module.dart';
import 'package:my_kom/module_orders/ui/screens/captain_orders/captain_orders.dart';
import 'package:my_kom/module_orders/ui/screens/order_detail.dart';
import 'package:my_kom/module_orders/ui/screens/order_status/order_status_screen.dart';
import 'package:my_kom/module_orders/ui/screens/owner_orders.dart';
import 'package:my_kom/module_profile/module_profile.dart';
import 'package:my_kom/module_profile/screen/profile_screen.dart';
import 'package:my_kom/module_shoping/screen/shop_screen.dart';
import 'package:my_kom/module_shoping/shoping_module.dart';
import 'package:my_kom/module_splash/screen/splash_screen.dart';
import 'package:my_kom/module_splash/splash_module.dart';
import 'package:my_kom/module_wrapper/wrapper.dart';
import 'package:my_kom/module_wrapper/wrapper_module.dart';
class AppComponentInjector implements AppComponent {
  AppComponentInjector._();

  LocalizationService? _singletonLocalizationService;
  CompanyService? _singletonCompanyService;

  static Future<AppComponent> create() async {
    final injector = AppComponentInjector._();
    return injector;
  }

  MyApp _createApp() => MyApp(
      _createLocalizationService(),
      _createWapperModule(),
      _createAboutModule(),
      _createSplashModule(),
      _createNavigatorModule(),
      _createAuthorizationModule(),
      _createMapModule(),
      _createCompanyModule(),
      _createShopingModule(),
      _createOrderModule(),
      _createProfileModule(),
      _createDashBoard()
      );

  LocalizationService _createLocalizationService() =>
      _singletonLocalizationService ??= LocalizationService();
  WapperModule _createWapperModule() => WapperModule(Wrapper());
  AboutModule _createAboutModule() => AboutModule(LanguageScreen(localizationService: _singletonLocalizationService!,));
  SplashModule _createSplashModule() =>
      SplashModule(SplashScreen(AuthService(), AboutService()));
  NavigatorModule _createNavigatorModule() {
    _singletonCompanyService ??= CompanyService();
    return NavigatorModule( NavigatorScreen(
        homeScreen: HomeScreen(mapBloc: MapBloc(),filterZoneCubit: FilterZoneCubit(),allCompanyBloc: AllCompanyBloc(_singletonCompanyService!),
            recommendedProductsCompanyBloc: RecommendedProductsCompanyBloc(_singletonCompanyService!),
          checkZoneBloc: CheckZoneBloc(_singletonCompanyService!),
          isInit: true,
            ),
        orderScreen: CaptainOrdersScreen(),
        profileScreen: ProfileScreen(),
        shopScreen:ShopScreen(),
        settingScreen: SettingScreen(localizationService:_singletonLocalizationService!),
    ),
    );
  }

  AuthorizationModule _createAuthorizationModule() =>
      AuthorizationModule( LoginScreen(), RegisterScreen() );
  MapModule _createMapModule() => MapModule(MapScreen());
  ShopingModule _createShopingModule()=> ShopingModule(ShopScreen());
  OrdersModule _createOrderModule()=> OrdersModule( CaptainOrdersScreen(),OwnerOrdersScreen(),OrderDetailScreen(),OrderStatusScreen());
  ProfileModule _createProfileModule()=> ProfileModule(ProfileScreen());
  DashBoardModule _createDashBoard()=> DashBoardModule(DashBoardScreen());
  CompanyModule _createCompanyModule()=> CompanyModule(CompanyProductScreen(),PriductDetailScreen());
  MyApp get app {
    return _createApp();
  }
}
