import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_kom/consts/colors.dart';
import 'package:my_kom/module_company/models/product_model.dart';
import 'package:my_kom/module_company/screen/products_detail_screen.dart';
import 'package:my_kom/module_dashbord/bloc/more_statistics_bloc.dart';
import 'package:my_kom/module_dashbord/bloc/statistics_bloc.dart';
import 'package:my_kom/module_dashbord/models/more_statis_model.dart';
import 'package:my_kom/module_dashbord/models/order_state_chart.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:intl/intl.dart';
import 'package:my_kom/module_dashbord/screen/product_statistics_detail.dart';
import 'package:my_kom/utils/size_configration/size_config.dart';
class StatistacsesScreen extends StatefulWidget {
   StatistacsesScreen({Key? key}) : super(key: key);

  @override
  State<StatistacsesScreen> createState() => _StatistacsesScreenState();
}

class _StatistacsesScreenState extends State<StatistacsesScreen> {
  final StatisticsBloc statisticsBloc = StatisticsBloc();
  final MoreStatisticsBloc moreStatisticsBloc = MoreStatisticsBloc();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    statisticsBloc.getStatistics();
    moreStatisticsBloc.getMoreStatistics();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              BlocBuilder<StatisticsBloc,StatisticsStates>(
                  bloc: statisticsBloc,
                  builder: (context ,state){
                if(state is StatisticsSuccessState){
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                          height: 250,
                          child: CustomBarChart(orderStateChart:state.statistics,)),
              SizedBox(height: 20,),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Revenue' , style: GoogleFonts.lato(
                  fontSize: 19,
                  fontWeight: FontWeight.w800,
                  color: Colors.black54,
          ),),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 16),
                padding: EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.black12.withOpacity(0.1)
                )
                ,height: 250,
                child: ListView.separated(
                  physics: ClampingScrollPhysics(),
                    itemCount: state.statistics.length,
                    separatorBuilder: (context,index){
                      return Divider(endIndent: 20,indent: 20,thickness: 2,);
                    },
                    itemBuilder: (context,index){
                  return Container(

                    height: 75,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Day : '+state.statistics[index].index.toString() +' ( '+DateFormat('yyyy-MM-dd').format(state.statistics[index].dateTime)+' )',
                        style: TextStyle(color: Colors.black54,fontSize: 16,fontWeight: FontWeight.w700),)
                       , Row(
                         children: [
                           Text('Revenue : ' ,
                              style: TextStyle(color: Colors.black54,fontSize: 16,fontWeight: FontWeight.w700),),

                           Text(state.statistics[index].revenue.toString() ,
                             style: TextStyle(color: ColorsConst.mainColor,fontSize: 18,fontWeight: FontWeight.w700),),

                         ],
                       )
                      ],
                    ),
                  );
                }),

               )

          ],
                  );
                }
                else if(state is StatisticsErrorState){
                  return Container(child: Text(state.message),);
                }
                else{
                  return Center(child: Container(child: CircularProgressIndicator(),));
                }
              })
              ,
              SizedBox(height: 20,),



          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text('The five most wanted products',style: GoogleFonts.lato(
              fontSize: 19,
              fontWeight: FontWeight.w800,
              color: Colors.black54,
            )),
          ),
              BlocBuilder<MoreStatisticsBloc,MoreStatisticsStates>(
                  bloc: moreStatisticsBloc,
                  builder: (context ,state){
                    if(state is MoreStatisticsSuccessState){
                     List<ProductModel> items = state.statistics.products;

                     return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          SizedBox(height: 10,),

                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 16),
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.black12.withOpacity(0.1)
                            )
                            ,height: 220,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                                physics: ClampingScrollPhysics(),
                                itemCount: items.length,

                                itemBuilder: (context,index){
                              //  return Container();
                               return   GestureDetector(
                                    onTap: () {

                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                ProductStatisticsDetail(productModel: items[index],)
                                          )
                                      );
                                    },
                                    child: Container(
                                      height: 200,
                                      width: 150,
                                      margin: EdgeInsets.symmetric(horizontal: 8,vertical: 4),
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
                                      child: Column(
                                        children: [
                                          Container(
                                            height: 100,
                                            child:  Container(
                                              width: double.infinity,
                                              child: ClipRRect(
                                                borderRadius:
                                                BorderRadius.circular(10),
                                                child:  CachedNetworkImage(
                                                  maxHeightDiskCache: 10,
                                                  imageUrl: items[index].imageUrl,
                                                  progressIndicatorBuilder:
                                                      (context, l, ll) =>
                                                      CircularProgressIndicator(
                                                        value: ll.progress,
                                                      ),
                                                  errorWidget: (context,
                                                      s, l) =>
                                                      Icon(Icons.error),
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 10,),
                                          Expanded(
                                            child: Padding(
                                              padding: EdgeInsets.only(top: 8,left: 8,right: 8),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    child: Row(
                                                      children: [
                                                        (items[index].old_price !=
                                                            null)
                                                            ? Text(
                                                          items[index]
                                                              .old_price
                                                              .toString(),
                                                          overflow:
                                                          TextOverflow
                                                              .ellipsis,
                                                          style: TextStyle(
                                                              decoration:
                                                              TextDecoration
                                                                  .lineThrough,
                                                              color: Colors
                                                                  .black26,
                                                              fontWeight:
                                                              FontWeight
                                                                  .w700,
                                                              fontSize:
                                                              SizeConfig
                                                                  .titleSize *
                                                                  3),
                                                        )
                                                            : SizedBox.shrink(),
                                                        SizedBox(width: 8,),
                                                        Expanded(
                                                          child: Text(
                                                            items[index]
                                                                .price
                                                                .toString(),
                                                            overflow: TextOverflow
                                                                .ellipsis,
                                                            style: TextStyle(
                                                                color: Colors.green,
                                                                fontWeight:
                                                                FontWeight.w700,
                                                                fontSize: SizeConfig
                                                                    .titleSize *
                                                                    4),
                                                          ),
                                                        ),

                                                      ],
                                                    ),
                                                  ),
                                                  SizedBox(height: 5,),
                                                  Row(
                                                    children: [

                                                      Expanded(
                                                        child: Padding(
                                                          padding: EdgeInsets.symmetric(horizontal: 5),

                                                          child: Text(
                                                            items[index].title,
                                                            style: TextStyle(
                                                                fontSize: SizeConfig
                                                                    .titleSize *
                                                                    2.1,
                                                                fontWeight:
                                                                FontWeight.bold,
                                                                overflow: TextOverflow
                                                                    .ellipsis),
                                                          ),
                                                        ),
                                                      ),
                                                      Text(
                                                        items[index]
                                                            .quantity
                                                            .toString() + ' Plot',
                                                        style: TextStyle(
                                                            color:
                                                            Colors.black26,
                                                            fontWeight:
                                                            FontWeight.w700,
                                                            fontSize: SizeConfig
                                                                .titleSize *
                                                                2.2),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(height: 5,),
                                                  Expanded(
                                                    child: Container(
                                                      padding: EdgeInsets.symmetric(horizontal: 5),
                                                      child: Text(
                                                        items[index].description,
                                                        overflow: TextOverflow.ellipsis,
                                                        maxLines: 3,
                                                        style: GoogleFonts.lato(
                                                            fontSize: SizeConfig.titleSize * 2,
                                                            color: Colors.black54,
                                                            fontWeight: FontWeight.w600
                                                        ),
                                                      ),
                                                    ),
                                                  ),


                                                ],
                                              ),
                                            ),
                                          ),

                                        ],
                                      ),
                                    ),
                                 );
                                }),

                          ),
                          SizedBox(height: 20,),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            child: Text('Top five users',style: GoogleFonts.lato(
                              fontSize: 19,
                              fontWeight: FontWeight.w800,
                              color: Colors.black54,
                            )),
                          ),
                          SizedBox(height: 10,),

                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 16),
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.black12.withOpacity(0.1)
                            )
                            ,height: 220,
                            child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                physics: ClampingScrollPhysics(),
                                itemCount: state.statistics.users.length,

                                itemBuilder: (context,index){
                                  //  return Container();
                                  return   GestureDetector(
                                    onTap: () {

                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ProductStatisticsDetail(productModel: items[index],)
                                          )
                                      );
                                    },
                                    child: Container(
                                      height: 200,
                                      width: 200,
                                      margin: EdgeInsets.symmetric(horizontal: 8,vertical: 4),
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
                                      child: Column(
                                        children: [
                                          Container(
                                            height: 80,
                                            width: 100,
                                            decoration: BoxDecoration(
                                                image: DecorationImage(
                                                    image: AssetImage('assets/profile.png'),
                                                    fit: BoxFit.cover
                                                )
                                            ),
                                          ),
                                          SizedBox(height: 10,),
                                          Expanded(
                                            child: Padding(
                                              padding: EdgeInsets.only(top: 8,left: 8,right: 8),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Center(
                                                    child: Container(
                                                      child:   Expanded(
                                                        child: Text(
                                                         state.statistics.users[index]
                                                              .user_name
                                                              .toString(),
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style: TextStyle(
                                                              color: Colors.green,
                                                              fontWeight:
                                                              FontWeight.w700,
                                                              fontSize: SizeConfig
                                                                  .titleSize *
                                                                  4),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(height: 5,),
                                                  Row(
                                                    children: [

                                                    Icon(Icons.email_outlined,color: Colors.black54,),
                                                      SizedBox(width: 8,),
                                                      Text(
                                                        state.statistics.users[index].email,
                                                        style: TextStyle(
                                                            color:
                                                            Colors.black54,
                                                            fontWeight:
                                                            FontWeight.w700,
                                                            fontSize: SizeConfig
                                                                .titleSize *
                                                                2.3),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(height: 5,),
                                                  Row(
                                                    children: [
                                                      Icon(Icons.location_on_outlined,color: Colors.black54,),
                                                      SizedBox(width: 8,),
                                                      Expanded(
                                                        child: Container(
                                                          padding: EdgeInsets.symmetric(horizontal: 5),
                                                          child: Text(
                                                            state.statistics.users[index].address.description,
                                                            overflow: TextOverflow.ellipsis,
                                                            maxLines: 3,
                                                            style: GoogleFonts.lato(
                                                                fontSize: SizeConfig.titleSize * 2,
                                                                color: Colors.black54,
                                                                fontWeight: FontWeight.w600
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),


                                                ],
                                              ),
                                            ),
                                          ),

                                        ],
                                      ),
                                    ),
                                  );
                                }),

                          )
                        ],
                      );
                    }
                    else if(state is MoreStatisticsErrorState){
                      return Container(child: Text(state.message),);
                    }
                    else{
                      return Center(child: Container(child: CircularProgressIndicator(),));
                    }
                  }),
              SizedBox(height: 50,)
            ],
          ),
        ),
      ),
    );
  }
}

class CustomBarChart extends StatelessWidget {
   CustomBarChart({ required this.orderStateChart, Key? key}) : super(key: key);

  final List<OrderStateChart> orderStateChart;
  @override
  Widget build(BuildContext context) {
    List<charts.Series<OrderStateChart,String>> series = [
      charts.Series(id: 'orders',data:orderStateChart,
          domainFn: (series,_)=>  DateFormat.d().format(series.dateTime).toString(),  // series.index.toString(),//
      measureFn: (series,_)=>series.orders,
        colorFn: (series,_)=>series.barColor!,
     //   labelAccessorFn: (series ,_)=> '${series.revenue}',


      )
    ];
    return charts.BarChart(
      series,
      animate: true,
      animationDuration: Duration(seconds: 1),
      // behaviors: [
      //   charts.DatumLegend(
      //     outsideJustification: charts.OutsideJustification.endDrawArea,
      //     entryTextStyle: charts.TextStyleSpec(
      //       color: charts.MaterialPalette.purple.shadeDefault
      //     )
      //   )
      // ],

    );
  }
}

