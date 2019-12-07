import 'dart:collection';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:else_app_two/models/base_model.dart';
import 'package:else_app_two/models/events_model.dart';
import 'package:else_app_two/models/firestore/submission_firestore_model.dart';
import 'package:else_app_two/utils/Contants.dart';
import 'package:else_app_two/utils/app_startup_data.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:logger/logger.dart';

class DatabaseManager {
  final logger = Logger();
  Firestore store;
  DatabaseReference baseDatabase;
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

  void markUserVisitForBeacon(String major, String minor) async {
    //write only once in 24 hours per beacon, use sqllite to store last write
    await store
        .collection(StartupData.dbreference)
        .document("beacons")
        .collection("advertisement")
        .document(major)
        .collection(minor)
        .document("user").collection(StartupData.userid)
        .add(
            {"timestamp":DateTime.now().millisecondsSinceEpoch.toString()});
  }

  Future getLimitedApprovedSubmissionsForEvent(String eventUid) async {
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

  Future getWinnerSubmissionForEvent(String eventUid) async {
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

  Future getAllApprovedSubmissionsForEvent(String eventUid) async {
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

  Future getUserSubmissionForEvent(EventModel event) async {
    FirestoreSubmissionModel submission;
    await store
        .collection(StartupData.dbreference)
        .document("events")
        .collection(event.uid)
        .document("submissions")
        .collection("allSubmissions")
        .document(StartupData.userid)
        .get()
        .then((DocumentSnapshot snapshot) {
      submission = FirestoreSubmissionModel(snapshot);
    }).catchError((error) {
      logger.i("No submissions by user for this event");
    });
    return submission;
  }

  Future addEventSubmission(EventModel event, String userId, File image) async {
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
      "uploaded_at": new DateTime.now(),
      "likes": 0
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

  Future getAllEventsForUser(String userId) async {
    List<Map<String, String>> allEventAndSubmissionUrls = List();

    await store
        .collection(StartupData.userReference)
        .document(userId)
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
      await FirebaseDatabase.instance
          .reference()
          .child(eUrl)
          .once()
          .then((receivedEvents) {
        EventModel event = EventModel(receivedEvents);
        returnData.putIfAbsent("eventDetails", () => event);
      });

      await store.document(sUrl).get().then((snap) {
        FirestoreSubmissionModel submission = FirestoreSubmissionModel(snap);
        returnData.putIfAbsent("submissionDetails", () => submission);
      });

      listParticipatedEvents.add(returnData);
    }
    return listParticipatedEvents;
  }

  DatabaseReference getEventsDBRef() {
    return baseDatabase.child('eventStaticData');
  }

  DatabaseReference getDealsDBRef() {
    return baseDatabase.child('dealsStaticData');
  }
}
