import 'package:else_app_two/firebaseUtil/database_manager.dart';
import 'package:else_app_two/home/events/models/events_model.dart';
import 'package:else_app_two/home/events/models/user_event_submission_model.dart';
import 'package:else_app_two/home/events/singleEvent/SingleEventPageViewHandler.dart';
import 'package:else_app_two/utils/SizeConfig.dart';
import 'package:flutter/material.dart';

class EventActivity extends StatelessWidget {
  final UserEventSubmissionModel event;
  EventActivity(this.event);
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
        padding: EdgeInsets.only(
            top: SizeConfig.blockSizeVertical * 1,
            left: SizeConfig.blockSizeHorizontal),
        child: GestureDetector(
            onTap: () => _redirectToSingleEventPage(context, event.eventUrl),
            child: Text("You have participated in " + event.eventName)));
  }

  _redirectToSingleEventPage(BuildContext context, String eventUrl) async {
    ///could delay screen transition
    EventModel eventDetails =
        await DatabaseManager().getEventModelFromEventUrl(eventUrl);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => SingleEventPageViewHandler()
                .getViewAccordingToEventType(eventDetails)));
  }
}
