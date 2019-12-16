import 'package:else_app_two/firebaseUtil/database_manager.dart';
import 'package:else_app_two/models/firestore/ad_beacon_model.dart';
import 'package:else_app_two/utils/Contants.dart';
import 'package:else_app_two/utils/app_startup_data.dart';
import 'package:else_app_two/utils/sql_lite.dart';

class BeaconServiceImpl {
  Function(String) adScreenCallback;

  BeaconServiceImpl(Function(String) callback) {
    this.adScreenCallback = callback;
    if (db == null) db = DatabaseManager();
  }

  int timeBeforeMarkingNextVisit = 60000; //time is in milisecs;
  DatabaseManager db;
  SqlLiteManager sql;

  handleBeacon(String major, String minor) async {
    switch (determineBeaconType(major)) {
      case "parking":
        await postHandlingForParkingBeacons(major, minor);
        break;
      case "advtsmntInt":
        await postHandlingForAdvtsmntBeacon(major, minor);
        break;
      case "monitoring":
        await postHandlingForMinotoringBeacon(major, minor);
        break;
    }
  }

  postHandlingForMinotoringBeacon(String major, String minor) async {
    if (await wasBeaconSeenRecently(major, minor)) {
      //do not update this visit to firestore
    } else {
      await db.markUserVisitForBeacon(major, minor,"advertisement");
    }
  }

  postHandlingForParkingBeacons(String major, String minor) async {
    if(Constants.parkingEligibleUser){
      //mark his visits against all parking beacons

      //distance should also be uplaoded
      db.markUserVisitForParkingBeacon(major, minor,"parking");
    }
  }

  postHandlingForAdvtsmntBeacon(String major, String minor) async {
    //get firestore record for this beacon
    AdBeacon adBeacon = await db.getAdMetaForBeacon(major, minor);

    if (adBeacon.allowedUsers.contains(StartupData.userid)) {
      //throw notification to user
      adScreenCallback(adBeacon.imageUrl);
    }
    //check if this user has seen the beacon before or not
  }

  Future<bool> wasBeaconSeenRecently(String major, String minor) async {
    var time = await SqlLiteManager().getLastVisitForBeacon(major, minor);
    if (time != null) {
      //user has visited this beacon in past
      if (hasEnoughTimePassedPastVisit(time[0])) {
        await SqlLiteManager().updateVisitTime(major, minor);
        //more than timeBeforeMarkingNextVisit secs have passed since his last visit
        return false;
      } else {
        //less than timeBeforeMarkingNextVisit secs have passed so we do nothings
        return true;
      }
    } else {
      //user never seen this beacon, make a entry in sql and upload visit to firestore
      await SqlLiteManager().insertBeaconVisit(major, minor);
      return false;
    }
  }

  bool hasEnoughTimePassedPastVisit(time) {
    if (DateTime.now().millisecondsSinceEpoch - int.parse(time) >
        timeBeforeMarkingNextVisit) {
      return true;
    }
    return false;
  }

  String determineBeaconType(String major) {
    if (major.length == 3) {
      return "parking";
    }
    if (major[2].compareTo("2") == 0) {
      return "advtsmntInt";
    }
    if (major[0].compareTo("1") == 0) {
      return "monitoring";
    }
  }
}
