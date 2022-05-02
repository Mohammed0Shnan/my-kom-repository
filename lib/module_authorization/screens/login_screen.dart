import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_kom/consts/colors.dart';
import 'package:my_kom/module_authorization/authorization_routes.dart';
import 'package:my_kom/module_authorization/bloc/cubits.dart';
import 'package:my_kom/utils/size_configration/size_config.dart';

class LoginScreen extends StatefulWidget {
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
  late final PageController _pageController;
  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      initialPage: 0,
    );
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
      body: SafeArea(
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
                    Text('login and start ordering water now',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.black26,
                            fontSize: SizeConfig.titleSize * 2.5))
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
                          title: Text('Email Address'),
                          subtitle: TextFormField(
                            keyboardType: TextInputType.emailAddress,
                            controller: _LoginEmailController,
                            decoration: InputDecoration(
                                prefixIcon: Icon(Icons.email),
                                border: OutlineInputBorder(
                                  borderSide: const BorderSide(
                                      color: Colors.black12,
                                      width: 10,
                                      style: BorderStyle.solid),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                hintText: 'Enter Email Address'
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
                          bloc: cubit,
                          builder: (context, state) {
                            return TextFormField(
                              controller: _LoginPasswordController,
                              decoration: InputDecoration(
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

                                return null;
                              },
                            );
                          },
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                     Align(
                       alignment: Alignment.centerRight,
                       child: GestureDetector(
                         onTap: (){

                         },
                         child: Container(
                           padding: EdgeInsets.only(right: 2.345 * SizeConfig.heightMulti),
                            child: Text(
                                'did you forget your password ?',
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black54)),
                          ),
                       ),
                     ),
                    SizedBox(
                      height: 50,
                    ),
                    ListTile(
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
                              primary: Color.fromARGB(255, 28, 174, 147),
                            ),
                            onPressed: () {
                              _pageController.jumpToPage(1);
                            },
                            child: Text('Login',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: SizeConfig.titleSize * 2.6,
                                    fontWeight: FontWeight.w700))),
                      ),
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
                      'You don\'t have an account ?',
                      style: TextStyle(
                          fontSize: SizeConfig.titleSize * 2.2,
                          color: Colors.black54),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamedAndRemoveUntil(
                            context, AuthorizationRoutes.REGISTER_SCREEN,(route)=>false);
                      },
                      child: Text('Create an account',
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
    );
  }

  bool _validateEmailStructure(String value) {
    //     String  pattern = r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~_-]).{8,}$';
    String pattern = r'^.+@[a-zA-Z]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z]+)$';
    RegExp regExp = new RegExp(pattern);
    return regExp.hasMatch(value);
  }
}
