import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:else_app_two/models/events_model.dart';
import 'package:else_app_two/utils/app_startup_data.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class DatabaseManager {
  final logger = Logger();
  Firestore store;
  DatabaseReference baseDatabase, eventDatabase, dealsDatabase;
  FirebaseStorage storageRef;
  DatabaseManager() {
    if(storageRef == null){
      storageRef=FirebaseStorage.instance;
    }
    if (store == null) {
      store = Firestore.instance;
    }
    if (baseDatabase == null) {
      baseDatabase =
          FirebaseDatabase.instance.reference().child(StartupData.dbreference);
      //make the above child path as variable that can be injected at app startup
    }
  }

  void addUser() async {
    await store
        .collection("users")
        .document("1")
        .setData({'username': 'suhail'});
  }

  void getApprovedSubmissionsForEvent(String event) async{
    // make this call synchronous
    List<String> imageUrls = List();
    QuerySnapshot querySnapshot = await store.collection(StartupData.dbreference).document("events").collection(event).document("submissions").
    collection("allSubmissions").getDocuments();
    var allSubmissions = querySnapshot.documents;
    allSubmissions.forEach((submission){
      imageUrls.add(submission.data['imageUrl']);
    });
    logger.i("returning submissions-{}",imageUrls.length);
  }
  
  void addEventSubmission(EventModel event,String userId,File image) async{
    StorageReference ref = storageRef.ref().child(StartupData.dbreference).child("events").child(event.uid).child("submissions").child(userId);
    final StorageUploadTask uploadTask = ref.putFile(
      image,
      StorageMetadata(
        contentType: "image" + '/' + "jpeg",
      ),
    );
    final StorageTaskSnapshot downloadUrl =
    (await uploadTask.onComplete);
    final String url = (await downloadUrl.ref.getDownloadURL());

    await store.collection(StartupData.dbreference).document("events").collection(event.uid).document("submissions").collection("allSubmissions").add({
      "userUid":userId,
      "status":"pending",
      "imageUrl":url,
      "uploaded_at": new DateTime.now(),
      "likes":0
    });
    logger.i("Event submission details saved successfully");
  }

  DatabaseReference getEventsDBRef() {
    return baseDatabase.child('eventStaticData');
  }

  DatabaseReference getDealsDBRef() {
    return baseDatabase.child('dealsStaticData');
  }
}
