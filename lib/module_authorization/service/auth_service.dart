
import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_kom/module_authorization/enums/auth_source.dart';
import 'package:my_kom/module_authorization/enums/auth_status.dart';
import 'package:my_kom/module_authorization/enums/user_role.dart';
import 'package:my_kom/module_authorization/exceptions/auth_exception.dart';
import 'package:my_kom/module_authorization/presistance/auth_prefs_helper.dart';
import 'package:my_kom/module_authorization/repository/auth_repository.dart';
import 'package:my_kom/module_authorization/requests/login_request.dart';
import 'package:my_kom/module_authorization/requests/register_request.dart';
import 'package:my_kom/module_authorization/response/login_response.dart';
import 'package:my_kom/module_authorization/response/register_response.dart';
import 'package:my_kom/utils/logger/logger.dart';

class AuthService {
  final AuthRepository _repository = new AuthRepository();

  final AuthPrefsHelper _prefsHelper = AuthPrefsHelper();
  FirebaseAuth _auth = FirebaseAuth.instance;

  // Delegates
  Future<bool> get isLoggedIn => _prefsHelper.isSignedIn();

  Future<String?> get userID => _prefsHelper.getUserId();

  Future<UserRole?> get userRole => _prefsHelper.getRole();

  Future<RegisterResponse> registerWithEmailAndPassword(String email,
      String password, UserRole role, AuthSource authSource) async {
    //  DTO
    RegisterRequest request = RegisterRequest(
      email: email,
      password: password,
      userRole: role,
    );

    try {
      String? result = await _repository.register(request);
      // The result may be an error if a private server is connected
      return RegisterResponse(data: 'Success !', state: true);
    } catch (e) {
      if (e is FirebaseAuthException) {
        {
          switch (e.code) {
            case 'auth/email-already-in-use':
              Logger()
                  .info('AuthService', 'Email address $email already in use.');
              break;
            case 'auth/invalid-email':
              Logger().info('AuthService', 'Email address $email is invalid.');
              break;
            case 'auth/operation-not-allowed':
              Logger().info('AuthService', 'Error during sign up.');
              break;
            case 'auth/weak-password':
              Logger().info('AuthService',
                  'Password is not strong enough. Add additional characters including special characters and numbers.');
              break;
            default:
              Logger().info('AuthService', '${e.message}');
              break;
          }
        }
        Logger().info('AuthService', 'Got Authorization Error: ${e.message}');
        return RegisterResponse(data: e.code.toString(), state: false);
      } else {
        return RegisterResponse(data: e.toString(), state: false);
      }
    }
  }

  Future<RegisterResponse> createProfile(ProfileRequest profileRequest) async {
    await Future.delayed(Duration(seconds: 2));
    try {
      bool result = await _repository.createProfile(profileRequest);
      return RegisterResponse(data: 'Success Register !', state: true);
    } catch (e) {
      return RegisterResponse(data: e.toString(), state: false);
    }
  }

  Future<AuthResponse> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      LoginRequest request = LoginRequest(email, password);
      LoginResponse response = await _repository.signIn(request);

      await _loginApiUser(AuthSource.EMAIL);

      await Future.wait([
        _prefsHelper.setToken(response.token),
      ]);

      return AuthResponse(
          message: 'Login Success', status: AuthStatus.AUTHORIZED);
    } catch (e) {
      if (e is FirebaseAuthException) {
        Logger().info('AuthService', e.code.toString());
        return AuthResponse(
            message:e.code.toString() +'\n (There Is No Internet)', status: AuthStatus.UNAUTHORIZED);
      }
      else if(e is GetProfileException)
        {
          Logger().info('AuthService', 'Error getting Profile Fire Base API');

        }
      else
      Logger().info('AuthService', 'Error getting the token from the Fire Base API');


      return AuthResponse(
          message: e.toString(), status: AuthStatus.UNAUTHORIZED);
    }
  }

   
   //This function is private to generalize to different authentication methods 
   //  phone , email , google ...etc

  Future<void> _loginApiUser(AuthSource authSource) async {
    var user = _auth.currentUser;

    // Change This
     try{
       ProfileResponse profileResponse = await _repository.getProfile(user!.uid);
       await Future.wait([
         _prefsHelper.setUserId(user.uid),
         _prefsHelper.setEmail(user.email!),
         _prefsHelper.setUsername(profileResponse.userName),
         _prefsHelper.setPhone(profileResponse.phone),
         _prefsHelper.setAuthSource(authSource),
         _prefsHelper.setRole(profileResponse.userRole),
       ]);
     }catch(e){
       throw GetProfileException('Error getting Profile Fire Base API');
     }
  }

  Future<void> logout() async {
    await _auth.signOut();
    await _prefsHelper.deleteToken();
    await _prefsHelper.cleanAll();
  }

  void fakeAccount() {
    FirebaseAuth.instance.currentUser!.delete();
  }
}
