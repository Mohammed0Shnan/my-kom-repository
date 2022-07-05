import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_kom/module_company/company_routes.dart';
import 'package:my_kom/module_company/models/company_arguments_route.dart';
import 'package:my_kom/module_company/models/company_model.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:my_kom/utils/size_configration/size_config.dart';
import 'package:my_kom/generated/l10n.dart';

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
                            if(data[index].isActive){
                              CompanyArgumentsRoute argumentsRoute = CompanyArgumentsRoute();
                              argumentsRoute.companyId = data[index].id;
                              argumentsRoute.companyImage = data[index].imageUrl;
                              argumentsRoute.companyName = data[index].name;
                              Navigator.pushNamed(context, CompanyRoutes.COMPANY_PRODUCTS_SCREEN,arguments: argumentsRoute);
                            }else{
                              showDialog(context: context, builder: (context){
                                return ClipRRect(
                                  borderRadius: BorderRadius.circular(20),

                                  child: AlertDialog(
                                    backgroundColor: Colors.white.withOpacity(0.8),
                                    clipBehavior: Clip.antiAlias,
                                    shape:RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),

                                    ) ,
                                    content:Container(
                                      height: 70,
                                      width: 90,

                                      child: Center(
                                        child:
                                        Text(S.of(context)!.serviceComingSoon,
                                          style: GoogleFonts.acme(
                                              color: Colors.green,
                                              fontWeight: FontWeight.bold
                                          ),
                                        ),
                                      ),
                                    ),

                                  ),
                                );
                              });

                            }

                              },
                              child: Stack(
                                children: [
                                  Container(
                                    clipBehavior: Clip.antiAlias,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(10),
                                        boxShadow: [
                                          BoxShadow(
                                              color: Colors.black12,
                                              blurRadius: 2,
                                              offset: Offset(0, 2))
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
                                                child:data[index].isActive? ClipRRect(
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

                                                ): Container(
                                                  decoration: BoxDecoration(
                                                    image: DecorationImage(
                                                      image: NetworkImage(  data[index].imageUrl,

                                                      ),
                                                      colorFilter: ColorFilter.mode(Colors.black, BlendMode.color)
                                                    )
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
                                                      color:data[index].isActive? Colors.black87:Colors.black26,
                                                      overflow: TextOverflow.ellipsis),
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  if(!data[index].isActive)
                                  Positioned.fill(child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.black38,
                                        borderRadius: BorderRadius.circular(10),
                                      
                                      ),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                      Image.asset('assets/coming-soon-clock.png',height: 50,color: Colors.white.withOpacity(0.8),),
                                        SizedBox(height: 8,),
                                        Text('Coming Soon',style: GoogleFonts.acme(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: SizeConfig.titleSize
                                           * 2.2
                                      ),),
                                    ],),
                                  )),
                                ],
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
