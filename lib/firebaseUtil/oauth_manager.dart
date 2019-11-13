import 'package:firebase_auth/firebase_auth.dart';

class OauthManager {
  FirebaseAuth _firebaseAuth;
  OauthManager(){
    _firebaseAuth = FirebaseAuth.instance;
  }
}