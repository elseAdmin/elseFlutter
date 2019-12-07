import 'package:else_app_two/firebaseUtil/database_manager.dart';
import 'package:else_app_two/utils/sql_lite.dart';
import 'package:flutter/material.dart';

class BeaconServiceImpl {
  int timeBeforeMarkingNextVisit = 60;
  DatabaseManager db;
  SqlLiteManager sql;
  BeaconServiceImpl() {
    if (db == null) db = DatabaseManager();
  }
  void handleBeacon(String major, String minor) {
    switch(determineBeaconType(major)){
      case "parking":
        postHandlingForParkingBeacons(major,minor);
        break;
      case "advtsmntInt":
        postHandlingForAdvtsmntBeacon(major,minor);
    }

  }

  String determineBeaconType(String major) {
    if(major.length==3){
      return "parking";
    }
    if(major[0].compareTo("1")==0){
      return "advtsmntInt";
    }
  }

  void postHandlingForParkingBeacons(String major, String minor) {
    if(wasBeaconSeenRecently(major,minor)) {
      //do not update visits to firestore
    }else{
      db.markUserVisitForBeacon(major, minor);
    }
  }

  void postHandlingForAdvtsmntBeacon(String major, String minor) {


  }

  bool wasBeaconSeenRecently(String major, String minor) {
   var time =  SqlLiteManager().getLastVisitForBeacon(major, minor);
     if(time!=null){
       //user has visited this beacon in past
       if(hasEnoughtTimePassedPastVisit(time[0])){
         SqlLiteManager().updateVisitTime(major, minor);
         //more than timeBeforeMarkingNextVisit secs have passed since his last visit
         return false;
       }else{
         //less than timeBeforeMarkingNextVisit secs have passed so we do nothings
         return true;
       }

     }else{
       //user never seen this beacon, make a entry in sql and upload visit to firestore
       SqlLiteManager().insertBeaconVisit(major, minor);
       return false;
     }
  }

  bool hasEnoughtTimePassedPastVisit(time) {
    if(DateTime.now().millisecondsSinceEpoch - int.parse(time) > timeBeforeMarkingNextVisit){
      return true;
    }
    return false;
  }
}
