import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_kom/consts/colors.dart';
import 'package:my_kom/module_authorization/authorization_routes.dart';
import 'package:my_kom/module_authorization/service/auth_service.dart';
import 'package:my_kom/module_home/screen/about_my_kom_screen.dart';
import 'package:my_kom/module_home/screen/connect_us_screen.dart';
import 'package:my_kom/module_home/screen/privacy_my_kom_screen.dart';
import 'package:my_kom/module_home/screen/usage_policy_screen.dart';
import 'package:my_kom/module_home/widgets/menu_item.dart';
import 'package:my_kom/module_localization/service/localization_service/localization_b;oc_service.dart';
import 'package:my_kom/utils/size_configration/size_config.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  final AuthService _authService = AuthService();
  final LocalizationService _localizationService = LocalizationService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            SizedBox(height: 30,),
            Expanded(
              child: GridView(gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3,
              childAspectRatio: 1,
                crossAxisSpacing: 30,
                mainAxisSpacing: 20
              ),

              children: [
                Container(
                  padding: EdgeInsets.only(top: 8,left: 4,right: 4),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white,
                    boxShadow: [BoxShadow(
                      color: Colors.black12,
                      blurRadius: 2,
                      offset: Offset(0,1)
                    )]
                  ),
                  child: Column(
                    children: [
                      Icon(Icons.language_outlined ,color: ColorsConst.mainColor,size: 7* SizeConfig.heightMulti),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 5),
                          child: BlocBuilder<LocalizationService,LocalizationState>(
                            bloc: _localizationService ,
                            builder: (context, state){
                              String lang ;
                              if(state is LocalizationArabicState){
                                lang = 'ar';
                              }else{
                                lang = 'en';
                              }
                              return DropdownButtonFormField<String>(

                                  decoration: InputDecoration(
                                    border: InputBorder.none,

                                  ),

                                  items: [
                                    DropdownMenuItem(
                                      child: Text('arabic',  style: TextStyle(fontWeight: FontWeight.bold,fontSize:  2.6 * SizeConfig.heightMulti,color: Colors.black45)),//Text(S.of(context).arabic),
                                      value: 'ar',
                                    ),
                                    DropdownMenuItem(
                                      child:Text('english', style: TextStyle(fontWeight: FontWeight.bold,fontSize:  2.6 * SizeConfig.heightMulti,color: Colors.black45)),//, Text(S.of(context).english),
                                      value: 'en',
                                    ),
                                  ],
                                  value: lang,
                                  onChanged: (String? newLang) {
                                    _localizationService.setLanguage(newLang!);
                                  });
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                GestureDetector(
                  onTap: (){},
                  child: Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white,
                        boxShadow: [BoxShadow(
                            color: Colors.black12,
                            blurRadius: 2,
                            offset: Offset(0,1)
                        )]
                    ),
                    child: Column(
                      children: [
                        Icon(Icons.settings_outlined ,color: ColorsConst.mainColor,size: 7 * SizeConfig.heightMulti),
                        SizedBox(height: 10,),
                        Expanded(child: Text('Setting', style: TextStyle(fontWeight: FontWeight.bold,fontSize:  2.6 * SizeConfig.heightMulti,color: Colors.black45),  ))
                      ],
                    ),

                  ),
                ),
                GestureDetector(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=> AboutMyKomScreen() ));

                  },
                  child: Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white,
                        boxShadow: [BoxShadow(
                            color: Colors.black12,
                            blurRadius: 2,
                            offset: Offset(0,1)
                        )]
                    ),
                    child: Column(
                      children: [
                        Icon(Icons.info_outline ,color: ColorsConst.mainColor,size: 7 * SizeConfig.heightMulti),
                        SizedBox(height: 10,),
                        Expanded(child: Text('About', style: TextStyle(fontWeight: FontWeight.bold,fontSize:  2.6 * SizeConfig.heightMulti,color: Colors.black45),  ))
                      ],
                    ),

                  ),
                ),
                GestureDetector(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=> PrivacyMyKomScreen() ));
                  },
                  child: Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white,
                        boxShadow: [BoxShadow(
                            color: Colors.black12,
                            blurRadius: 2,
                            offset: Offset(0,1)
                        )]
                    ),
                    child: Column(
                      children: [
                        Icon(Icons.lock_outline ,color: ColorsConst.mainColor,size: 7 * SizeConfig.heightMulti),
                        SizedBox(height: 10,),
                        Expanded(child: Text('Privacy', style: TextStyle(fontWeight: FontWeight.bold,fontSize:  2.6 * SizeConfig.heightMulti,color: Colors.black45),  ))
                      ],
                    ),

                  ),
                ),

                GestureDetector(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=> UsagePolicyScreen() ));

                  },
                  child: Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white,
                        boxShadow: [BoxShadow(
                            color: Colors.black12,
                            blurRadius: 2,
                            offset: Offset(0,1)
                        )]
                    ),
                    child: Column(
                      children: [
                        Icon(Icons.description_outlined ,color: ColorsConst.mainColor,size: 7 * SizeConfig.heightMulti),
                        SizedBox(height: 10,),
                        Expanded(child: Text('Policy', style: TextStyle(fontWeight: FontWeight.bold,fontSize:  2.6 * SizeConfig.heightMulti,color: Colors.black45),  ))
                      ],
                    ),

                  ),
                ),
                GestureDetector(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=> ConnectUsScreen() ));

                  },
                  child: Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white,
                        boxShadow: [BoxShadow(
                            color: Colors.black12,
                            blurRadius: 2,
                            offset: Offset(0,1)
                        )]
                    ),
                    child: Column(
                      children: [
                        Icon(Icons.phone_outlined ,color: ColorsConst.mainColor,size: 7 * SizeConfig.heightMulti),
                        SizedBox(height: 10,),
                        Expanded(child: Text('Connect', style: TextStyle(fontWeight: FontWeight.bold,fontSize:  2.6 * SizeConfig.heightMulti,color: Colors.black45),  ))
                      ],
                    ),

                  ),
                ),
                GestureDetector(
                  onTap: (){
                    _authService.logout().then((value) {
                      Navigator.pushNamedAndRemoveUntil(context, AuthorizationRoutes.LOGIN_SCREEN,(route)=>false);
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white,
                        boxShadow: [BoxShadow(
                            color: Colors.black12,
                            blurRadius: 2,
                            offset: Offset(0,1)
                        )]
                    ),
                    child: Column(
                      children: [
                        Icon(Icons.logout_outlined ,color: ColorsConst.mainColor,size: 7 * SizeConfig.heightMulti),
                        SizedBox(height: 10,),
                        Expanded(child: Text('Logout', style: TextStyle(fontWeight: FontWeight.bold,fontSize:  2.6 * SizeConfig.heightMulti,color: Colors.black45),  ))
                      ],
                    ),

                  ),
                ),

              ],
              ),
            ),

          ],
        ),
      ),
    );
  }
}
