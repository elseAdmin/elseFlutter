
import 'package:else_app_two/profileTab/about_us_detail_screen.dart';
import 'package:flutter/material.dart';

class ProfileScreenRoute {

  AboutUsDetailScreen aboutUs = new AboutUsDetailScreen();
  Future routeToProfileOptions(BuildContext context, int index){
    switch(index){
      case 0 :
        return Navigator.push(context,
                MaterialPageRoute(
                  builder: (context) => AboutUsDetailScreen(index: index),
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
        break;

      case 3:
        break;

      case 4:
        break;
    }
  }
}