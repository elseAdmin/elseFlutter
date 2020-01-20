import 'dart:collection';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:else_app_two/auth/models/user_crud_model.dart';
import 'package:else_app_two/auth/models/user_model.dart';
import 'package:else_app_two/beaconAds/models/ad_beacon_model.dart';
import 'package:else_app_two/beaconAds/models/user_deal_model.dart';
import 'package:else_app_two/firebaseUtil/api.dart';
import 'package:else_app_two/firebaseUtil/firebase_api.dart';
import 'package:else_app_two/home/deals/models/deals_model.dart';
import 'package:else_app_two/home/events/models/user_event_submission_model.dart';
import 'package:else_app_two/models/base_model.dart';
import 'package:else_app_two/home/events/models/events_model.dart';
import 'package:else_app_two/feedback/models/feedback_model.dart';
import 'package:else_app_two/home/events/models/loc_submission_model.dart';
import 'package:else_app_two/home/events/models/offline_submission_model.dart';
import 'package:else_app_two/home/events/models/online_submission_model.dart';
import 'package:else_app_two/navigationTab/models/shop_model.dart';
import 'package:else_app_two/parkingTab/models/user_parking_model.dart';
import 'package:else_app_two/requests/models/user_request_model.dart';
import 'package:else_app_two/feedback/models/user_feedback_model.dart';
import 'package:else_app_two/utils/Contants.dart';
import 'package:else_app_two/utils/app_startup_data.dart';
import 'package:else_app_two/utils/helper_methods.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:logger/logger.dart';

class DatabaseManager {
  final logger = Logger();
  static Firestore store;
  DatabaseReference baseDatabase, eventDatabase, dealsDatabase;

  FirebaseStorage storageRef;
  Map<String, List> universeVsParticipatedEvents = HashMap();
  static Map activityTimelineMap;
  static List<EventModel> events;
  static List<Map<String, BaseModel>> myEvents;

  static List<DealModel> deals;
  static HashMap<String, Set<ShopModel>> indexShopMap;
  static Function(List<EventModel>) eventsFound;
  static Function(List<DealModel>) dealsFound;
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

  /// startup data methods  - start

  Future initialiseCurrentUser() async {
    final UserCrudModel userProvider = UserCrudModel('users', new Api('users'));
    final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
    final FirebaseUser firebaseUser = await _firebaseAuth.currentUser();
    User user;
    if (firebaseUser != null && firebaseUser.uid != null) {
      user = await userProvider.getUserById(firebaseUser.uid);
    }
    StartupData.user = user;
    return user;
  }

  getAllShops(bool refresh, FireBaseApi fireBaseApi) async {
    if (indexShopMap == null || refresh) {
      indexShopMap = HashMap();
      var results = await fireBaseApi.getDataSnapshot();
      List shopsKey = results.value.keys.toList();
      Map<dynamic, dynamic> values = results.value;

      for (String shop in shopsKey) {
        Set<ShopModel> shopModelList = new Set();
        ShopModel shopModel = ShopModel.fromMap(values[shop]);
        shopModelList.add(shopModel);
        indexShopMap[shop] = shopModelList;
        for (String category in shopModel.category) {
          Set<ShopModel> shopModelsCategory = indexShopMap[category];
          if (shopModelsCategory == null) {
            shopModelsCategory = new Set();
          }
          shopModelsCategory.add(shopModel);
          indexShopMap[category] = shopModelsCategory;
        }
      }
      return indexShopMap;
    } else {
      return indexShopMap;
    }
  }

  getAllActiveDeals(bool refresh) async {
    if (deals == null || refresh) {
      await getDealsDBRef()
          .orderByChild('status')
          .equalTo('active')
          .once()
          .then((snapshot) {
        if (snapshot.value.length != 0) {
          deals = List();
          for (int i = 1; i < snapshot.value.length; i++) {
            if (snapshot.value[i] != null) {
              DealModel deal = DealModel.fromMap(snapshot.value[i]);
              deals.add(deal);
            }
          }
        }
      });
      if (dealsFound != null) {
        dealsFound(deals);
      }
      return deals;
    } else {
      return deals;
    }
  }

  getAllActiveEvents(bool refresh) async {
    if (events == null || refresh) {
      await getEventsDBRef()
          .orderByChild('status')
          .equalTo('active')
          .once()
          .then((snapshot) {
        if (snapshot.value.length != 0) {
          events = List();
          //print(snapshot.value);
          snapshot.value.forEach((key, value) {
            EventModel event = EventModel.fromMap(value);
            events.add(event);
          });
        }
      }).catchError((error) {
        logger.i(error);
      });
      if (eventsFound != null) {
        eventsFound(events);
      }
      return events;
    } else {
      return events;
    }
  }

  getMyEvents(bool refresh) async {
    if (myEvents == null || refresh) {
      myEvents = List();
    }
  }

  getMyFeedbacks(bool refresh) async {}

