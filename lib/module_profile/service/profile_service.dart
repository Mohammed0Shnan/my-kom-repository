import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_kom/module_authorization/enums/auth_source.dart';
import 'package:my_kom/module_authorization/exceptions/auth_exception.dart';
import 'package:my_kom/module_authorization/presistance/auth_prefs_helper.dart';
import 'package:my_kom/module_authorization/repository/auth_repository.dart';
import 'package:my_kom/module_authorization/requests/register_request.dart';
import 'package:my_kom/module_authorization/response/login_response.dart';
import 'package:my_kom/module_profile/model/profile_model.dart';

class ProfileService{

  final AuthRepository _repository = AuthRepository();
  final AuthPrefsHelper _prefsHelper = AuthPrefsHelper();
  FirebaseAuth _auth = FirebaseAuth.instance;

  Future<ProfileModel?> getMyProfile() async {
    var user = _auth.currentUser;
    // Change This
    try{
      ProfileResponse profileResponse = await _repository.getProfile(user!.uid);

      await Future.wait([
        _prefsHelper.setEmail(user.email!),
        _prefsHelper.setAdderss(profileResponse.address),
        _prefsHelper.setUsername(profileResponse.userName),
        _prefsHelper.setPhone(profileResponse.phone),
        _prefsHelper.setAuthSource(AuthSource.EMAIL),
        _prefsHelper.setRole(profileResponse.userRole),
      ]);
      ProfileModel profileModel = ProfileModel(userName: profileResponse.userName, email: user.email!,  phone: profileResponse.phone,address: profileResponse.address, userRole: profileResponse.userRole);
      return profileModel;
    }catch(e){
      return null;
      throw GetProfileException('Error getting Profile Fire Base API');
    }

  }

  Future<ProfileModel?> getUserProfile(String userID) async {

    // Change This
    try{
      ProfileResponse profileResponse = await _repository.getProfile(userID);

      ProfileModel profileModel = ProfileModel(userName: profileResponse.userName, email: profileResponse.email,  phone: profileResponse.phone,address: profileResponse.address, userRole: profileResponse.userRole);
      return profileModel;
    }catch(e){
      return null;
      throw GetProfileException('Error getting Profile Fire Base API');
    }

  }

  Future <ProfileModel?> editMyProfile(ProfileRequest request)async {
    await Future.delayed(Duration(seconds: 1));
    var user = _auth.currentUser;

    // Change This
    try{
      bool editResponse = await _repository.editProfile(user!.uid , request);
      ProfileResponse profileResponse = await _repository.getProfile(user.uid);
      await Future.wait([
        _prefsHelper.setEmail(user.email!),
        _prefsHelper.setAdderss(profileResponse.address),
        _prefsHelper.setUsername(profileResponse.userName),
        _prefsHelper.setPhone(profileResponse.phone),
        _prefsHelper.setAuthSource(AuthSource.EMAIL),
        _prefsHelper.setRole(profileResponse.userRole),
      ]);
      ProfileModel profileModel = ProfileModel(userName: profileResponse.userName, email: user.email!,  phone: profileResponse.phone,address: profileResponse.address, userRole: profileResponse.userRole);
      return profileModel;
    }catch(e){
      return null;
      throw GetProfileException('Error getting Profile Fire Base API');
    }
  }
}