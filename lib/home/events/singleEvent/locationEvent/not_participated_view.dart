import 'package:else_app_two/basicElements/LoginDialog.dart';
import 'package:else_app_two/firebaseUtil/database_manager.dart';
import 'package:else_app_two/firebaseUtil/oauth_manager.dart';
import 'package:else_app_two/home/events/models/events_model.dart';
import 'package:else_app_two/utils/SizeConfig.dart';
import 'package:else_app_two/utils/app_startup_data.dart';
import 'package:flutter/material.dart';

import 'package:fluttertoast/fluttertoast.dart';
class NotParticipatedView extends StatefulWidget{
  final EventModel event;
  final Function() callback;
  NotParticipatedView(this.event,this.callback);
  @override
  State<StatefulWidget> createState() => NotParticipatedViewState();
}
class NotParticipatedViewState extends State<NotParticipatedView>{
  bool isLoggedIn = false;
  @override
  initState(){
    if(StartupData.user!=null){
      isLoggedIn=true;
    }
    super.initState();
  }
  _onUserParticipated(){
    if(isLoggedIn) {
      Fluttertoast.showToast(
          msg: "Get set ready go",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIos: 1,
          backgroundColor: Colors.black12,
          textColor: Colors.white,
          fontSize: 13.0
      );

      DatabaseManager()
          .markUserParticipationForLocationEvent(widget.event)
          .then((value) {
        //call setState for submissionView
        widget.callback();
      });
    }else{
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) => LoginDialog(onSignIn));
    }
  }
  onSignIn() {
    isLoggedIn = true;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OauthManager(onSignedIn: _onUserParticipated),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
        padding:EdgeInsets.all(SizeConfig.blockSizeVertical*7)
        ,child:Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          GestureDetector(
            onTap:_onUserParticipated,
            child: Text("I'm in",style: TextStyle(fontSize: 26),),
          )
        ]));
  }
}