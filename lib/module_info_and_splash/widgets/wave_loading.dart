
import 'package:flutter/material.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';

class WaveLoadingWidget extends StatelessWidget {
  final bool run;
  final double container_width;
  final double container_height;
  WaveLoadingWidget(
      {required this.container_height,
      required this.container_width,
      required this.run,
      Key? key})
      : super(key: key);

  _buildCard({
    Config? config,
    Color backgroundColor = Colors.transparent,
    DecorationImage? backgroundImage,
    double height = 152.0,
    double? waveAmplitude,
    double? waveFrequency,
    double? wavePhase,
  }) {
    return Container(
      height: height,
      width: double.infinity,
      child: WaveWidget(
        isLoop: true,
        config: config!,
        backgroundColor: backgroundColor,
        backgroundImage: backgroundImage,
        size: Size(double.infinity, double.infinity),
        waveAmplitude: waveAmplitude!,
        wavePhase: wavePhase!,
        waveFrequency: waveFrequency!,
      ),
    );
  }

  MaskFilter? _blur;
  final List<MaskFilter?> _blurs = [
    null,
    MaskFilter.blur(BlurStyle.normal, 10.0),
    MaskFilter.blur(BlurStyle.inner, 10.0),
    MaskFilter.blur(BlurStyle.outer, 10.0),
    MaskFilter.blur(BlurStyle.solid, 16.0),
  ];
  int _blurIndex = 0;
  MaskFilter _nextBlur() {
    if (_blurIndex == _blurs.length - 1) {
      _blurIndex = 0;
    } else {
      _blurIndex = _blurIndex + 1;
    }
    _blur = _blurs[_blurIndex]!;
    return _blurs[_blurIndex]!;
  }

  @override
  Widget build(BuildContext context) {
    
    return Container(
      height: container_height,
      width: container_width,
      decoration: BoxDecoration(
          color: Colors.green.withOpacity(0.1), shape: BoxShape.circle),
      clipBehavior: Clip.antiAlias,
      child: _buildCard(
        waveAmplitude: 40,
        wavePhase: 200,
        waveFrequency: 1.2,
        config: CustomConfig(

          gradients: [
            [
              Color.fromARGB(255, 141, 238, 225),
              Color.fromARGB(255, 141, 238, 225),
            ],
            [
              Color.fromARGB(255, 39, 210, 187),
              Color.fromARGB(255, 39, 210, 187),
            ],
            [
              Color.fromARGB(255, 28, 174, 147),
              Color.fromARGB(255, 28, 174, 147),
            ],
          ],
          durations: [6000, 4000, 5000],
          heightPercentages: [0.3, 0.25, 0.32],
          blur: _blur,
          gradientBegin: Alignment.bottomLeft,
          gradientEnd: Alignment.topRight,
        ),
      ),
    );
  }
}
// import 'dart:async';

// import 'package:flutter/material.dart';
// import 'package:my_kom/utils/size_configration/size_config.dart';

// class WaveLoadingWidget extends StatelessWidget {
//   final bool run;
//   final double container_width;
//   final double container_height;
//   WaveLoadingWidget(
//       {required this.container_height,
//       required this.container_width,
//       required this.run,
//       Key? key})
//       : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: container_height,
//       width: container_width,
//       decoration: BoxDecoration(
//           color: Colors.green.withOpacity(0.1), shape: BoxShape.circle),
//       clipBehavior: Clip.antiAlias,
//       child: Stack(
//         alignment: Alignment.bottomCenter,
//         children: [
//           WaveLoading(
//               run_wave: run,
//               color: Color.fromARGB(255, 141, 238, 225),
//               begin: 1.8,
//               end: 2,
//               duration: 200,
//               height: container_height * 1,
//               width: container_width,
//               height_wave_from_l: 1,
//               height_wave_from_r: 0.1),
//           WaveLoading(
//               run_wave: run,
//               color: Color.fromARGB(255, 39, 210, 187),
//               begin: 1.5,
//               end: 4,
//               duration: 170,
//               height: container_height * 0.8,
//               width: container_width,
//               height_wave_from_l: 0.1,
//               height_wave_from_r: 0.3),
//           WaveLoading(
//               run_wave: run,
//               color: Color.fromARGB(255, 28, 174, 147),
//               begin: 4,
//               end: 2,
//               duration: 150,
//               height: container_height * 0.75,
//               width: container_width,
//               height_wave_from_l: 2.5,
//               height_wave_from_r: 0.2),
//         ],
//       ),
//     );
//   }
// }

// class WaveLoading extends StatefulWidget {
//   final bool run_wave;
//   final Color color;
//   final double begin;
//   final double end;
//   final int duration;
//   final double height;
//   final double width;
//   final double height_wave_from_l;
//   final double height_wave_from_r;
//   WaveLoading(
//       {required this.run_wave,
//       required this.color,
//       required this.begin,
//       required this.end,
//       required this.duration,
//       required this.height,
//       required this.width,
//       required this.height_wave_from_l,
//       required this.height_wave_from_r,
//       Key? key})
//       : super(key: key);

