import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_kom/consts/colors.dart';
import 'package:my_kom/module_authorization/bloc/is_loggedin_cubit.dart';
import 'package:my_kom/module_authorization/requests/register_request.dart';
import 'package:my_kom/module_authorization/screens/widgets/login_sheak_alert.dart';
import 'package:my_kom/module_map/map_routes.dart';
import 'package:my_kom/module_map/models/address_model.dart';
import 'package:my_kom/module_orders/ui/widgets/no_data_for_display_widget.dart';
import 'package:my_kom/module_profile/bloc/profile_bloc.dart';
import 'package:my_kom/utils/size_configration/size_config.dart';
import 'package:my_kom/generated/l10n.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ProfileBloc profileBloc = ProfileBloc();
  late final IsLogginCubit isLogginCubit;
  final TextEditingController _profileUserNameController = TextEditingController();
  final TextEditingController _profileAddressController = TextEditingController();
  final TextEditingController _profilePhoneController = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState

    isLogginCubit = IsLogginCubit();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      userId =  ModalRoute.of(context)!.settings.arguments as String? ;

    });
    super.initState();
  }

  @override
  void dispose() {
    isLogginCubit.close();
    super.dispose();
  }
 late String? userId;
  bool isEditingProfile = false;
 late ProfileRequest? request ;
  late AddressModel addressModel ;
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<IsLogginCubit,IsLogginCubitState>(
        bloc: isLogginCubit,
        listener: (context,state){
      if(state ==IsLogginCubitState.LoggedIn)
        {
          if(userId == null){
            profileBloc.getMyProfile();
          }else{
            profileBloc.getUserProfile(userId: userId!);
          }
        }
      if(state == IsLogginCubitState.NotLoggedIn)
        loginCheakAlertWidget(context);
    },
    builder: (context,state){
    if(state == IsLogginCubitState.LoggedIn){

      return  Stack(
        children: [
          Container(
            color: Colors.grey.shade50,
          ),
          Scaffold(
            backgroundColor: Colors.transparent,
            body: BlocConsumer<ProfileBloc, ProfileStates>(
                bloc: profileBloc,
                listener: (context,state){
                  if(state is ProfileSuccessState){
                    _profileUserNameController.text = state.data.userName;
                    _profileAddressController.text = state.data.address.description;
                    _profilePhoneController.text = state.data.phone;
                    addressModel = state.data.address;
                    if(state.isEditState){
                      isEditingProfile = ! isEditingProfile;
                    }

                  }
                },
                builder: (context,state) {

                  if(state is ProfileErrorState){
                    return NoDataForDisplayWidget();
                  }
                  else if(state is ProfileSuccessState) {

                    return SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 30),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Spacer(),
                                IconButton(
                                  onPressed: (){
                                    if(!isEditingProfile){
                                      isEditingProfile = !isEditingProfile;
                                      setState((){});
                                    }else{
                                      request = ProfileRequest
                                        (userName: _profileUserNameController.text.trim(), address:
                                      addressModel
                                          , phone: _profilePhoneController.text.trim(),
                                      );
                                      profileBloc.editProfile(request!);
                                    }


                                  },
                                  icon: Icon(!isEditingProfile? Icons.edit: Icons.save , color: Colors.black54,),
                                ),

                              ],
                            ),
                            SizedBox(height: 5,),
                            Text(S.of(context)!.myProfile,textAlign: TextAlign.center,style: TextStyle(
                                color: Colors.black54,
                                fontSize: SizeConfig.titleSize * 3.2,
                                fontWeight: FontWeight.bold


                            ),),
                            SizedBox(height: 20,),
                            Container(
                              height: SizeConfig.screenHeight * 0.27,
                              child: LayoutBuilder(
                                builder: (context,constraints){
                                  double innerHeight  = constraints.maxHeight;
                                  double innerWidth  = constraints.maxWidth;
                                  return Stack(
                                    fit:StackFit.expand,
                                    alignment: Alignment.center,
                                    children: [
                                      Positioned(left: 0,
                                        right: 0,
                                        bottom: 0,
                                        child: Container(
                                          alignment: Alignment.center,
                                          height:innerHeight * 0.55,
                                          width:innerWidth ,
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              boxShadow: [
                                                BoxShadow(color: Colors.black12,
                                                    blurRadius: 5
                                                )
                                              ],
                                              borderRadius: BorderRadius.circular(30)
                                          ),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [

                                              SizedBox(
                                                height: SizeConfig.heightMulti * 4.5,
                                              ),
                                              Center(
                                                child: TextFormField(
                                                  textAlign: TextAlign.center,

                                                  controller: _profileUserNameController,

                                                  style: TextStyle(

                                                      fontSize: SizeConfig.titleSize * 2.8,
                                                      fontWeight: FontWeight.bold,
                                                      color: Colors.grey[700]
                                                  ),

                                                  decoration: InputDecoration(
                                                    suffixIcon: (!isEditingProfile)?null:Icon(Icons.edit,color: Colors.black,),
                                                    border: InputBorder.none,
                                                    //S.of(context).name,
                                                  ),
                                                  textInputAction: TextInputAction.next,
                                                  // Move focus to next
                                                ),
                                              ),


                                            ],),
                                        ),
                                      ),
                                      Positioned(
                                        top: 0,
                                        left: 0,
                                        right: 0,
                                        child: Center(
                                          child: Container(
                                            clipBehavior: Clip.antiAlias,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              boxShadow: [
                                                BoxShadow(color: Colors.black12,
                                                    blurRadius: 5
                                                )
                                              ],
                                            ),
                                            child: Image.asset('assets/profile.png',
                                              fit: BoxFit.fitWidth,
                                              width: innerWidth *0.35,
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  );
                                },
                              ),
                            ),
                            SizedBox(height: 25,),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 15),
                              height: SizeConfig.screenHeight * 0.43,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(color: Colors.black12,
                                      blurRadius: 5
                                  )
                                ],
                              ),
                              child: Column(
                                children: [
                                  SizedBox(height: 20,),

                                  Text(S.of(context)!.myInformation,style:  TextStyle(
                                      fontSize: SizeConfig.titleSize * 2.3,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey[600]
                                  ),),
                                  Divider(
                                    thickness: 2.5,
                                  ),
                                  SizedBox(height: 10,),

                                  Container(
                                    height: SizeConfig.screenHeight *0.14,
                                    padding: EdgeInsets.symmetric(horizontal: 20),
                                    decoration: BoxDecoration(

                                        borderRadius: BorderRadius.circular(30),
                                        color: Colors.grey.shade200
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        SizedBox(height: 8,),
                                        Text(S.of(context)!.myAddress,style:  TextStyle(
                                            fontSize: SizeConfig.titleSize * 2,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.grey[600]
                                        ),),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Icon(Icons.location_on , color: ColorsConst.mainColor,size: 17,),
                                            SizedBox(width: 10,),
                                            Expanded(
                                              child: Container(
                                                padding: EdgeInsets.only(top: 12),
                                                child: TextFormField(
                                                  readOnly: true,
                                                  controller: _profileAddressController,
                                                  maxLines: 2,
                                                  style:  TextStyle(
                                                      fontSize:SizeConfig.titleSize * 1.7,

                                                      fontWeight: FontWeight.bold,
                                                      color: Colors.grey[600]
                                                  ),
                                                  decoration: InputDecoration(
                                                    border: InputBorder.none,
                                                    //S.of(context).name,
                                                  ),
                                                  textInputAction: TextInputAction.next,
                                                  // Move focus to next
                                                ),
                                              ),

                                            ),
                                            if(isEditingProfile)
                                              GestureDetector(
                                                onTap: (){
                                                  Navigator.pushNamed(
                                                      context, MapRoutes.MAP_SCREEN,arguments: true)
                                                      .then((value) {
                                                    if (value != null) {
                                                      addressModel = (value as AddressModel);
                                                      _profileAddressController.text =
                                                          addressModel.description;
                                                      addressModel = value;

                                                    }

                                                  });
                                                },
                                                child: Container(
                                                  width: SizeConfig.heightMulti * 5,
                                                  height: SizeConfig.heightMulti * 5,
                                                  decoration: BoxDecoration(
                                                      color: ColorsConst.mainColor,
                                                      borderRadius:
                                                      BorderRadius.circular(10)),
                                                  child: Icon(
                                                      Icons.my_location_outlined,
                                                      size: SizeConfig.heightMulti *3,
                                                      color: Colors.white),
                                                ),
                                              )

                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 10,),
                                  Container(
                                    padding: EdgeInsets.symmetric(horizontal: 20),

                                    height: SizeConfig.screenHeight *0.15,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(30),
                                        color: Colors.grey.shade200
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.center,                            children: [
                                      Text(S.of(context)!.emailAndPhone,style:  TextStyle(
                                          fontSize: SizeConfig.titleSize * 2,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey[600]
                                      ),),
                                      SizedBox(height: 8,),

                                      Row(
                                        children: [
                                          Icon(Icons.email , color: ColorsConst.mainColor,size: 17,),
                                          SizedBox(width: 10,),
                                          Text(state.data.email,style:  TextStyle(
                                              fontSize: SizeConfig.titleSize * 1.7,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.grey[600]
                                          ),),

                                        ],
                                      ),
                                      SizedBox(height: 5,),

                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(Icons.phone , color: ColorsConst.mainColor,size: 17,),
                                          SizedBox(width: 10,),
                                          Text(state.data.phone,style:  TextStyle(
                                              fontSize: SizeConfig.titleSize * 1.7,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.grey[600]
                                          ),),


                                        ],
                                      )
                                    ],
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  } else
                    return Center(
                      child: Container(
                        height: 40,
                        width: 40,
                        child: Center(
                          child: CircularProgressIndicator(color: ColorsConst.mainColor,),
                        ),
                      ),
                    );
                }
            ),
          )
        ],
      );

    }
    else{
      return Scaffold(
        backgroundColor: Colors.white,
      );
    }
        }

    );


  }

}

