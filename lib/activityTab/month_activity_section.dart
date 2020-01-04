import 'package:else_app_two/activityTab/item_handler.dart';
import 'package:else_app_two/utils/SizeConfig.dart';
import 'package:flutter/material.dart';

class MonthActivity extends StatefulWidget {
  final List monthActivities;
  MonthActivity(this.monthActivities);
  @override
  createState() => MonthActivityState();
}

class MonthActivityState extends State<MonthActivity> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
        child: ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: widget.monthActivities.length,
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
                        Text("Earlier this month",
                            style: TextStyle(fontSize: 24)),
                        Divider(
                            endIndent: SizeConfig.blockSizeHorizontal * 40,
                            color: Colors.black87,
                            height: SizeConfig.blockSizeVertical)
                      ])),
              ActivityTypeHandler().getAppropriateViewForActivity(
                  widget.monthActivities[index].runtimeType.toString(),
                  widget.monthActivities[index]),
            ],
          );
        }
        return ActivityTypeHandler().getAppropriateViewForActivity(
            widget.monthActivities[index].runtimeType.toString(),
            widget.monthActivities[index]);
      },
    ));
  }
}
