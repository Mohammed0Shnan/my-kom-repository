import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_kom/module_about/animations/fade_animation.dart';
import 'package:my_kom/module_about/animations/scale_animation.dart';
import 'package:my_kom/module_about/bloc/splash_animation_bloc.dart';
import 'package:my_kom/module_about/screen/language_screen.dart';
import 'package:my_kom/module_about/widgets/wave_loading.dart';
import 'package:my_kom/utils/size_configration/size_config.dart';

class NextSplashScreen extends StatefulWidget {
  const NextSplashScreen({Key? key}) : super(key: key);

  @override
  State<NextSplashScreen> createState() => _NextSplashScreenState();
}

class _NextSplashScreenState extends State<NextSplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 1), () {
      spalshAnimationBloC.playAnimation();
    });
  }
  @override
  void dispose() {
    spalshAnimationBloC.close();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(MediaQuery.of(context).size);

    return Scaffold(
      body: SafeArea(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              height: SizeConfig.screenHeight,
            ),
            Positioned(
              top: SizeConfig.screenHeight * 0.1,
              child:const ScaleAnimation(
                duration: 300,
                child: CircleAvatar(
                  radius: 100,
                ),
              ),
            ),
            BlocConsumer<SpalshAnimationBloC, bool>(
              bloc: spalshAnimationBloC,
              listener: (context, state) {},
              builder: (context, state) {
                double current_width = 0;
                if (state) {
                  current_width = SizeConfig.screenWidth * 0.4;
                } else
                  current_width = 0;

                return Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: SizeConfig.screenWidth * 0.25),
                  child: Row(
                    children: [
                      CustomFadeAnimation(
                        child: AnimatedContainer(
                          alignment: Alignment.centerLeft,
                          duration: Duration(milliseconds: 300),
                          child: const Center(
                              child: Text(
                            'M Y  K O M',
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(color: Colors.blue, fontSize: 30),
                          )),
                          height: 50,
                          width: current_width,
                        ),
                      ),
                      Container(
                        height: 50,
                        width: SizeConfig.screenWidth * 0.1,
                        color: Colors.blue,
                      )
                    ],
                  ),
                );
              },
            ),

            Positioned(
              left: -SizeConfig.widhtMulti * 10,
              right: -SizeConfig.widhtMulti * 10,
              bottom: -SizeConfig.screenWidth / 2,
              child: BlocConsumer<SpalshAnimationBloC, bool>(
                bloc: spalshAnimationBloC,
                listener: (context, state) {
                  if (state) {
                        Future.delayed(Duration(seconds: 2),(){
                        return  Navigator.push(context, PageRouteBuilder(
                      transitionDuration: Duration(milliseconds: 500),
                      pageBuilder: (context,animation,seondryAnimation){
                      return LanguageScreen();
                    })
                    
                    );
             
                        });
                  }
                },
                builder: (context, state) {
                  return Material(
                    child: Hero(
                      tag: 'logo',
                      child: WaveLoadingWidget(
                        container_height: SizeConfig.screenWidth + 100,
                        container_width: SizeConfig.screenWidth + 100,
                        run: true,
                      ),
                    ),
                  );
                },
              ),
            )
            // Positioned(

            //   left: -SizeConfig.widhtMulti * 10,
            //   right: -SizeConfig.widhtMulti * 10,
            //   bottom: -SizeConfig.screenWidth / 2,
            //   child:
            //    WaveLoadingWidget(

            //     run: true,
            //     container_height: SizeConfig.screenWidth + 100,
            //     container_width: SizeConfig.screenWidth + 100,
            //   ),
            // )
          ],
        ),
      ),
    );
  }
}
