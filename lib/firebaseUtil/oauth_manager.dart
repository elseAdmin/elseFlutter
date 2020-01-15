import 'package:else_app_two/auth/auth.dart';
import 'package:else_app_two/auth/auth_provider.dart';
import 'package:else_app_two/auth/models/user_model.dart';
import 'package:else_app_two/profileTab/register_user.dart';
import 'package:else_app_two/firebaseUtil/api.dart';
import 'package:else_app_two/auth/models/user_crud_model.dart';
import 'package:else_app_two/utils/Contants.dart';
import 'package:else_app_two/utils/app_startup_data.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OauthManager extends StatefulWidget {
  final VoidCallback onSignedIn;
  const OauthManager({Key key, this.onSignedIn}) : super(key: key);

  @override
  _OauthManager createState() => _OauthManager();

}

class _OauthManager extends State<OauthManager>{
  final _formKey = GlobalKey<FormState>();
  TextEditingController _smsCodeController = TextEditingController();
  TextEditingController _phoneNumberController = TextEditingController();
  final UserCrudModel userProvider = UserCrudModel('users', new Api('users'));
  String verificationId;
  String _message = '';
  final String prefixNumber = '+91';
  bool disabledKey = true;

  /// Sends the code to the specified phone number.
  Future<void> _sendCodeToPhoneNumber() async {
    final BaseAuth _auth = AuthProvider.of(context).auth;

    setState(() {
      _message = 'All the process text will be seen here';
    });
    final PhoneVerificationCompleted verificationCompleted =
        (AuthCredential phoneAuthCredential) {
      _auth.signInwithPhoneNumber(phoneAuthCredential);
      setState(() {
        print('Received phone auth credential: $phoneAuthCredential');
        _message = 'Received phone auth credential: $phoneAuthCredential';
      });
    };

    final PhoneVerificationFailed verificationFailed = (
        AuthException authException) {
      setState(() {
        print('Phone number verification failed. Code: ${authException
            .code}. Message: ${authException.message}');
        _message = 'Phone number verification failed. Code: ${authException
            .code}. Message: ${authException.message}';
      });
    };

    final PhoneCodeSent codeSent =
        (String verificationId, [int forceResendingToken]) async {
      this.verificationId = verificationId;
      print("code sent to " + _phoneNumberController.text);
      setState(() {
        _message = "code sent to " + _phoneNumberController.text;
        disabledKey = false;
      });
    };

    final PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
        (String verificationId) {
      this.verificationId = verificationId;
      print("time out");
      _message = "time out";
    };

    await _auth.verifyPhoneNumber(
        phoneNumber: prefixNumber+_phoneNumberController.text,
        timeout: const Duration(seconds: 5),
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
  }

  void _signedIn() {
    Navigator.pop(context);
    widget.onSignedIn();
  }

  Future _checkForNewUser(BuildContext context, String userId, String phoneNumber) async {
    User user = await userProvider.getUserById(userId);

    if(user == null){
      await Navigator.push(context,
        MaterialPageRoute(
          builder: (context) => RegisterUser(userId, _phoneNumberController.text, _signedIn),
        ),
      );
    }
    else{
      _signedIn();
    }
  }

  /// Sign in using an sms code as input.
  void _signInWithPhoneNumber(BuildContext context, String smsCode) async {
    final BaseAuth _auth = AuthProvider.of(context).auth;

    final AuthCredential credential = PhoneAuthProvider.getCredential(
      verificationId: verificationId,
      smsCode: smsCode,
    );
    final String userId =
        (await _auth.signInwithPhoneNumber(credential));
    final String currentUserId = await _auth.currentUser();
    assert(userId == currentUserId);
    if(userId.isNotEmpty){
      User user = await UserCrudModel('users', new Api('users')).getUserById(userId);
        if (user != null && userId.isNotEmpty) {
          StartupData.user = user;
        }
      await _checkForNewUser(context, userId, _phoneNumberController.text);
    }
    setState(() {
      if (userId != null) {
        print('Successfully signed in, uid: ' + userId);
        _message = 'Successfully signed in, uid: ' + userId;
      } else {
        print('Sign in failed');
        _message = 'Sign In Failed!! Wrong OTP';
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Constants.titleBarBackgroundColor,
        iconTheme: IconThemeData(
          color: Constants.textColor, //change your color here
        ),
        title: Text("Login",
          style: TextStyle(
            color: Constants.titleBarTextColor,
            fontSize: 18,
          ),
        ),
      ),
      body: Center(
        child: new Container(
          height: MediaQuery.of(context).size.height / 2,
          width: MediaQuery.of(context).size.width * 2 / 3,
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextFormField(
                  controller: _phoneNumberController,
                  keyboardType: TextInputType.phone,
                  textInputAction: TextInputAction.send,
                  maxLength: 10,
                  decoration: const InputDecoration(
                    labelText: 'Phone number (+x xxx-xxx-xxxx)',
                    prefixText: '+91-',
                  ),
                  validator: (String value) {
                    if (value.length < 10) {
                      return 'Phone number (+x xxx-xxx-xxxx)';
                    }
                    else if(value.length > 10){
                      return 'Invalid phone number';
                    }
                    else{
                      return null;
                    }
                  },
                ),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  alignment: Alignment.center,
                  child: RaisedButton(
                    onPressed: () async {
                      if (_formKey.currentState.validate()) {
                        _sendCodeToPhoneNumber();
                      }
                    },
                    color: Colors.blueGrey,
                    child: const Text(
                      'Send OTP',
                      style: TextStyle(
                          color: Colors.white
                      ),
                    ),
                  ),
                ),
                AbsorbPointer(
                  absorbing: disabledKey,
                  child: Column(
                    children: <Widget>[
                      TextField(
                        controller: _smsCodeController,
                        decoration: const InputDecoration(labelText: 'Verification code'),
                        keyboardType: TextInputType.number,
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        alignment: Alignment.center,
                        child: ButtonTheme(
                          minWidth: MediaQuery.of(context).size.width / 2,
                          child: RaisedButton(
                            onPressed: () async {
                              _signInWithPhoneNumber(context, _smsCodeController.text);
                            },
                            color: Colors.blueGrey,

                            child: const Text(
                              'LOG IN',
                              style: TextStyle(
                                  color: Colors.white
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(_message),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

}