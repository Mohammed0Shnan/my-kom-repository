import 'package:my_kom/module_authorization/enums/auth_status_enum.dart';
import 'package:my_kom/module_authorization/service/login_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginBloc extends Bloc<LoginEvent, LoginStates> {
  final LoginService _service = LoginService();

  LoginBloc() : super(LoginInitState());

  @override
  Stream<LoginStates> mapEventToState(LoginEvent event) async* {
    switch (event) {
      case LoginEvent.LOADING:
        {
          yield LoginLoadingState();
          break;
        }
      case LoginEvent.SUCCESS:
        {
          yield LoginSuccessState();
          break;
        }
      case LoginEvent.ERROR:
        {
          yield LoginErrorState();
          break;
        }
      default:
        {
          yield LoginInitState();
        }
    }
  }

  login(String userName, String password) async {
    this.add(LoginEvent.LOADING);
    _service.login(userName, password).then((value) {
      if (value == AuthStatus.AUTHORIZED) {
        this.add(LoginEvent.SUCCESS);
      } else
        this.add(LoginEvent.ERROR);
    });
  }
}

enum LoginEvent { INIT, LOADING, SUCCESS, ERROR }

abstract class LoginStates {}

class LoginInitState extends LoginStates {}

class LoginSuccessState extends LoginStates {}

class LoginLoadingState extends LoginStates {}

class LoginErrorState extends LoginStates {}
