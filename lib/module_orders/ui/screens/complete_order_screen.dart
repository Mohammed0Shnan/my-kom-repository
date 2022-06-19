import 'package:flutter/material.dart';
import 'package:my_kom/consts/colors.dart';
import 'package:my_kom/module_home/navigator_routes.dart';
import 'package:my_kom/module_orders/orders_routes.dart';
import 'package:my_kom/utils/size_configration/size_config.dart';

class CompleteOrderScreen extends StatefulWidget {
  final String orderId;
   CompleteOrderScreen({required this.orderId,Key? key}) : super(key: key);

  @override
  State<CompleteOrderScreen> createState() => _CompleteOrderScreenState();
}

class _CompleteOrderScreenState extends State<CompleteOrderScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: SizeConfig.screenHeight * 0.1,),
            Center(
              child: Container(
                height: SizeConfig.screenHeight * 0.4,
                width: SizeConfig.screenWidth * 0.8,
                child: Image.asset('assets/complete_order.png',fit: BoxFit.contain,),
              ),
            ),
            Text('Thank you !',style: TextStyle(fontSize: 25,fontWeight: FontWeight.w800,color: Colors.black54),),
            SizedBox(height: 8,),
            Text('Your request has been received',style: TextStyle(fontSize: 19,fontWeight: FontWeight.w800,color: Colors.black45)),
            Spacer(),
            Container(
              height: SizeConfig.heightMulti * 7,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                color: ColorsConst.mainColor,
                borderRadius: BorderRadius.circular(10)
              ),
              width: SizeConfig.screenWidth,
              child: MaterialButton(
                onPressed: (){
                  Navigator.pushNamed(context, OrdersRoutes.ORDER_STATUS_SCREEN,arguments:  widget.orderId);
                },
                child: Center(child: Text('Follow The Order',style: TextStyle(color: Colors.white,fontSize: 20),),),
              ),
            ),SizedBox(height:10,),
            Container(
              height: SizeConfig.heightMulti * 7,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: ColorsConst.mainColor,
                  width: 3
                )
              ),
              width: SizeConfig.screenWidth,
              child: MaterialButton(
                onPressed: (){
                  Navigator.pushNamed(context, NavigatorRoutes.NAVIGATOR_SCREEN);
                },
                child: Center(child: Text('Go To Home',style: TextStyle(color: ColorsConst.mainColor,fontSize: 20),),),
              ),
            ),SizedBox(height: 20,),
          ],
        ),
      ),
    );
  }
}
