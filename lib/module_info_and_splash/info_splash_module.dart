import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:my_kom/abstracts/module/my_module.dart';
import 'package:my_kom/module_info_and_splash/info_splash_routes.dart';
import 'package:my_kom/module_info_and_splash/screen/next_splash_screen.dart';

class InfoSplashModule extends MyModule {
  final NextSplashScreen _nextSplashScreen;
  InfoSplashModule(this._nextSplashScreen);
  @override
  Map<String, WidgetBuilder> getRoutes() => {
        InfoSplashRoutes.NEXT_SPLASH_SCREEN: (context) => this._nextSplashScreen
      };
}
