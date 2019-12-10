import 'package:else_app_two/firebaseUtil/database_manager.dart';
import 'package:else_app_two/models/events_model.dart';
import 'package:else_app_two/models/firestore/loc_submission_model.dart';
import 'package:else_app_two/utils/SizeConfig.dart';
import 'package:flutter/material.dart';

class ParticipatedView extends StatefulWidget {
  final LocationEventSubmissionModel submissionDetails;
  final EventModel event;
  ParticipatedView(this.event, this.submissionDetails);
  @override
  createState() => ParticipatedViewState();
}

class ParticipatedViewState extends State<ParticipatedView> {
  var t = 'sorry';
  @override
  void initState() {
    DatabaseManager().getUniqueVisitsForBeacon(widget.event).then((dates) {
      setState(() {
        t = dates.length.toString();
      });
    });
    super.initState();
  }

  int _index = 0;
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    // TODO: implement build
    return Container(
        width: SizeConfig.blockSizeHorizontal * 100,
        color: Colors.cyan,
        margin: EdgeInsets.only(top: SizeConfig.blockSizeVertical * 3),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Container(
                    height: SizeConfig.blockSizeVertical * 2,
                    width: SizeConfig.blockSizeHorizontal * 14,
                    decoration: BoxDecoration(
                        color: Colors.orange, shape: BoxShape.circle),
                    child: Text("")),
                Container(child: Text("Date"))
              ],
            ),
            Container(padding: EdgeInsets.only(top:1,bottom:1),color: Colors.black,height:10,width:1,),
            Row(
              children: <Widget>[
                Container(
                    height: SizeConfig.blockSizeVertical * 2,
                    width: SizeConfig.blockSizeHorizontal * 14,
                    decoration: BoxDecoration(
                        color: Colors.orange, shape: BoxShape.circle),
                    child: Text("")),
                Container(child: Text("Date"))
              ],
            )
          ],
        ));
  }

  List<Step> getSteps() {
    List<Step> stepList = List();
    for (int i = 0; i < widget.event.observedDays; i++) {
      Step step = new Step(
          title: Text("Third"),
          subtitle: Text("Constructor"),
          state: StepState.complete);
    }
  }
}
