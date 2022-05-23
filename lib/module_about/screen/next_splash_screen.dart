import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_kom/module_about/animations/fade_animation.dart';
import 'package:my_kom/module_about/animations/scale_animation.dart';
import 'package:my_kom/module_about/bloc/splash_animation_bloc.dart';
import 'package:my_kom/module_about/screen/language_screen.dart';
import 'package:my_kom/module_about/widgets/wave_loading.dart';
import 'package:my_kom/module_localization/service/localization_service/localization_b;oc_service.dart';
import 'package:my_kom/utils/size_configration/size_config.dart';

class NextSplashScreen extends StatefulWidget {
  LocalizationService localizationService;
   NextSplashScreen({required this.localizationService, Key? key}) : super(key: key);

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
      backgroundColor: Colors.grey.shade100,
      body: SafeArea(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              height: SizeConfig.screenHeight,
            ),
            Positioned(
              top: SizeConfig.screenHeight * 0.1,
              child: ScaleAnimation(
                duration: 300,
                child: 
                
               Container(
                 height: 31.25 * SizeConfig.heightMulti,
                 width: 31.25 * SizeConfig.heightMulti,
                 clipBehavior: Clip.antiAlias,
                 decoration: BoxDecoration(
                   shape: BoxShape.circle
                 ),
                child: Image.asset('assets/logo3.png',fit: BoxFit.cover,)
               )
              ),
            ),
            Container(
              width: SizeConfig.screenWidth * 0.54,
              margin: EdgeInsets.symmetric(horizontal: SizeConfig.screenWidth * 0.23),
              child: BlocConsumer<SpalshAnimationBloC, bool>(
                bloc: spalshAnimationBloC,
                listener: (context, state) {},
                builder: (context, state) {
                  double current_width = 0;
                  if (state) {
                    current_width = SizeConfig.screenWidth * 0.4;
                  } else
                    current_width = 0;

                  return Row(
                    children: [
                      CustomFadeAnimation(
                        child: AnimatedContainer(
                          alignment: Alignment.centerLeft,
                          duration: Duration(milliseconds: 300),
                          child: Container(
                            color: Colors.red,
                          child: Image.asset('assets/logo1.png',
                            fit: BoxFit.cover,
                          ),
                          ),
                          height: 7.8 * SizeConfig.heightMulti,
                          width: current_width,
                        ),
                      ),
                      Container(
                        height: 8.2 * SizeConfig.heightMulti,
                        width: SizeConfig.screenWidth * 0.12,
                        color: Colors.white,
                      child: Image.asset('assets/logo2.png',fit: BoxFit.contain,),
                      )
                    ],
                  );
                },
              ),
            ),

            Positioned(
              left: -SizeConfig.widhtMulti * 10,
              right: -SizeConfig.widhtMulti * 10,
              bottom: -SizeConfig.screenHeight / 3,
              child: BlocConsumer<SpalshAnimationBloC, bool>(
                bloc: spalshAnimationBloC,
                listener: (context, state) {
                  if (state) {
                        Future.delayed(Duration(seconds: 2),(){
                        return  Navigator.push(context, PageRouteBuilder(
                      transitionDuration: Duration(milliseconds: 500),
                      pageBuilder: (context,animation,seondryAnimation){
                      return LanguageScreen(localizationService: widget.localizationService,);
                    })

                    );

                        });
                  }
                },
                builder: (context, state) {
                  return Material(
                          color: Colors.grey.shade100,

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
