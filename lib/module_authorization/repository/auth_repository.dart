import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_kom/module_authorization/requests/register_request.dart';

class AuthRepository {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<bool> register(RegisterRequest request) async {
    var user = _firebaseAuth.currentUser;
    await _firebaseAuth
        .createUserWithEmailAndPassword(
      email: request.email,
      password: request.password,
    )
        .then((UserCredential credential) async {
      User? user = credential.user;
      return await _firestore
          .collection('users')
          .doc(user!.uid)
          .set(request.toJson())
          .catchError((error) {
        throw Exception(error.toString());
      });
    }).catchError((error) {
      throw Exception(error.toString());
    });
    return true;
  }
}
