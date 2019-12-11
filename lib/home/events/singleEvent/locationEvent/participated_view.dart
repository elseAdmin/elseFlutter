import 'package:else_app_two/firebaseUtil/database_manager.dart';
import 'package:else_app_two/models/events_model.dart';
import 'package:else_app_two/models/firestore/loc_submission_model.dart';
import 'package:else_app_two/utils/SizeConfig.dart';
import 'package:else_app_two/utils/helper_methods.dart';
import 'package:flutter/material.dart';

class ParticipatedView extends StatefulWidget {
  final LocationEventSubmissionModel submissionDetails;
  final EventModel event;
  ParticipatedView(this.event, this.submissionDetails);
  @override
  createState() => ParticipatedViewState();
}

class ParticipatedViewState extends State<ParticipatedView> {
  List visitDates;
  @override
  void initState() {
    DatabaseManager().getUniqueVisitsForBeacon(widget.event).then((dates) {
      setState(() {
        visitDates = dates.toList();
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
        child: Stepper(
      steps: getSteps(),
      currentStep: _index,
      onStepTapped: (index) {
        setState(() {
          _index = index;
        });
      },
      controlsBuilder: (BuildContext context,
              {VoidCallback onStepContinue, VoidCallback onStepCancel}) =>
          Container(),
    ));
  }

  List<Step> getSteps() {
    List<String> titles = List();
    titles.add("First");
    titles.add("Second");
    titles.add("Third");
    titles.add("Fourth");
    titles.add("Fifth");
    titles.add("Sixth");
    titles.add("Seventh");
    titles.add("Eighth");
    titles.add("Nineth");

    // *** not more than nine days can be observed

    List<Step> stepList = List();
    for (int i = 0; i < widget.event.observedDays; i++) {
      if (visitDates != null && i < visitDates.length && isVisitAfterSubmission(visitDates[i])) {
        //has user completed the event?
        if (visitDates.length == widget.event.observedDays) {
          //user has completed the event
          DatabaseManager().markLocationEventCompleted(widget.event);
        }
        //visited steps
        var stateCheck = StepState.complete;
        Step step = new Step(
            title: Text(titles[i]),
            state: stateCheck,
            content: Text("You were here on " + getDateFromString(i)));
        stepList.add(step);
      } else {
        //not visited
        var stateCheck = StepState.indexed;
        Step step = new Step(
            title: Text(titles[i]),
            state: stateCheck,
            content: Text("We are yet to mark your visit"));
        stepList.add(step);
      }
    }
    return stepList;
  }
  isVisitAfterSubmission(String visitDate){
    DateTime submissionDateTime  = DateTime.fromMillisecondsSinceEpoch(widget.submissionDetails.timestamp);
    int visitMonth = int.parse(getMonthInt(visitDate));
    int visitDay = int.parse(getDayInt(visitDate));

    if(visitMonth<submissionDateTime.month){
      //visit not counted
      return false;
    }else if(visitMonth==submissionDateTime.month){
      if(visitDay<=submissionDateTime.day){
        return false;
      }
    }
    return true;

  }
  getMonthInt(String date){
    return date[2] + date[3];
  }
  getDayInt(String date){
    return date[0] + date[1];
  }
  getYearInt(String date){
    return date[4] + date[5] + date[6] + date[7];
  }
  getDateFromString(int i) {
    String date, monthName, year;
    date = getDayInt(visitDates[i]);
    String mon = getMonthInt(visitDates[i]);
    monthName = HelperMethods().getLiteralMonthForIntMonth(mon);
    year = getYearInt(visitDates[i]);

    return date + " " + monthName + " " + year;
  }
}
