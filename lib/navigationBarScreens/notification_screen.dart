import 'package:else_app_two/activityTab/activity_screen.dart';
import 'package:else_app_two/basicElements/BallProgressIndicator.dart';
import 'package:else_app_two/firebaseUtil/database_manager.dart';
import 'package:else_app_two/firebaseUtil/oauth_manager.dart';
import 'package:else_app_two/utils/app_startup_data.dart';
import 'package:flutter/material.dart';

class NotificationScreen extends StatefulWidget {
  @override
  createState() => NotificationScreenState();
}

class NotificationScreenState extends State<NotificationScreen> {
  Map activities;
  bool isLoggedIn = false;
  @override
  void initState() {
    // TODO: implement initState
    if (StartupData.user != null && StartupData.user.id != null) {
      isLoggedIn=true;
      DatabaseManager().getAllActivityOfUser(false).then((activities) {
        setState(() {
          this.activities = activities;
        });
      });
    }
    super.initState();
  }
  redirectLogin() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OauthManager(onSignedIn: _signedIn),
      ),
    );
  }

  void _signedIn() {
    DatabaseManager().getAllActivityOfUser(false).then((activities) {
      setState(() {
        this.activities = activities;
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    if(isLoggedIn) {
      if (activities == null) {
        return BallProgressIndicator();
      } else {
        return ActivityMainScreen(activities);
      }
    } else {
      return Center(
        child: GestureDetector(
          onTap: redirectLogin,
          child: Text("Login to view your activity"),
        ),
      );
    }
  }
}
