import 'dart:math';

import 'package:flutter/material.dart';
import 'package:my_kom/consts/colors.dart';
import 'package:my_kom/utils/size_configration/size_config.dart';

class ShopScreen extends StatefulWidget {
  const ShopScreen({Key? key}) : super(key: key);

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  late final String companyName;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Shopping Cart',
              style: TextStyle(color: Colors.black),
            ),
            Text(
              'شركة العين',
              style: TextStyle(color: Colors.black45),
            )
          ],
        ),
      ),
      body: SafeArea(
          child: Container(
        child: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            Container(
              height: 100,
              decoration: BoxDecoration(color: Colors.black12.withOpacity(0.1)),
              child: Row(
                children: [
                  TweenAnimationBuilder(
                      tween: Tween<double>(begin: 0.0, end: 1.0),
                      duration: Duration(seconds: 2),
                      builder: (context,double value, child) {
                        return Container(
                            width: 100,
                            height: 100,
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Stack(
                              children: [
                                ShaderMask(
                                  shaderCallback: (rect) {
                                    return SweepGradient(
                                        startAngle: 0,
                                        endAngle: 2 * pi,
                                        center: Alignment.center,
                                        stops: [
                                          value,
                                          value
                                        ],
                                        colors: [
                                           ColorsConst.mainColor,
                                          Colors.grey.withOpacity(0.2)
                                        ]).createShader(rect);
                                  },
                                  child: Container(
                                    width: 100,
                                    height: 100,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.white),
                                  ),
                                ),
                                Center(
                                  child: Container(
                                    height: 70,
                                    width: 70,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.white),
                                        child: Center(child: Text('1 of 4',style: TextStyle(fontWeight: FontWeight.w600,color: ColorsConst.mainColor),)),
                                  ),
                                )
                              ],
                            ));
                      }),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Details and price of the shipment',
                            style: TextStyle(
                                color: ColorsConst.mainColor,
                                fontWeight: FontWeight.w600,
                                fontSize: SizeConfig.titleSize * 2.5)),
                        SizedBox(
                          height: 8,
                        ),
                        Text('Next is the address and shipping details',
                            style: TextStyle(
                                color: Colors.black38,
                                fontSize: SizeConfig.titleSize * 2))
                      ],
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              child: ListView(
                children: [
                  _buildShopeCard(),
                  _buildShopeCard(),
                  _buildShopeCard(),
                  _buildShopeCard(),
                ],
              ),
            ),
          ],
        ),
      )),
    );
  }

  Widget _buildShopeCard() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      height: SizeConfig.heightMulti * 18,
      child: Row(
        children: [
          Container(
            width: 10,
            decoration: BoxDecoration(
                color: ColorsConst.mainColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                )),
          ),
          Expanded(
            child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black12,
                        blurRadius: 5,
                        offset: Offset(0, 3))
                  ],
                ),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    double h = constraints.maxHeight;
                    double w = constraints.maxWidth;

                    return Row(
                      children: [
                        Container(
                          width: w / 4,
                          child: Image.asset('assets/productItem.png'),
                        ),
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'مياه االعين 200 مل ',
                                style: TextStyle(
                                    fontSize: 17, fontWeight: FontWeight.w600),
                              ),
                              Text('24 حبة \ الكرتون'),
                              Text(
                                '1200 AED',
                                style: TextStyle(color: ColorsConst.mainColor),
                              )
                            ]),
                        Spacer(),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              height: h / 3.3,
                              width: w / 3.4,
                              clipBehavior: Clip.antiAlias,
                              decoration: BoxDecoration(
                                boxShadow: [BoxShadow(color: Colors.black12)],
                                borderRadius: BorderRadius.circular(5),
                                color: Colors.white.withOpacity(0.1),
                              ),
                              child: Stack(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        color: ColorsConst.mainColor,
                                        width: 30,
                                        child: IconButton(
                                            onPressed: () {},
                                            icon: Icon(
                                              Icons.minimize_sharp,
                                              size: SizeConfig.imageSize * 5,
                                              color: Colors.white,
                                            )),
                                      ),
                                      Container(
                                        child: Text('100'),
                                      ),
                                      Container(
                                        width: 30,
                                        color: ColorsConst.mainColor,
                                        child: Center(
                                          child: IconButton(
                                              onPressed: () {},
                                              icon: Icon(
                                                Icons.add,
                                                size: SizeConfig.imageSize * 5,
                                                color: Colors.white,
                                              )),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )
                      ],
                    );
                  },
                )),
          )
        ],
      ),
    );
  }
}
