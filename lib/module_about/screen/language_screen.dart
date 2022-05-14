import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_kom/module_about/screen/about_screen.dart';
import 'package:my_kom/module_about/widgets/language_drop_down.dart';
import 'package:my_kom/module_about/widgets/wave_loading.dart';
import 'package:my_kom/utils/size_configration/size_config.dart';

class LanguageScreen extends StatelessWidget {
  const LanguageScreen({Key? key}) : super(key: key);

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
                    child: WaveLoadingWidget(
                      container_height: 31.25 * SizeConfig.heightMulti,
                      container_width: 31.25 * SizeConfig.heightMulti,
                      run: true,
                    ),
                  ),
                ),
                SizedBox(
                  height: SizeConfig.heightMulti * 12,
                ),
                ListTile(
                    title: Padding(
                        padding: EdgeInsets.only(bottom: 10),
                        child: Text('Language',
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
                    subtitle: LangugeDropDownWidget()),
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
                        child: Text('Next',
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
