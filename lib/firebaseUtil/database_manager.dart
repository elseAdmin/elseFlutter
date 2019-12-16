import 'dart:collection';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:else_app_two/models/base_model.dart';
import 'package:else_app_two/models/events_model.dart';
import 'package:else_app_two/models/firestore/ad_beacon_model.dart';
import 'package:else_app_two/models/firestore/loc_submission_model.dart';
import 'package:else_app_two/models/firestore/offline_submission_model.dart';
import 'package:else_app_two/models/firestore/online_submission_model.dart';
import 'package:else_app_two/models/firestore/user_parking_model.dart';
import 'package:else_app_two/utils/Contants.dart';
import 'package:else_app_two/utils/app_startup_data.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:logger/logger.dart';

class DatabaseManager {
  final logger = Logger();
  static Firestore store;
  DatabaseReference baseDatabase, eventDatabase, dealsDatabase;
  FirebaseStorage storageRef;
  Map<String, List> universeVsParticipatedEvents = HashMap();
  DatabaseManager() {
    if (storageRef == null) {
      storageRef = FirebaseStorage.instance;
    }
    if (store == null) {
      store = Firestore.instance;
    }
    if (baseDatabase == null) {
      baseDatabase =
          FirebaseDatabase.instance.reference().child(StartupData.dbreference);
    }
  }

  markLocationEventCompleted(EventModel event) async {
    await store
        .collection(StartupData.dbreference)
        .document("events")
        .collection(event.uid)
        .document("submissions")
        .collection("allSubmissions")
        .document(StartupData.userid)
        .updateData({
      "status": "complete",
    });
  }

  getUserParticipationForOfflineEvent(EventModel event) async {
    OfflineEventSubmissionModel model;
    await store
        .collection(StartupData.dbreference)
        .document("events")
        .collection(event.uid)
        .document("submissions")
        .collection("allSubmissions")
        .document(StartupData.userid)
        .get()
        .then((DocumentSnapshot snapshot) {
      //what if snapshot is null ?
      model = OfflineEventSubmissionModel(snapshot);
    }).catchError((error) {
      logger.i("No submissions by user for this event");
    });
    return model;
  }

  getUniqueVisitsForBeacon(EventModel event) async {
    Set uniqueDates = Set();
    List visits = await getAllVisitsForBeaconInEventTimeRange(event);
    for (var visit in visits) {
      int time = visit.data['timestamp'];
      DateTime date = DateTime.fromMillisecondsSinceEpoch(time);
      String day = date.day.toString();
      if (day.length == 1) {
        day = "0" + day;
      }
      String month = date.month.toString();
      if (month.length == 1) {
        month = "0" + month;
      }
      String year = date.year.toString();
      String key = day + month + year; // 8th dec 2019 = 08122019
      uniqueDates.add(key);
    }
    return uniqueDates;
  }

  getAllVisitsForBeaconInEventTimeRange(EventModel event) async {
    List visits;
    await store
        .collection(StartupData.dbreference)
        .document("beacons")
        .collection("advertisement")
        .document(event.beaconDataList[0].major.toString())
        .collection(event.beaconDataList[0].minor.toString())
        .document("user")
        .collection(StartupData.userid)
        .where('timestamp',
            isGreaterThanOrEqualTo: event.startDate.millisecondsSinceEpoch)
        .where('timestamp',
            isLessThanOrEqualTo: event.endDate.millisecondsSinceEpoch)
        .orderBy('timestamp')
        .getDocuments()
        .then((docs) {
      visits = docs.documents;
    }).catchError((error) {
      logger.e(error);
    });
    return visits;
  }

  getUserParticipationForLocationEvent(EventModel event) async {
    LocationEventSubmissionModel model;
    await store
        .collection(StartupData.dbreference)
        .document("events")
        .collection(event.uid)
        .document("submissions")
        .collection("allSubmissions")
        .document(StartupData.userid)
        .get()
        .then((DocumentSnapshot snapshot) {
      //what if snapshot is null ?
      model = LocationEventSubmissionModel(snapshot);
    }).catchError((error) {
      logger.i("No submissions by user for this event");
    });
    return model;
  }

  markUserVisitForBeacon(String major, String minor, String beaconType) async {
    await store
        .collection(StartupData.dbreference)
        .document("beacons")
        .collection(beaconType)
        .document(major)
        .collection(minor)
        .document("user")
        .collection(StartupData.userid)
        .add({"timestamp": DateTime.now().millisecondsSinceEpoch});
  }

  markUserVisitForParkingBeacon(
      String major, String minor, String beaconType) async {
    await store
        .collection(StartupData.dbreference)
        .document("beacons")
        .collection(beaconType)
        .document(major)
        .collection(minor)
        .add({
      "timestamp": DateTime.now().millisecondsSinceEpoch,
      "userUid": StartupData.userid
    });
  }

