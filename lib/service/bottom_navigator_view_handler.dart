
import 'package:else_app_two/navigationBarScreens/home_screen.dart';
import 'package:else_app_two/navigationBarScreens/navigation_screen.dart';
import 'package:else_app_two/navigationBarScreens/notification_screen.dart';
import 'package:else_app_two/navigationBarScreens/parking_screen.dart';
import 'package:else_app_two/navigationBarScreens/profile_screen.dart';
import 'package:firebase_performance/firebase_performance.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class BottomNavigatorViewHandler {
  final logger = Logger();

  Widget getViewForNavigationBarIndex(int index) {
    final Trace myTrace = FirebasePerformance.instance.newTrace("nav_section");
    Parking parking = new Parking();
    Profile profile = new Profile();
    HomeScreen home = new HomeScreen();
    NavigationScreen navigation = new NavigationScreen();
    NotificationScreen notification = new NotificationScreen();
    switch (index) {
      case 0:
        myTrace.incrementMetric("nav_home", 1);
        return home;
        break;
      case 1:
        myTrace.incrementMetric("nav_profile", 1);
        return profile;
        break;
    }
  }
}
/*
*     myTrace.incrementMetric("nav_explore", 1);
        return navigation;
        break;
      case 2:
        myTrace.incrementMetric("nav_parking", 1);
        return parking;
        break;
      case 3:
        myTrace.incrementMetric("nav_activity", 1);
        return notification;
        break;
      case 4:
* */