import 'dart:math';

import 'package:my_kom/module_info_and_splash/screen/next_splash_screen.dart';
import 'package:my_kom/module_info_and_splash/screen/splash_screen.dart';
import 'package:my_kom/utils/auth_guard/auth_gard.dart';
import 'package:my_kom/utils/back_ground/background.dart';
import 'package:my_kom/utils/size_configration/size_config.dart';
import 'package:flutter/material.dart';
import 'package:my_kom/module_info_and_splash/widgets/wave_loading.dart';

class Wrapper extends StatelessWidget {
  //final AuthGuard _authGuard = AuthGuard(SharedPreferencesHelper());
  final AuthGuard _authGuard = AuthGuard();
  // final Welcome _welcome;
  // final HomeScreen _homeScreen;
  // Wrapper(this._welcome, this._homeScreen);
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(MediaQuery.of(context).size);
    //   return _welcome;
    return FutureBuilder<bool>(
        initialData: null,
        future: _authGuard.isLoggedIn(),
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          if (snapshot.data == null) {
           return Container();
          } else {
            if (snapshot.data!) {
              return SplashScreen();     //_homeScreen;
            } else {
              return Container(
                color: Colors.red,
                child: Center(
                  child: Text('Login'),
                ),
              ); //_welcome;
            }
          }
        });
  }
}