  getAllActivityOfUser(bool refresh) async {
    ///IMP
    //below queries should fetch max 1 month data
    if (activityTimelineMap == null || refresh) {
      activityTimelineMap = HashMap();
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
        if (parking.timestamp != null) {
          timestamps.add(parking.timestamp);
        } else {
          logger.i(parking);
        }
      });
      userDealsActivityList.forEach((deal) {
        map.putIfAbsent(deal.timestamp, () => deal);
        if (deal.timestamp != null) {
          timestamps.add(deal.timestamp);
        } else {
          logger.i(deal);
        }
      });
      allEventAndSubmissionList.forEach((event) {
        map.putIfAbsent(event.timestamp, () => event);
        if (event.timestamp != null) {
          timestamps.add(event.timestamp);
        } else {
          logger.i(event);
        }
      });
      requestList.forEach((request) {
        map.putIfAbsent(request.timestamp, () => request);
        if (request.timestamp != null) {
          timestamps.add(request.timestamp);
        } else {
          logger.i(request);
        }
      });
      feedbackList.forEach((feedback) {
        map.putIfAbsent(feedback.timestamp, () => feedback);
        if (feedback.timestamp != null) {
          timestamps.add(feedback.timestamp);
        } else {
          logger.i(feedback);
        }
      });

      timestamps.sort();

      List todaysActivities = List();
      List thisWeekActivities = List();
      List thisMonthActivities = List();
      HelperMethods helper = HelperMethods();
      for (int i = timestamps.length - 1; i >= 0; i--) {
        if (helper.isTimestampForToday(timestamps[i])) {
          todaysActivities.add(map[timestamps[i]]);
        } else if (helper.isTimestampForThisWeek(timestamps[i])) {
          thisWeekActivities.add(map[timestamps[i]]);
        } else {
          thisMonthActivities.add(map[timestamps[i]]);
        }
      }

      activityTimelineMap.putIfAbsent("today", () => todaysActivities);
      activityTimelineMap.putIfAbsent("week", () => thisWeekActivities);
      activityTimelineMap.putIfAbsent("month", () => thisMonthActivities);

