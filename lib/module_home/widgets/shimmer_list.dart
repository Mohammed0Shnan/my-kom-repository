import 'package:flutter/material.dart';
import 'package:my_kom/utils/size_configration/size_config.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300.withOpacity(0.8),
      highlightColor: Colors.grey.shade100,
      enabled: true,
      child: ListView.builder(
          shrinkWrap: true,
          itemCount: 4,
          itemBuilder: (BuildContext ctxt, int i) {
            return Container(
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                  border: Border.all(
                      color: Colors.white, width: 1, style: BorderStyle.solid),
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.black12,
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black38,
                        blurRadius: 2,
                        offset: Offset(0, 1))
                  ]),
              margin: EdgeInsets.symmetric(
                  horizontal: SizeConfig.widhtMulti * 7, vertical: 10),
              width: double.infinity,
              height: SizeConfig.heightMulti * 10,
              
              child: Row(
                children: [
                  Container(
                    height: SizeConfig.heightMulti * 10 ,
                    width:  SizeConfig.imageSize * 25,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.black,
                        boxShadow: [
                          BoxShadow(
                              color: Colors.white,
                              blurRadius: 10,
                              offset: Offset(0, 10))
                        ]),
                    child: ClipRRect(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10),
                        ),
                        child: CircleAvatar()),
                  ),
                  SizedBox(width: 10,),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Container(
                          margin: EdgeInsets.only(right: 10),
                          height: 15,
                          width: MediaQuery.of(context).size.width,
                          color: Colors.white,
                        ),
                            Container(
                              height: 15,
                          width: SizeConfig.screenWidth * 0.3,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
    );
  }
}
