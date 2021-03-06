import 'package:else_app_two/activityTab/month_activity_section.dart';
import 'package:else_app_two/activityTab/today_activity_section.dart';
import 'package:else_app_two/activityTab/week_activity_section.dart';
import 'package:else_app_two/firebaseUtil/database_manager.dart';
import 'package:else_app_two/firebaseUtil/oauth_manager.dart';
import 'package:else_app_two/utils/Contants.dart';
import 'package:else_app_two/utils/SizeConfig.dart';
import 'package:else_app_two/utils/app_startup_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class ActivityMainScreen extends StatefulWidget {
  Map activities;
  ActivityMainScreen(this.activities);
  @override
  createState() => ActivityMainScreenState();
}

class ActivityMainScreenState extends State<ActivityMainScreen> {
  final logger = Logger();
  bool isLoggedIn = false;

  Future<Null> _handleRefresh() async {
    Map refreshedActivities =
        await DatabaseManager().getAllActivityOfUser(true);
    setState(() {
      widget.activities = refreshedActivities;
    });
    return null;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (StartupData.user != null) {
      isLoggedIn = true;
    }
    // logger.i(widget.activities);
  }

  @override
  Widget build(BuildContext context) {
    if (isLoggedIn) {
      if (widget.activities['today'] == null &&
          widget.activities['week'] == null &&
          widget.activities['month'] == null) {
        return RefreshIndicator(
            onRefresh: _handleRefresh,
            child: Center(
              child: Text("No activity so far"),
            ));
      } else {
        return RefreshIndicator(
            onRefresh: _handleRefresh,
            child: Scaffold(
              body: Container(
                color: Constants.mainBackgroundColor,
                child: CustomScrollView(
                  slivers: <Widget>[
                    SliverPadding(
                        padding: EdgeInsets.only(
                            bottom: SizeConfig.blockSizeVertical * 2),
                        sliver: SliverList(
                          delegate: SliverChildListDelegate(
                            [
                              TodayActivity(widget.activities['today']),
                              WeekActivity(widget.activities['week']),
                              MonthActivity(widget.activities['month'])
                            ],
                          ),
                        )),
                  ],
                ),
              ),
            ));
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

  redirectLogin() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OauthManager(onSignedIn: _signedIn),
      ),
    );
  }

  void _signedIn() {
    DatabaseManager().getAllActivityOfUser(true).then((refreshedActivities) {
      setState(() {
        isLoggedIn = true;
        widget.activities = refreshedActivities;
      });
    });
  }
}
