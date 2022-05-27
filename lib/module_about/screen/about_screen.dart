import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
    'https://assets4.lottiefiles.com/packages/lf20_lv0auvzz.json',
    'https://assets10.lottiefiles.com/packages/lf20_2h7yicxc.json',
    'https://assets1.lottiefiles.com/packages/lf20_HBXF2O.json',
    'https://assets9.lottiefiles.com/packages/lf20_yZpLO2.json'
  ];
  final List<String> pageTitleInformations = [
    'About MyKom',
    'Pay easily',
    'Shipping',
    'Wallet'
  ];
  final List<String> pageSubTitleInformations = [
    'It is an application dedicated to helping you order your water from all companies and provides delivery to all Emirates',
    'Payment in MyKom is easy and safe because it is through the application ',
    'MyKom can deliver you anywhere in the Emirates quickly and easily',
    'you can keep the money in your wallet inside the application'
  ];

  int currentIndex =0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Background(
        child: Stack(
          
          alignment: Alignment.center,
          children: [
            Positioned.fill(
              child: PageView.builder(
                onPageChanged: (index){
                  currentIndex = index;
                  setState(() {

                  });
                },
                controller: _pageController,
                itemCount: 4,
                itemBuilder: (context, index) {
                  return BlocBuilder<PageViewAnimationBloc, double>(
                    bloc: bloc,
                    builder: (context, state) {
                      return Opacity(
                        opacity: max(1 - (state - index).abs(), 0),
                        child: Page(
                          title: index == 0 ? Container(
                            height: SizeConfig.titleSize * 5,
                            child: Image.asset('assets/logo1.png',fit: BoxFit.contain,)): Text(''),
                          lottieUrl: LottieUrls[index],
                          color: Colors.transparent,
                          infoTitle: pageTitleInformations[index],
                          infoSubTitle: pageSubTitleInformations[index],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            Positioned(
                top: 20,
                right: 20,
                child: TextButton(
                  child: Text('Skip'),
                  onPressed: () async{
                      AboutService().setInited();
                    // Navigator.pushNamed(
                    //     context, NavigatorRoutes.NAVIGATOR_SCREEN);
                    Navigator.pushNamed(
                        context, AuthorizationRoutes.REGISTER_SCREEN);
                  },
                )),
            Positioned(
              bottom: SizeConfig.screenHeight * 0.16,
              child: SmoothPageIndicator(
                controller: _pageController,
                count: 4,
                effect: JumpingDotEffect(
                    dotColor: Colors.black12,
                    dotHeight: 8,
                    dotWidth: 25,
                    spacing: 2,
                    jumpScale: 2,
                    activeDotColor: ColorsConst.mainColor),
              ),
            ),
            Positioned(
                bottom: 20,
                right: 20,
                child: TextButton(
                  child:currentIndex == 3? Text('Get Started',style: TextStyle(color: Colors.white)) :Text('Next',style: TextStyle(color: Colors.white),),
                  onPressed: () async{
                    if (_pageController.page == 3) {
                      AboutService().setInited();
                      Navigator.pushNamed(
                          context, NavigatorRoutes.NAVIGATOR_SCREEN);
                    } else {
                      _pageController.nextPage(
                          duration: Duration(milliseconds: 400),
                          curve: Curves.ease);
                    }
                  },
                ))
          ],
        ),
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
      height: SizeConfig.screenHeight * 0.4,
      color: color,
      child: Column(children: [
        Flexible(
          flex: 4,
          child: Column(
            children: [
              Container(
                  height: SizeConfig.screenHeight * .4,
                  child: Lottie.network(lottieUrl)),
                  title
            ,
              Spacer()
            ],
          ),
        ),
       
        Flexible(
          flex: 3,
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: SizeConfig.screenHeight * 0.02,
                ),
                Text(
                  infoTitle,
                  style: GoogleFonts.lato(
                    fontSize: SizeConfig.titleSize * 3.5,
                    fontWeight: FontWeight.bold,
                    color: Colors.red

                  )
                ),
                SizedBox(
                  height: 20,
                ),
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
            ),
          ),
        ),
      ]),
    );
  }
}
