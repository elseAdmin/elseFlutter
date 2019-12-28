import 'package:else_app_two/home/events/singleEvent/locationEvent/main_view.dart';
import 'package:else_app_two/home/events/singleEvent/offlineEvent/main_view.dart';
import 'package:else_app_two/home/events/models/events_model.dart';
import 'package:else_app_two/home/events/singleEvent/onlineEvent/online_event_screen.dart';
import 'package:flutter/material.dart';

class SingleEventPageViewHandler {
 Widget getViewAccordingToEventType(EventModel event){
   switch(event.type){
     case "Offline":
       return new OfflineEventScreen(event);
       break;
     case "Online":
       return new OnlineEventScreen(event);
       break;
     case "Location":
       return new LocationEventScreen(event);
       break;
   }
 }
}