import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_kom/consts/colors.dart';
import 'package:my_kom/module_authorization/authorization_routes.dart';
import 'package:my_kom/module_authorization/bloc/cubits.dart';
import 'package:my_kom/module_authorization/bloc/register_bloc.dart';
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
  @override
  void initState() {
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
      body: SafeArea(
        child: PageView(
          physics: NeverScrollableScrollPhysics(),
          controller: _pageController,
          children: [
            /// Page Number One
            ///
            Container(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      height: SizeConfig.screenHeight * 0.25,
                      child: Stack(alignment: Alignment.center, children: [
                        Container(color: Colors.black12),
                        Container(
                          margin: EdgeInsets.symmetric(
                              horizontal: SizeConfig.screenWidth * 0.2),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text('Welcome TO',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: SizeConfig.titleSize * 3.5)),
                              Text('M Y  K O M',
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: SizeConfig.titleSize * 5)),
                              Text(
                                  'create your account and start ordering water now',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.black26,
                                      fontSize: SizeConfig.titleSize * 2.5))
                            ],
                          ),
                        )
                      ]),
                    ),
                    Form(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      key: _registerFormKey,
                      child: Flex(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        direction: Axis.vertical,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: ListTile(
                                title: Text('Email Address'),
                                subtitle: TextFormField(
                                  keyboardType: TextInputType.emailAddress,
                                  controller: _registerEmailController,
                                  decoration: InputDecoration(
                                      prefixIcon: Icon(Icons.email),
                                      border: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            color: Colors.black12,
                                            width: 10,
                                            style: BorderStyle.solid),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      hintText: 'Email Address'
                                      //S.of(context).name,
                                      ),
                                  textInputAction: TextInputAction.next,
                                  onEditingComplete: () => node.nextFocus(),
                                  // Move focus to next
                                  validator: (result) {
                                    if (result!.isEmpty) {
                                      return 'Email Address is Required'; //S.of(context).nameIsRequired;
                                    }
                                    if (!_validateEmailStructure(result))
                                      return 'Must write an email address';
                                    return null;
                                  },
                                )),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: ListTile(
                              title: Text('Password'),
                              subtitle: BlocBuilder<PasswordHiddinCubit,
                                  PasswordHiddinCubitState>(
                                bloc: cubit1,
                                builder: (context, state) {
                                  return TextFormField(
                                    controller: _registerPasswordController,
                                    decoration: InputDecoration(
                                        prefixIcon: Icon(Icons.lock),
                                        suffixIcon: IconButton(
                                            onPressed: () {
                                              cubit1.changeState();
                                            },
                                            icon: state ==
                                                    PasswordHiddinCubitState
                                                        .VISIBILITY
                                                ? Icon(Icons.visibility)
                                                : Icon(Icons.visibility_off)),
                                        border: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              color: Colors.black12,
                                              width: 10,
                                              style: BorderStyle.solid),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        hintText:
                                            'Password' // S.of(context).email,
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
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: ListTile(
                              title: Text('Confirm Password'),
                              subtitle: BlocBuilder<PasswordHiddinCubit,
                                  PasswordHiddinCubitState>(
                                bloc: cubit2,
                                builder: (context, state) {
                                  return TextFormField(
                                    controller:
                                        _registerConfirmPasswordController,
                                    decoration: InputDecoration(
                                        prefixIcon: Icon(Icons.lock),
                                        suffixIcon: IconButton(
                                            onPressed: () {
                                              cubit2.changeState();
                                            },
                                            icon: state ==
                                                    PasswordHiddinCubitState
                                                        .VISIBILITY
                                                ? Icon(Icons.visibility)
                                                : Icon(Icons.visibility_off)),
                                        border: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                            color: Colors.black12,
                                            width: 10,
                                            style: BorderStyle.solid,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        hintText:
                                            'Confirm Password' // S.of(context).password,
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
                            height: 50,
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
                                        width: 50,
                                        height: 50,
                                        child: CircularProgressIndicator()));
                              else
                                return ListTile(
                                  title: Container(
                                    height: 70,
                                    clipBehavior: Clip.antiAlias,
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    padding: EdgeInsets.symmetric(vertical: 10),
                                    child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10)),
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
                                                email: email,
                                                password: password);
                                          }
                                        },
                                        child: Text('Next',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize:
                                                    SizeConfig.titleSize * 2.6,
                                                fontWeight: FontWeight.w700))),
                                  ),
                                );
                            },
                          ),
                          SizedBox(
                            height: 50,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'You have a My com account !',
                            style: TextStyle(
                                fontSize: SizeConfig.titleSize * 2.2,
                                color: Colors.black54),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(
                                  context, AuthorizationRoutes.LOGIN_SCREEN);
                            },
                            child: Text('Login',
                                style: TextStyle(
                                    fontSize: SizeConfig.titleSize * 2.4,
                                    fontWeight: FontWeight.w700,
                                    color: ColorsConst.mainColor)),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 50,
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
                      Container(
                          height: SizeConfig.screenHeight * 0.25,
                          width: SizeConfig.screenWidth,
                          color: Colors.black12,
                          padding: EdgeInsets.symmetric(
                              horizontal: SizeConfig.screenWidth * 0.2),
                          child: Text('  Complete your details',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: SizeConfig.titleSize * 3.5))),
                      Form(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        key: _registerCompleteFormKey,
                        child: Flex(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          direction: Axis.vertical,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: ListTile(
                                  title: Text('User Name'),
                                  subtitle: TextFormField(
                                    controller: _registerUserNameController,
                                    decoration: InputDecoration(
                                        prefixIcon: Icon(Icons.person),
                                        border: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              color: Colors.black12,
                                              width: 10,
                                              style: BorderStyle.solid),
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        hintText: 'Mohammed .'
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
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: ListTile(
                                  title: Text('Address'),
                                  subtitle: GestureDetector(
                                    onTap: () {
                                      Navigator.pushNamed(
                                              context, MapRoutes.MAP_SCREEN)
                                          .then((value) {
                                        if (value != null) {
                                          addressModel = (value as AddressModel);
                                          _registerAddressController.text =
                                              addressModel.description;
                                        }
                                      });
                                    },
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: TextFormField(
                                            controller:
                                                _registerAddressController,
                                            readOnly: true,
                                            enableInteractiveSelection: true,

                                            decoration: InputDecoration(
                                                prefixIcon:
                                                    Icon(Icons.location_on),
                                                border: OutlineInputBorder(
                                                  borderSide: const BorderSide(
                                                      color: Colors.black,
                                                      width: 10,
                                                      style: BorderStyle.solid),
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                hintText: 'Burj Al Arab',
                                                hintStyle: TextStyle(
                                                    color: Colors
                                                        .black26) // S.of(context).email,
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
                                        Align(
                                          alignment: Alignment.topCenter,
                                          child: Container(
                                            width: SizeConfig.heightMulti * 9.1,
                                            height: SizeConfig.heightMulti * 9.1,
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
                                    ),
                                  )),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: ListTile(
                                title: Text('Phone Number'),
                                subtitle: Container(
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.symmetric(
                                      vertical: 5, horizontal: 10),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                          color: Colors.black26,
                                          style: BorderStyle.solid)),
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
                              height: 50,
                            ),
                            BlocConsumer<RegisterBloc, RegisterStates>(
                              bloc: widget._bloc,
                              listener: (context, state) {
                                if (state is CompleteErrorState) {
                                  snackBarErrorWidget(context, state.message);
                                } else if (state is CompleteSuccessState) {
                                  snackBarSuccessWidget(context, state.data);
                                  Navigator.pushNamed(
                                      context, NavigatorRoutes.NAVIGATOR_SCREEN);
                                }
                              },
                              builder: (context, state) {
                                if (state is CompleteLoadingState)
                                  return Center(
                                    child: Container(
                                        height: 40,
                                        width: 40,
                                        child: CircularProgressIndicator()),
                                  );
                                else
                                  return ListTile(
                                    title: Container(
                                      height: 70,
                                      clipBehavior: Clip.antiAlias,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      padding: EdgeInsets.symmetric(vertical: 10),
                                      child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10)),
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
                                          child: Text('Register',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize:
                                                      SizeConfig.titleSize * 2.6,
                                                  fontWeight: FontWeight.w700))),
                                    ),
                                  );
                              },
                            ),
                            SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 40),
                        alignment: Alignment.center,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'When registering, you agree to !',
                              style: TextStyle(
                                  fontSize: SizeConfig.titleSize * 2,
                                  color: Colors.black54),
                            ),
                            Expanded(
                              child: GestureDetector(
                                onTap: () {},
                                child: Container(
                                  child: Text(' the Privacy and Security Policy',
                                      style: TextStyle(
                                          fontSize: SizeConfig.titleSize * 2,
                                          fontWeight: FontWeight.w700,
                                          color: ColorsConst.mainColor)),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
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
