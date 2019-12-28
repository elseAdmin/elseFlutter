import 'package:else_app_two/activityTab/month_activity_section.dart';
import 'package:else_app_two/activityTab/today_activity_section.dart';
import 'package:else_app_two/activityTab/week_activity_section.dart';
import 'package:else_app_two/home/events/singleEvent/EventStaticData.dart';
import 'package:else_app_two/utils/Contants.dart';
import 'package:else_app_two/utils/SizeConfig.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class ActivityMainScreen extends StatefulWidget {
  final Map activities;
  ActivityMainScreen(this.activities);
  @override
  createState() => ActivityMainScreenState();
}

class ActivityMainScreenState extends State<ActivityMainScreen> {
  final logger = Logger();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // logger.i(widget.activities);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Constants.mainBackgroundColor,
        child: CustomScrollView(
          slivers: <Widget>[
            SliverPadding(
                padding:
                    EdgeInsets.only(bottom: SizeConfig.blockSizeVertical * 2),
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
    );
  }
}
