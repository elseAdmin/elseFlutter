import 'package:else_app_two/activityTab/item_handler.dart';
import 'package:else_app_two/utils/SizeConfig.dart';
import 'package:flutter/material.dart';

class TodayActivity extends StatefulWidget {
  final List todayActivities;
  TodayActivity(this.todayActivities);
  @override
  createState() => TodayActivityState();
}

class TodayActivityState extends State<TodayActivity> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    if (widget.todayActivities != null) {
      return Container(
          child: ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: widget.todayActivities.length,
            itemBuilder: (context, index) {
              if (index == 0) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                        padding: EdgeInsets.only(
                            top: SizeConfig.blockSizeVertical,
                            left: SizeConfig.blockSizeHorizontal * 2),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text("Today", style: TextStyle(fontSize: 24)),
                              Divider(
                                  endIndent: SizeConfig.blockSizeHorizontal *
                                      40,
                                  color: Colors.black87,
                                  height: SizeConfig.blockSizeVertical)
                            ])),
                    ActivityTypeHandler().getAppropriateViewForActivity(
                        widget.todayActivities[index].runtimeType.toString(),
                        widget.todayActivities[index]),
                  ],
                );
              }
              return ActivityTypeHandler().getAppropriateViewForActivity(
                  widget.todayActivities[index].runtimeType.toString(),
                  widget.todayActivities[index]);
            },
          ));
    } else {
      return Container();
    }
  }
}
