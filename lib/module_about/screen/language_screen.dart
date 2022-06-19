import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_kom/generated/l10n.dart';
import 'package:my_kom/module_about/screen/about_screen.dart';
import 'package:my_kom/module_about/widgets/language_drop_down.dart';
import 'package:my_kom/module_about/widgets/wave_loading.dart';
import 'package:my_kom/module_localization/service/localization_service/localization_b;oc_service.dart';
import 'package:my_kom/utils/size_configration/size_config.dart';

class LanguageScreen extends StatelessWidget {
 final  LocalizationService localizationService ;
  const LanguageScreen({ required this.localizationService, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Material(
          child: Container(
            width: SizeConfig.screenWidth,
            padding:
                EdgeInsets.symmetric(horizontal: SizeConfig.screenWidth * 0.08),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Hero(
                  tag: 'logo',
                  child: Center(
                    child: Container(
                           height: 31.25 * SizeConfig.heightMulti,
                           width: 31.25 * SizeConfig.heightMulti,
                      child: Image.asset('assets/new_oval_logo.png',fit: BoxFit.contain,),
                    ),
                  ),
                ),
                SizedBox(
                  height: SizeConfig.heightMulti * 12,
                ),
                ListTile(
                    title: Padding(
                        padding: EdgeInsets.only(bottom: 10),
                        child: Text(S.of(context)!.language,
                            style: GoogleFonts.lato(
                              color: Colors.black54,
                                fontWeight: FontWeight.w600
                            ),
                            // style: TextStyle(
                            //     color: Colors.black,
                            //     fontSize: SizeConfig.titleSize * 2.2,
                            //     fontWeight: FontWeight.w600)
                        )
                    ),
                    subtitle: LangugeDropDownWidget(localizationService: localizationService,)),
                SizedBox(
                  height: SizeConfig.heightMulti * 3.3,
                ),
                ListTile(
                  title: Container(
                    height: 11.8 *  SizeConfig.heightMulti ,
                    clipBehavior: Clip.antiAlias,
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(10)),
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          primary: Color.fromARGB(255, 28, 174, 147),
                        ),
                        onPressed: () {
                              Navigator.of(context)
                            .push(MaterialPageRoute(builder: (conterxt) {
                          return AboutScreen();
                        }));
                          
                        },
                        child: Text(S.of(context)!.next,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: SizeConfig.titleSize * 2.6,
                                fontWeight: FontWeight.w700))),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
