import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_kom/consts/colors.dart';
import 'package:my_kom/module_about/service/about_service.dart';
import 'package:my_kom/module_authorization/authorization_routes.dart';
import 'package:my_kom/module_home/navigator_routes.dart';
import 'package:my_kom/module_about/bloc/page_view_animation_bloc.dart';
import 'package:my_kom/module_about/widgets/background.dart';
import 'package:my_kom/utils/size_configration/size_config.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:lottie/lottie.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({Key? key}) : super(key: key);

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  late final _pageController ;
  late PageViewAnimationBloc bloc;
  @override
  void initState() {
    _pageController = PageController(
      initialPage: 0,
    );
    bloc = PageViewAnimationBloc(_pageController);
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    bloc.close();
    super.dispose();
  }

  final List<String> LottieUrls = [
    'assets/page2.png',
    'assets/page3.png',
  'assets/page1.png'

  ];
  final List<String> pageTitleInformations = [
    'BRINGS YOUR IDEA LIFE',
    'Pay easily',
    'Shipping',

  ];
  final List<String> pageSubTitleInformations = [
    'It is an application dedicated to helping you order your water from all companies and provides delivery to all Emirates',
    'Payment in MyKom is easy and safe because it is through the application ',
    'MyKom can deliver you anywhere in the Emirates quickly and easily',
  ];

  int currentIndex =0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Stack(

        alignment: Alignment.center,
        children: [
          Container(
            height: SizeConfig.screenHeight,
            width: SizeConfig.screenWidth,
            color: Colors.white,
          ),
          Positioned(
            top: SizeConfig.screenHeight * 0.25,
            child: Container(
              height: SizeConfig.screenHeight,
              width: SizeConfig.screenWidth,
              child: PageView.builder(
                onPageChanged: (index){
                  currentIndex = index;
                  setState(() {

                  });
                },
                controller: _pageController,
                itemCount: 3,
                itemBuilder: (context, index) {
                  return BlocBuilder<PageViewAnimationBloc, double>(
                    bloc: bloc,
                    builder: (context, state) {
                      return Opacity(
                        opacity: max(1 - (state - index).abs(), 0),
                        child: Container(
                            height: SizeConfig.screenHeight,
                            width: SizeConfig.screenWidth,
                            child: Page(

                              title: Text(pageTitleInformations[index]),
                              lottieUrl: LottieUrls[index],
                              color: Colors.transparent,
                              infoTitle: pageTitleInformations[index],
                              infoSubTitle: pageSubTitleInformations[index],
                            ),
                           // child: Image.asset(LottieUrls[index],fit: BoxFit.fill,)

                        ),
                        // child: Page(
                        //
                        //   title: index == 0 ? Container(
                        //     height: SizeConfig.titleSize * 5,
                        //     child: Image.asset('assets/logo1.png',fit: BoxFit.contain,)): Text(''),
                        //   lottieUrl: LottieUrls[index],
                        //   color: Colors.transparent,
                        //   infoTitle: pageTitleInformations[index],
                        //   infoSubTitle: pageSubTitleInformations[index],
                        // ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
          Positioned(top: -SizeConfig.screenHeight* 0.4,
          right: 0,
          left: 0,
            child: Container(
              height: SizeConfig.screenHeight* 0.6,
              width: SizeConfig.screenWidth,
              decoration: BoxDecoration(
                color: ColorsConst.mainColor,
                shape: BoxShape.circle

              ),

            ),
          ),
          Positioned(top: SizeConfig.screenHeight* 0.05,
            right: SizeConfig.screenWidth * 0.24,
            left: SizeConfig.screenWidth * 0.24,
            child:Container(
              height:55,
              child: Image.asset('assets/new_logo.png',fit: BoxFit.fill,),
            )
          ),
          // Positioned(
          //     top: 100,
          //
          //     child: Container(
          //     width:  SizeConfig.screenWidth * 0.4,
          //       child: Image.asset('assets/new_logo.png',
          //         fit: BoxFit.cover,
          //       ),
          //     ),
          // ),
          Positioned(
            bottom: SizeConfig.screenHeight * 0.12,
            child: SmoothPageIndicator(
              controller: _pageController,
              count: 3,
              effect: JumpingDotEffect(
                  dotColor: Colors.grey.shade400,
                  dotHeight:7,
                  dotWidth: 25,
                  spacing: 2,
                  jumpScale: 2,
                  activeDotColor:ColorsConst.mainColor),
            ),
          ),
          Positioned(
              bottom: 10,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: (){
                      Navigator.pushNamed(
                          context, NavigatorRoutes.NAVIGATOR_SCREEN);
                    },
                    child: Container(
                        alignment: Alignment.center,
                        height: 60,
                        width: SizeConfig.screenWidth * 0.2,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(bottomRight: Radius.circular(30),
                                topRight: Radius.circular(30)
                            ),
                            color: ColorsConst.mainColor
                        ),
                        child: Text('SKIP',style: GoogleFonts.lato(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.bold
                        ),)
                    ),
                  ),

                  GestureDetector(
                    onTap: (){
                      if (_pageController.page == 2) {
                        AboutService().setInited();
                        Navigator.pushNamed(
                            context, NavigatorRoutes.NAVIGATOR_SCREEN);
                      } else {
                        _pageController.nextPage(
                            duration: Duration(milliseconds: 400),
                            curve: Curves.ease);
                      }

                    },
                    child: Container(
                        alignment: Alignment.center,

                        height: 60,
                        width: SizeConfig.screenWidth * 0.2,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(topLeft: Radius.circular(30),
                                bottomLeft: Radius.circular(30)
                            ),
                            color: ColorsConst.mainColor
                        ),
                        child: Text('NEXT',style: GoogleFonts.lato(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.bold
                        ))
                    ),
                  ),
                ],
              )),

        ],
      ),
    );
  }
}