//   @override
//   State<WaveLoading> createState() => _WaveLoadingState();
// }

// class _WaveLoadingState extends State<WaveLoading>
//     with TickerProviderStateMixin {
//   late AnimationController controller1;
//   late Animation animation1;
//   late AnimationController controller2;
//   late Animation animation2;
//   late AnimationController controller3;
//   late Animation animation3;
//   late AnimationController controller4;
//   late Animation animation4;

//   bool wave = false;
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     controller1 = AnimationController(
//         vsync: this, duration: Duration(milliseconds: 1400));
//     animation1 = Tween<double>(begin: widget.begin, end: widget.end)
//         .animate(CurvedAnimation(parent: controller1, curve: Curves.easeInOut))
//       ..addListener(() {
//         setState(() {});
//       })
//       ..addStatusListener((status) {
//         if (status == AnimationStatus.completed) {
//           controller1.reverse();
//           wave = !wave;
//         } else if (status == AnimationStatus.dismissed) {
//           controller1.forward();
//         }
//       });

//     controller2 = AnimationController(
//         vsync: this, duration: Duration(milliseconds: 1300));
//     animation2 = Tween<double>(begin: widget.begin, end: widget.end)
//         .animate(CurvedAnimation(parent: controller2, curve: Curves.easeInOut))
//       ..addListener(() {
//         setState(() {});
//       })
//       ..addStatusListener((status) {
//         if (status == AnimationStatus.completed) {
//         } else if (status == AnimationStatus.dismissed) {
//           controller2.forward();
//         }
//       });

//     controller3 = AnimationController(
//         vsync: this, duration: Duration(milliseconds: 1100));
//     animation3 = Tween<double>(begin: widget.begin, end: widget.end)
//         .animate(CurvedAnimation(parent: controller3, curve: Curves.easeInOut))
//       ..addListener(() {
//         setState(() {});
//       })
//       ..addStatusListener((status) {
//         if (status == AnimationStatus.completed) {
//           controller3.reverse();
//           // wave = ! wave;
//         } else if (status == AnimationStatus.dismissed) {
//           controller3.forward();
//           // wave = ! wave;
//         }
//       });

//     controller4 = AnimationController(
//         vsync: this, duration: Duration(milliseconds: 1200));
//     animation4 = Tween<double>(begin: widget.begin, end: widget.end)
//         .animate(CurvedAnimation(parent: controller4, curve: Curves.easeInOut))
//       ..addListener(() {
//         setState(() {});
//       })
//       ..addStatusListener((status) {
//         if (status == AnimationStatus.completed) {
//           controller4.reverse();
//         } else if (status == AnimationStatus.dismissed) {
//           controller4.forward();
//         }
//       });
//     if (widget.run_wave) _runAnimation();
//     // Timer(Duration(milliseconds: widget.duration), () {
//     //   controller3.forward();
//     // });

//     // Timer(Duration(milliseconds: widget.duration * 2), () {
//     //   controller2.forward();
//     // });
//     // Timer(Duration(milliseconds: widget.duration * 2 + 400), () {
//     //   controller1.forward();
//     // });
//   }

//   void _runAnimation() {
//     controller4.forward();
//     controller3.forward();
//     controller2.forward();
//     controller1.forward();
//   }

//   @override
//   void dispose() {
//     controller1.dispose();
//     controller2.dispose();
//     controller3.dispose();
//     controller4.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return CustomPaint(
//       painter: MyPaint(
//           animation1.value,
//           animation2.value,
//           animation3.value,
//           animation4.value,
//           widget.color,
//           widget.height_wave_from_l,
//           widget.height_wave_from_r),
//       child: Container(
//         height: widget.height,
//         width: widget.width,
//       ),
//     );
//   }
// }

// class MyPaint extends CustomPainter {
//   final double h1;
//   final double h2;
//   final double h3;
//   final double h4;
//   final double percent_l;
//   final double percent_r;
//   final Color color;

//   MyPaint(this.h1, this.h2, this.h3, this.h4, this.color, this.percent_l,
//       this.percent_r);
//   @override
//   void paint(Canvas canvas, Size size) {
//     var paint = Paint()
//       ..color = color
//       ..style = PaintingStyle.fill;

//     var path = Path();
//     path.moveTo(0, size.height / h1);
//     path.cubicTo(size.width * .4, size.height / h2 * percent_r, size.width * .9,
//         size.height / h3 * percent_l, size.width, size.height / h4);
//     path.lineTo(size.width, size.height);
//     path.lineTo(0, size.height);
//     canvas.drawPath(path, paint);
//   }

//   @override
//   bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
// }

// class DrowCi extends CustomClipper<Path> {
//   @override
//   Path getClip(Size size) {
//     // TODO: implement getClip
//     Path path = Path();
//     path.arcTo(Rect.fromCircle(center: Offset(size.width, 50.0), radius: 300),
//         0, 0, true);

//     return path;
//   }

//   @override
//   bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
//     // TODO: implement shouldReclip
//     return true;
//   }
// }
