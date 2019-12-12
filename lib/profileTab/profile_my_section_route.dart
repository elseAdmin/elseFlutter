import 'package:else_app_two/feedback/myfeedback_screen.dart';
import 'package:flutter/material.dart';

import 'help_section.dart';

class ProfileMySectionScreenRoute {

  Future routeToProfileOptions(BuildContext context, int index){
    switch(index){
      case 0 :
        return Navigator.push(context,
          MaterialPageRoute(
            builder: (context) => HelpSection(index:index),
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