class Page extends StatelessWidget {
  final Color color;
  final Widget title;
  final String infoTitle;
  final String infoSubTitle;
  final String lottieUrl;

  const Page(
      {required this.title,
      required this.infoTitle,
      required this.infoSubTitle,
      required this.lottieUrl,
      required this.color,

      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: SizeConfig.screenWidth,
      height: SizeConfig.screenHeight ,
      child:Column(
        children: [
          Container(
            height: SizeConfig.screenHeight * 0.3,
            child: Image.asset(lottieUrl),
          ),
          SizedBox(height: 40,),
                    Text(
                      infoTitle,
                      style: GoogleFonts.lato(
                        fontSize: SizeConfig.titleSize * 3.5,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87

                      )
                    ),
                    SizedBox(height: 20,),
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: SizeConfig.heightMulti * 6),
                      child: Text(
                        infoSubTitle,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.lato(

                          fontSize: SizeConfig.titleSize * 2.4,
                          fontWeight: FontWeight.w600,
                          color: Colors.black54


                        ),
                      ),
                    ),
        ],
      )
      // child: Column(children: [
      //   Flexible(
      //     flex: 4,
      //     child: Column(
      //       children: [
      //         Container(
      //             height: SizeConfig.screenHeight * .4,
      //             child: Lottie.network(lottieUrl)),
      //
      //
      //         Spacer()
      //       ],
      //     ),
      //   ),
      //
      //   Flexible(
      //     flex: 3,
      //     child: Container(
      //       child: Column(
      //         crossAxisAlignment: CrossAxisAlignment.center,
      //         children: [
      //           SizedBox(
      //             height: SizeConfig.screenHeight * 0.02,
      //           ),
      //           Text(
      //             infoTitle,
      //             style: GoogleFonts.lato(
      //               fontSize: SizeConfig.titleSize * 3.5,
      //               fontWeight: FontWeight.bold,
      //               color: Colors.white
      //
      //             )
      //           ),
      //           SizedBox(
      //             height: 20,
      //           ),
      //           Container(
      //             padding: EdgeInsets.symmetric(
      //                 horizontal: SizeConfig.heightMulti * 6),
      //             child: Text(
      //               infoSubTitle,
      //               textAlign: TextAlign.center,
      //               style: GoogleFonts.lato(
      //
      //                 fontSize: SizeConfig.titleSize * 2.4,
      //                 fontWeight: FontWeight.w600,
      //                 color: Colors.white.withOpacity(0.7)
      //
      //
      //               ),
      //             ),
      //           ),
      //         ],
      //       ),
         // ),
      //  ),
      //]),
    );
  }
}
