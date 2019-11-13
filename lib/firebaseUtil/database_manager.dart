import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';

class DatabaseManager {
  Firestore store;
  DatabaseReference baseDatabase, eventDatabase, dealsDatabase;

  DatabaseManager() {
    if (store == null) {
      store = Firestore.instance;
    }
    if (baseDatabase == null) {
      baseDatabase =
          FirebaseDatabase.instance.reference().child('unityOneRohini');
      //make the above child path as variable that can be injected at app startup
    }
  }

  void addUser() async {
    await store
        .collection("users")
        .document("1")
        .setData({'username': 'suhail'});
  }

  DatabaseReference getEventsDBRef() {
    return baseDatabase.child('eventStaticData');
  }

  DatabaseReference getDealsDBRef() {
    return baseDatabase.child('dealsStaticData');
  }
}
