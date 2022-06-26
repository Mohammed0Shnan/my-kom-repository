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
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 30,),

            // InkWell(
            //   onTap: (){
            //     Navigator.push(context, MaterialPageRoute(builder:(context)=> WalletScreen()));
            //   },
            //   child: menuItem(
            //       icon: Icons.shopping_basket,
            //       title: 'My Wallet'
            //   ),
            // ),

            ListTile(
              leading: Icon(Icons.language ,color: ColorsConst.mainColor,size: 4.8 * SizeConfig.heightMulti),
              title: BlocBuilder<LocalizationService,LocalizationState>(
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
                          border: InputBorder.none),

                      items: [
                        DropdownMenuItem(
                          child: Text('arabic',  style: TextStyle(fontWeight: FontWeight.bold,fontSize:  3.5 * SizeConfig.heightMulti,color: Colors.black45)),//Text(S.of(context).arabic),
                          value: 'ar',
                        ),
                        DropdownMenuItem(
                          child:Text('english', style: TextStyle(fontWeight: FontWeight.bold,fontSize:  3.5 * SizeConfig.heightMulti,color: Colors.black45)),//, Text(S.of(context).english),
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
            SizedBox(height: 10,),
            menuItem(
                icon: Icons.settings,
                title: 'Setting',
              onTap: (){

              }
            ),

            SizedBox(height: 10,),
            menuItem(
                icon: Icons.info,
                title: 'About My Kom',
              onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> AboutMyKomScreen()));
              }
            ),
            SizedBox(height: 10,),
            menuItem(
                icon: Icons.lock,
                title: 'Privacy',
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> PrivacyMyKomScreen()));
                }
            ),
            SizedBox(height: 10,),
            menuItem(
                icon: Icons.description,
                title: 'Usage Policy',
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> UsagePolicyScreen()));
                }
            ),
            SizedBox(height: 10,),
            menuItem(
                icon: Icons.phone,
                title: 'Connect Us',
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> ConnectUsScreen()));
                }
            ),
            menuItem(
                icon: Icons.edit,
                title: 'Logout',
              onTap: (){
                AuthService().logout().then((value) {
                  //AboutService().setInited();
                  Navigator.pushNamedAndRemoveUntil(context, AuthorizationRoutes.LOGIN_SCREEN,(route)=>false);
                });
              }
            ),
          ],
        ),
      ),
    );
  }
}
