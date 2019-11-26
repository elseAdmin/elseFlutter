import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class OauthManager extends StatefulWidget {
  final bool isLoggedIn;

  OauthManager(this.isLoggedIn);

  @override
  _OauthManager createState() => _OauthManager();

}

class _OauthManager extends State<OauthManager>{

  TextEditingController _smsCodeController = TextEditingController();
  TextEditingController _phoneNumberController = TextEditingController();
  String verificationId;
  String _message = '';
  final String prefixNumber = '+91';

  /// Sends the code to the specified phone number.
  Future<void> _sendCodeToPhoneNumber() async {
    setState(() {
      _message = 'All the process text will be seen here';
    });
    final PhoneVerificationCompleted verificationCompleted =
        (AuthCredential phoneAuthCredential) {
      _auth.signInWithCredential(phoneAuthCredential);
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
      _message = "code sent to " + _phoneNumberController.text;
    };

    final PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
        (String verificationId) {
      this.verificationId = verificationId;
      print("time out");
      _message = "time out";
    };

    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: prefixNumber+_phoneNumberController.text,
        timeout: const Duration(seconds: 5),
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
  }

  /// Sign in using an sms code as input.
  void _signInWithPhoneNumber(String smsCode) async {
    final AuthCredential credential = PhoneAuthProvider.getCredential(
      verificationId: verificationId,
      smsCode: smsCode,
    );
    final FirebaseUser user =
        (await _auth.signInWithCredential(credential)).user;
    final FirebaseUser currentUser = await _auth.currentUser();
    assert(user.uid == currentUser.uid);
    setState(() {
      if (user != null) {
        print('Successfully signed in, uid: ' + user.uid);
        _message = 'Successfully signed in, uid: ' + user.uid;
      } else {
        print('Sign in failed');
        _message = 'Sign In Failed';
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Center(
        child: new Container(
          height: MediaQuery.of(context).size.height / 2,
          width: MediaQuery.of(context).size.width * 2 / 3,
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
                  if (value.isEmpty) {
                    return 'Phone number (+x xxx-xxx-xxxx)';
                  }
                  if(value.length < 10){
                    _message = 'Invalid phone number';
                  }
                  return null;
                },
              ),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                alignment: Alignment.center,
                child: RaisedButton(
                  onPressed: () async {
                    _sendCodeToPhoneNumber();
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
              TextField(
                controller: _smsCodeController,
                decoration: const InputDecoration(labelText: 'Verification code'),
              ),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                alignment: Alignment.center,
                child: ButtonTheme(
                  minWidth: MediaQuery.of(context).size.width / 2,
                  child: RaisedButton(
                    onPressed: () async {
                      _signInWithPhoneNumber(_smsCodeController.text);
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
    );
  }

}