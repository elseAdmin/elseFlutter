import 'package:else_app_two/firebaseUtil/database_manager.dart';
import 'package:else_app_two/home/events/singleEvent/offlineEvent/not_participated_view.dart';
import 'package:else_app_two/home/events/singleEvent/offlineEvent/participated_view.dart';
import 'package:else_app_two/home/events/models/events_model.dart';
import 'package:else_app_two/home/events/models/offline_submission_model.dart';
import 'package:flutter/material.dart';
import 'package:loading/indicator/ball_pulse_indicator.dart';
import 'package:loading/loading.dart';

class SubmissionView extends StatefulWidget{
  final EventModel event;
  SubmissionView(this.event);
  @override
  createState() =>SubmissionViewState();
}

class SubmissionViewState extends State<SubmissionView>{
  List result = List();
  OfflineEventSubmissionModel submissionDetails;
  @override
  void initState() {
    DatabaseManager().getUserParticipationForOfflineEvent(widget.event).then((value){
      if(value==null){
        value = OfflineEventSubmissionModel(null);
      }
      setState(() {
        submissionDetails = value;
      });
    });
    super.initState();
  }

  onUserParticipated(){
    DatabaseManager().getUserParticipationForOfflineEvent(widget.event).then((value){
      if(value==null){
        value = OfflineEventSubmissionModel(null);
      }
      setState(() {
        submissionDetails = value;
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    if(submissionDetails==null){
      //still fetching details
      return  Center(
        child: Loading(
            indicator: BallPulseIndicator(),
            size: 60.0,
            color: Colors.blue),
      );
    }else if(submissionDetails.participatedAt == null){
      //user never participated
      return NotParticipatedView(widget.event,onUserParticipated);
    }else{
      return ParticipatedView(widget.event,submissionDetails);
    }
  }

}