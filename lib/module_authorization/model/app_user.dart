import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_kom/module_authorization/enums/auth_source.dart';
import 'package:my_kom/module_authorization/enums/user_role.dart';
import 'package:my_kom/module_map/models/address_model.dart';

class AppUser {
  final String id;
  final String email;
  final AddressModel address;
  final String user_name;
  final phone_number;
  final AuthSource authSource;
  final UserRole userRole;
  final String? stripeId;
  final String? activeCard ;

  AppUser({required this.id, required this.email,required this.authSource,required this.userRole,required this.address ,required this.phone_number ,required this.user_name,required this.stripeId,required this.activeCard});
}