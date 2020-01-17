import 'package:else_app_two/firebaseUtil/database_manager.dart';
import 'package:else_app_two/firebaseUtil/oauth_manager.dart';
import 'package:else_app_two/home/events/singleEvent/offlineEvent/not_participated_view.dart';
import 'package:else_app_two/home/events/singleEvent/offlineEvent/participated_view.dart';
import 'package:else_app_two/home/events/models/events_model.dart';
import 'package:else_app_two/home/events/models/offline_submission_model.dart';
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
  bool isLoggedIn;
  List result = List();
  OfflineEventSubmissionModel submissionDetails;
  @override
  void initState() {
    if (StartupData.user != null) {
      isLoggedIn = true;
      DatabaseManager()
          .getUserParticipationForOfflineEvent(widget.event)
          .then((value) {
        if (value == null) {
          value = OfflineEventSubmissionModel(null);
        }
        setState(() {
          submissionDetails = value;
        });
      });
    } else {
      isLoggedIn = false;
    }
    super.initState();
  }

  onUserParticipated() {
    DatabaseManager()
        .getUserParticipationForOfflineEvent(widget.event)
        .then((value) {
      if (value == null) {
        value = OfflineEventSubmissionModel(null);
      }
      setState(() {
        submissionDetails = value;
      });
    });
  }

  redirectLogin() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OauthManager(onSignedIn: _signedIn),
      ),
    );
  }

  void _signedIn() {
    DatabaseManager()
        .getUserParticipationForOfflineEvent(widget.event)
        .then((value) {
      if (value == null) {
        value = OfflineEventSubmissionModel(null);
      }
      setState(() {
        isLoggedIn = true;
        submissionDetails = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoggedIn) {
      if (submissionDetails == null) {
        //still fetching details
        return Center(
          child: Loading(
              indicator: BallPulseIndicator(), size: 60.0, color: Colors.blue),
        );
      } else if (submissionDetails.participatedAt == null) {
        //user never participated
        return NotParticipatedView(widget.event, onUserParticipated);
      } else {
        return ParticipatedView(widget.event, submissionDetails);
      }
    } else {
      return Center(
          child: GestureDetector(onTap: redirectLogin, child: Text("Login")));
    }
  }
}
