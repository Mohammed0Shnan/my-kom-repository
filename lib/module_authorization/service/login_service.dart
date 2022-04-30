import 'package:my_kom/module_authorization/enums/auth_status_enum.dart';
import 'package:my_kom/module_authorization/repository/login_repository.dart';
import 'package:my_kom/module_authorization/requests/login_request.dart';
import 'package:my_kom/module_authorization/response/login_response.dart';
import 'package:my_kom/module_persistence/sharedpref/shared_preferences_helper.dart';

class LoginService {
  final LoginRepository _repository = new LoginRepository();
 // final SharedPreferencesHelper _preferencesHelper = SharedPreferencesHelper();
  Future<AuthStatus> login(String username, String password) async {
    LoginRequest request = LoginRequest(username, password);
    LoginResponse response = await _repository.login(request);
    if (response == null) {
      return AuthStatus.UNAUTHORIZED;
    } else {
      // save in local storge

     // await _preferencesHelper.setToken(response.token);
      return AuthStatus.AUTHORIZED;
    }
  }

  Future<bool?> logout() async {
    // free local storge

   // return await _preferencesHelper.clearData();
  }
}
