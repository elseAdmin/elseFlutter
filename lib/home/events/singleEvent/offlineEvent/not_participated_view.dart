import 'package:else_app_two/firebaseUtil/database_manager.dart';
import 'package:else_app_two/models/events_model.dart';
import 'package:else_app_two/utils/SizeConfig.dart';
import 'package:flutter/material.dart';

import 'package:fluttertoast/fluttertoast.dart';

class NotParticipatedView extends StatelessWidget{
  final EventModel event;
  final Function() callback;
  NotParticipatedView(this.event,this.callback);
  _onUserParticipated(){
    Fluttertoast.showToast(
        msg: "Hope to see you",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIos: 1,
        backgroundColor: Colors.black12,
        textColor: Colors.white,
        fontSize: 13.0
    );

    DatabaseManager().markUserParticipationForOfflineEvent(event).then((value){
      //call setState for submissionView
      callback();
    });
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
            child: Text("I'll join",style: TextStyle(fontSize: 26),),
          )
        ]));
  }
}