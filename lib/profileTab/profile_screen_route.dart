
import 'package:else_app_two/profileTab/about_us.dart';
import 'package:else_app_two/requests/request_screen.dart';
import 'package:flutter/material.dart';

import 'help_section.dart';

class ProfileScreenRoute {

  AboutUsDetailScreen aboutUs = new AboutUsDetailScreen();
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
                builder: (context) => AboutUsDetailScreen(index: index),
              ),
            );
        break;

      case 2 :
        return Navigator.push(context,
          MaterialPageRoute(
            builder: (context) => RequestsPage(),
          ),
        );
        break;

      case 3:
        break;

      case 4:
        break;
    }
  }
}