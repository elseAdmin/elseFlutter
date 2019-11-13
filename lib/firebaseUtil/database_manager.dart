import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';

class DatabaseManager {
  Firestore store;
  DatabaseReference eventDatabase;
  DatabaseManager(){
    if(store==null) {
      store = Firestore.instance;
    }
    if(eventDatabase==null) {
      eventDatabase = FirebaseDatabase.instance.reference().child('unityOneRohini').child('eventStaticData');
    }
  }
  void addUser() async {
    await store.collection("users").document("1").setData({
      'username': 'suhail'
    });
  }
  DatabaseReference getEventsDBRef(){
    return eventDatabase;
  }
}