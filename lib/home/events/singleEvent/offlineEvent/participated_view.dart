import 'package:else_app_two/home/events/models/events_model.dart';
import 'package:else_app_two/home/events/models/offline_submission_model.dart';
import 'package:else_app_two/utils/SizeConfig.dart';
import 'package:flutter/material.dart';

class ParticipatedView extends StatefulWidget {
  final OfflineEventSubmissionModel submissionDetails;
  final EventModel event;
  ParticipatedView(this.event, this.submissionDetails);
  @override
  createState() => ParticipatedViewState();
}

class ParticipatedViewState extends State<ParticipatedView> {
  var t = 'sorry';
  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    // TODO: implement build
    return Container(
      padding: EdgeInsets.only(top:SizeConfig.blockSizeVertical*2,left: SizeConfig.blockSizeHorizontal*3),
        child: Column(children: <Widget>[
          Row(children: <Widget>[
            Text("Your visitor Id is "),
            Text(widget.submissionDetails.participationId),
            Text(". We will be happy to have you")
          ],),
          Row(children: <Widget>[],),
        ],));
  }
}
