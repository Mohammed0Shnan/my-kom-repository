
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_kom/consts/colors.dart';
import 'package:my_kom/utils/size_configration/size_config.dart';
class ConnectUsScreen extends StatefulWidget {
  const ConnectUsScreen({Key? key}) : super(key: key);

  @override
  State<ConnectUsScreen> createState() => _ConnectUsScreenState();
}
class _ConnectUsScreenState extends State<ConnectUsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsConst.mainColor,
      appBar: AppBar(
        backgroundColor: ColorsConst.mainColor,
        elevation: 0,
        title: Text('Connect Us'),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: SizeConfig.screenHeight * 0.03,),
          Center(
            child: Container(
              width: SizeConfig.screenWidth * 0.6,
              child: Image.asset('assets/new_logo.png'),
            ),

          ),
          SizedBox(height: SizeConfig.screenHeight * 0.1,),
          Center(
            child: Container(
              height: SizeConfig.heightMulti * 9.5,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10)),
              padding: EdgeInsets.symmetric(vertical: 10),
              child: ClipRRect(
                clipBehavior: Clip.antiAlias,
                borderRadius: BorderRadius.circular(10),
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(

                      primary:Colors.white,
                    ),
                    onPressed: () {

                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.phone,color: Colors.blue,),
                        SizedBox(width: 10,),
                        Text('05554434232',
                            style: TextStyle(
                                color: Colors.blue,
                                fontSize:
                                SizeConfig.titleSize * 3,
                                fontWeight: FontWeight.w700)),
                      ],
                    )),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
