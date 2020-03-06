import 'dart:collection';
import 'dart:math';
import 'package:else_app_two/beaconAds/models/ad_beacon_model.dart';
import 'package:else_app_two/firebaseUtil/database_manager.dart';
import 'package:else_app_two/utils/Contants.dart';
import 'package:else_app_two/utils/app_startup_data.dart';
import 'package:else_app_two/utils/sql_lite.dart';
import 'package:logger/logger.dart';
import 'package:synchronized/synchronized.dart';

class BeaconServiceImpl {
  final logger = Logger();
  Function(AdBeacon) adScreenCallback;
  Map<String, int> visitMap = HashMap();
  Map<String, AdBeacon> adMap = HashMap();
  BeaconServiceImpl(Function(AdBeacon) callback) {
    this.adScreenCallback = callback;
    if (db == null) db = DatabaseManager();
  }

  // TODO @Suhail Check calls of this call and initialization
  static Function(int) sectionCallback;
  BeaconServiceImpl.parkingConstructor(Function(int) callback) {
    sectionCallback = callback;
  }
  int previousSection = -100;

  var lock = new Lock();
  int timeBeforeMarkingNextVisit = 120000; //time is in milisecs;
  DatabaseManager db;
  SqlLiteManager sql;

  handleBeacon(String major, String minor, String rssi) async {
    switch (determineBeaconType(major)) {
      case "parking":
        await postHandlingForParkingBeacons(major, minor, rssi);
        break;
      case "advtsmntInt":
        await postHandlingForAdvtsmntBeacon(major, minor);
        break;
      case "monitoring":
        await postHandlingForMonitoringBeacon(major, minor);
        break;
      case "advtsmntExt":
        break;
      case "none":
        break;
    }
  }

  postHandlingForMonitoringBeacon(String major, String minor) async {
    await wasBeaconSeenRecently(major, minor);
  }

  wasBeaconSeenRecently(String major, String minor) async {
    String key = major + minor;
    int lastVisitTime;

    if (!visitMap.containsKey(key)) {
      lastVisitTime = DateTime.now().millisecondsSinceEpoch;
      await db.markUserVisitForMonitoringBeacon(major, minor);
      visitMap.putIfAbsent(key, () => lastVisitTime);
    } else {
      lastVisitTime = visitMap[key];
      if (hasEnoughTimePassedPastVisit(lastVisitTime)) {
        visitMap.update(key, (v) => DateTime.now().millisecondsSinceEpoch,
            ifAbsent: () => DateTime.now().millisecondsSinceEpoch);
        await db.markUserVisitForMonitoringBeacon(major, minor);
      }
    }

  }

  bool hasEnoughTimePassedPastVisit(time) {
    if (DateTime.now().millisecondsSinceEpoch - time >
        timeBeforeMarkingNextVisit) {
      return true;
    }
    return false;
  }

  bool parkingBeaconTimePassVisit(time) {
    if (DateTime.now().millisecondsSinceEpoch - time >
        StartupData.parkingBeaconIntervalInMillis) {
      return true;
    }
    return false;
  }

  postHandlingForParkingBeacons(String major, String minor, String rssi) async {
    Constants.inRangeForParking = true;
    if (Constants.parkingEligibleUser) {
      bool parkingBeaconCheck = true;
      if (Constants.beaconTimeStampMap.containsKey(major + minor)) {
        int previousTimeStamp = Constants.beaconTimeStampMap[major + minor];
        if (!parkingBeaconTimePassVisit(previousTimeStamp)) {
          parkingBeaconCheck = false;
        }
      }
      if (parkingBeaconCheck) {
        db.markUserVisitForParkingBeacon(major, minor, rssi);
        Constants.beaconTimeStampMap[major + minor] =
            DateTime.now().millisecondsSinceEpoch;
      }

      Constants.parkingLevel = int.parse(major[0]);
      // TODO @Suhail add callback here on the basis of logic
      if (sectionCallback != null &&
          hasSectionChanged(int.parse(major[1] + major[2]))) {
        sectionCallback(Constants.section);
      }
    }
  }

  hasSectionChanged(int newSectionValue) {
    if (previousSection == -100) {
      previousSection = newSectionValue;
      Constants.section = newSectionValue;
      return true;
    }
    if (previousSection != newSectionValue) {
      previousSection = newSectionValue;
      return false;
    } else {
      previousSection = newSectionValue;
      Constants.section = newSectionValue;
      return true;
    }
  }

  postHandlingForAdvtsmntBeacon(String major, String minor) async {
    String key = major + minor;
    bool adShown = false;
    await lock.synchronized(() async {
      if (!adMap.containsKey(key)) {
        AdBeacon adBeacon = await db.getAdMetaForBeacon(major, minor);
        adBeacon.major = major;
        adBeacon.minor = minor;
        adMap.putIfAbsent(key, () => adBeacon);
        if (adBeacon.isUserAllowed() &&
            !await db.hasUserSeenAdBefore(major, minor)) {
          //throw notification to user
          if (!adShown) {
            adShown = true;
            adScreenCallback(adBeacon);
          }
        }
      }
    });
  }

  String determineBeaconType(String major) {
    if (major.length == 3) {
      return "parking";
    }
    if (major[0].compareTo("2") == 0) {
      return "advtsmntInt";
    }
    if (major[0].compareTo("1") == 0) {
      return "monitoring";
    }
    if (major[0].compareTo("3") == 0) {
      return "advtsmntExt";
    }
    return "none";
  }

/*
  Future<bool> wasBeaconSeenRecentlySQLiteVersion(String major, String minor) async {
    Map row = await SqlLiteManager().getLastVisitForBeacon(major, minor);
    if (row != null) {
      //user has visited this beacon in past
      if (hasEnoughTimePassedPastVisit(row['time'])) {
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
 */
}
