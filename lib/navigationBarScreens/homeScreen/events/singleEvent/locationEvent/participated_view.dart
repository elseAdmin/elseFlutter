import 'package:else_app_two/firebaseUtil/database_manager.dart';
import 'package:else_app_two/models/events_model.dart';
import 'package:else_app_two/models/firestore/loc_submission_model.dart';
import 'package:flutter/material.dart';

class ParticipatedView extends StatefulWidget {
  final LocationEventSubmissionModel submissionDetails;
  final EventModel event;
  ParticipatedView(this.event,this.submissionDetails);
  @override
  createState() => ParticipatedViewState();
}

class ParticipatedViewState extends State<ParticipatedView>{
  @override
  void initState() {
    DatabaseManager().getVisitsForBeacon(widget.event.beaconDataList[0]);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Text("sorry");
  }

}