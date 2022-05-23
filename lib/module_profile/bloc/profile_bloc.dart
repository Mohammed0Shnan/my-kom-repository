import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_kom/module_authorization/requests/register_request.dart';
import 'package:my_kom/module_profile/model/profile_model.dart';
import 'package:my_kom/module_profile/service/profile_service.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileStates> {
  final ProfileService _service = ProfileService();

  ProfileBloc() : super(ProfileInitState()) {
    on<ProfileEvent>((ProfileEvent event, Emitter<ProfileStates> emit) {
      if (event is ProfileLoadingEvent)
              emit(ProfileLoadingState());
            else if (event is ProfileErrorEvent){
              emit(ProfileErrorState(message: event.data));
            }
            else if (event is ProfileSuccessEvent)
            emit(ProfileSuccessState(data: event.data));
      else {
        emit(ProfileInitState());
      }
    });
  }

 

  getMyProfile() async {
    this.add(ProfileLoadingEvent());
    _service.getMyProfile().then((value) {
      if (value !=null) {
        this.add(ProfileSuccessEvent(data: value));
      } else
        this.add(ProfileErrorEvent(data: 'Error getting Profile Fire Base API'));
    });
  }
  
   editProfile(ProfileRequest request){
  //        this.add(CompleteLoadingEvent());
  // _service.createProfile(request).then((value) {
  //         if (value.state) {
  //       this.add(CompleteSuccessEvent(data: value.data));
  //     } else
  //       this.add(CompleteErrorEvent(data:value.data));
 // });
 }

  void deleteFakeAccount() {
  //  _service.fakeAccount();

  }
}



abstract class ProfileEvent {}

class ProfileInitEvent extends ProfileEvent {
    String data;
  ProfileInitEvent({required this.data});
}

class ProfileSuccessEvent extends ProfileEvent {
  ProfileModel data;
  ProfileSuccessEvent({required this.data});
}

class ProfileLoadingEvent extends ProfileEvent {}

class ProfileErrorEvent extends ProfileEvent {
  String data;
  ProfileErrorEvent({required this.data});
}

abstract class ProfileStates {}

class ProfileInitState extends ProfileStates {}

class ProfileSuccessState extends ProfileStates {
    ProfileModel data;
  ProfileSuccessState({required this.data});
}

class ProfileLoadingState extends ProfileStates {}

class ProfileErrorState extends ProfileStates {
  String message;
  ProfileErrorState({required this.message});
}




