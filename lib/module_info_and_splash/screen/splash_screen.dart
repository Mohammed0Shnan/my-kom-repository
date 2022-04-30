import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:my_kom/consts/colors.dart';
import 'package:my_kom/module_info_and_splash/screen/next_splash_screen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
        splash: Container(
          color: Colors.white,
          width: 50,
          height: 50,
        ),
        backgroundColor: ColorsConst.Splash,
        animationDuration: Duration(milliseconds: 200),
        duration: 900,
        centered: true,
        curve: Curves.easeInOut,

        splashIconSize: 50,

        splashTransition: SplashTransition.fadeTransition,
        nextScreen: const NextSplashScreen());
  }
}
