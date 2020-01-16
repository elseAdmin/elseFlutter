import 'package:else_app_two/activityTab/item_handler.dart';
import 'package:else_app_two/utils/SizeConfig.dart';
import 'package:flutter/material.dart';

class WeekActivity extends StatefulWidget {
  final List weekActivities;
  WeekActivity(this.weekActivities);
  @override
  createState() => WeekActivityState();
}

class WeekActivityState extends State<WeekActivity> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    if (widget.weekActivities != null) {
      return Container(
          child: ListView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: widget.weekActivities.length,
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
                          Text("This week", style: TextStyle(fontSize: 24)),
                          Divider(
                              endIndent: SizeConfig.blockSizeHorizontal * 40,
                              color: Colors.black87,
                              height: SizeConfig.blockSizeVertical)
                        ])),
                ActivityTypeHandler().getAppropriateViewForActivity(
                    widget.weekActivities[index].runtimeType.toString(),
                    widget.weekActivities[index]),
              ],
            );
          }
          return ActivityTypeHandler().getAppropriateViewForActivity(
              widget.weekActivities[index].runtimeType.toString(),
              widget.weekActivities[index]);
        },
      ));
    } else {
      return Container();
    }
  }
}
