import 'package:else_app_two/activityTab/activity_screen.dart';
import 'package:else_app_two/firebaseUtil/database_manager.dart';
import 'package:flutter/material.dart';
import 'package:loading/indicator/ball_pulse_indicator.dart';
import 'package:loading/loading.dart';

class NotificationScreen extends StatefulWidget {
  @override
  createState() => NotificationScreenState();
}

class NotificationScreenState extends State<NotificationScreen> {
  List activities;
  @override
  void initState() {
    // TODO: implement initState
    DatabaseManager().getAllActivityOfUser().then((activities) {
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
      return Center(
        child: Loading(
            indicator: BallPulseIndicator(), size: 60.0, color: Colors.blue),
      );
    } else {
      return ActivityMainScreen(activities);
    }
  }
}
