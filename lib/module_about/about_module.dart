
import 'package:flutter/src/widgets/framework.dart';
import 'package:my_kom/abstracts/module/my_module.dart';
import 'package:my_kom/module_about/about_routes.dart';
import 'package:my_kom/module_about/screen/about_screen.dart';
import 'package:my_kom/module_about/screen/next_splash_screen.dart';

class AboutModule extends MyModule {
  NextSplashScreen _nextSplashScreen;
  AboutModule(this._nextSplashScreen);
  @override
  Map<String, WidgetBuilder> getRoutes() {
    return {  AboutRoutes.ROUTE_ABOUT: (context) => _nextSplashScreen};
  }
 
  }
