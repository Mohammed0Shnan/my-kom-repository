import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_kom/module_authorization/enums/auth_source.dart';
import 'package:my_kom/module_authorization/enums/user_role.dart';
import 'package:my_kom/module_authorization/service/auth_service.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterStates> {
  final AuthService _service = AuthService();

  RegisterBloc() : super(RegisterInitState()) {
    on<RegisterEvent>((RegisterEvent event, Emitter<RegisterStates> emit) {
      if (event is RegisterLoadingEvent)
        emit(RegisterLoadingState());
      else if (event is RegisterErrorEvent){
        emit(RegisterErrorState(message: event.message));
      }
      else if (event is RegisterSuccessEvent) 
      emit(RegisterSuccessState());
      else {
        emit(RegisterInitState());
      }
    });
  }

 

  register({required String email,required String password,}) async {
    this.add(RegisterLoadingEvent());
    _service.registerWithEmailAndPassword(email, password ,UserRole.ROLE_USER, AuthSource.EMAIL).then((value) {
      if (value.state) {
        this.add(RegisterSuccessEvent());
      } else
        this.add(RegisterErrorEvent(message: value.message));
    });
  }
}

abstract class RegisterEvent {}

class RegisterInitEvent extends RegisterEvent {
    String message;
  RegisterInitEvent({required this.message});
}

class RegisterSuccessEvent extends RegisterEvent {}

class RegisterLoadingEvent extends RegisterEvent {}

class RegisterErrorEvent extends RegisterEvent {
  String message;
  RegisterErrorEvent({required this.message});
}

abstract class RegisterStates {}

class RegisterInitState extends RegisterStates {}

class RegisterSuccessState extends RegisterStates {}

class RegisterLoadingState extends RegisterStates {}

class RegisterErrorState extends RegisterStates {
  String message;
  RegisterErrorState({required this.message});
}
