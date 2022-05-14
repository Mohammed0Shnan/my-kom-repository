import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:my_kom/utils/size_configration/size_config.dart';

class BottomCustomClipperWidget extends StatelessWidget {
  const BottomCustomClipperWidget({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(children: [
      
        Positioned(
          bottom: 0,
        left: 0,
        right: 0,
        child:   ClipPath(
        child: Container(
        height: 18 * SizeConfig.heightMulti,
            color:Color.fromARGB(255, 39, 210, 187),
            width: double.infinity,
          ),
        clipper: WaveClipperOne(reverse: true),
        ),),
         Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child:   ClipPath(
          child: Container(
            height: 18 * SizeConfig.heightMulti,
            color: Color.fromARGB(255, 141, 238, 225),
            width: double.infinity,
          ),
        clipper: WaveClipperTwo(reverse: true),
        ),),

      ]),
    );
  }
}
// Color.fromARGB(255, 141, 238, 225),
// Color.fromARGB(255, 141, 238, 225),
// ],
// [
// Color.fromARGB(255, 39, 210, 187),
// Color.fromARGB(255, 39, 210, 187),
// ],
// [
// Color.fromARGB(255, 28, 174, 147),
// Color.fromARGB(255, 28, 174, 147),