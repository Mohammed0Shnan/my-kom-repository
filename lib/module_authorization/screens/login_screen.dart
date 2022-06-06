import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_kom/consts/colors.dart';
import 'package:my_kom/module_authorization/authorization_routes.dart';
import 'package:my_kom/module_authorization/bloc/cubits.dart';
import 'package:my_kom/module_authorization/bloc/login_bloc.dart';
import 'package:my_kom/module_authorization/enums/user_role.dart';
import 'package:my_kom/module_authorization/screens/widgets/auth_background.dart';
import 'package:my_kom/module_authorization/screens/widgets/custom_clip_widget.dart';
import 'package:my_kom/module_authorization/screens/widgets/top_snack_bar_widgets.dart';
import 'package:my_kom/module_home/navigator_routes.dart';
import 'package:my_kom/utils/size_configration/size_config.dart';

class LoginScreen extends StatefulWidget {
  final LoginBloc _loginBloc = LoginBloc();
  LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _LoginFormKey = GlobalKey<FormState>();
  final TextEditingController _LoginEmailController = TextEditingController();
  final TextEditingController _LoginPasswordController =
      TextEditingController();

  late final PasswordHiddinCubit cubit;
  @override
  void initState() {
    super.initState();
    cubit = PasswordHiddinCubit();
  }

