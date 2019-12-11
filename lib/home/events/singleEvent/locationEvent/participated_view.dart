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

    //not more than nine days can be observed

    List<Step> stepList = List();
    for (int i = 0; i < widget.event.observedDays; i++) {
      var stateCheck;
      if (visitDates != null && i < visitDates.length) {
        //visited steps
        stateCheck = StepState.complete;
        Step step = new Step(
            title: Text(titles[i]),
            state: stateCheck,
            content: Text("You were here on " + getDateFromString(i)));
        stepList.add(step);
      } else {
        //not visited 
        stateCheck = StepState.indexed;
        Step step = new Step(
            title: Text(titles[i]),
            state: stateCheck,
            content: Text("We are yet to mark your visit"));
        stepList.add(step);
      }
    }
    return stepList;
  }

  getDateFromString(int i) {
    String stringDate = visitDates[i];
    String date, monthName, year;

    date = stringDate[0] + stringDate[1];
    String mon = stringDate[2] + stringDate[3];
    monthName = HelperMethods().getLiteralMonthForIntMonth(mon);
    year = stringDate[4] + stringDate[5] + stringDate[6] + stringDate[7];

    return date + " " + monthName + " " + year;
  }
}
