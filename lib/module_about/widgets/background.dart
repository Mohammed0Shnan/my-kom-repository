import 'package:flutter/material.dart';
import 'package:my_kom/module_about/widgets/custom_clipper.dart';
import 'package:my_kom/utils/size_configration/size_config.dart';

class Background extends StatelessWidget {
  final Widget child;
  Background({required this.child});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: SafeArea(
        child: Stack(
          
          children: [
            Positioned(
              bottom:- SizeConfig.screenHeight * 0.15,
              left: 0,
              right: 0,
              child: Container(
                height: SizeConfig.screenWidth ,
                width:  SizeConfig.screenWidth,
                decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    shape: BoxShape.circle),
              ),
            ),
            BottomCustomClipperWidget(),
            child
          ],
        ),
      ),
    );
  }
}
