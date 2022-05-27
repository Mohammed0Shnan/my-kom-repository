import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_kom/consts/colors.dart';
import 'package:my_kom/module_authorization/authorization_routes.dart';
import 'package:my_kom/module_authorization/screens/widgets/top_snack_bar_widgets.dart';
import 'package:my_kom/module_orders/state_manager/captain_orders/captain_orders.dart';
import 'package:my_kom/utils/size_configration/size_config.dart';


deleteOrderCheckAlertWidget(BuildContext context,{required String orderID}){
  // set up the AlertDialog
  AlertDialog alert = AlertDialog(

clipBehavior: Clip.antiAlias,
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20)

    ),
    content: Container(

      height: 100,
      child: Column(
     crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text('Do you want to delete the order ? ',style: TextStyle(fontSize: SizeConfig.titleSize * 2.4,fontWeight: FontWeight.w800,color: Colors.black54),),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                height: 35,
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                    color: ColorsConst.mainColor,
                    borderRadius: BorderRadius.circular(10)
                ),
                child: MaterialButton(
                  onPressed: (){
                    Navigator.pop(context);
                  },
                  child:Text('Cancel',style: TextStyle(color: Colors.white,fontSize: SizeConfig.titleSize * 2.7),),

                ),
              ),
              Container(
                clipBehavior: Clip.antiAlias,
                height: 35,
                decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(10)
                ),
                child: MaterialButton(
                  onPressed: (){
                    context.read<CaptainOrdersListBloc>().deleteOrder(orderID).then((value) {
                      if(value){
                        snackBarSuccessWidget(context, 'Success Deleted !!');
                        Navigator.pop(context);

                      }else{
                        snackBarErrorWidget(context, 'Error in Deleted  !!');
                      }

                    });
                  },
                  child:Text('Delete',style: TextStyle(color: Colors.white,fontSize: SizeConfig.titleSize * 2.7),),

                ),
              ),
            ],
          ),
        ],
      ),
    ),

  );

// show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

