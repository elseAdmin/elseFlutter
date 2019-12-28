import 'dart:collection';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:else_app_two/beaconAds/models/ad_beacon_model.dart';
import 'package:else_app_two/beaconAds/models/user_deal_model.dart';
import 'package:else_app_two/home/events/models/user_event_submission_model.dart';
import 'package:else_app_two/models/base_model.dart';
import 'package:else_app_two/home/events/models/events_model.dart';
import 'package:else_app_two/feedback/models/feedback_model.dart';
import 'package:else_app_two/home/events/models/loc_submission_model.dart';
import 'package:else_app_two/home/events/models/offline_submission_model.dart';
import 'package:else_app_two/home/events/models/online_submission_model.dart';
import 'package:else_app_two/parkingTab/models/user_parking_model.dart';
import 'package:else_app_two/requests/models/user_request_model.dart';
import 'package:else_app_two/feedback/models/user_feedback_model.dart';
import 'package:else_app_two/utils/Contants.dart';
import 'package:else_app_two/utils/app_startup_data.dart';
import 'package:else_app_two/utils/helper_methods.dart';
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

  getAllActivityOfUser() async {
    ///IMP
    //below querries should fetch max 1 month data
    List<ParkingModel> parkingActivityList =
        await DatabaseManager().getAllParkings();
    List<UserDealModel> userDealsActivityList =
        await DatabaseManager().getGrabbedDeals();
    List<UserEventSubmissionModel> allEventAndSubmissionList =
        await DatabaseManager().getAllEventActivityForUser();
    List<UserRequestModal> requestList =
        await DatabaseManager().getRequestsForUser();
    List<UserFeedBack> feedbackList =
        await DatabaseManager().getAllFeedbacksForUser();

    Map map = HashMap();
    List timestamps = List();
    parkingActivityList.forEach((parking) {
      map.putIfAbsent(parking.timestamp, () => parking);
      timestamps.add(parking.timestamp);
    });
    userDealsActivityList.forEach((deal) {
      map.putIfAbsent(deal.timestamp, () => deal);
      timestamps.add(deal.timestamp);
    });
    allEventAndSubmissionList.forEach((event) {
      map.putIfAbsent(event.timestamp, () => event);
      timestamps.add(event.timestamp);
    });
    requestList.forEach((request) {
      map.putIfAbsent(request.timestamp, () => request);
      timestamps.add(request.timestamp);
    });
    feedbackList.forEach((feedback) {
      map.putIfAbsent(feedback.timestamp, () => feedback);
      timestamps.add(feedback.timestamp);
    });

    timestamps.sort();

    List todaysActivities = List();
    List thisWeekActivities = List();
    List thisMonthActivities = List();
    HelperMethods helper = HelperMethods();
    for (int i = timestamps.length - 1; i >= 0; i--) {
      if(helper.isTimestampForToday(timestamps[i])){
        todaysActivities.add(map[timestamps[i]]);
      }else if(helper.isTimestampForThisWeek(timestamps[i])){
        thisWeekActivities.add(map[timestamps[i]]);
      }else{
        thisMonthActivities.add(map[timestamps[i]]);
      }

    }

    Map activityTimelineMap = HashMap();
    activityTimelineMap.putIfAbsent("today",() => todaysActivities);
    activityTimelineMap.putIfAbsent("week",() => thisWeekActivities);
    activityTimelineMap.putIfAbsent("month",() => thisMonthActivities);

    return activityTimelineMap;
  }

  getUserFeedbackDetails(String path) async {
    FeedBack feedBack;
    logger.i(path);
    await store.document(path).get().then((doc) {
      feedBack = FeedBack.fromMap(doc.data, doc.documentID);
    });
    return feedBack;
  }

  Future getAllFeedbacksForUser() async {
    List<UserFeedBack> feedbacks = List();
    await store
        .collection(StartupData.userReference)
        // VERY IMP , remove hard coded user
        .document("3myGjUrtkOW0lwwjnMLIj7UUWKW2")
        .collection("feedbacks")
        .getDocuments()
        .then((docs) {
      docs.documents.forEach((doc) {
        UserFeedBack request = UserFeedBack.fromMap(doc.data);
        feedbacks.add(request);
      });
    });
    return feedbacks;
  }

  markDealSeenForUser(AdBeacon beacon, String status) async {
    if (status.compareTo("grab") == 0) {
      await store
          .collection(StartupData.userReference)
          .document(StartupData.userid)
          .collection("deals")
          .add({
        "imageUrl": beacon.imageUrl,
        "timestamp": DateTime.now().millisecondsSinceEpoch,
        "universe": Constants.universe
      });

      await store
          .collection(StartupData.dbreference)
          .document("beacons")
          .collection("advertisement")
          .document(beacon.major)
          .collection(beacon.minor)
          .document("user")
          .collection(StartupData.userid)
          .add({
        "status": "grab",
        "timestamp": DateTime.now().millisecondsSinceEpoch
      }).catchError((error) {
        logger.e(error);
      });
    } else {
      await store
          .collection(StartupData.dbreference)
          .document("beacons")
          .collection("advertisement")
          .document(beacon.major)
          .collection(beacon.minor)
          .document("user")
          .collection(StartupData.userid)
          .add({
        "status": "pass",
        "timestamp": DateTime.now().millisecondsSinceEpoch
      }).catchError((error) {
        logger.e(error);
      });
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
        .orderBy('timestamp', descending: true)
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

  markUserVisitForMonitoringBeacon(String major, String minor) async {
    await store
        .collection(StartupData.dbreference)
        .document("beacons")
        .collection("monitoring")
        .document(major)
        .collection(minor)
        .document("user")
        .collection(StartupData.userid)
        .add({"timestamp": DateTime.now().millisecondsSinceEpoch});
  }

  markUserVisitForParkingBeacon(
      String major, String minor, String distance) async {
    logger.i(distance);
    logger.i(double.parse(distance));
    await store
        .collection(StartupData.dbreference)
        .document("beacons")
        .collection("parking")
        .document(major)
        .collection(minor)
        .add({
      "timestamp": DateTime.now().millisecondsSinceEpoch,
      "userUid": StartupData.userid,
      "distance": double.parse(distance)
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
      "eventName": event.name,
      "timestamp": DateTime.now().millisecondsSinceEpoch
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
      "eventName": event.name,
      "participatedAt": DateTime.now().millisecondsSinceEpoch
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
      "eventName": event.name,
      "participatedAt": DateTime.now().millisecondsSinceEpoch
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

  Future getActiveParking() async {
    ParkingModel parkingModel;
    await store
        .collection('users')
        .document(StartupData.userid)
        .collection('parking')
        .where('status', isEqualTo: 'active')
        .getDocuments()
        .then((querySnapshot) {
      querySnapshot.documents.forEach((docSnap) {
        parkingModel = ParkingModel(docSnap);
      });
    });

    if (parkingModel != null) {
      Constants.parkingEligibleUser = false;
    } else {
      parkingModel = ParkingModel(null);
    }

    return parkingModel;
  }

  Future getAllParkings() async {
    List<ParkingModel> allParkingData = List();
    await store
        .collection('users')
        .document(StartupData.userid)
        .collection('parking')
        .getDocuments()
        .then((querySnapshot) {
      querySnapshot.documents.forEach((docSnap) {
        ParkingModel parkingModel = ParkingModel(docSnap);
        if (parkingModel.major != null) {
          allParkingData.add(parkingModel);
        }
      });
    }).catchError((error) {
      logger.e(error);
    });
    return allParkingData;
  }

  Future getGrabbedDeals() async {
    List<UserDealModel> userDeals = List();
    await store
        .collection('users')
        .document(StartupData.userid)
        .collection('deals')
        .getDocuments()
        .then((querySnapshot) {
      querySnapshot.documents.forEach((docSnap) {
        UserDealModel deal = UserDealModel(docSnap);
        if (deal.imageUrl != null) {
          userDeals.add(deal);
        }
      });
    }).catchError((error) {
      logger.e(error);
    });
    return userDeals;
  }

  getLastestVisitForMonitoringBeacon(String major, String minor) async {
    int time = 0;
    await store
        .collection(StartupData.dbreference)
        .document("beacons")
        .collection("monitoring")
        .document(major)
        .collection(minor)
        .document("user")
        .collection(StartupData.userid)
        .orderBy("timestamp", descending: true)
        .limit(1)
        .getDocuments()
        .then((QuerySnapshot snapshot) {
      snapshot.documents.forEach((doc) {
        time = doc.data['timestamp'];
      });
    }).catchError((error) {
      time = 0;
    });
    return time;
  }

  Future<bool> hasUserSeenAdBefore(String major, String minor) async {
    bool seen = false;
    await store
        .collection(StartupData.dbreference)
        .document("beacons")
        .collection("advertisement")
        .document(major)
        .collection(minor)
        .document("user")
        .collection(StartupData.userid)
        .getDocuments()
        .then((QuerySnapshot snapshot) {
      snapshot.documents.forEach((doc) {
        seen = true;
      });
    }).catchError((error) {
      seen = false;
    });
    return seen;
  }

  saveUserRequest(String requestPath) async {
    await store
        .collection(StartupData.userReference)
        .document(StartupData.userid)
        .collection("requests")
        .add({
      "requestUrl": requestPath,
      "timestamp": DateTime.now().millisecondsSinceEpoch,
      "universe": Constants.universe
    });
  }

  Future getRequestsForUser() async {
    List<UserRequestModal> requests = List();
    await store
        .collection(StartupData.userReference)
        .document(StartupData.userid)
        .collection("requests")
        .getDocuments()
        .then((docs) {
      docs.documents.forEach((doc) {
        UserRequestModal request = UserRequestModal(doc);
        requests.add(request);
      });
    });
    return requests;
  }

  Future getAllEventActivityForUser() async {
    List<UserEventSubmissionModel> allEventAndSubmissionUrls = List();

    await store
        .collection(StartupData.userReference)
        .document(StartupData.userid)
        .collection("events")
        .getDocuments()
        .then((snapshot) {
      snapshot.documents.forEach((doc) {
        UserEventSubmissionModel model = UserEventSubmissionModel(doc);
        allEventAndSubmissionUrls.add(model);
      });
    });

    return allEventAndSubmissionUrls;
  }

  DatabaseReference getEventsDBRef() {
    return baseDatabase.child('eventStaticData');
  }

  DatabaseReference getDealsDBRef() {
    return baseDatabase.child('dealsStaticData');
  }

  DatabaseReference getShopsDBRef() {
    return baseDatabase.child('shopStaticData');
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
}
