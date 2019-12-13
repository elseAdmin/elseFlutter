import 'package:else_app_two/feedback/myfeedback_screen.dart';
import 'package:else_app_two/profileTab/myEvents/my_events.dart';
import 'package:flutter/material.dart';

class ProfileMySectionScreenRoute {

  Future routeToProfileOptions(BuildContext context, int index){
    switch(index){
      case 0 :
        return Navigator.push(context,
          MaterialPageRoute(
            builder: (context) => MyEvents(),
          ),
        );
        break;

      case 1 :
        return Navigator.push(context,
          MaterialPageRoute(
            builder: (context) => MyFeedbackPage(),
          ),
        );
        break;

      case 2 :
        break;
    }
  }
}