      return activityTimelineMap;
    } else {
      return activityTimelineMap;
    }
  }

  /// startup data methods  - end

  getUserSpecificDealsForShop(
      String shopUid, Function(List<AdBeacon>) dealsFound) async {
    List<AdBeacon> adDeals = List();
    await store
        .collection(StartupData.userReference)
        .document(StartupData.user.id)
        .collection("deals")
        .where('shopUid', isEqualTo: shopUid)
        .getDocuments()
        .then((snapshot) => {
              snapshot.documents.forEach((doc) => {adDeals.add(AdBeacon(doc))})
            });
    return dealsFound(adDeals);
  }

  saveUserRatingForStore(String storeName, double rating) async {
    await store
        .collection(Constants.universe)
        .document("store")
        .collection("rating")
        .add({
      "rating": rating,
      "timestamp": DateTime.now().millisecondsSinceEpoch,
      "userUid": StartupData.user.id,
      "storeName": storeName
    });
  }

  void saveUserReviewForStore(String storeName, String userReview) async {
    await store
        .collection(Constants.universe)
        .document("store")
        .collection("review")
        .add({
      "review": userReview,
      "timestamp": DateTime.now().millisecondsSinceEpoch,
      "userUid": StartupData.user.id,
      "storeName": storeName
    });
  }

  getUserFeedbackDetails(String path) async {
    FeedBack feedBack;
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
          .document(StartupData.user.id)
          .collection("deals")
          .add({
        "imageUrl": beacon.imageUrl,
        "timestamp": DateTime.now().millisecondsSinceEpoch,
        "universe": Constants.universe,
        "shopUid": beacon.shopUid
      });

      await store
          .collection(StartupData.dbreference)
          .document("beacons")
          .collection("advertisement")
          .document(beacon.major)
          .collection(beacon.minor)
          .document("seenUser")
          .collection(StartupData.user.id)
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
          .collection(StartupData.user.id)
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
        .document(StartupData.user.id)
        .updateData({
      "status": "complete",
    });
  }

  getUserParticipationForOfflineEvent(EventModel event) async {
    OfflineEventSubmissionModel model;
    if (StartupData.user == null) {
      return null;
    }
    await store
        .collection(StartupData.dbreference)
        .document("events")
        .collection(event.uid)
        .document("submissions")
        .collection("allSubmissions")
        .document(StartupData.user.id)
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
        .collection(StartupData.user.id)
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
    if (StartupData.user == null) {
      return null;
    }
    await store
        .collection(StartupData.dbreference)
        .document("events")
        .collection(event.uid)
        .document("submissions")
        .collection("allSubmissions")
        .document(StartupData.user.id)
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
        .collection(StartupData.user.id)
        .add({"timestamp": DateTime.now().millisecondsSinceEpoch});
  }

  markUserVisitForParkingBeacon(
      String major, String minor, String distance) async {
    await store
        .collection(StartupData.dbreference)
        .document("beacons")
        .collection("parking")
        .document(major)
        .collection(minor)
        .add({
      "timestamp": DateTime.now().millisecondsSinceEpoch,
      "userUid": StartupData.user.id,
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
    if (StartupData.user == null) {
      return null;
    }
    await store
        .collection(StartupData.dbreference)
        .document("events")
        .collection(event.uid)
        .document("submissions")
        .collection("allSubmissions")
        .document(StartupData.user.id)
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
    bool alreadySubmitted = false;
    await store
        .collection(StartupData.dbreference)
        .document("events")
        .collection(event.uid)
        .document("submissions")
        .collection("allSubmissions")
        .document(StartupData.user.id)
        .get()
        .then((snapshot) {
      if (snapshot != null && snapshot.data != null) {
        alreadySubmitted = true;
      }
    });
    if (alreadySubmitted) return;

    await store
        .collection(StartupData.dbreference)
        .document("events")
        .collection(event.uid)
        .document("submissions")
        .collection("allSubmissions")
        .document(StartupData.user.id)
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
        .document(StartupData.user.id)
        .path;

    await store
        .collection(StartupData.dbreference)
        .document("events")
        .collection(event.uid)
        .document("submissions")
        .setData(<String, dynamic>{
      'count': FieldValue.increment(1),
    }, merge: true);

    await store
        .collection(StartupData.userReference)
        .document(StartupData.user.id)
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

    bool alreadySubmitted = false;
    await store
        .collection(StartupData.dbreference)
        .document("events")
        .collection(event.uid)
        .document("submissions")
        .collection("allSubmissions")
        .document(StartupData.user.id)
        .get()
        .then((snapshot) {
      if (snapshot != null && snapshot.data != null) {
        alreadySubmitted = true;
      }
    });
    if (alreadySubmitted) return;

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
        .collection(StartupData.dbreference)
        .document("events")
        .collection(event.uid)
        .document("submissions")
        .setData(<String, dynamic>{
      'count': FieldValue.increment(1),
    }, merge: true);

    await store
        .collection(StartupData.userReference)
        .document(userId)
        .collection("events")
        .add({
      "universe": StartupData.dbreference,
      "eventUrl": getEventsDBRef().child(event.uid).path,
      "submissionUrl": pathToUserSubmission,
      "eventName": event.name,
      "timestamp": DateTime.now().millisecondsSinceEpoch
    });

    logger.i("Event submission details saved successfully");
    return "Submission upload sucess";
  }

  Future markUserParticipationForLocationEvent(EventModel event) async {
    bool alreadySubmitted = false;
    await store
        .collection(StartupData.dbreference)
        .document("events")
        .collection(event.uid)
        .document("submissions")
        .collection("allSubmissions")
        .document(StartupData.user.id)
        .get()
        .then((snapshot) {
      if (snapshot != null && snapshot.data != null) {
        alreadySubmitted = true;
      }
    });
    if (alreadySubmitted) return;

    await store
        .collection(StartupData.dbreference)
        .document("events")
        .collection(event.uid)
        .document("submissions")
        .collection("allSubmissions")
        .document(StartupData.user.id)
        .setData({
      "participatedAt": DateTime.now().millisecondsSinceEpoch,
      "date": DateTime.now(),
      "status": "incomplete",
      "type": "location"
    });

    await store
        .collection(StartupData.dbreference)
        .document("events")
        .collection(event.uid)
        .document("submissions")
        .setData(<String, dynamic>{
      'count': FieldValue.increment(1),
    }, merge: true);

    String submissionPath = store
        .collection(StartupData.dbreference)
        .document("events")
        .collection(event.uid)
        .document("submissions")
        .collection("allSubmissions")
        .document(StartupData.user.id)
        .path;

    await store
        .collection(StartupData.userReference)
        .document(StartupData.user.id)
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

  Future getAllEventsForUser(bool refresh) async {
    if (myEvents == null || refresh) {
      List<Map<String, String>> allEventAndSubmissionUrls = List();

      await store
          .collection(StartupData.userReference)
          .document(StartupData.user.id)
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

      myEvents = List();

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
        myEvents.add(returnData);
      }
      return myEvents;
    } else {
      return myEvents;
    }
  }

  Future getActiveParking() async {
    ParkingModel parkingModel;
    await store
        .collection('users')
        .document(StartupData.user.id)
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
        .document(StartupData.user.id)
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
        .document(StartupData.user.id)
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
        .collection(StartupData.user.id)
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
        .document("seenUser")
        .collection(StartupData.user.id)
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
        .document(StartupData.user.id)
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
        .document(StartupData.user.id)
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
        .document(StartupData.user.id)
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

  Future getEventModelFromEventUrl(String url) async {
    EventModel event;
    await FirebaseDatabase.instance
        .reference()
        .child(url)
        .once()
        .then((receivedEvents) {
      event = EventModel(receivedEvents);
    }).catchError((error) {
      logger.e(error);
    });
    return event;
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

  getDealsForShop(String shopName, Function(List<DealModel>) dealsFound) {
    List<DealModel> result = List();
    if (deals != null) {
      for (DealModel deal in deals) {
        if (deal.shopName.compareTo(shopName) == 0) {
          result.add(deal);
        }
      }
    }
    return dealsFound(result);
  }
}
