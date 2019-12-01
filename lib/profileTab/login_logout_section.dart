import 'package:else_app_two/auth/auth.dart';
import 'package:else_app_two/auth/auth_provider.dart';
import 'package:flutter/material.dart';

import '../firebaseUtil/oauth_manager.dart';

class LoginLogoutSection extends StatefulWidget{
  final bool isUserLoggedIn;
  final VoidCallback onSignedOut;
  final VoidCallback onSignedIn;
  LoginLogoutSection(this.isUserLoggedIn, this.onSignedOut, this.onSignedIn);

  @override
  _LoginLogoutSection createState() => _LoginLogoutSection();
}

class _LoginLogoutSection extends State<LoginLogoutSection>{

  Future<void> _signOut(BuildContext context) async {
    try {
      final BaseAuth auth = AuthProvider.of(context).auth;
      await auth.signOut();
      widget.onSignedOut();
    } catch (e) {
      print(e);
    }
  }

  void _signedIn() {
    setState(() {
      widget.onSignedIn();
    });
  }

  Future<void> _signIn(BuildContext context) async {
    try {
      await Navigator.push(context,
        MaterialPageRoute(
          builder: (context) => OauthManager(onSignedIn: _signedIn),
        ),
      );
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: userStatusChild(context, widget.isUserLoggedIn),
    );
  }

  Widget userStatusChild(BuildContext context, isUserLogged){
    if(isUserLogged){
      return ListTile(
        contentPadding: const EdgeInsets.only(left: 10, right: 10,top: 10,bottom: 10),
        title: FlatButton(
          color: Colors.white,
          onPressed: () => _signOut(context),
          child: const Text(
            'LOGOUT',
            style: TextStyle(
                fontWeight: FontWeight.bold
            ),
          ),
        ),
        subtitle: Text(
          'ELSE',
          textAlign: TextAlign.center,
          style: TextStyle(
              fontWeight: FontWeight.bold
          ),
        ),
      );
    }
    else {
      return ListTile(
        contentPadding: const EdgeInsets.only(left: 10, right: 10,top: 10,bottom: 10),
        title: FlatButton(
          color: Colors.white,
          onPressed: () => _signIn(context),
          child: const Text(
            'LOGIN',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18
            ),
          ),
        ),
        subtitle: Text(
          'ELSE',
          textAlign: TextAlign.center,
          style: TextStyle(
              fontWeight: FontWeight.bold
          ),
        ),
      );
    }
  }

}