  Future getAdMetaForBeacon(String major, String minor) async {
    AdBeacon adBeacon;
    await store
        .collection(StartupData.dbreference)
        .document("beacons")
        .collection("advertisement")
        .document(major)
        .collection(minor)
        .document("adMeta")
        .get()
        .then((DocumentSnapshot snapshot) {
      adBeacon = AdBeacon(snapshot);
    });
    return adBeacon;
  }

  Future getLimitedApprovedSubmissionsForOnlineEvent(String eventUid) async {
    // make this call synchronous
    List<String> imageUrls = List();
    await store
        .collection(StartupData.dbreference)
        .document("events")
        .collection(eventUid)
        .document("submissions")
        .collection("allSubmissions")
        .where("status", isEqualTo: "approved")
        .orderBy("uploaded_at", descending: true)
        .limit(20)
        .getDocuments()
        .then((QuerySnapshot snapshot) {
      snapshot.documents.forEach((doc) {
        imageUrls.add(doc.data["imageUrl"]);
      });
    });
    return imageUrls;
  }

  Future getWinnerSubmissionForOnlineEvent(String eventUid) async {
    List<String> imageUrls = List();
    await store
        .collection(StartupData.dbreference)
        .document("events")
        .collection(eventUid)
        .document("submissions")
        .collection("winnerSubmission")
        .getDocuments()
        .then((QuerySnapshot snapshot) {
      snapshot.documents.forEach((doc) {
        imageUrls.add(doc.data["imageUrl"]);
      });
    });
    return imageUrls;
  }

  Future getAllApprovedSubmissionsForOnlineEvent(String eventUid) async {
    // make this call synchronous
    List<String> imageUrls = List();
    await store
        .collection(StartupData.dbreference)
        .document("events")
        .collection(eventUid)
        .document("submissions")
        .collection("allSubmissions")
        .where("status", isEqualTo: "approved")
        .orderBy("uploaded_at", descending: true)
        .getDocuments()
        .then((QuerySnapshot snapshot) {
      snapshot.documents.forEach((doc) {
        imageUrls.add(doc.data["imageUrl"]);
      });
    });
    return imageUrls;
  }

  Future getUserSubmissionForOnlineEvent(EventModel event) async {
    OnlineEventSubmissionModel submission;
    await store
        .collection(StartupData.dbreference)
        .document("events")
        .collection(event.uid)
        .document("submissions")
        .collection("allSubmissions")
        .document(StartupData.userid)
        .get()
        .then((DocumentSnapshot snapshot) {
      //what if snapshot is null ?
      submission = OnlineEventSubmissionModel(snapshot);
    }).catchError((error) {
      logger.i("No submissions by user for this event");
    });
    return submission;
  }

  markUserParticipationForOfflineEvent(EventModel event) async {
    await store
        .collection(StartupData.dbreference)
        .document("events")
        .collection(event.uid)
        .document("submissions")
        .collection("allSubmissions")
        .document(StartupData.userid)
        .setData({
      "participatedAt": DateTime.now().millisecondsSinceEpoch,
      "participationId": "123",
      "type": "offline" //generate unique id
    });

    String submissionPath = store
        .collection(StartupData.dbreference)
        .document("events")
        .collection(event.uid)
        .document("submissions")
        .collection("allSubmissions")
        .document(StartupData.userid)
        .path;

    await store
        .collection(StartupData.userReference)
        .document(StartupData.userid)
        .collection("events")
        .add({
      "universe": StartupData.dbreference,
      "eventUrl": getEventsDBRef().child(event.uid).path,
      "submissionUrl": submissionPath,
    });
    return;
  }

  Future markUserParticipationForOnlineEvent(
      EventModel event, String userId, File image) async {
    //upload image to firebase storage
    StorageReference ref = storageRef
        .ref()
        .child(StartupData.dbreference)
        .child("events")
        .child(event.uid)
        .child("submissions")
        .child(userId);
    final StorageUploadTask uploadTask = ref.putFile(
      image,
      StorageMetadata(
        contentType: "image" + '/' + "jpeg",
      ),
    );
    final StorageTaskSnapshot downloadUrl = (await uploadTask.onComplete);
    final String url = (await downloadUrl.ref.getDownloadURL());

    //upload submission details to firestore
    await store
        .collection(StartupData.dbreference)
        .document("events")
        .collection(event.uid)
        .document("submissions")
        .collection("allSubmissions")
        .document(userId)
        .setData({
      "userUid": userId,
      "status": Constants.pendingStatusMessage,
      "imageUrl": url,
      "uploaded_at": DateTime.now(),
      "likes": 0,
      "type": "online",
      "participatedAt": DateTime.now().millisecondsSinceEpoch
    });

    //upload submission and event details to user data.
    String pathToUserSubmission = store
        .collection(StartupData.dbreference)
        .document("events")
        .collection(event.uid)
        .document("submissions")
        .collection("allSubmissions")
        .document(userId)
        .path;

    await store
        .collection(StartupData.userReference)
        .document(userId)
        .collection("events")
        .add({
      "universe": StartupData.dbreference,
      "eventUrl": getEventsDBRef().child(event.uid).path,
      "submissionUrl": pathToUserSubmission,
    });

    logger.i("Event submission details saved successfully");
    return "Submission upload sucess";
  }

