
import 'package:else_app_two/home/events/singleEvent/SingleEventPageViewHandler.dart';
import 'package:else_app_two/models/base_model.dart';
import 'package:else_app_two/home/events/models/events_model.dart';
import 'package:else_app_two/home/events/models/loc_submission_model.dart';
import 'package:else_app_two/home/events/models/offline_submission_model.dart';
import 'package:else_app_two/home/events/models/online_submission_model.dart';
import 'package:else_app_two/utils/SizeConfig.dart';
import 'package:else_app_two/utils/helper_methods.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class MyEventCard extends StatelessWidget {
  final Map<String, BaseModel> details;
  MyEventCard(this.details);
  final logger = Logger();
  @override
  Widget build(BuildContext context) {

    EventModel eventDetails = details['eventDetails'];
    String displayDate = getDisplayDateForParticipatedAt(eventDetails);
    return Container(
      color:Colors.grey[200],
        //color: Colors.cyan,
        child: Column(
          children: <Widget>[
        Container(

        padding:EdgeInsets.only(top: SizeConfig.blockSizeVertical,left: SizeConfig.blockSizeHorizontal*2,right: SizeConfig.blockSizeHorizontal*5,bottom: SizeConfig.blockSizeHorizontal),
      child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[Text(eventDetails.name,style: TextStyle(fontSize: 19),)],
            )),
            Container(
              padding:EdgeInsets.only(top:SizeConfig.blockSizeHorizontal*2,left: SizeConfig.blockSizeHorizontal*5,right: SizeConfig.blockSizeHorizontal*5),
                child:Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[Text("Status",style: TextStyle(fontSize: 15),),
                Text(getEventStatus(eventDetails.endDate))],
            )),
            Container(
                padding:EdgeInsets.only(left: SizeConfig.blockSizeHorizontal*5,right: SizeConfig.blockSizeHorizontal*5),
                child:Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[Text("Participated"),
               Text(displayDate)],
            )),
            Container(
                padding:EdgeInsets.only(bottom:SizeConfig.blockSizeHorizontal,top:SizeConfig.blockSizeHorizontal*2,left: SizeConfig.blockSizeHorizontal*5,right: SizeConfig.blockSizeHorizontal*2),
                child:Row(
             mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[GestureDetector(
                  onTap: () => _redirectToSingleEventPage(context,eventDetails),
                  child:Text("more details",style: TextStyle(fontWeight: FontWeight.bold),))],
            )),
            Container(
                color: Colors.white,
                height: SizeConfig.blockSizeVertical,
            width:SizeConfig.blockSizeHorizontal*100)
          ],
        ));
  }

  _redirectToSingleEventPage(BuildContext context, EventModel eventDetails) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) =>
                SingleEventPageViewHandler()
                    .getViewAccordingToEventType(
                    eventDetails)));
  }

  String getEventStatus(DateTime endDate) {
    if(endDate.isBefore(DateTime.now())){
      return "Expired";
    }else{
      return "Ongoing";
    }
  }

  String getDisplayDateForParticipatedAt(EventModel eventDetails){
    String displayDate;
    DateTime participatedAt;
    if(eventDetails.type.compareTo('Online')==0){
      OnlineEventSubmissionModel submissionDetail = details['submissionDetails'];
      participatedAt=submissionDetail.participatedAt;
      displayDate = participatedAt.day.toString() + " "+HelperMethods().getMonthNameForMonth(participatedAt.month.toString()) +" "+participatedAt.year.toString();
    }
    if(eventDetails.type.compareTo('Offline')==0){
      OfflineEventSubmissionModel submissionDetail = details['submissionDetails'];
      participatedAt=submissionDetail.participatedAt;
      displayDate = participatedAt.day.toString() + " "+HelperMethods().getMonthNameForMonth(participatedAt.month.toString()) +" "+participatedAt.year.toString();
    }
    if(eventDetails.type.compareTo('Location')==0){
      LocationEventSubmissionModel submissionDetail = details['submissionDetails'];
      participatedAt=submissionDetail.participatedAt;
      displayDate = participatedAt.day.toString() + " "+HelperMethods().getMonthNameForMonth(participatedAt.month.toString()) +" "+participatedAt.year.toString();
    }
    return displayDate;
  }

}
