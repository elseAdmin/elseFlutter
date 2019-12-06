import 'dart:collection';
import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:else_app_two/models/events_model.dart';
import 'package:else_app_two/models/firestore/submission_firestore_model.dart';
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

    await store
        .collection(StartupData.userReference)
        .document(userId)
        .collection("events")
        .document(Constants.universe)
        .setData({event.uid: true});

    logger.i("Event submission details saved successfully");
    return "Submission upload sucess";
  }

  Future getAllEventsForUser(String userId) async {
    List docs = List();
    List events = List();

    await store
        .collection(StartupData.userReference)
        .document(userId)
        .collection("events")
        .getDocuments()
        .then((QuerySnapshot snapshot) {
      snapshot.documents.forEach((doc) {
        if (!universeVsParticipatedEvents.containsKey(doc.documentID)) {
          List events = List();
          events.add(doc.data);
          universeVsParticipatedEvents[doc.documentID] = events;
        } else {
          List events = universeVsParticipatedEvents[doc.documentID];
          events.add(doc.data);
          universeVsParticipatedEvents[doc.documentID] = events;
        }
      });
    });

    universeVsParticipatedEvents.forEach((universe,eventsInUniverse) async {
      List allEventsInUniverse = List();
      await FirebaseDatabase.instance.reference().child(universe).child("eventStaticData").once().then((snap){
        allEventsInUniverse = snap.value;
      });
      for(int i=0;i<eventsInUniverse.length;i++){
        if(!eventsInUniverse.contains(allEventsInUniverse[i].value['eventUid'])){
          allEventsInUniverse.remove(allEventsInUniverse[i]);
        }
      }
    });
    return null;
  }

  DatabaseReference getEventsDBRef() {
    return baseDatabase.child('eventStaticData');
  }

  DatabaseReference getDealsDBRef() {
    return baseDatabase.child('dealsStaticData');
  }

  DatabaseReference getBaseDBRef(){
    return baseDatabase;
  }

  Firestore getStoreReference() {
    return store;
  }
}
