import 'package:else_app_two/activityTab/activity_screen.dart';
import 'package:else_app_two/basicElements/BallProgressIndicator.dart';
import 'package:else_app_two/firebaseUtil/database_manager.dart';
import 'package:flutter/material.dart';

class NotificationScreen extends StatefulWidget {
  @override
  createState() => NotificationScreenState();
}

class NotificationScreenState extends State<NotificationScreen> {
  Map activities;
  @override
  void initState() {
    // TODO: implement initState
    DatabaseManager().getAllActivityOfUser(false).then((activities) {
      setState(() {
        this.activities = activities;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    if (activities == null) {
      return BallProgressIndicator();
    } else {
      return ActivityMainScreen(activities);
    }
  }
}
