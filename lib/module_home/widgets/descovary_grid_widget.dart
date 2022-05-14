import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:my_kom/module_company/company_routes.dart';
import 'package:my_kom/module_company/models/company_model.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:my_kom/module_company/screen/company_products_screen.dart';
import 'package:my_kom/utils/size_configration/size_config.dart';

class DescoveryGridWidget extends StatelessWidget {
  final List<CompanyModel> data;

  final Function onRefresh;
  const DescoveryGridWidget(
      {required this.data, required this.onRefresh, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (data.length == 0) {
      return Center(
          child: Container(
        child: Text('Empty !!!'),
      ));
    } else {
      return AnimationLimiter(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 25),
          child: RefreshIndicator(
            onRefresh: () => onRefresh(),
            child: GridView.count(
                crossAxisCount: 3,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
                childAspectRatio: 0.9,
                children: List.generate(
                    data.length,
                    (index) => AnimationConfiguration.staggeredGrid(
                          position: index,
                          columnCount: 3,
                          duration: Duration(milliseconds: 350),
                          child: ScaleAnimation(
                              child: FadeInAnimation(
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(context, MaterialPageRoute(builder: (context)=> CompanyProductScreen(company: data[index])));
                                             //           Navigator.pushNamed(context, CompanyRoutes.COMPANY_PRODUCTS_SCREEN,arguments: data[index].id);

                              },
                              child: Container(
                                clipBehavior: Clip.antiAlias,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.black12,
                                          blurRadius: 3,
                                          offset: Offset(0, 5))
                                    ]),
                                child: Hero(
                                  tag: 'company'+data[index].id,
                                  child: Column(
                                    children: [
                                      Flexible(
                                        flex: 4,
                                        child: Container(
                                          child: AspectRatio(
                                            aspectRatio: 1.3,
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              child: data[index]
                                                          .imageUrl
                                                          .length !=
                                                      0
                                                  ? Container(
                                                      decoration: BoxDecoration(
                                                        image: DecorationImage(
                                                          image:
                                                              new ExactAssetImage(
                                                                  data[index]
                                                                      .imageUrl),
                                                          fit: BoxFit.cover,
                                                        ),
                                                      ),
                                                    )
                                                  : CachedNetworkImage(
                                                      maxHeightDiskCache: 10,
                                                      imageUrl:
                                                          data[index].imageUrl,
                                                      progressIndicatorBuilder:
                                                          (context, l, ll) =>
                                                              CircularProgressIndicator(
                                                        value: ll.progress,
                                                      ),
                                                      errorWidget:
                                                          (context, s, l) =>
                                                              Icon(Icons.error),
                                                      fit: BoxFit.cover,
                                                    ),
                                            ),
                                          ),
                                        ),
                                      ),
                                     
                                      Flexible(
                                        flex: 2,
                                        child: Center(
                                          child: Padding(
                                            padding: EdgeInsets.only(top: 8),
                                            child: Text(
                                              data[index].name,
                                              style: TextStyle(
                                                  fontSize:
                                                      SizeConfig.titleSize * 2.2,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black54,
                                                  overflow: TextOverflow.ellipsis),
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          )),
                        ))),
          ),
        ),
      );
    }
  }
}
