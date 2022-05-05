import 'package:my_kom/module_authorization/enums/auth_status.dart';
import 'package:my_kom/module_authorization/service/auth_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginBloc extends Bloc<LoginEvent, LoginStates> {
  final AuthService _service = AuthService();

  LoginBloc() : super(LoginInitState()) {
    on<LoginEvent>((LoginEvent event, Emitter<LoginStates> emit) {
      if (event == LoginEvent.LOADING)
        emit(LoginLoadingState());
      else if (event == LoginEvent.SUCCESS) emit(LoginSuccessState());
      else if (event == LoginEvent.ERROR) emit(LoginErrorState());
      else {
        emit(LoginInitState());
      }
    });
  }


  login(String email, String password) async {
    this.add(LoginEvent.LOADING);
    _service.login(email, password).then((value) {
      if (value == AuthStatus.AUTHORIZED) {
        this.add(LoginEvent.SUCCESS);
      } else{
        this.add(LoginEvent.ERROR);

      }
    });
  }
}

enum LoginEvent { INIT, LOADING, SUCCESS, ERROR }

abstract class LoginStates {}

class LoginInitState extends LoginStates {}

class LoginSuccessState extends LoginStates {}

class LoginLoadingState extends LoginStates {}

class LoginErrorState extends LoginStates {}
