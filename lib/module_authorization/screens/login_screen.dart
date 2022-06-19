import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_kom/consts/colors.dart';
import 'package:my_kom/module_authorization/authorization_routes.dart';
import 'package:my_kom/module_authorization/bloc/cubits.dart';
import 'package:my_kom/module_authorization/bloc/login_bloc.dart';
import 'package:my_kom/module_authorization/enums/user_role.dart';
import 'package:my_kom/module_authorization/screens/reset_password_screen.dart';
import 'package:my_kom/module_authorization/screens/widgets/top_snack_bar_widgets.dart';
import 'package:my_kom/module_authorization/service/auth_service.dart';
import 'package:my_kom/module_dashbord/dashboard_routes.dart';
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
      backgroundColor: Colors.white,
        body: Form(
          key: _LoginFormKey,
          child: SingleChildScrollView(
            child: Column(
              children: [

                Container(
                  width: SizeConfig.screenWidth,
                  height: SizeConfig.heightMulti * 7,
                  color: ColorsConst.mainColor,

                ),
                SizedBox(height: SizeConfig.screenHeight * 0.1,),
                Text('Login',
                    style: GoogleFonts.lato(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                        fontSize: SizeConfig.titleSize * 5)),
                SizedBox(height: SizeConfig.screenHeight * 0.05,),

                Container(
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Don\'t have an account ?  ',
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
                                fontSize: SizeConfig.titleSize * 2.5,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue                          )

                        ),
                      )
                    ],
                  ),
                ),



                        SizedBox(height: SizeConfig.heightMulti * 4,),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: ListTile(
                            title: Padding(
                              padding: EdgeInsets.only(bottom: 8),
                              child: Text('EMAIL',style:GoogleFonts.lato(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black54,
                                  fontSize: SizeConfig.titleSize * 2.5
                              ))),
                              subtitle: TextFormField(
                                style: TextStyle(fontSize: 20),
                                keyboardType: TextInputType.emailAddress,
                                controller: _LoginEmailController,
                                decoration: InputDecoration(

                                    border:OutlineInputBorder(
                                      borderSide: BorderSide(
                                        width: 2,
                                        style:BorderStyle.solid ,
                                        color: Colors.black87
                                      )
                                    ),

                                    hintText: 'Email',
                                    hintStyle: TextStyle(color: Colors.black26,fontWeight: FontWeight.w800,fontSize: 13)
                                  //S.of(context).name,
                                ),
                                textInputAction: TextInputAction.next,
                                onEditingComplete: () => node.nextFocus(),

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
                          height: 8,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),

                          ),
                          child: ListTile(
                            title: Padding(
                                padding: EdgeInsets.only(bottom: 8),
                                child: Text('PASSWORD',style:GoogleFonts.lato(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black54,
                                    fontSize: SizeConfig.titleSize * 2.5
                                ))),
                            subtitle: BlocBuilder<PasswordHiddinCubit,
                                PasswordHiddinCubitState>(
                              bloc: cubit,
                              builder: (context, state) {
                                return TextFormField(
                                  controller: _LoginPasswordController,
                                  style: TextStyle(
                                    fontSize: 20
                                  ),
                                  decoration: InputDecoration(

                                      errorStyle: GoogleFonts.lato(
                                        color: Colors.red.shade700,
                                        fontWeight: FontWeight.w800,


                                      ),

                                        suffixIcon: IconButton(
                                          onPressed: () {
                                            cubit.changeState();
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
                                );
                              },
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context)=>
                              RestPasswordScreen()
                              ));
                            },
                            child: Container(
                              padding: EdgeInsets.only(
                                  right: 2.345 * SizeConfig.heightMulti),
                              child: Text('Forgot password ?',
                                  style: GoogleFonts.lato(
                                    fontWeight: FontWeight.w800,
                                    color: Colors.black54,
                                    fontSize: SizeConfig.titleSize * 2.1,
                                  )),
                            ),
                          ),
                        ),
                        SizedBox(
                          height:SizeConfig.heightMulti *3,
                        ),
                        BlocConsumer<LoginBloc, LoginStates>(
                            bloc: widget._loginBloc,
                            listener: (context, LoginStates state)async {
                              if (state is LoginSuccessState) {
                                snackBarSuccessWidget(context, state.message);
                                UserRole? role = await AuthService().userRole;
                                if(role != null){

                                  if (role == UserRole.ROLE_OWNER) {
                                    Navigator.pushNamed(
                                        context, DashboardRoutes.DASHBOARD_SCREEN);
                                  }  else{
                                    Navigator.pushNamed(
                                        context, NavigatorRoutes.NAVIGATOR_SCREEN);
                                  }}

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
                                    height: SizeConfig.heightMulti * 11,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10)),
                                    padding: EdgeInsets.symmetric(vertical: 10),
                                    child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(

                                          primary:ColorsConst.mainColor,
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
                                        child: Text('LOGIN',
                                            style: TextStyle(
                                                color: Colors.black87,
                                                fontSize:
                                                SizeConfig.titleSize * 3.4,
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
