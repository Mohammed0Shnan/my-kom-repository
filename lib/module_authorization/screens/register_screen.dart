import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_kom/consts/colors.dart';
import 'package:my_kom/module_authorization/authorization_routes.dart';
import 'package:my_kom/module_authorization/bloc/cubits.dart';
import 'package:my_kom/module_authorization/bloc/register_bloc.dart';
import 'package:my_kom/module_authorization/enums/user_role.dart';
import 'package:my_kom/module_authorization/requests/register_request.dart';
import 'package:my_kom/module_authorization/screens/widgets/top_snack_bar_widgets.dart';
import 'package:my_kom/module_home/navigator_routes.dart';
import 'package:my_kom/module_map/map_routes.dart';
import 'package:my_kom/module_map/models/address_model.dart';
import 'package:my_kom/utils/size_configration/size_config.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:country_code_picker/country_code_picker.dart';

class RegisterScreen extends StatefulWidget {
  final RegisterBloc _bloc = RegisterBloc();
  RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final GlobalKey<FormState> _registerFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _registerCompleteFormKey = GlobalKey<FormState>();
  final TextEditingController _registerEmailController =
      TextEditingController();
  final TextEditingController _registerPasswordController =
      TextEditingController();
  final TextEditingController _registerConfirmPasswordController =
      TextEditingController();
  final TextEditingController _registerUserNameController =
      TextEditingController();
  final TextEditingController _registerAddressController =
      TextEditingController();
  final TextEditingController _registerPhoneNumberController =
      TextEditingController();

