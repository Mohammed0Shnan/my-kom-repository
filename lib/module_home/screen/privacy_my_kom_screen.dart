
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_kom/consts/colors.dart';
import 'package:my_kom/utils/size_configration/size_config.dart';
class PrivacyMyKomScreen extends StatefulWidget {
  const PrivacyMyKomScreen({Key? key}) : super(key: key);

  @override
  State<PrivacyMyKomScreen> createState() => _PrivacyMyKomScreenState();
}

class _PrivacyMyKomScreenState extends State<PrivacyMyKomScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsConst.mainColor,
      appBar: AppBar(
        backgroundColor: ColorsConst.mainColor,
        elevation: 0,
        title: Text('Privacy'),
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
          Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Text('information information informationinformation informationinformation vinformation informationinformation information ',
              style: GoogleFonts.lato(
                color: Colors.white,
                fontSize: 16
              ),
              ))
        ],
      ),
    );
  }
}
