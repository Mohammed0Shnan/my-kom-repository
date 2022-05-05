import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_kom/module_authorization/enums/auth_source.dart';
import 'package:my_kom/module_authorization/enums/auth_status.dart';
import 'package:my_kom/module_authorization/enums/user_role.dart';
import 'package:my_kom/module_authorization/model/app_user.dart';
import 'package:my_kom/module_authorization/repository/auth_repository.dart';
import 'package:my_kom/module_authorization/requests/register_request.dart';
import 'package:my_kom/module_authorization/response/login_response%20copy.dart';
import 'package:my_kom/module_map/models/address_model.dart';
import 'package:my_kom/utils/logger/logger.dart';

class AuthService {
  final AuthRepository _repository = new AuthRepository();
  // final SharedPreferencesHelper _preferencesHelper = SharedPreferencesHelper();
  Future<AuthStatus> register(
      String username, String password, UserRole role) async {
    // RegisterRequest request = RegisterRequest(email: username,password: password,password_confirmation: confirmPassword);
    // var response = await _repository.register(request);
    await Future.delayed(Duration(seconds: 2));
    return AuthStatus.AUTHORIZED;

    // if (response == null) {
    //   return AuthStatus.UNAUTHORIZED;
    // } else {
    //   // save in local storge

    //   return AuthStatus.AUTHORIZED;
    // }
  }

  Future<RegisterResponse> registerWithEmailAndPassword(String email,
      String password, UserRole role, AuthSource authSource) async {

    //  DTO 
    RegisterRequest request = RegisterRequest(
      email: email,
      password: password,
      userRole: role,
      authSource: authSource,
    );

    try {
      bool result = await _repository.register(request);
      // The result may be an error if a private server is connected
      return RegisterResponse(message: 'Register Success !', state: true);
    } catch (e) {
      if (e is FirebaseAuthException) {

        FirebaseAuthException x = e;
        Logger().info('AuthService', 'Got Authorization Error: ${x.message}');
        return RegisterResponse(message: x.message.toString(), state: false);

      } else {
        return RegisterResponse(message: e.toString(), state: false);
        
      }
    }
  }

  login(String email, String password) {}

  // Future<void> signInWithEmailAndPassword(
  //   String email,
  //   String password,
  //   UserRole role,
  //   bool isRegister,
  // ) async {
  //   try {
  //     var creds = await _auth.signInWithEmailAndPassword(
  //       email: email,
  //       password: password,
  //     );

  //     if (isRegister) {
  //       await _registerApiNewUser(AppUser(creds.user, AuthSource.EMAIL, role));
  //     } else {
  //       await _loginApiUser(role, AuthSource.EMAIL);
  //     }
  //   } catch (e) {
  //     if (e is FirebaseAuthException) {
  //       FirebaseAuthException x = e;
  //       Logger().info('AuthService', 'Got Authorization Error: ${x.message}');
  //       _authSubject.addError(x.message);
  //     } else {
  //       _authSubject.addError(e.toString());
  //     }
  //   }
  // }
}
