import 'package:else_app_two/models/events_model.dart';
import 'package:else_app_two/navigationBarScreens/homeScreen/events/singleEvent/locationEvent/location_event_screen.dart';
import 'package:else_app_two/navigationBarScreens/homeScreen/events/singleEvent/offline_event_screen.dart';
import 'package:else_app_two/navigationBarScreens/homeScreen/events/singleEvent/onlineEvent/online_event_screen.dart';
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