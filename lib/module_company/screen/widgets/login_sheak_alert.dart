import 'package:flutter/material.dart';
import 'package:my_kom/consts/colors.dart';
import 'package:my_kom/module_authorization/authorization_routes.dart';
import 'package:my_kom/utils/size_configration/size_config.dart';


loginCheakAlertWidget(context){
  // set up the AlertDialog
  AlertDialog alert = AlertDialog(


    content: Container(
      height: 150,
      child: Column(
crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          IconButton(onPressed: (){
            Navigator.pop(context);
          }, icon: Icon(Icons.clear)),
          Text('You are not subscribed to May',style: TextStyle(fontSize: SizeConfig.titleSize * 2.3,fontWeight: FontWeight.w600,color: Colors.black54),),
          Spacer(),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
                color: ColorsConst.mainColor,
                borderRadius: BorderRadius.circular(10)
            ),
            child: MaterialButton(
              onPressed: (){
                Navigator.pushNamed(context, AuthorizationRoutes.LOGIN_SCREEN);
              },
              child:Text('Login',style: TextStyle(color: Colors.white,fontSize: SizeConfig.titleSize * 2.7),),

            ),
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

