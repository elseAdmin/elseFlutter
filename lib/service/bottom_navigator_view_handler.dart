
import 'package:else_app_two/navigationBarScreens/home_screen.dart';
import 'package:else_app_two/navigationBarScreens/navigation_screen.dart';
import 'package:else_app_two/navigationBarScreens/notification_screen.dart';
import 'package:else_app_two/navigationBarScreens/parking_screen.dart';
import 'package:else_app_two/navigationBarScreens/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class BottomNavigatorViewHandler {
  final logger = Logger();

  Widget getViewForNavigationBarIndex(int index) {
    Parking parking = new Parking();
    Profile profile = new Profile();
    HomeScreen home = new HomeScreen();
    NavigationScreen navigation = new NavigationScreen();
    NotificationScreen notification = new NotificationScreen();
    switch (index) {
      case 0:
        return home;
        break;
      case 1:
        return navigation;
        break;
      case 2:
        return parking;
        break;
      case 3:
        return notification;
        break;
      case 4:
        return profile;
        break;
    }
  }
}
