
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_kom/consts/colors.dart';
import 'package:my_kom/module_authorization/bloc/register_bloc.dart';
import 'package:my_kom/module_authorization/screens/login_automatically.dart';
class PhoneCodeSentScreen extends StatefulWidget {
  final String phoneNumber ;
  final String email;
  final String password;
   PhoneCodeSentScreen({required this.phoneNumber,required this.email,required this.password,Key? key}) : super(key: key);

  @override
  State<PhoneCodeSentScreen> createState() => _PhoneCodeSentScreenState();
}

class _PhoneCodeSentScreenState extends State<PhoneCodeSentScreen> {
   final _confirmationController = TextEditingController();
   final RegisterBloc _registerBloc = RegisterBloc();
   bool retryEnabled = false;
   bool loading = false;

   @override
  void initState() {
     _registerBloc.registerPhoneNumber(widget.phoneNumber);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:     Form(
    child: Flex(
    direction: Axis.vertical,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextFormField(
              controller: _confirmationController,
              decoration: InputDecoration(
                labelText:'Confirm Code',
                hintText: '123456',
              ),
              keyboardType: TextInputType.number,
              validator: (v) {
                if (v!.isEmpty) {
                  return 'Please Input Phone Number';
                }
                return null;
              }),
        ),
        OutlinedButton(
          onPressed: retryEnabled
              ? () {
          //  screen.retryPhone();
          }
              : null,
          child: Text('Resend Code'),
        ),

        loading ? Text('Loading') : Container(
          decoration: BoxDecoration(color:ColorsConst.mainColor),
          child: GestureDetector(
            onTap: () {
              loading = true;
              Future.delayed(Duration(seconds: 10), () {
                loading = false;
              });
              //screen.refresh();
              print(_confirmationController.text);
              _registerBloc.confirmCaptainCode(_confirmationController.text).then((value) {
                print(value);
                if(value == true){
                  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>
                  LoginAutomatically(email:widget.email, password:widget.password)
                  ),(route)=>false);
                }
              });
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                   'Confirm',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
    ),
    );
  }
}