  late final PasswordHiddinCubit cubit1, cubit2;
  late final PageController _pageController;
  late final UserRole userRole;
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      userRole =  ModalRoute.of(context)!.settings.arguments as UserRole;
    });
    super.initState();
    _pageController = PageController(
      initialPage: 0,
    );
    cubit1 = PasswordHiddinCubit();
    cubit2 = PasswordHiddinCubit();
  }

  @override
  void dispose() {
    cubit1.close();
    cubit2.close();
    super.dispose();
  }

  late AddressModel addressModel;
  @override
  Widget build(BuildContext context) {
    final node = FocusScope.of(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Container(
            width: SizeConfig.screenWidth,
            height: SizeConfig.heightMulti * 7,
            color: ColorsConst.mainColor,

          ),
          Expanded(
            child: PageView(
              physics: NeverScrollableScrollPhysics(),
              controller: _pageController,
              children: [
                /// Page Number One
                ///
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          height: SizeConfig.screenHeight * 0.25,
                          margin: EdgeInsets.symmetric(
                              horizontal: SizeConfig.screenWidth * 0.2),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(height: 10,),

                              Text('Create New\n Account',
                                  textAlign:TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.black45,
                                      fontWeight: FontWeight.w900,
                                      fontSize: SizeConfig.titleSize * 5)),
                              SizedBox(
                                height:SizeConfig.screenHeight * 0.03,
                              ),
                              Container(
                                alignment: Alignment.center,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Already have one !  ',
                                      style: TextStyle(
                                          fontSize: SizeConfig.titleSize * 3,
                                          color: Colors.black45,
                                          fontWeight: FontWeight.w800
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.pushNamed(
                                            context, AuthorizationRoutes.LOGIN_SCREEN);
                                      },
                                      child: Text('Login',
                                          style:  GoogleFonts.lato(
                                              fontSize: SizeConfig.titleSize * 2.5,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.blue                          )),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Form(
                          key: _registerFormKey,
                          child: Flex(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            direction: Axis.vertical,
                            children: [
                              ListTile(
                                  title: Padding(
                                      padding: EdgeInsets.only(bottom: 8),
                                      child: Text('EMAIL', style:GoogleFonts.lato(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black54,
                                          fontSize: SizeConfig.titleSize * 2.7
                                      ))),
                                  subtitle: TextFormField(
                                    style: TextStyle(fontSize: 20),
                                    keyboardType: TextInputType.emailAddress,
                                    controller: _registerEmailController,
                                    decoration: InputDecoration(


                                        border:OutlineInputBorder(
                                            borderSide: BorderSide(
                                                width: 2,
                                                style:BorderStyle.solid ,
                                                color: Colors.black87
                                            )
                                        ),
                                        hintText: 'Email'
                                        ,
                                        hintStyle: TextStyle(color: Colors.black26,fontWeight: FontWeight.w800,fontSize: 13)
                                        //S.of(context).name,
                                        ),
                                    textInputAction: TextInputAction.next,
                                    onEditingComplete: () => node.nextFocus(),
                                    // Move focus to next
                                    validator: (result) {
                                      if (result!.isEmpty) {
                                        return 'Email is Required'; //S.of(context).nameIsRequired;
                                      }
                                      if (!_validateEmailStructure(result))
                                        return 'Must write an email';
                                      return null;
                                    },
                                  )),
                              SizedBox(
                                height:SizeConfig.screenHeight * 0.015,
                              ),
                              ListTile(
                                title: Padding(
                                    padding: EdgeInsets.only(bottom: 8),
                                    child: Text('PASSWORD', style:GoogleFonts.lato(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black54,
                                        fontSize: SizeConfig.titleSize * 2.5
                                    ))),
                                subtitle: BlocBuilder<PasswordHiddinCubit,
                                    PasswordHiddinCubitState>(
                                  bloc: cubit1,
                                  builder: (context, state) {
                                    return TextFormField(
                                      controller: _registerPasswordController,
                                      decoration: InputDecoration(

                                          suffixIcon: IconButton(
                                              onPressed: () {
                                                cubit1.changeState();
                                              },
                                              icon: state ==
                                                      PasswordHiddinCubitState
                                                          .VISIBILITY
                                                  ? Icon(Icons.visibility)
                                                  : Icon(Icons.visibility_off)),
                                          border:OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  width: 2,
                                                  style:BorderStyle.solid ,
                                                  color: Colors.black87
                                              )
                                          ),
                                          hintText:
                                              'Password' // S.of(context).email,
                                        , hintStyle: TextStyle(color: Colors.black26,fontWeight: FontWeight.w800,fontSize: 13)
                                          ),
                                      obscureText: state ==
                                              PasswordHiddinCubitState.VISIBILITY
                                          ? false
                                          : true,
                                      textInputAction: TextInputAction.next,
                                      onEditingComplete: () => node.nextFocus(),

                                      // Move focus to next
                                      validator: (result) {
                                        if (result!.isEmpty) {
                                          return '* Password is Required'; //S.of(context).emailAddressIsRequired;
                                        }
                                        if (result.length < 8) {
                                          return '* The password is short, it must be 8 characters long'; //S.of(context).emailAddressIsRequired;
                                        }
                                        if (!_validatePasswordStructure(result))
                                          return '* It must be made up of numbers, letters and signs';
                                        return null;
                                      },
                                    );
                                  },
                                ),
                              ),
                              SizedBox(
                                height:SizeConfig.screenHeight * 0.015,
                              ),
                              ListTile(
                                title: Padding(
                                    padding: EdgeInsets.only(bottom: 8),
                                    child: Text('CONFIRM',style:GoogleFonts.lato(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black54,
                                        fontSize: SizeConfig.titleSize * 2.5
                                    ))),
                                subtitle: BlocBuilder<PasswordHiddinCubit,
                                    PasswordHiddinCubitState>(
                                  bloc: cubit2,
                                  builder: (context, state) {
                                    return TextFormField(
                                      controller:
                                          _registerConfirmPasswordController,
                                      decoration: InputDecoration(

                                          suffixIcon: IconButton(
                                              onPressed: () {
                                                cubit2.changeState();
                                              },
                                              icon: state ==
                                                      PasswordHiddinCubitState
                                                          .VISIBILITY
                                                  ? Icon(Icons.visibility)
                                                  : Icon(Icons.visibility_off)),
                                          border:OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  width: 2,
                                                  style:BorderStyle.solid ,
                                                  color: Colors.black87
                                              )
                                          ),
                                          hintText:
                                              'Confirm Password' // S.of(context).password,
                                        , hintStyle: TextStyle(color: Colors.black26,fontWeight: FontWeight.w800,fontSize: 13)
                                          ),
                                      validator: (result) {
                                        if (result!.trim() !=
                                            _registerPasswordController.text
                                                .trim()) {
                                          return 'Confirm pass mismatch';
                                        }
                                        if (result.isEmpty) {
                                          return 'Confirm Password Is Required!';
                                        }
                                        return null;
                                      },
                                      obscureText: state ==
                                              PasswordHiddinCubitState.VISIBILITY
                                          ? false
                                          : true,
                                      textInputAction: TextInputAction.done,
                                      onFieldSubmitted: (_) => node
                                          .unfocus(), // Submit and hide keyboard
                                    );
                                  },
                                ),
                              ),
                              SizedBox(
                                height:SizeConfig.screenHeight * 0.04,
                              ),
                              Center(
                                child: SmoothPageIndicator(
                                  controller: _pageController,
                                  count: 2,
                                  effect: ExpandingDotsEffect(
                                      dotColor: Colors.black12,
                                      dotHeight: 10,
                                      dotWidth: 10,
                                      spacing: 2,
                                      activeDotColor: ColorsConst.mainColor),
                                ),
                              ),
                              SizedBox(
                                height:SizeConfig.screenHeight * 0.05,
                              ),
                              BlocConsumer<RegisterBloc, RegisterStates>(
                                bloc: widget._bloc,
                                listener: (context, state) {
                                  if (state is RegisterSuccessState) {
                                    _pageController.jumpToPage(1);
                                  } else if (state is RegisterErrorState) {
                                    snackBarErrorWidget(context, state.message);
                                  }
                                },
                                builder: (context, state) {
                                  if (state is RegisterLoadingState)
                                    return Center(
                                        child: Container(
                                          margin: EdgeInsets.all(20),
                                            width: 50,
                                            height: 50,
                                            child: CircularProgressIndicator()));
                                  else
                                    return ListTile(
                                      title: Container(
                                        height: SizeConfig.heightMulti * 10,

                                        padding: EdgeInsets.symmetric(vertical: 10),
                                        child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(

                                              primary:
                                                  Color.fromARGB(255, 28, 174, 147),
                                            ),
                                            onPressed: () {
                                              if (_registerFormKey.currentState!
                                                  .validate()) {
                                                String email =
                                                    _registerEmailController.text
                                                        .trim();
                                                String password =
                                                    _registerPasswordController.text
                                                        .trim();
                                                widget._bloc.register(
                                                    userRole: userRole,
                                                    email: email,
                                                    password: password);
                                              }
                                            },
                                            child: Text('Next',
                                                style: TextStyle(
                                                    color: Colors.black87,
                                                    fontSize:
                                                        SizeConfig.titleSize * 2.6,
                                                    fontWeight: FontWeight.w700))),
                                      ),
                                    );
                                },
                              ),

                            ],
                          ),
                        ),

                      ],
                    ),
                  ),
                ),

                //////////////////////////
                //////////////////////////
                /////////////////////////
                /// Page Number Tow

                WillPopScope(
                  onWillPop: ()=> _willPop(),
                  child: Container(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(height: 20,),
                          Text('Complete your details',
                              textAlign:TextAlign.center,
                              style: TextStyle(
                                  color: Colors.black45,
                                  fontWeight: FontWeight.w900,
                                  fontSize: SizeConfig.titleSize * 4.5)),
                          SizedBox(height: SizeConfig.heightMulti * 3,),
                          // Container(
                          //   margin: EdgeInsets.symmetric(horizontal: 30),
                          //   alignment: Alignment.center,
                          //   child: Row(
                          //     mainAxisAlignment: MainAxisAlignment.center,
                          //     children: [
                          //       Text(
                          //         'When registering, you agree to ! ',
                          //         style: TextStyle(
                          //             fontSize: SizeConfig.titleSize * 1.8,
                          //             color: Colors.black54,
                          //             fontWeight: FontWeight.w700
                          //         ),
                          //       ),
                          //       SizedBox(width: 5,),
                          //       Expanded(
                          //         child: GestureDetector(
                          //           onTap: () {},
                          //           child: Container(
                          //             child: Text('the Privacy and Security Policy',
                          //                 style: TextStyle(
                          //                     fontSize: SizeConfig.titleSize * 2,
                          //                     fontWeight: FontWeight.w800,
                          //                     color: ColorsConst.mainColor)),
                          //           ),
                          //         ),
                          //       )
                          //     ],
                          //   ),
                          // ),
                          SizedBox(
                            height:SizeConfig.screenHeight * 0.07,
                          ),
                          Form(
                            key: _registerCompleteFormKey,
                            child: Flex(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              direction: Axis.vertical,
                              children: [
                                ListTile(
                                    title: Padding(
                                      padding: EdgeInsets.only(bottom: 8),
                                      child: Text('NAME',style:GoogleFonts.lato(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black54,
                                          fontSize: SizeConfig.titleSize * 2.7
                                      ))),
                                    subtitle: TextFormField(
                                      controller: _registerUserNameController,
                                      decoration: InputDecoration(
                                          errorStyle: GoogleFonts.lato(
                                            color: Colors.red.shade700,
                                            fontWeight: FontWeight.w800,


                                          ),
                                          border:OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  width: 2,
                                                  style:BorderStyle.solid ,
                                                  color: Colors.black87
                                              )
                                          ),                                          hintText: 'Mohammed .'
                                            , hintStyle:  TextStyle(color: Colors.black26,fontWeight: FontWeight.w800,fontSize: 13)

                                          //S.of(context).name,
                                          ),
                                      textInputAction: TextInputAction.next,
                                      onEditingComplete: () => node.nextFocus(),
                                      // Move focus to next
                                      validator: (result) {
                                        if (result!.isEmpty) {
                                          return 'User Name is Required'; //S.of(context).nameIsRequired;
                                        }
                                        return null;
                                      },
                                    )),
                                SizedBox(
                                  height: 8,
                                ),
                                ListTile(
                                    title: Padding(
                                      padding: EdgeInsets.only(bottom: 8),
                                      child: Text('ADDRESS', style:GoogleFonts.lato(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black54,
                                          fontSize: SizeConfig.titleSize * 2.7
                                      ))),
                                    subtitle: Row(
                                      children: [
                                        Expanded(
                                          child: TextFormField(
                                            controller:
                                                _registerAddressController,
                                            readOnly: true,
                                            enableInteractiveSelection: true,

                                            decoration: InputDecoration(
                                                errorStyle: GoogleFonts.lato(
                                                  color: Colors.red.shade700,
                                                  fontWeight: FontWeight.w800,


                                                ),
                                                prefixIcon:
                                                    Icon(Icons.location_on),
                                                border:OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                        width: 2,
                                                        style:BorderStyle.solid ,
                                                        color: Colors.black87
                                                    )
                                                ),                                                hintText: 'Burj Al Arab',
                                                hintStyle:  TextStyle(color: Colors.black26,fontWeight: FontWeight.w800,fontSize: 13)// S.of(context).email,
                                                ),

                                            textInputAction: TextInputAction.next,
                                            onEditingComplete: () =>
                                                node.nextFocus(),
                                            // Move focus to next
                                            validator: (result) {
                                              if (result!.isEmpty) {
                                                return 'Address is Required'; //S.of(context).emailAddressIsRequired;
                                              }

                                              return null;
                                            },
                                          ),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        GestureDetector(
                                          onTap: (){
                                            Navigator.pushNamed(
                                                context, MapRoutes.MAP_SCREEN,arguments: true)
                                                .then((value) {
                                              if (value != null) {
                                                addressModel = (value as AddressModel);
                                                _registerAddressController.text =
                                                    addressModel.description;
                                              }
                                            });
                                          },
                                          child: Container(

                                            width: SizeConfig.heightMulti * 8.5,
                                            height: SizeConfig.heightMulti * 8.5,
                                            decoration: BoxDecoration(
                                                color: ColorsConst.mainColor,
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            child: Icon(
                                                Icons.my_location_outlined,
                                                size: SizeConfig.heightMulti * 4,
                                                color: Colors.white),
                                          ),
                                        )
                                      ],
                                    )),
                                SizedBox(
                                  height: 8,
                                ),
                                ListTile(
                                  title: Padding(
                                    padding: EdgeInsets.only(bottom: 8),
                                    child: Text('PHONE',style:GoogleFonts.lato(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black54,
                                        fontSize: SizeConfig.titleSize * 2.7
                                    ))),
                                  subtitle: Container(
height: SizeConfig.heightMulti * 8.5,
                                    alignment: Alignment.center,
                                    padding: EdgeInsets.symmetric(
                                         horizontal: 10),
                                      clipBehavior: Clip.antiAlias,
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                            color: Colors.black45,
                                            width: 1
                                          )
                                      ),
                                    child: Row(
                                      children: [
                                        Icon(Icons.phone),
                                        CountryCodePicker(
                                          initialSelection:
                                              'دولة الإمارات العربية المتحدة',
                                          showOnlyCountryWhenClosed: false,
                                          favorite: [
                                            '+971',
                                            'دولة الإمارات العربية المتحدة'
                                          ],
                                          onChanged: (c) {
                                            print(c);
                                          },
                                        ),
                                        Divider(
                                          height: 30,
                                          color: Colors.black,
                                          thickness: 10,
                                        ),
                                        Expanded(
                                            child: TextFormField(
                                          keyboardType: TextInputType.number,
                                          controller:
                                              _registerPhoneNumberController,
                                          decoration: InputDecoration(
                                              border: InputBorder.none,
                                              hintText:
                                                  '(0)123412212' // S.of(context).email,
                                  , hintStyle: TextStyle(color: Colors.black26,fontWeight: FontWeight.w800,fontSize: 13)

                                              ),
                                          validator: (result) {
                                            if (result!.isEmpty) {
                                              return 'Phone Number Is Required !';
                                            } else if (!_validatePhoneNumberStructure(
                                                result)) {
                                              return 'Enter Valid Phone Number';
                                            } else
                                              return null;
                                          },
                                        ))
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Center(
                                  child: SmoothPageIndicator(
                                    controller: _pageController,
                                    count: 2,
                                    effect: ExpandingDotsEffect(
                                        dotColor: Colors.black12,
                                        dotHeight: 10,
                                        dotWidth: 10,
                                        spacing: 2,
                                        activeDotColor: ColorsConst.mainColor),
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                BlocConsumer<RegisterBloc, RegisterStates>(
                                  bloc: widget._bloc,
                                  listener: (context, state) {
                                    if (state is CompleteErrorState) {
                                      snackBarErrorWidget(context, state.message);
                                    } else if (state is CompleteSuccessState) {
                                      snackBarSuccessWidget(context, state.data);
                                      if(userRole == UserRole.ROLE_USER){
                                        Navigator.pushNamed(
                                            context, NavigatorRoutes.NAVIGATOR_SCREEN);
                                      }else{
                                        Navigator.pop(context);
                                      }

                                    }
                                  },
                                  builder: (context, state) {
                                    if (state is CompleteLoadingState)
                                      return Center(
                                        child: Container(
                                          margin: EdgeInsets.all(20),
                                            height: 50,
                                            width: 50,
                                            child: CircularProgressIndicator()),
                                      );
                                    else
                                      return ListTile(
                                        title: Container(
                                          height: SizeConfig.heightMulti * 10.5,

                                          padding: EdgeInsets.symmetric(vertical: 10),
                                          child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                primary:
                                                    Color.fromARGB(255, 28, 174, 147),
                                              ),
                                              onPressed: () {

                                                if (_registerCompleteFormKey
                                                    .currentState!
                                                    .validate()) {
                                                  String name =
                                                      _registerUserNameController.text
                                                          .trim();
                                                  String phone =
                                                      _registerPhoneNumberController
                                                          .text
                                                          .trim();
                                                  ProfileRequest profileRequest =
                                                      ProfileRequest(
                                                          userName: name,
                                                          address: addressModel,
                                                          phone: phone);
                                                  widget._bloc
                                                      .createProfile(profileRequest);
                                                }
                                              },
                                              child: Text('REGISTER',
                                                  style: TextStyle(
                                                      color: Colors.black87,
                                                      fontSize:
                                                          SizeConfig.titleSize * 2.6,
                                                      fontWeight: FontWeight.w700))),
                                        ),
                                      );
                                  },
                                ),

                              ],
                            ),
                          ),

                          SizedBox(height: 20,),

                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),

          ),

        ],
      ),
    );
  }

  _willPop(){
    widget._bloc.deleteFakeAccount();
    Navigator.pop(context);


  }

  bool _validatePasswordStructure(String value) {
    //     String  pattern = r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~_-]).{8,}$';
    String pattern = r'^(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~_-]).{8,}$';
    RegExp regExp = new RegExp(pattern);
    return regExp.hasMatch(value);
  }

  bool _validateEmailStructure(String value) {
    //     String  pattern = r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~_-]).{8,}$';
    String pattern = r'^.+@[a-zA-Z]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z]+)$';
    RegExp regExp = new RegExp(pattern);
    return regExp.hasMatch(value);
  }

  bool _validatePhoneNumberStructure(String value) {
    //     String  pattern = r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~_-]).{8,}$';
    String pattern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
    RegExp regExp = new RegExp(pattern);
    return regExp.hasMatch(value);
  }
}
