import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_kom/module_authorization/enums/auth_source.dart';
import 'package:my_kom/module_authorization/enums/user_role.dart';
import 'package:my_kom/module_map/models/address_model.dart';

class AppUser {
  final User credential;
  final AddressModel address;
  final String user_name;
  final phone_number;
  final AuthSource authSource;
  final UserRole userRole;
  AppUser({required this.credential,required this.authSource,required this.userRole,required this.address ,required this.phone_number ,required this.user_name});
}