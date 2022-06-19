import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:my_kom/module_company/company_routes.dart';
import 'package:my_kom/module_company/models/company_arguments_route.dart';
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
                              //  Navigator.push(context, MaterialPageRoute(builder: (context)=> CompanyProductScreen(company: data[index])));
                                CompanyArgumentsRoute argumentsRoute = CompanyArgumentsRoute();
                                argumentsRoute.companyId = data[index].id;
                                argumentsRoute.companyImage = data[index].imageUrl;
                                argumentsRoute.companyName = data[index].name;

                                Navigator.pushNamed(context, CompanyRoutes.COMPANY_PRODUCTS_SCREEN,arguments: argumentsRoute);
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
                                             // child: Image.network( data[index].imageUrl,fit: BoxFit.cover,),
                                              child: CachedNetworkImage(
                                                filterQuality: FilterQuality.high,
                                                imageUrl:
                                                data[index].imageUrl,
                                                progressIndicatorBuilder:
                                                    (context, l, ll) =>
                                                    Center(
                                                      child: Container(
                                                        height: 40,
                                                        width: 40,
                                                        child: CircularProgressIndicator(
                                                          value: ll.progress,
                                                          color: Colors.black12,

                                                        ),
                                                      ),
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
