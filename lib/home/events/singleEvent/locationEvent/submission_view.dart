import 'package:else_app_two/basicElements/BallProgressIndicator.dart';
import 'package:else_app_two/firebaseUtil/database_manager.dart';
import 'package:else_app_two/firebaseUtil/oauth_manager.dart';
import 'package:else_app_two/home/events/models/events_model.dart';
import 'package:else_app_two/home/events/models/loc_submission_model.dart';
import 'package:else_app_two/home/events/singleEvent/locationEvent/not_participated_view.dart';
import 'package:else_app_two/home/events/singleEvent/locationEvent/participated_view.dart';
import 'package:else_app_two/utils/app_startup_data.dart';
import 'package:flutter/material.dart';
import 'package:loading/indicator/ball_pulse_indicator.dart';
import 'package:loading/loading.dart';

class SubmissionView extends StatefulWidget {
  final EventModel event;
  SubmissionView(this.event);
  @override
  createState() => SubmissionViewState();
}

class SubmissionViewState extends State<SubmissionView> {
  List result = List();
  LocationEventSubmissionModel submissionDetails;
  @override
  void initState() {
    DatabaseManager()
        .getUserParticipationForLocationEvent(widget.event)
        .then((value) {
      if (value == null) {
        value = LocationEventSubmissionModel(null);
      }
      setState(() {
        submissionDetails = value;
      });
    });
    super.initState();
  }

  onUserParticipated() {
    DatabaseManager()
        .getUserParticipationForLocationEvent(widget.event)
        .then((value) {
      if (value == null) {
        value = LocationEventSubmissionModel(null);
      }
      setState(() {
        submissionDetails = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (submissionDetails == null) {
      //still fetching details
      return BallProgressIndicator();
    } else if (submissionDetails.participatedAt == null) {
      //user never participated
      return NotParticipatedView(widget.event, onUserParticipated);
    } else {
      return ParticipatedView(widget.event, submissionDetails);
    }
  }
}
