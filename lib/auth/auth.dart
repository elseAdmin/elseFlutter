import 'dart:async';
import 'package:else_app_two/auth/models/user_model.dart';
import 'package:else_app_two/utils/app_startup_data.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class BaseAuth {
  Future<String> signInwithPhoneNumber(AuthCredential credential);
  Future<String> currentUser();
  Future<void> signOut();

  verifyPhoneNumber(
      {String phoneNumber,
      Duration timeout,
      PhoneVerificationCompleted verificationCompleted,
      PhoneVerificationFailed verificationFailed,
      PhoneCodeSent codeSent,
      PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout}) {}
}

class Auth implements BaseAuth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  Future<String> signInwithPhoneNumber(AuthCredential credential) async {
    FirebaseUser firebaseUser =
        (await _firebaseAuth.signInWithCredential(credential)).user;
    User user = User(firebaseUser.uid,firebaseUser.phoneNumber,firebaseUser.displayName,firebaseUser.email);
    return firebaseUser?.uid;
  }

  @override
  Future<String> currentUser() async {
    final FirebaseUser firebaseUser = await _firebaseAuth.currentUser();
    User user;
    if(firebaseUser!=null && firebaseUser.uid!=null) {
      user = User(
          firebaseUser.uid, firebaseUser.phoneNumber, firebaseUser.displayName,
          firebaseUser.email);
    }
    StartupData.user=user;
    return user.id;
  }

  @override
  Future<void> signOut() async {
    return _firebaseAuth.signOut();
  }

  @override
  verifyPhoneNumber(
      {String phoneNumber,
      Duration timeout,
      PhoneVerificationCompleted verificationCompleted,
      PhoneVerificationFailed verificationFailed,
      PhoneCodeSent codeSent,
      PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout}) async {
    return await _firebaseAuth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        timeout: const Duration(seconds: 5),
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
  }
}