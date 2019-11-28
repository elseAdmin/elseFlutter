import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:else_app_two/models/events_model.dart';
import 'package:else_app_two/models/firestore/submission_firestore_model.dart';
import 'package:else_app_two/utils/app_startup_data.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:logger/logger.dart';

class DatabaseManager {
  final logger = Logger();
  Firestore store;
  DatabaseReference baseDatabase;
  FirebaseStorage storageRef;
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

  void addUser() async {
    await store
        .collection("users")
        .document("1")
        .setData({'username': 'suhail'});
  }

  Future getLimitedApprovedSubmissionsForEvent(String eventUid) async {
    // make this call synchronous
    List<String> imageUrls = List();
    await store
        .collection(StartupData.dbreference)
        .document("events")
        .collection(eventUid)
        .document("submissions")
        .collection("allSubmissions").where("status",isEqualTo: "approved").orderBy("uploaded_at",descending: true).limit(20)
        .getDocuments()
        .then((QuerySnapshot snapshot) {
      snapshot.documents.forEach((doc) {
        imageUrls.add(doc.data["imageUrl"]);
      });
    });
    return imageUrls;
  }

  Future getWinnerSubmissionForEvent(String eventUid) async{
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
        .collection("allSubmissions").where("status",isEqualTo: "approved").orderBy("uploaded_at",descending: true)
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
      "status": "pending",
      "imageUrl": url,
      "uploaded_at": new DateTime.now(),
      "likes": 0
    });
    logger.i("Event submission details saved successfully");
    return "Submission upload sucess";
  }

  DatabaseReference getEventsDBRef() {
    return baseDatabase.child('eventStaticData');
  }

  DatabaseReference getDealsDBRef() {
    return baseDatabase.child('dealsStaticData');
  }
}
