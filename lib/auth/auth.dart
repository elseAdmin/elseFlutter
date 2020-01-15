import 'dart:async';
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
    FirebaseUser user =
        (await _firebaseAuth.signInWithCredential(credential)).user;
    return user?.uid;
  }

  @override
  Future<String> currentUser() async {
    final FirebaseUser user = await _firebaseAuth.currentUser();
    return user?.uid;
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
