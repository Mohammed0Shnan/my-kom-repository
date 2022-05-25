import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_kom/consts/colors.dart';
import 'package:my_kom/utils/size_configration/size_config.dart';


class CaptainOrdersScreen extends StatefulWidget {


  @override
  State<StatefulWidget> createState() => CaptainOrdersScreenState();
}

class CaptainOrdersScreenState extends State<CaptainOrdersScreen> {

  final String CURRENT_ORDER = 'current';
  final String PREVIOUS_ORDER = 'previous';
  late String current_tap ;
  @override
  void initState() {
    current_tap = CURRENT_ORDER;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: Colors.grey.shade100,
    body: SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8,vertical: 5),
            child: Text('Orders',style: GoogleFonts.lato(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: Colors.black45
            ),),
          ),
          SizedBox(height: 8,),
          getAccountSwitcher(),
          SizedBox(height: 8,),

          Expanded(
            child: AnimatedSwitcher(
              duration: Duration(milliseconds: 500),
              child: current_tap == CURRENT_ORDER
                  ? getCurrentOrders()
                  : getPreviousOrders(),
            ),
          ),
        ],
      ),
    ),

  );
  }
  Widget getAccountSwitcher() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: SizeConfig.widhtMulti * 3),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                current_tap = CURRENT_ORDER;
                if (mounted) {
                  setState(() {});
                }
              },
              child: AnimatedContainer(
                  duration: Duration(milliseconds: 500),
                  padding: EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: current_tap == CURRENT_ORDER
                        ? ColorsConst.mainColor
                        : Colors.transparent,

                  ),
                  child: Center(child: Text('Current Orders',style: TextStyle(
                    color: current_tap == CURRENT_ORDER ?Colors.white: ColorsConst.mainColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 16
                  ),))),
            ),
          ),
          Expanded(
            child:GestureDetector(
              onTap: () {
                current_tap = PREVIOUS_ORDER;
                if (mounted) {
                  setState(() {});
                }
              },
              child: AnimatedContainer(
                duration: Duration(milliseconds: 500),
                padding: EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),

                  color:    current_tap == PREVIOUS_ORDER
                      ? ColorsConst.mainColor
                      : Colors.transparent,
                ),
                child:Center(child: Text('Previous Orders',style: TextStyle(
                    color: current_tap == PREVIOUS_ORDER ?Colors.white: ColorsConst.mainColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 16
                ))),
              ),
            ),
          )

        ],
      ),
    );
  }
 Widget getCurrentOrders(){
    return ListView.separated(
      itemCount: 5,
      separatorBuilder: (context,index){
        return SizedBox(height: 8,);
      },
      itemBuilder: (context,index){
        return Container(
          height: 120,
          width: double.infinity,
          padding: EdgeInsets.all(10),
          margin: EdgeInsets.symmetric(horizontal: 16,vertical: 5),
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius:2,
                spreadRadius: 1
              )
            ],
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [

                  Text('Details',style: GoogleFonts.lato(
                    fontSize: 18,
                    color: Colors.black54,
                    fontWeight: FontWeight.w800
                  ),),
                  InkWell(
                      onTap: (){

                      },
                      child: Icon(Icons.close,color:Colors.black54 ,)),
                ],
              ),
              SizedBox(height: 8,),
              Text('')
            ],
          ),
        );
      },
    );
  }

  Widget getPreviousOrders(){
    return Container(
      color: Colors.blue,
    );
  }

}
