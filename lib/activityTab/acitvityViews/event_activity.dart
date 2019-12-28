import 'package:else_app_two/home/events/models/user_event_submission_model.dart';
import 'package:else_app_two/utils/SizeConfig.dart';
import 'package:flutter/material.dart';

class EventActivity extends StatelessWidget{
  final UserEventSubmissionModel event;
  EventActivity(this.event);
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return  Container(
        padding: EdgeInsets.only(top:SizeConfig.blockSizeVertical*0.5,left: SizeConfig.blockSizeHorizontal),
        child: GestureDetector(
            onTap: () => {

            },
            child: Text("Grabbed a deal at " + event.universe)));
  }

}