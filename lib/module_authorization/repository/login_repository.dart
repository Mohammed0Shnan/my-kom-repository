import 'package:my_kom/module_authorization/requests/login_request.dart';
import 'package:my_kom/module_authorization/response/login_response.dart';
import 'package:my_kom/module_network/http_client/http_client.dart';

class LoginRepository {
  final ApiClient _apiClient = ApiClient();

  Future<LoginResponse> login(LoginRequest request) async {

    //real requsting

    // dynamic response = await _apiClient.post(Urls.LOGIN_URL, request.toJson());
    // if (response != null) {
    //   return LoginResponse.fromJson(response);
    // } else
    //   return null;


    // for testing 
    await Future.delayed(Duration(seconds:2));
    return LoginResponse.fromJson({'status_code':200,'message':'Success' , 'token':'smfksemflksefnesnfksnfksnfknfekfnkef'});
  }
}
