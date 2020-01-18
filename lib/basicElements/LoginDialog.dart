import 'package:else_app_two/utils/SizeConfig.dart';
import 'package:flutter/material.dart';

class LoginDialog extends StatefulWidget{
  final VoidCallback onSignIn;
  LoginDialog(this.onSignIn);

  @override
  createState() => LoginDialogState();
}

class LoginDialogState extends State<LoginDialog> {

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    // TODO: implement build

    return SimpleDialog(
        title: Text(
          "You need to login to first",
          textAlign: TextAlign.center,
        ),
        elevation: 20,
        children: <Widget>[
          Container(
              child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              GestureDetector(
                child: Text("leave", style: TextStyle(fontSize: 20)),
                onTap: () {
                  Navigator.of(context, rootNavigator: true).pop();
                },
              ),
              GestureDetector(
                child: Text("login", style: TextStyle(fontSize: 20)),
                onTap: () {
                  widget.onSignIn();
                },
              )
            ],
          ))
        ]);
  }
}
