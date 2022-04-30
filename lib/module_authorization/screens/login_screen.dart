import 'package:my_kom/module_authorization/bloc/login_bloc.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  final LoginBloc _bloc = LoginBloc();
  LoginScreen({Key? key}) : super(key: key);

  final TextEditingController _usernameController = new TextEditingController();
  final TextEditingController _passwordController = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              controller: _usernameController,
              decoration: InputDecoration(
                  labelText: 'user name',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30)))),
            ),
            SizedBox(height: 20,),
            TextFormField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                  labelText: 'password',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30)))),
            ),
            SizedBox(height: 50,),
            MaterialButton(
              elevation: 20,
              minWidth: 200,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30)
              ),
              height: 70,
              color: Colors.red,
              onPressed: (){
                String username = _usernameController.text;
                String password = _passwordController.text;  
                _bloc.login(username, password);
              },
              child: Text('Login',style: TextStyle(color: Colors.white,fontSize: 30),),
            ),
          ],
        ),
      ),
    );
  }
}
