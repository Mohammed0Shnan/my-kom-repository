import 'dart:io' show Platform;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_kom/module_about/animations/fade_animation.dart';
import 'package:my_kom/module_company/bloc/all_company_bloc.dart';
import 'package:my_kom/module_company/company_routes.dart';
import 'package:my_kom/module_company/models/company_model.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:my_kom/module_company/screen/company_products_screen.dart';
import 'package:my_kom/module_home/widgets/shimmer_list.dart';
import 'package:my_kom/utils/size_configration/size_config.dart';

class DescoveryListWidget extends StatelessWidget {
  final List<CompanyModel> data;
  final Function onRefresh;

  const DescoveryListWidget(
      {required this.onRefresh, required this.data, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _buildCompanyItems(data);
  }

  Widget _buildCompanyItems(List<CompanyModel> list) {
    if (list.length == 0) {
      return Center(
          child: Container(
        child: Text('Empty !!!'),
      ));
    } else {
      double h = SizeConfig.heightMulti * 10;
      double w = SizeConfig.screenWidth;
      double imageWidth = SizeConfig.imageSize;
      return AnimationLimiter(
        child: RefreshIndicator(
          onRefresh: () => onRefresh(),
          child: ListView.builder(
              physics: Platform.isAndroid
                  ? ClampingScrollPhysics()
                  : BouncingScrollPhysics(),
              itemCount: list.length,
              itemBuilder: (context, index) {
                return AnimationConfiguration.staggeredList(
                  position: index,
                  duration: Duration(milliseconds: 400),
                  child: SlideAnimation(
                    child: FadeInAnimation(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CompanyProductScreen(
                                      company_id: data[index].id)));

                          //    Navigator.pushNamed(context, CompanyRoutes.COMPANY_PRODUCTS_SCREEN,arguments: data[index].id);
                        },
                        child: Container(
                          margin: EdgeInsets.symmetric(
                              horizontal: SizeConfig.widhtMulti * 7,
                              vertical: 10),
                          height: h,
                          width: w,
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  blurRadius: 2,
                                  color: Colors.black12,
                                )
                              ]),
                          child: Row(
                            children: [
                              Flexible(
                                child: Hero(
                                  tag: 'company'+data[index].id,
                                  child: Container(
                                    height: h,
                                    width: imageWidth * 25,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: list[index].imageUrl.length == 0
                                          ? Container(
                                              decoration: BoxDecoration(
                                                image: DecorationImage(
                                                  image: new ExactAssetImage(
                                                      list[index].imageUrl),
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            )
                                          : CachedNetworkImage(
                                              maxHeightDiskCache: 10,
                                              imageUrl: list[index].imageUrl,
                                              progressIndicatorBuilder:
                                                  (context, l, ll) =>
                                                      CircularProgressIndicator(
                                                value: ll.progress,
                                              ),
                                              errorWidget: (context, s, l) =>
                                                  Icon(Icons.error),
                                              fit: BoxFit.cover,
                                            ),
                                    ),
                                  ),
                                ),
                              ),
                              Flexible(
                                child: SizedBox(
                                  width: 20,
                                ),
                              ),
                              Flexible(child: Text(list[index].name)),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }),
        ),
      );
    }
  }
}
