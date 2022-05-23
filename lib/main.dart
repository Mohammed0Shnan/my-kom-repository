
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_kom/generated/l10n.dart';
import 'package:my_kom/injecting/components/app.component.dart';
import 'package:my_kom/module_about/about_module.dart';
import 'package:my_kom/module_authorization/authorization_module.dart';
import 'package:my_kom/module_company/company_module.dart';
import 'package:my_kom/module_home/navigator_module.dart';
import 'package:my_kom/module_localization/service/localization_service/localization_b;oc_service.dart';
import 'package:my_kom/module_orders/orders_module.dart';
import 'package:my_kom/module_profile/module_profile.dart';
import 'package:my_kom/module_shoping/shoping_module.dart';
import 'package:my_kom/module_splash/splash_module.dart';
import 'package:my_kom/module_splash/splash_routes.dart';
import 'package:my_kom/module_wrapper/wrapper_module.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'module_map/map_module.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final container = await AppComponent.create();
  BlocOverrides.runZoned(
    () {
      return runApp(container.app);
    },
    blocObserver: AppObserver(),
  );
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.

 final LocalizationService _localizationService;
  final WapperModule _wapperModule;
  final SplashModule _splashModule;
  final AboutModule _aboutModule;
  final NavigatorModule _navigatorModule;
  final AuthorizationModule _authorizationModule;
  final MapModule _mapModule;
  final CompanyModule _companyModule;
  final ShopingModule _shopingModule;
  final OrdersModule _ordersModule;
  final ProfileModule _profileModule;
  MyApp(this._localizationService,this._wapperModule, this._aboutModule,this._splashModule, this._navigatorModule,
      this._authorizationModule,this._mapModule, this._companyModule,this._shopingModule,this._ordersModule,this._profileModule);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    Map<String, WidgetBuilder> routes = {};
    routes.addAll(widget._wapperModule.getRoutes());
    routes.addAll(widget._aboutModule.getRoutes());
    routes.addAll(widget._splashModule.getRoutes());
    routes.addAll(widget._navigatorModule.getRoutes());
    routes.addAll(widget._authorizationModule.getRoutes());
    routes.addAll(widget._mapModule.getRoutes());
    routes.addAll(widget._companyModule.getRoutes());
        routes.addAll(widget._shopingModule.getRoutes());
    routes.addAll(widget._ordersModule.getRoutes());
    routes.addAll(widget._profileModule.getRoutes());

    return FutureBuilder<Widget>(
      initialData: Container(color: Colors.green),
      future: configuratedApp(routes),
      builder: (BuildContext context, AsyncSnapshot<Widget> snapshot) {
        return snapshot.data!;
      },
    );
  }

  Future<Widget> configuratedApp(Map<String, WidgetBuilder> routes) async {
    return BlocBuilder<LocalizationService, LocalizationState>(
        bloc: widget._localizationService,
        builder: (context, state) {
          String language;
          if (state is LocalizationArabicState) {
            language = 'ar';
          } else {
            language = 'en';
          }
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'My Kom',
            routes: routes,
            locale: Locale.fromSubtags(
              languageCode: language,
            ),
            localizationsDelegates: [
              S.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: S.delegate.supportedLocales,
              initialRoute: SplashRoutes.SPLASH_SCREEN
          );
        });
  }
  @override
  void dispose() {
    widget._localizationService.close();
    super.dispose();
  }
}

class AppObserver extends BlocObserver {
  @override
  void onCreate(BlocBase bloc) {
    print(bloc);
    super.onCreate(bloc);
  }

  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
  }

  @override
  void onClose(BlocBase bloc) {
    print(bloc);
    super.onClose(bloc);
  }
}