  Future markUserParticipationForLocationEvent(EventModel event) async {
    await store
        .collection(StartupData.dbreference)
        .document("events")
        .collection(event.uid)
        .document("submissions")
        .collection("allSubmissions")
        .document(StartupData.userid)
        .setData({
      "participatedAt": DateTime.now().millisecondsSinceEpoch,
      "date": DateTime.now(),
      "status": "incomplete",
      "type": "location"
    });

    String submissionPath = store
        .collection(StartupData.dbreference)
        .document("events")
        .collection(event.uid)
        .document("submissions")
        .collection("allSubmissions")
        .document(StartupData.userid)
        .path;

    await store
        .collection(StartupData.userReference)
        .document(StartupData.userid)
        .collection("events")
        .add({
      "universe": StartupData.dbreference,
      "eventUrl": getEventsDBRef().child(event.uid).path,
      "submissionUrl": submissionPath,
    });

    return;
  }

  Future getAllEventsForUser() async {
    List<Map<String, String>> allEventAndSubmissionUrls = List();

    await store
        .collection(StartupData.userReference)
        .document(StartupData.userid)
        .collection("events")
        .getDocuments()
        .then((snapshot) {
      List<DocumentSnapshot> allEventsOfUser = snapshot.documents;
      for (var event in allEventsOfUser) {
        Map<String, String> eventDetails = HashMap();
        eventDetails.putIfAbsent(
            "submissionUrl", () => event.data['submissionUrl']);
        eventDetails.putIfAbsent("eventUrl", () => event.data['eventUrl']);
        allEventAndSubmissionUrls.add(eventDetails);
      }
    });

    List<Map<String, BaseModel>> listParticipatedEvents = List();

    for (int i = 0; i < allEventAndSubmissionUrls.length; i++) {
      Map<String, BaseModel> returnData = HashMap();
      Map event = allEventAndSubmissionUrls[i];
      String eUrl = event["eventUrl"];
      String sUrl = event["submissionUrl"];
      logger.i("start " + DateTime.now().millisecondsSinceEpoch.toString());
      await FirebaseDatabase.instance
          .reference()
          .child(eUrl)
          .once()
          .then((receivedEvents) {
        EventModel event = EventModel(receivedEvents);
        returnData.putIfAbsent("eventDetails", () => event);
      }).catchError((error) {
        logger.e(error);
      });

      await store.document(sUrl).get().then((snap) {
        if (snap.data['type'] == 'online') {
          OnlineEventSubmissionModel submission =
              OnlineEventSubmissionModel(snap);
          returnData.putIfAbsent("submissionDetails", () => submission);
        }
        if (snap.data['type'] == 'offline') {
          OfflineEventSubmissionModel submission =
              OfflineEventSubmissionModel(snap);
          returnData.putIfAbsent("submissionDetails", () => submission);
        }
        if (snap.data['type'] == 'location') {
          LocationEventSubmissionModel submission =
              LocationEventSubmissionModel(snap);
          returnData.putIfAbsent("submissionDetails", () => submission);
        }
      });

      listParticipatedEvents.add(returnData);
    }
    logger.i("end " + DateTime.now().millisecondsSinceEpoch.toString());
    return listParticipatedEvents;
  }

  DatabaseReference getEventsDBRef() {
    return baseDatabase.child('eventStaticData');
  }

  DatabaseReference getDealsDBRef() {
    return baseDatabase.child('dealsStaticData');
  }

  DatabaseReference getBaseDBRef() {
    return baseDatabase;
  }

  Firestore getStoreReference() {
    return store;
  }

  FirebaseStorage getStorageReference() {
    return storageRef;
  }

  getUserParkingReference() async {
    ParkingModel parkingModel ;
    await store.collection('users').document(StartupData.userid).collection('parking').where('status',isEqualTo: 'active').getDocuments().then((querySnapshot){
      querySnapshot.documents.forEach((docSnap){
        parkingModel =  ParkingModel(docSnap);
      });
    });
    return parkingModel;
  }
}