  @override
  void dispose() {
    cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final node = FocusScope.of(context);
    return Scaffold(

        body: AuthBackground(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: SizeConfig.screenHeight * 0.24,
                  margin: EdgeInsets.symmetric(
                      horizontal: SizeConfig.screenWidth * 0.2),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 10,),

                      Text('Welcome TO',
                          style: TextStyle(
                              color: Colors.black45,
                              fontWeight: FontWeight.w900,
                              fontSize: SizeConfig.titleSize * 3.5)),
                      SizedBox(height: 5,),
                      Container(
                        width: SizeConfig.screenWidth * 0.6,
                        height: 7.9 * SizeConfig.heightMulti,

                       child:  Stack(
                         children: [
                           Container(
                               width: SizeConfig.screenWidth * 0.5,
                               height: 7.8 * SizeConfig.heightMulti,
                               child: Image.asset('assets/logo_word.png',fit: BoxFit.cover,)),
                           Positioned(
                               top: SizeConfig.widhtMulti*2.4,
                               left: SizeConfig.widhtMulti * 15,
                               child: Container(
                                   width: SizeConfig.widhtMulti * 7.2,
                                   height: SizeConfig.widhtMulti * 7.2,
                                   child: SvgPicture.asset('assets/2.svg')) ),

                           Positioned(
                               top: 10,
                               right: SizeConfig.widhtMulti * 5,
                               child: Container(
                                   width:  SizeConfig.widhtMulti * 8,
                                   height: SizeConfig.widhtMulti * 8,
                                   child: SvgPicture.asset('assets/2.svg')) ),

                         ],
                       ),
                       //  child: Row(
                       //    mainAxisAlignment: MainAxisAlignment.center,
                       //    children: [
                       //      Stack(
                       //        children: [
                       //  Container(
                       //  width: SizeConfig.screenWidth * 0.5,
                       //      height: 7.8 * SizeConfig.heightMulti,
                       //      child: Image.asset('assets/logo_word.png',fit: BoxFit.cover,)),
                       //      Positioned(
                       //        top: 10,
                       //          left: 55,
                       //          child: Container(
                       //          width: 25,
                       //          height: 25,
                       //          child: SvgPicture.asset('assets/2.svg')) )
                       //
                       //  ],
                       //      ),
                       // //  Image.asset('assets/logo1.png',fit: BoxFit.fitWidth,)),
                       //      Container(
                       //          height: 7.8 * SizeConfig.heightMulti,
                       //          width: SizeConfig.screenWidth * 0.1,
                       //          child: SvgPicture.asset('assets/1.svg'))
                       //    ],
                       //  ),
                      ),
                      SizedBox(height: 5,),

                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        child: Text('login and start ordering water now',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.lato(
                                fontSize: SizeConfig.titleSize * 2.1,
                                fontWeight: FontWeight.w600,
                                color: Colors.black38
                            )),
                      )
                    ],
                  ),
                ),
                Form(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  key: _LoginFormKey,
                  child: Flex(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    direction: Axis.vertical,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: ListTile(
                            title: Padding(
                                padding: EdgeInsets.only(bottom: 8),
                                child: Text('Email Address' , style:GoogleFonts.lato(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black54,
                                  fontSize: SizeConfig.titleSize * 2.5
                                ),)),
                            subtitle: Container(
                              clipBehavior: Clip.antiAlias,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [BoxShadow(color: Colors.black26,blurRadius: 8,offset: Offset(0,3))]
                              ),
                              child: TextFormField(

                                keyboardType: TextInputType.emailAddress,
                                controller: _LoginEmailController,
                                decoration: InputDecoration(
                                    errorStyle: GoogleFonts.lato(
                                      color: Colors.red.shade700,
                                      fontWeight: FontWeight.w800,
                                    ),
                                    prefixIcon: Icon(Icons.email),
                                    border: InputBorder.none,
                                    hintText: 'Email Address',
                                    hintStyle: TextStyle(color: Colors.black26,fontWeight: FontWeight.w800,fontSize: 13)
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
                              ),
                            )),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),

                        ),
                        child: ListTile(
                          title: Padding(
                              padding: EdgeInsets.only(bottom: 8),
                              child: Text('Password',style:GoogleFonts.lato(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black54,
                                  fontSize: SizeConfig.titleSize * 2.5
                              ))),
                          subtitle: BlocBuilder<PasswordHiddinCubit,
                              PasswordHiddinCubitState>(
                            bloc: cubit,
                            builder: (context, state) {
                              return Container(
                                clipBehavior: Clip.antiAlias,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [BoxShadow(color: Colors.black26,blurRadius: 8,offset: Offset(0,3))]
                                ),
                                child: TextFormField(
                                  controller: _LoginPasswordController,
                                  decoration: InputDecoration(
                                    errorStyle: GoogleFonts.lato(
                                      color: Colors.red.shade700,
                                      fontWeight: FontWeight.w800,


                                    ),
                                      prefixIcon: Icon(Icons.lock),
                                      suffixIcon: IconButton(
                                          onPressed: () {
                                            cubit.changeState();
                                          },
                                          icon: state ==
                                                  PasswordHiddinCubitState
                                                      .VISIBILITY
                                              ? Icon(Icons.visibility)
                                              : Icon(Icons.visibility_off)),
                                      border:InputBorder.none,
                                      hintText: 'Password',
                                      hintStyle: TextStyle(color: Colors.black26,fontWeight: FontWeight.w800,fontSize: 13)
// S.of(context).email,
                                      ),
                                  obscureText:
                                      state == PasswordHiddinCubitState.VISIBILITY
                                          ? false
                                          : true,

                                  textInputAction: TextInputAction.done,
                                  onFieldSubmitted: (v) => node.unfocus(),
                                  // Move focus to next
                                  validator: (result) {
                                    if (result!.isEmpty) {
                                      return '* Password is Required'; //S.of(context).emailAddressIsRequired;
                                    }
                                    if (result.length < 8) {
                                      return '* The password is short, it must be 8 characters long'; //S.of(context).emailAddressIsRequired;
                                    }

                                    return null;
                                  },
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                          onTap: () {},
                          child: Container(
                            padding: EdgeInsets.only(
                                right: 2.345 * SizeConfig.heightMulti),
                            child: Text('Did you forget your password ?',
                                style: GoogleFonts.lato(
                                  fontWeight: FontWeight.w800,
                                  color: Colors.black45,
                                  fontSize: SizeConfig.titleSize * 2.1,
                                )),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      BlocConsumer<LoginBloc, LoginStates>(
                          bloc: widget._loginBloc,
                          listener: (context, LoginStates state) {
                            if (state is LoginSuccessState) {
                              snackBarSuccessWidget(context, state.message);
                              Navigator.pushNamed(
                                  context, NavigatorRoutes.NAVIGATOR_SCREEN);
                            } else if (state is LoginErrorState) {
                              snackBarErrorWidget(context, state.message);
                            }
                          },
                          builder: (context, LoginStates state) {
                            if (state is LoginLoadingState)
                              return Container(
                                  height: 40,
                                  width: 40,
                                  child: Center(
                                    child: CircularProgressIndicator(
                                      color: ColorsConst.mainColor,
                                    ),
                                  ));
                            else
                              return ListTile(
                                title: Container(
                                  height: 70,
                                  clipBehavior: Clip.antiAlias,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10)),
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
                                        if (_LoginFormKey.currentState!
                                            .validate()) {
                                          String email =
                                              _LoginEmailController.text.trim();
                                          String password =
                                              _LoginPasswordController.text
                                                  .trim();
                                          widget._loginBloc
                                              .login(email, password);
                                        }
                                      },
                                      child: Text('Login',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize:
                                                  SizeConfig.titleSize * 2.6,
                                              fontWeight: FontWeight.w700))),
                                ),
                              );
                          }),
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
                        'You don\'t have an account ?',
                        style:  GoogleFonts.lato(
                            fontWeight: FontWeight.w800,
                            color: Colors.black45,
                          fontSize: SizeConfig.titleSize * 2,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(
                              context,
                              AuthorizationRoutes.REGISTER_SCREEN,
                            arguments: UserRole.ROLE_USER
                             );
                        },
                        child: Text('Create an account',
                            style:  GoogleFonts.lato(
                                fontSize: SizeConfig.titleSize * 2.3,
                                fontWeight: FontWeight.bold,
                                color: ColorsConst.mainColor                          )

                              ),
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

    );
  }

  bool _validateEmailStructure(String value) {
    //     String  pattern = r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~_-]).{8,}$';
    String pattern = r'^.+@[a-zA-Z]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z]+)$';
    RegExp regExp = new RegExp(pattern);
    return regExp.hasMatch(value);
  }
}
